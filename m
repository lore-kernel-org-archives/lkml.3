Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433AbaH1UgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 16:36:12 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:29139 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaH1UgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 16:36:10 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>, Peter Foley <pefoley2@pefoley.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Documentation/video4linux: don't build without CONFIG_VIDEO_V4L2
Date: Fri, 29 Aug 2014 00:34:20 +0400
Message-Id: <1409258060-21897-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we get warnings:
WARNING: "vb2_ops_wait_finish" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
WARNING: "vb2_ops_wait_prepare" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!
...
WARNING: "video_unregister_device" [Documentation//video4linux/v4l2-pci-skeleton.ko] undefined!

Fixes: 8db5ab4b50fb ("Documentation: add makefiles for more targets")

Cc: Peter Foley <pefoley2@pefoley.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 Documentation/video4linux/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/video4linux/Makefile b/Documentation/video4linux/Makefile
index d58101e..f19f38e 100644
--- a/Documentation/video4linux/Makefile
+++ b/Documentation/video4linux/Makefile
@@ -1 +1,3 @@
+ifneq ($(CONFIG_VIDEO_V4L2),)
 obj-m := v4l2-pci-skeleton.o
+endif
-- 
1.9.3

