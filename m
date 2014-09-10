Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaIJPy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:54:57 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38474 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbaIJPyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:54:53 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 1/4] backlight: use static initializers
Date: Wed, 10 Sep 2014 17:54:20 +0200
Message-Id: <1410364463-12692-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use static initializers instead of setting up global variables during
runtime. This reduces code size and execution time.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/backlight/backlight.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index bddc8b1..726c6c6 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -21,9 +21,9 @@
 #include <asm/backlight.h>
 #endif
 
-static struct list_head backlight_dev_list;
-static struct mutex backlight_dev_list_mutex;
-static struct blocking_notifier_head backlight_notifier;
+static LIST_HEAD(backlight_dev_list);
+static DEFINE_MUTEX(backlight_dev_list_mutex);
+static BLOCKING_NOTIFIER_HEAD(backlight_notifier);
 
 static const char *const backlight_types[] = {
 	[BACKLIGHT_RAW] = "raw",
@@ -582,9 +582,6 @@ static int __init backlight_class_init(void)
 
 	backlight_class->dev_groups = bl_device_groups;
 	backlight_class->pm = &backlight_class_dev_pm_ops;
-	INIT_LIST_HEAD(&backlight_dev_list);
-	mutex_init(&backlight_dev_list_mutex);
-	BLOCKING_INIT_NOTIFIER_HEAD(&backlight_notifier);
 
 	return 0;
 }
-- 
2.1.0

