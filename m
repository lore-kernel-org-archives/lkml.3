Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3KEAxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 19:53:04 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:34021 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469Ab3KEAxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 19:53:02 -0500
X-Authority-Analysis: v=2.0 cv=LKjkseq9 c=1 sm=0 a=3SewDSjaRW4vdJyuxQ33ZQ==:17 a=DeBnktw0k-IA:10 a=h4GvHp9fE2UA:10 a=S1A5HrydsesA:10 a=fxJcL_dCAAAA:8 a=KGjhK52YXX0A:10 a=Ak4RzM5K6msA:10 a=qYT2PwKetgGGbV7-aXIA:9 a=2eKvNQJKnqYA:10 a=3SewDSjaRW4vdJyuxQ33ZQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 72.238.73.171
From: Phillip Susi <psusi@ubuntu.com>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] libata: use sleep instead of standby command
Date: Mon,  4 Nov 2013 19:52:59 -0500
Message-Id: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ATA SLEEP mode saves some more power than SUSPEND, and
has basically the same recovery time, so use it instead.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 drivers/ata/libata-scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 97a0cef..79b75fd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1362,8 +1362,8 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		     system_entering_hibernation())
 			goto skip;
 
-		/* Issue ATA STANDBY IMMEDIATE command */
-		tf->command = ATA_CMD_STANDBYNOW1;
+		/* Issue ATA SLEEP command */
+		tf->command = ATA_CMD_SLEEP;
 	}
 
 	/*
-- 
1.8.3.2

