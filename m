Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522Ab3EVWKu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:10:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757504Ab3EVWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:10:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jon Mason <jon.mason@intel.com>
Subject: [ 12/21] ntb: off by one sanity checks
Date: Wed, 22 May 2013 15:10:30 -0700
Message-Id: <20130522205234.047146670@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130522205232.597066680@linuxfoundation.org>
References: <20130522205232.597066680@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit ad3e2751e7c546ae678be1f8d86e898506b42cef upstream.

These tests are off by one.  If "mw" is equal to NTB_NUM_MW then we
would go beyond the end of the ndev->mw[] array.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_hw.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -345,7 +345,7 @@ int ntb_read_remote_spad(struct ntb_devi
  */
 void __iomem *ntb_get_mw_vbase(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return NULL;
 
 	return ndev->mw[mw].vbase;
@@ -362,7 +362,7 @@ void __iomem *ntb_get_mw_vbase(struct nt
  */
 resource_size_t ntb_get_mw_size(struct ntb_device *ndev, unsigned int mw)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return 0;
 
 	return ndev->mw[mw].bar_sz;
@@ -380,7 +380,7 @@ resource_size_t ntb_get_mw_size(struct n
  */
 void ntb_set_mw_addr(struct ntb_device *ndev, unsigned int mw, u64 addr)
 {
-	if (mw > NTB_NUM_MW)
+	if (mw >= NTB_NUM_MW)
 		return;
 
 	dev_dbg(&ndev->pdev->dev, "Writing addr %Lx to BAR %d\n", addr,


