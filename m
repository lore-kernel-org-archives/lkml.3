Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbaAGVjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:39:19 -0500
Received: from 6.77.broadband6.iol.cz ([88.101.77.6]:50128 "EHLO
	dhcp-26-207.brq.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751541AbaAGVjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:39:12 -0500
X-Greylist: delayed 647 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 16:39:11 EST
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>, Brian King <brking@us.ibm.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 1/7] ipr: Do not call pci_disable_msi/msix() if pci_enable_msi/msix() failed
Date: Tue,  7 Jan 2014 19:05:36 +0100
Message-Id: <0df3838fb698aa959ee5a9afac6ebf2f23213a66.1389103215.git.agordeev@redhat.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1389103215.git.agordeev@redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/scsi/ipr.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 36ac1c3..fb57e21 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9255,10 +9255,8 @@ static int ipr_enable_msix(struct ipr_ioa_cfg *ioa_cfg)
 	while ((err = pci_enable_msix(ioa_cfg->pdev, entries, vectors)) > 0)
 			vectors = err;
 
-	if (err < 0) {
-		pci_disable_msix(ioa_cfg->pdev);
+	if (err < 0)
 		return err;
-	}
 
 	if (!err) {
 		for (i = 0; i < vectors; i++)
@@ -9278,10 +9276,8 @@ static int ipr_enable_msi(struct ipr_ioa_cfg *ioa_cfg)
 	while ((err = pci_enable_msi_block(ioa_cfg->pdev, vectors)) > 0)
 			vectors = err;
 
-	if (err < 0) {
-		pci_disable_msi(ioa_cfg->pdev);
+	if (err < 0)
 		return err;
-	}
 
 	if (!err) {
 		for (i = 0; i < vectors; i++)
-- 
1.7.7.6

