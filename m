Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbbASWCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 17:02:47 -0500
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:31619 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbbASWCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 17:02:46 -0500
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 19 Jan 2015 23:02:40 +0100
X-ME-IP: 90.20.161.114
From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
To: schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, rhoppe@de.ibm.com,
        linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] s390: char: Free memory on error path.
Date: Mon, 19 Jan 2015 23:02:00 +0100
Message-Id: <1421704920-29820-1-git-send-email-christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.1.0
X-Antivirus: avast! (VPS 150119-0, 19/01/2015), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free allocated page in case of error returned by hmcdrv_ftp_startup.

Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
---
 drivers/s390/char/hmcdrv_ftp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/char/hmcdrv_ftp.c b/drivers/s390/char/hmcdrv_ftp.c
index 4bd6332..f6e00af 100644
--- a/drivers/s390/char/hmcdrv_ftp.c
+++ b/drivers/s390/char/hmcdrv_ftp.c
@@ -199,8 +199,10 @@ int hmcdrv_ftp_probe(void)
 
 	rc = hmcdrv_ftp_startup();
 
-	if (rc)
+	if (rc) {
+		free_page((unsigned long) ftp.buf);
 		return rc;
+	}
 
 	rc = hmcdrv_ftp_do(&ftp);
 	free_page((unsigned long) ftp.buf);
-- 
2.1.0

