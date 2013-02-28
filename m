Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996Ab3B1PDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:03:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42363 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3B1Oto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:49:44 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Airlie <airlied@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 095/139] drm/udl: disable fb_defio by default
Date: Thu, 28 Feb 2013 14:44:05 +0000
Message-Id: <1362062689-2567-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 677d23b70bf949f75746c80cbae92c233c6b5e2a upstream.

There seems to be a bad interaction between gem/shmem and defio on top,
I get list corruption on the page lru in the shmem code.

Turn it off for now until we get some more digging done.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/udl/udl_fb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index adbf85e..c9df873 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -22,9 +22,9 @@
 
 #include "drm_fb_helper.h"
 
-#define DL_DEFIO_WRITE_DELAY    5 /* fb_deferred_io.delay in jiffies */
+#define DL_DEFIO_WRITE_DELAY    (HZ/20) /* fb_deferred_io.delay in jiffies */
 
-static int fb_defio = 1;  /* Optionally enable experimental fb_defio mmap support */
+static int fb_defio = 0;  /* Optionally enable experimental fb_defio mmap support */
 static int fb_bpp = 16;
 
 module_param(fb_bpp, int, S_IWUSR | S_IRUSR | S_IWGRP | S_IRGRP);
-- 
1.8.1.2

