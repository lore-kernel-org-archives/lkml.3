Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaLSMlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:41:14 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54567 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbaLSMlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:41:13 -0500
Date: Fri, 19 Dec 2014 13:41:10 +0100
From: Quentin Lambert <lambert.quentin@gmail.com>
To: joe@perches.com
Cc: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] [SCSI] mpt2sas: Remove unnecessary use of a boolean
 variable
Message-ID: <20141219124110.GA20299@sloth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 58e4521..6cc0591 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1414,12 +1414,8 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	struct msix_entry *entries, *a;
 	int r;
 	int i;
-	u8 try_msix = 0;
 
-	if (msix_disable == -1 || msix_disable == 0)
-		try_msix = 1;
-
-	if (!try_msix)
+	if (msix_disable != -1 && msix_disable != 0)
 		goto try_ioapic;
 
 	if (_base_check_enable_msix(ioc) != 0)
-- 
1.9.1

