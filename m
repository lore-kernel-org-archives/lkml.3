Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaGVG3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 02:29:39 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:56529 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbaGVG3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 02:29:37 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: wein@de.ibm.com
Cc: stefan.haberland@de.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s390: Fix me in dasd_eer.c
Date: Tue, 22 Jul 2014 02:29:32 -0400
Message-Id: <1406010572-13217-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes return type to EMEDUIMTYPE in function, dasd_eer_enable
for when checking if the medium has no errors according to this function.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/s390/block/dasd_eer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 21ef63c..08ee040 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -462,7 +462,7 @@ int dasd_eer_enable(struct dasd_device *device)
 		return 0;
 
 	if (!device->discipline || strcmp(device->discipline->name, "ECKD"))
-		return -EPERM;	/* FIXME: -EMEDIUMTYPE ? */
+		return -EMEDIUMTYPE;	/* FIXME: -EMEDIUMTYPE ? */
 
 	cqr = dasd_kmalloc_request(DASD_ECKD_MAGIC, 1 /* SNSS */,
 				   SNSS_DATA_SIZE, device);
-- 
1.9.1

