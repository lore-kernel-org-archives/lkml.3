Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbaFSNkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 09:40:31 -0400
Received: from mail-we0-f193.google.com ([74.125.82.193]:35965 "EHLO
	mail-we0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506AbaFSNk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 09:40:29 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, Mark Salter <msalter@redhat.com>,
        Aubrey Li <aubrey.li@linux.intel.com>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 0/3] EFI reboot/poweroff support
Date: Thu, 19 Jun 2014 14:40:22 +0100
Message-Id: <1403185225-9031-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

Both x86 and ARM need a way to reboot/poweroff machines using the EFI
runtime services.

For x86, we want to really, really restrict this support to those
platforms that absolultely have no other method because EfiResetSystem()
doesn't generally work very well in the wild. The ARM folks probably
need to be less picky.

This series is against the EFI 'next' branch.

Matt Fleming (3):
  efi/reboot: Add generic wrapper around EfiResetSystem()
  efi/reboot: Allow powering off machines using EFI
  x86/reboot: Add EFI reboot quirk for ACPI Hardware Reduced flag

 arch/ia64/kernel/process.c     |  2 +-
 arch/x86/include/asm/efi.h     |  6 +++++
 arch/x86/kernel/reboot.c       | 24 ++++++++++++------
 arch/x86/platform/efi/quirks.c | 23 ++++++++++++++++++
 drivers/firmware/efi/Makefile  |  2 +-
 drivers/firmware/efi/reboot.c  | 55 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h            |  7 ++++++
 7 files changed, 110 insertions(+), 9 deletions(-)
 create mode 100644 drivers/firmware/efi/reboot.c

-- 
1.9.0

