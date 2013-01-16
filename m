Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab3APNP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:15:57 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:60849 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab3APNPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:15:55 -0500
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, gregkh@linuxfoundation.org, volokh84@gmail.com,
        dhowells@redhat.com, rdunlap@xenotime.net, hans.verkuil@cisco.com,
        justinmattock@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] staging: media: go7007: memory clear fix memory clearing for v4l2_subdev allocation
Date: Wed, 16 Jan 2013 17:00:48 +0400
Message-Id: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-driver.c |    2 +-
 drivers/staging/media/go7007/go7007-v4l2.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index ece2dd1..a66e339 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -571,7 +571,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	struct go7007 *go;
 	int i;
 
-	go = kmalloc(sizeof(struct go7007), GFP_KERNEL);
+	go = kzalloc(sizeof(struct go7007), GFP_KERNEL);
 	if (go == NULL)
 		return NULL;
 	go->dev = dev;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index a78133b..e6fa543 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -98,7 +98,7 @@ static int go7007_open(struct file *file)
 
 	if (go->status != STATUS_ONLINE)
 		return -EBUSY;
-	gofh = kmalloc(sizeof(struct go7007_file), GFP_KERNEL);
+	gofh = kzalloc(sizeof(struct go7007_file), GFP_KERNEL);
 	if (gofh == NULL)
 		return -ENOMEM;
 	++go->ref_count;
-- 
1.7.7.6

