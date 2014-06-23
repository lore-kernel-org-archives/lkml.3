Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbaFWNmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:42:42 -0400
Received: from smtprelay0185.hostedemail.com ([216.40.44.185]:33707 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754617AbaFWNmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:42:37 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:4419:4605:5007:6261:9592:10004:10026:10848:11026:11657:11658:11914:12043:12114:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hose64_8ae3b77accf20
X-Filterd-Recvd-Size: 1865
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Christian Benvenuti <benve@cisco.com>, Sujith Sankar <ssujith@cisco.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Neel Patel <neepatel@cisco.com>, netdev@vger.kernel.org
Subject: [PATCH 10/22] enic: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:38 -0700
Message-Id: <cfd907966b8feaaa1c2ecbd537a7a0ef3fc98141.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/cisco/enic/vnic_dev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/vnic_dev.c b/drivers/net/ethernet/cisco/enic/vnic_dev.c
index e86a45c..8a4799c 100644
--- a/drivers/net/ethernet/cisco/enic/vnic_dev.c
+++ b/drivers/net/ethernet/cisco/enic/vnic_dev.c
@@ -432,14 +432,12 @@ int vnic_dev_fw_info(struct vnic_dev *vdev,
 	int err = 0;
 
 	if (!vdev->fw_info) {
-		vdev->fw_info = pci_alloc_consistent(vdev->pdev,
-			sizeof(struct vnic_devcmd_fw_info),
-			&vdev->fw_info_pa);
+		vdev->fw_info = pci_zalloc_consistent(vdev->pdev,
+						      sizeof(struct vnic_devcmd_fw_info),
+						      &vdev->fw_info_pa);
 		if (!vdev->fw_info)
 			return -ENOMEM;
 
-		memset(vdev->fw_info, 0, sizeof(struct vnic_devcmd_fw_info));
-
 		a0 = vdev->fw_info_pa;
 		a1 = sizeof(struct vnic_devcmd_fw_info);
 
-- 
1.8.1.2.459.gbcd45b4.dirty

