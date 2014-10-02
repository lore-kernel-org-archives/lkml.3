Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaJBH0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 03:26:20 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:47914 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaJBH0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 03:26:19 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pch_phub: Build context save/restore only for PM
Date: Thu,  2 Oct 2014 09:26:16 +0200
Message-Id: <1412234776-20056-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The pch_phub_save_reg_conf() and pch_phub_restore_reg_conf() functions
are only used for suspend/resume support (i.e. when PM is enabled). If
PM is disabled they don't need to be built.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/misc/pch_phub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 956597321d2a..9a17a9bab8d6 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -158,6 +158,7 @@ static void pch_phub_read_modify_write_reg(struct pch_phub_reg *chip,
 	iowrite32(((ioread32(reg_addr) & ~mask)) | data, reg_addr);
 }
 
+#ifdef CONFIG_PM
 /* pch_phub_save_reg_conf - saves register configuration */
 static void pch_phub_save_reg_conf(struct pci_dev *pdev)
 {
@@ -280,6 +281,7 @@ static void pch_phub_restore_reg_conf(struct pci_dev *pdev)
 	if ((chip->ioh_type == 2) || (chip->ioh_type == 4))
 		iowrite32(chip->funcsel_reg, p + FUNCSEL_REG_OFFSET);
 }
+#endif
 
 /**
  * pch_phub_read_serial_rom() - Reading Serial ROM
-- 
2.1.0

