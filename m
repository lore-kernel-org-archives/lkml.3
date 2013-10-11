Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3JKOeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:34:03 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47738 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752996Ab3JKOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:34:01 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH 0/2] EFI earlyprintk support
Date: Fri, 11 Oct 2013 15:33:55 +0100
Message-Id: <1381502037-22225-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

These two patches cleanup the #include <linux/efi.h> duplication and add
support for earlyprintk=efi, which is the only way users can debug early
boot crashes without special hardware.

Matt Fleming (2):
  x86/efi: Include linux/efi.h in asm/efi.h
  x86/efi: Add EFI framebuffer earlyprintk support

 Documentation/kernel-parameters.txt  |   8 +-
 arch/x86/Kconfig.debug               |   9 ++
 arch/x86/boot/compressed/eboot.c     |   1 -
 arch/x86/include/asm/efi.h           |   4 +
 arch/x86/kernel/early_printk.c       |   6 ++
 arch/x86/kernel/setup.c              |   1 -
 arch/x86/platform/efi/Makefile       |   1 +
 arch/x86/platform/efi/early_printk.c | 191 +++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi.c          |   1 -
 arch/x86/platform/efi/efi_32.c       |   1 -
 arch/x86/platform/efi/efi_64.c       |   1 -
 arch/x86/platform/uv/bios_uv.c       |   1 -
 12 files changed, 216 insertions(+), 9 deletions(-)
 create mode 100644 arch/x86/platform/efi/early_printk.c

-- 
1.8.1.4

