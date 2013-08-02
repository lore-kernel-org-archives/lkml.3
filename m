Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3HBQud (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:50:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38240 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3HBQua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:50:30 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        matt.fleming@intel.com, tony.luck@gmail.com, patches@linaro.org,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v2 0/5] Make commonly useful UEFI functions common
Date: Fri,  2 Aug 2013 17:56:17 +0100
Message-Id: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set breaks out some common code from x86/ia64 EFI support
code and puts it into drivers/firmware/efi.

First it takes the definition of the global "efi" data structure
and moves it into global efi.c. Then it implements a common version
of efi_config_init().

Secondly it breaks the efi_lookup_mapped_addr() function out of x86
and places it in global efi.c, for shared use with future ARM
patches.

IA64 code compile tested only.

Leif Lindholm (5):
  ia64: add early_memremap() alias for early_ioremap()
  efi: provide a generic efi_config_init()
  efi: x86: use common code for (U)EFI configuration scanning
  efi: ia64: use common code for (U)EFI configuration scanning
  efi: x86: make efi_lookup_mapped_addr() a common function

 arch/ia64/include/asm/io.h  |    1 +
 arch/ia64/kernel/efi.c      |   54 ++++-------------
 arch/x86/platform/efi/efi.c |  126 ++++-----------------------------------
 drivers/firmware/efi/efi.c  |  138 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h         |    8 +++
 5 files changed, 168 insertions(+), 159 deletions(-)

-- 
1.7.10.4

