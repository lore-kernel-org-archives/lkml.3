Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaK0Iqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:46:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:41421 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbaK0Iqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:51 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Tejun Heo <tj@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 22/91] ahci: add pcid for Marvel 0x9182 controller
Date: Thu, 27 Nov 2014 16:42:05 +0800
Message-Id: <1417077794-9299-22-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit c5edfff9db6f4d2c35c802acb4abe0df178becee upstream.

Keystone K2E EVM uses Marvel 0x9182 controller. This requires support
for the ID in the ahci driver.

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
[lizf: Backported to 3.4:
 - adjust context
 - s/PCI_VENDOR_ID_MARVELL_EXT/0x1b4b/]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/ata/ahci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 009a097..d366a75 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -443,6 +443,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
 	{ PCI_DEVICE(0x1b4b, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
+	{ PCI_DEVICE(0x1b4b, 0x9182),
+	  .driver_data = board_ahci_yes_fbs },                  /* 88se9182 */
 	{ PCI_DEVICE(0x1b4b, 0x9192),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 on some Gigabyte */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
-- 
1.9.1

