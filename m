Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267Ab3ERChy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:37:54 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:54223 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429Ab3ERChx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:37:53 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Jon Mason <jon.mason@intel.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.9-stable] ntb: off by one sanity checks
Date: Sat, 18 May 2013 11:35:38 +0900
Message-Id: <1368844538-3841-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Dan Carpenter <dan.carpenter@oracle.com>"

commit ad3e2751e7c546ae678be1f8d86e898506b42cef upstream

These tests are off by one.  If "mw" is equal to NTB_NUM_MW then we
would go beyond the end of the ndev->mw[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/ntb/ntb_hw.c | 6 +++---
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
1.8.1.2

