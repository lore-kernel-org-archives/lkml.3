Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaINQl3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:41:29 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:63043 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772AbaINQl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:41:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIOANrEFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfAGBBBd4hAQBBScvIxBROR4ZiEIBqQ2PAxiFfIhtZAcWhDUFnQiMMIkPghuBRTsvgQaBRAEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 4/9 linux-next] drm/nouveau: use container_of to resolve nouveau_fbdev from drm_fb_helper
Date: Sun, 14 Sep 2014 18:40:17 +0200
Message-Id: <1410712823-29137-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410712823-29137-1-git-send-email-fabf@skynet.be>
References: <1410712823-29137-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
Compiled but untested.

 drivers/gpu/drm/nouveau/nouveau_fbcon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index 8bdd270..673d270 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -308,7 +308,8 @@ static int
 nouveau_fbcon_create(struct drm_fb_helper *helper,
 		     struct drm_fb_helper_surface_size *sizes)
 {
-	struct nouveau_fbdev *fbcon = (struct nouveau_fbdev *)helper;
+	struct nouveau_fbdev *fbcon =
+		container_of(helper, struct nouveau_fbdev, helper);
 	struct drm_device *dev = fbcon->dev;
 	struct nouveau_drm *drm = nouveau_drm(dev);
 	struct nvif_device *device = &drm->device;
-- 
1.9.1

