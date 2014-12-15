Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaLOTde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:33:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40953 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482AbaLOTdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:33:22 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 84/96] ahci: disable MSI on SAMSUNG 0xa800 SSD
Date: Mon, 15 Dec 2014 11:26:44 -0800
Message-Id: <1418671616-25482-85-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2b21ef0aae65f22f5ba86b13c4588f6f0c2dbefb upstream.

Just like 0x1600 which got blacklisted by 66a7cbc303f4 ("ahci: disable
MSI instead of NCQ on Samsung pci-e SSDs on macbooks"), 0xa800 chokes
on NCQ commands if MSI is enabled.  Disable MSI.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=89171
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ccb972e..9de149d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -494,6 +494,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=60731
 	 */
 	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
+	{ PCI_VDEVICE(SAMSUNG, 0xa800), board_ahci_nomsi },
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
-- 
1.9.1

