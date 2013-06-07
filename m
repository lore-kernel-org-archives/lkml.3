Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3FGNJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:09:18 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:56895 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417Ab3FGNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:09:17 -0400
From: Laura Lawniczak <laura.lawniczak@googlemail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Kurt Kanzenbach <shifty91@gmail.com>,
        linux-kernel@i4.cs.fau.de, linux-kernel@vger.kernel.org,
        Al Cho <acho@novell.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Laura Lawniczak <laura.lawniczak@googlemail.com>,
        Johannes Schilling <of82ecuq@cip.cs.fau.de>
Subject: [PATCH] keucr: removed unnecessary variables and comments
Date: Fri,  7 Jun 2013 15:08:29 +0200
Message-Id: <1370610509-32432-1-git-send-email-laura.lawniczak@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130606215721.GA24059@kroah.com>
References: <20130606215721.GA24059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blen and bn were only used in commented code fragments.
since comments should be informative and not for storing old
code, both, commented code and variables, were removed.

Signed-off-by: Laura Lawniczak <laura.lawniczak@googlemail.com>
Signed-off-by: Johannes Schilling <of82ecuq@cip.cs.fau.de>
---
 drivers/staging/keucr/transport.c |   15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/drivers/staging/keucr/transport.c b/drivers/staging/keucr/transport.c
index c47a035..aeb2186 100644
--- a/drivers/staging/keucr/transport.c
+++ b/drivers/staging/keucr/transport.c
@@ -85,16 +85,9 @@ static void usb_stor_print_cmd(struct us_data *us, struct scsi_cmnd *srb)
 {
 	PBYTE   Cdb = srb->cmnd;
 	DWORD   cmd = Cdb[0];
-	DWORD   bn  =   ((Cdb[2] << 24) & 0xff000000) |
-			((Cdb[3] << 16) & 0x00ff0000) |
-			((Cdb[4] << 8) & 0x0000ff00) |
-			((Cdb[5] << 0) & 0x000000ff);
-	WORD    blen = ((Cdb[7] << 8) & 0xff00) | ((Cdb[8] << 0) & 0x00ff);
 
 	switch (cmd) {
 	case TEST_UNIT_READY:
-		/* dev_dbg(&us->pusb_dev->dev,
-			"scsi cmd %X --- SCSIOP_TEST_UNIT_READY\n", cmd); */
 		break;
 	case INQUIRY:
 		dev_dbg(&us->pusb_dev->dev,
@@ -113,14 +106,8 @@ static void usb_stor_print_cmd(struct us_data *us, struct scsi_cmnd *srb)
 				"scsi cmd %X --- SCSIOP_READ_CAPACITY\n", cmd);
 		break;
 	case READ_10:
-		/*  dev_dbg(&us->pusb_dev->dev,
-			"scsi cmd %X --- SCSIOP_READ,bn = %X, blen = %X\n"
-			cmd, bn, blen); */
 		break;
 	case WRITE_10:
-		/* dev_dbg(&us->pusb_dev->dev,
-			"scsi cmd %X --- SCSIOP_WRITE, bn = %X, blen = %X\n",
-			cmd, bn, blen); */
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
 		dev_dbg(&us->pusb_dev->dev,
@@ -130,8 +117,6 @@ static void usb_stor_print_cmd(struct us_data *us, struct scsi_cmnd *srb)
 		dev_dbg(&us->pusb_dev->dev, "scsi cmd %X --- Other cmd\n", cmd);
 		break;
 	}
-	bn = 0;
-	blen = 0;
 }
 
 /*
-- 
1.7.10.4

