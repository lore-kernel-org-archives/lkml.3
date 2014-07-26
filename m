Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaGZO1s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:27:48 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:42134 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbaGZO1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:27:47 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stefan Weinhuber <wein@de.ibm.com>,
        Stefan Haberland <stefan.haberland@de.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s390: block: dasd_eer.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:29:12 +0200
Message-Id: <1406384952-2857-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/s390/block/dasd_eer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd_eer.c b/drivers/s390/block/dasd_eer.c
index 21ef63c..666dbd0 100644
--- a/drivers/s390/block/dasd_eer.c
+++ b/drivers/s390/block/dasd_eer.c
@@ -312,7 +312,7 @@ static void dasd_eer_write_standard_trigger(struct dasd_device *device,
 	do_gettimeofday(&tv);
 	header.tv_sec = tv.tv_sec;
 	header.tv_usec = tv.tv_usec;
-	strncpy(header.busid, dev_name(&device->cdev->dev),
+	strlcpy(header.busid, dev_name(&device->cdev->dev),
 		DASD_EER_BUSID_SIZE);
 
 	spin_lock_irqsave(&bufferlock, flags);
@@ -355,7 +355,7 @@ static void dasd_eer_write_snss_trigger(struct dasd_device *device,
 	do_gettimeofday(&tv);
 	header.tv_sec = tv.tv_sec;
 	header.tv_usec = tv.tv_usec;
-	strncpy(header.busid, dev_name(&device->cdev->dev),
+	strlcpy(header.busid, dev_name(&device->cdev->dev),
 		DASD_EER_BUSID_SIZE);
 
 	spin_lock_irqsave(&bufferlock, flags);
-- 
1.7.10.4

