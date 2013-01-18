Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330Ab3ARWIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:08:53 -0500
Received: from outgoing.csail.mit.edu ([128.30.2.149]:57033 "EHLO
	outgoing.csail.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab3ARWIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:08:52 -0500
X-Greylist: delayed 2643 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jan 2013 17:08:52 EST
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: David Airlie <airlied@linux.ie>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] udl: zero out struct fb_deferred_io on allocation
Date: Fri, 18 Jan 2013 16:25:16 -0500
Message-Id: <1358544316-6024-1-git-send-email-nickolai@csail.mit.edu>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure all fields of the struct fb_deferred_io are zeroed out on init,
otherwise the fbdefio->first_io function pointer can contain garbage,
and fb_deferred_io_mkwrite() will end up jumping to this garbage address.

Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 drivers/gpu/drm/udl/udl_fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index d4ab3be..40503ba 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -301,7 +301,7 @@ static int udl_fb_open(struct fb_info *info, int user)
 
 		struct fb_deferred_io *fbdefio;
 
-		fbdefio = kmalloc(sizeof(struct fb_deferred_io), GFP_KERNEL);
+		fbdefio = kzalloc(sizeof(struct fb_deferred_io), GFP_KERNEL);
 
 		if (fbdefio) {
 			fbdefio->delay = DL_DEFIO_WRITE_DELAY;
-- 
1.7.10.4

