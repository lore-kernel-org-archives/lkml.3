Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaGZO0Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:26:16 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:43522 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaGZO0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:26:15 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Stefan Weinhuber <wein@de.ibm.com>,
        Stefan Haberland <stefan.haberland@de.ibm.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] s390: block: dasd_devmap.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:27:40 +0200
Message-Id: <1406384860-2775-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/s390/block/dasd_devmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 2ead7e7..4a60ef8 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -424,7 +424,7 @@ dasd_add_busid(const char *bus_id, int features)
 	if (!devmap) {
 		/* This bus_id is new. */
 		new->devindex = dasd_max_devindex++;
-		strncpy(new->bus_id, bus_id, DASD_BUS_ID_SIZE);
+		strlcpy(new->bus_id, bus_id, DASD_BUS_ID_SIZE);
 		new->features = features;
 		new->device = NULL;
 		list_add(&new->list, &dasd_hashlists[hash]);
-- 
1.7.10.4

