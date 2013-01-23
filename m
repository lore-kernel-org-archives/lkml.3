Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3AWIBI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 03:01:08 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:61242 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3AWIBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 03:01:06 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH v3 0/2] Add Wondermedia Serial Flash controller support
Date: Wed, 23 Jan 2013 21:01:06 +1300
Message-Id: <1358928068-12417-1-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 Changes:
As requested by Artem Bityutskiy, I have seperated out the flash chip data into
a seperate file (flash_jedec.(h/c)) which should be expandable by other drivers
as needed.

I have also cleared up some of the sparse warnings that were being generated,
but need some help with the last one:
+drivers/mtd/devices/wmt_sflash.c:442:24: warning: cast removes address space of expression [sparse]
which relates to this line:
+	u32 addr_to = (u32)info->sf_base_virt + to;

What is the correct way to get the value of ->sf_base_virt without generating
a sparse warning? sf_base_virt is void __iomem *.

Tony Prisk (2):
  mtd: Add a common JEDEC flash device table
  mtd: vt8500: Add support for Wondermedia Serial Flash Controller

 drivers/mtd/devices/Kconfig       |   10 +
 drivers/mtd/devices/Makefile      |    3 +-
 drivers/mtd/devices/flash_jedec.c |   96 ++++++
 drivers/mtd/devices/flash_jedec.h |   30 ++
 drivers/mtd/devices/wmt_sflash.c  |  585 +++++++++++++++++++++++++++++++++++++
 5 files changed, 723 insertions(+), 1 deletion(-)
 create mode 100644 drivers/mtd/devices/flash_jedec.c
 create mode 100644 drivers/mtd/devices/flash_jedec.h
 create mode 100644 drivers/mtd/devices/wmt_sflash.c

-- 
1.7.9.5

