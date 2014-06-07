Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaFGOo6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 10:44:58 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:64456 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaFGOo4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 10:44:56 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt2sas: mpt2sas_base.c:  Cleaning up wrong return value
Date: Sat,  7 Jun 2014 16:45:49 +0200
Message-Id: <1402152349-18484-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A variable to manage the error code is not returned.

This was partly found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index bde63f7..ed10b74f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3546,7 +3546,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		r = -EIO;
 	}
 
-	return 0;
+	return r;
 }
 
 /**
-- 
1.7.10.4

