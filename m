Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3BCQOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:14:50 -0500
Received: from mail.skyhub.de ([78.46.96.112]:42587 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab3BCQOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:14:47 -0500
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 0/4] x86, head_32: Some cleanups
Date: Sun,  3 Feb 2013 17:14:35 +0100
Message-Id: <1359908079-10469-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.2.422.g08c0e7f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

Hi,

here are some initial low-hanging fruits wrt head_32.S cleanup. I've
made them as easily digestible as possible; after all, this is boot asm
and meddling with it tends to upset kernels.

Also, I've made the assumption that having boot_cpu_data.cpuid_level
contain the CPUID level for the boot cpu means that the APs have the
same CPUID level. This should be the case on X86.

They boot fine 486 and 486SX in qemu but I'd like to hear whether
the direction I'm going is ok before I continue testing them on real
hardware.

Thanks.


Borislav Petkov (4):
  x86, head_32: Remove i386 pieces
  x86: Detect CPUID support early at boot
  x86, head_32: Remove CPUID detection from default_entry
  x86, 32-bit: Drop new_cpu_data

 arch/x86/include/asm/processor.h |   1 -
 arch/x86/kernel/head_32.S        | 105 ++++++++++++++++-----------------------
 arch/x86/kernel/setup.c          |   3 --
 arch/x86/lguest/boot.c           |   6 +--
 arch/x86/xen/enlighten.c         |   8 +--
 5 files changed, 51 insertions(+), 72 deletions(-)

-- 
1.8.1.2.422.g08c0e7f

