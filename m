Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959Ab3EGB4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:56:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:29232 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842Ab3EGBz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:55:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="333594732"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 02/10] ntb: off by one sanity checks
Date: Mon,  6 May 2013 18:55:21 -0700
Message-Id: <1367891729-11738-3-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

These tests are off by one.  If "mw" is equal to NTB_NUM_MW then we
would go beyond the end of the ndev->mw[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index f802e7c..195cc51 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -345,7 +345,7 @@ int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val)
  */
 void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return NULL;
 
 	return ndev->mw[mw].vbase;
@@ -362,7 +362,7 @@ void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
  */
 resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return 0;
 
 	return ndev->mw[mw].bar_sz;
@@ -380,7 +380,7 @@ resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
  */
 void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return;
 
 	dev_dbg(&ndev->pdev->dev, "Writing addr %Lx to BAR %d\n", addr,
-- 
1.7.9.5

