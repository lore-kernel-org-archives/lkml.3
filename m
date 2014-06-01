Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbaFANRb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 09:17:31 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54470 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaFANR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 09:17:29 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: sun3_NCR5380.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:18:22 +0200
Message-Id: <1401628702-18164-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/sun3_NCR5380.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 636bbe0..93f3fd5 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2442,7 +2442,7 @@ static void NCR5380_reselect (struct Scsi_Host *instance)
     unsigned char target_mask;
     unsigned char lun;
 #ifdef SUPPORT_TAGS
-    unsigned char tag;
+    unsigned char tag = TAG_NONE;
 #endif
     unsigned char msg[3];
     struct scsi_cmnd *tmp = NULL, *prev;
-- 
1.7.10.4

