Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800Ab3LBU6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:58:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754102Ab3LBTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:13:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.10 078/173] qxl: avoid an oops in the deferred io code.
Date: Mon,  2 Dec 2013 11:11:01 -0800
Message-Id: <20131202191152.325946939@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit cc87509d87696d7cd393882f5dedea01e03e41a9 upstream.

If we are using deferred io due to plymouth or X.org fbdev driver
we will oops in memcpy due to this pointless multiply here,

removing it fixes fbdev to start and not oops.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/qxl/qxl_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/qxl/qxl_fb.c
+++ b/drivers/gpu/drm/qxl/qxl_fb.c
@@ -91,7 +91,7 @@ static void qxl_fb_dirty_flush(struct fb
 	u32 x1, x2, y1, y2;
 
 	/* TODO: hard coding 32 bpp */
-	int stride = qfbdev->qfb.base.pitches[0] * 4;
+	int stride = qfbdev->qfb.base.pitches[0];
 
 	x1 = qfbdev->dirty.x1;
 	x2 = qfbdev->dirty.x2;


