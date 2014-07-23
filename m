Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbaGWTvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 15:51:01 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34226 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932665AbaGWTvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 15:51:00 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: gregkh@linuxfoundation.org
Cc: john.stultz@linaro.org, rebecca@android.com, ccross@android.com,
        mitchelh@codeaurora.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: Remove checkpatch errors in ion.c for android staging
Date: Wed, 23 Jul 2014 15:50:55 -0400
Message-Id: <1406145055-4578-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes a few errors that checkpatch gives when run
on ion.c. I didn't remove the warning from returning in a void
function as we need to write ion_dma_buf_kunmap and I have no
idea how to do this as all we are doing in this function as of now
is returning and leaking the memory allocated in ion_dma_buf_kmap.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 drivers/staging/android/ion/ion.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 389b8f6..934d55d 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -56,6 +56,7 @@ struct ion_device {
 	struct mutex buffer_lock;
 	struct rw_semaphore lock;
 	struct plist_head heaps;
+
 	long (*custom_ioctl)(struct ion_client *client, unsigned int cmd,
 			     unsigned long arg);
 	struct rb_root clients;
@@ -805,6 +806,7 @@ struct ion_client *ion_client_create(struct ion_device *dev,
 						client, &debug_client_fops);
 	if (!client->debug_root) {
 		char buf[256], *path;
+
 		path = dentry_path(dev->clients_debug_root, buf, 256);
 		pr_err("Failed to create client debugfs at %s/%s\n",
 			path, client->display_name);
--
1.9.1

