Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474Ab3JPNvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 09:51:08 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:60908 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934095Ab3JPNvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 09:51:06 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 0/5] EFI capsule pstore support
Date: Wed, 16 Oct 2013 14:50:55 +0100
Message-Id: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The UEFI spec describes a capsule mechanism that allows data blobs to be
handed to the firmware at runtime. If the firmware doesn't recognise the
guid of the capsule and if certain flags are set in the capsule header,
the firmware will preserve the memory region containing the capsule
across a reboot. We can utilise this feature to perform crash dumps and
function tracing to aid in crash analysis.

The capsule buffers containing pstore data can be much larger than is
possible with the EFI variable pstore backend, which makes it
particularly attractive for function tracing. Futhermore, because the
memory regions containing the capsule data are registered with the
firmware prior to the crash (as opposed to efi-pstore.c which invokes
variable services from the crash handler) it's more useful for debugging
hard hangs.

Matt Fleming (5):
  pstore/ftrace: Don't increment initial data offset
  efi: Introduce a Runtime Services lock
  efi: Add common efi_reboot() implementation
  efi: Move efi_status_to_err() to efi.h
  efi: Capsule update support and pstore backend

 arch/ia64/kernel/efi.c         |  33 +-
 arch/ia64/kernel/process.c     |   2 +-
 arch/x86/kernel/reboot.c       |  21 +-
 arch/x86/platform/efi/efi.c    | 108 +++++-
 drivers/firmware/efi/Kconfig   |  19 +
 drivers/firmware/efi/Makefile  |   3 +-
 drivers/firmware/efi/capsule.c | 802 +++++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c     |  12 +
 drivers/firmware/efi/reboot.c  |  37 ++
 drivers/firmware/efi/vars.c    |  52 +--
 fs/pstore/inode.c              |   1 -
 include/linux/efi.h            |  54 +++
 12 files changed, 1072 insertions(+), 72 deletions(-)
 create mode 100644 drivers/firmware/efi/capsule.c
 create mode 100644 drivers/firmware/efi/reboot.c

-- 
1.8.1.4

