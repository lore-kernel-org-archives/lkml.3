Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbaLOOep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:34:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38959 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbaLOO3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:11 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 148/168] ahci: disable MSI on SAMSUNG 0xa800 SSD
Date: Mon, 15 Dec 2014 14:26:42 +0000
Message-Id: <1418653622-21105-149-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2b21ef0aae65f22f5ba86b13c4588f6f0c2dbefb upstream.

Just like 0x1600 which got blacklisted by 66a7cbc303f4 ("ahci: disable
MSI instead of NCQ on Samsung pci-e SSDs on macbooks"), 0xa800 chokes
on NCQ commands if MSI is enabled.  Disable MSI.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=89171
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5fc11a616a7a..3b18399290b3 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -495,6 +495,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=60731
 	 */
 	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
+	{ PCI_VDEVICE(SAMSUNG, 0xa800), board_ahci_nomsi },
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
-- 
2.1.3

