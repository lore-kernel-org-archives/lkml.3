Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965227Ab3IEKgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:36:19 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:59392 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935607Ab3IEKgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:36:17 -0400
From: Leif Lindholm <leif.lindholm@linaro.org>
To: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
        matt.fleming@intel.com, tony.luck@gmail.com, grant.likely@secretlab.ca,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v4 0/3] Make commonly useful UEFI functions common
Date: Thu,  5 Sep 2013 11:34:52 +0100
Message-Id: <1378377295-32758-1-git-send-email-leif.lindholm@linaro.org>
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

Leif Lindholm (3):
  ia64: add early_memremap() alias for early_ioremap()
  efi: x86: ia64: provide a generic efi_config_init()
  efi: x86: make efi_lookup_mapped_addr() a common function

 arch/ia64/include/asm/io.h  |    1 +
 arch/ia64/kernel/efi.c      |   54 ++++-------------
 arch/x86/platform/efi/efi.c |  126 ++++----------------------------------
 drivers/firmware/efi/efi.c  |  140 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h         |    8 +++
 5 files changed, 170 insertions(+), 159 deletions(-)

-- 
1.7.10.4

