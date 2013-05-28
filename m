Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815Ab3E1JkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:40:06 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:46562 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933768Ab3E1JkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:40:03 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] md: md.c: use strlcpy instead of strcpy
Date: Tue, 28 May 2013 02:39:41 -0700
Message-Id: <1369733981-10679-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Name of major driver can be of maximum of DISK_NAME_LEN size, therefore
use strlcpy instead of strcpy.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/md/md.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0bbe710..9450a2c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4863,7 +4863,7 @@ static int md_alloc(dev_t dev, char *name)
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
 	if (name)
-		strcpy(disk->disk_name, name);
+		strlcpy(disk->disk_name, name, DISK_NAME_LEN);
 	else if (partitioned)
 		sprintf(disk->disk_name, "md_d%d", unit);
 	else
-- 
1.7.10.4

