Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760384Ab3B0AU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:20:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933895Ab3B0AJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [ 45/86] drm/udl: disable fb_defio by default
Date: Tue, 26 Feb 2013 16:07:53 -0800
Message-Id: <20130226235917.583162289@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 677d23b70bf949f75746c80cbae92c233c6b5e2a upstream.

There seems to be a bad interaction between gem/shmem and defio on top,
I get list corruption on the page lru in the shmem code.

Turn it off for now until we get some more digging done.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/udl/udl_fb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


