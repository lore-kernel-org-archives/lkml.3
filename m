Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751535AbaG3Utm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:49:42 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:61945 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaG3Utl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:49:41 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ch.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Wed, 30 Jul 2014 22:51:08 +0200
Message-Id: <1406753468-19983-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are going to use memset before strncpy you must copy sizeof -1.
And removed unnecessary magic numbers.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/ch.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 2a32374..1fecf60 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -634,19 +634,23 @@ static long ch_ioctl(struct file *file,
 		memset(&vparams,0,sizeof(vparams));
 		if (ch->counts[CHET_V1]) {
 			vparams.cvp_n1  = ch->counts[CHET_V1];
-			strncpy(vparams.cvp_label1,vendor_labels[0],16);
+			strncpy(vparams.cvp_label1, vendor_labels[0],
+					sizeof(vparams.cvp_label1) - 1);
 		}
 		if (ch->counts[CHET_V2]) {
 			vparams.cvp_n2  = ch->counts[CHET_V2];
-			strncpy(vparams.cvp_label2,vendor_labels[1],16);
+			strncpy(vparams.cvp_label2, vendor_labels[1],
+					sizeof(vparams.cvp_label2) - 1);
 		}
 		if (ch->counts[CHET_V3]) {
 			vparams.cvp_n3  = ch->counts[CHET_V3];
-			strncpy(vparams.cvp_label3,vendor_labels[2],16);
+			strncpy(vparams.cvp_label3, vendor_labels[2],
+					sizeof(vparams.cvp_label3) - 1);
 		}
 		if (ch->counts[CHET_V4]) {
 			vparams.cvp_n4  = ch->counts[CHET_V4];
-			strncpy(vparams.cvp_label4,vendor_labels[3],16);
+			strncpy(vparams.cvp_label4, vendor_labels[3],
+					sizeof(vparams.cvp_label4) - 1);
 		}
 		if (copy_to_user(argp, &vparams, sizeof(vparams)))
 			return -EFAULT;
-- 
1.7.10.4

