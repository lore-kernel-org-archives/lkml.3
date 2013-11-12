Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab3KLCQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 21:16:14 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2166 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KLCQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 21:16:04 -0500
From: Jerry Hoemann <jerry.hoemann@hp.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, matt.fleming@intel.com, yinghai@kernel.org,
        penberg@kernel.org, akpm@linux-foundation.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, jerry.hoemann@hp.com
Subject: [PATCH 0/3] Early use of boot service memory
Date: Mon, 11 Nov 2013 19:15:55 -0700
Message-Id: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some platform have firmware that violates UEFI spec and access boot service
code or data segments after the system has called Exit Boot Services.
The call to efi_reserve_boot_services in setup_arch is a work around to
avoid using boot service memory until after the kernel has done
Set Virtual Map.

However, this reservation fragments memory which can cause
large allocations early in boot (e.g. crash kernel) to fail.

This patch set extends the add_efi_memmap with an optional
argument to specify that firmware "correctly" doesn't resuse
boot services memory after Exit Boot Services.

With this information, setup_arch avoids calling
efi_reserve_boot_services and fragmenting memory.


Jerry Hoemann (3):
  efi: Early use of boot service memory
  x86: avoid efi_reserve_boot_services
  x86, efi: Early use of boot service memory

 Documentation/kernel-parameters.txt |  8 ++++++++
 arch/x86/kernel/setup.c             |  2 +-
 arch/x86/platform/efi/efi.c         | 13 +++++++++++--
 include/linux/efi.h                 |  1 +
 4 files changed, 21 insertions(+), 3 deletions(-)

-- 
1.7.11.3

