Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab3AVHTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 02:19:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16538 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3AVHTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 02:19:18 -0500
Date: Tue, 22 Jan 2013 10:19:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jon Mason <jon.mason@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kbuild@01.org
Subject: [patch] ntb: off by one sanity checks
Message-ID: <20130122071914.GA8966@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These tests are off by one.  If "mw" is equal to NTB_NUM_MW then we
would go beyond the end of the ndev->mw[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 4c71b17..5bf54f3 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -359,7 +359,7 @@ int ntb_read_remote_spad(struct ntb_device *ndev, unsigned int idx, u32 *val)
  */
 void *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return NULL;
 
 	return ndev->mw[mw].vbase;
@@ -376,7 +376,7 @@ void *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
  */
 resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return 0;
 
 	return ndev->mw[mw].bar_sz;
@@ -394,7 +394,7 @@ resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
  */
 void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return;
 
 	dev_dbg(&ndev->pdev->dev, "Writing addr %Lx to BAR %d\n", addr,
