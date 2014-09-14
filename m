Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaINQl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 12:41:28 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:12808 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803AbaINQl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 12:41:27 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIOANrEFVRbsGnM/2dsb2JhbABggw2zSAEBAQEBAQUBbwGdfAGBBBd4hAQBBScvIxBROR4ZiEIBqQ2PAxiFfIlRBxaENQWdCIwwiQ+CG4FFOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: airlied@linux.ie, Fabian Frederick <fabf@skynet.be>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 5/9 linux-next] drm/nouveau: use container_of to resolve nouveau_plane from drm_plane
Date: Sun, 14 Sep 2014 18:40:18 +0200
Message-Id: <1410712823-29137-6-git-send-email-fabf@skynet.be>
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

 drivers/gpu/drm/nouveau/dispnv04/overlay.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/dispnv04/overlay.c b/drivers/gpu/drm/nouveau/dispnv04/overlay.c
index b36afcb..1e9056a 100644
--- a/drivers/gpu/drm/nouveau/dispnv04/overlay.c
+++ b/drivers/gpu/drm/nouveau/dispnv04/overlay.c
@@ -97,7 +97,8 @@ nv10_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 		  uint32_t src_w, uint32_t src_h)
 {
 	struct nvif_device *dev = &nouveau_drm(plane->dev)->device;
-	struct nouveau_plane *nv_plane = (struct nouveau_plane *)plane;
+	struct nouveau_plane *nv_plane =
+		container_of(plane, struct nouveau_plane, base);
 	struct nouveau_framebuffer *nv_fb = nouveau_framebuffer(fb);
 	struct nouveau_crtc *nv_crtc = nouveau_crtc(crtc);
 	struct nouveau_bo *cur = nv_plane->cur;
@@ -173,7 +174,8 @@ static int
 nv10_disable_plane(struct drm_plane *plane)
 {
 	struct nvif_device *dev = &nouveau_drm(plane->dev)->device;
-	struct nouveau_plane *nv_plane = (struct nouveau_plane *)plane;
+	struct nouveau_plane *nv_plane =
+		container_of(plane, struct nouveau_plane, base);
 
 	nvif_wr32(dev, NV_PVIDEO_STOP, 1);
 	if (nv_plane->cur) {
@@ -224,7 +226,8 @@ nv_set_property(struct drm_plane *plane,
 		struct drm_property *property,
 		uint64_t value)
 {
-	struct nouveau_plane *nv_plane = (struct nouveau_plane *)plane;
+	struct nouveau_plane *nv_plane =
+		container_of(plane, struct nouveau_plane, base);
 
 	if (property == nv_plane->props.colorkey)
 		nv_plane->colorkey = value;
@@ -344,7 +347,8 @@ nv04_update_plane(struct drm_plane *plane, struct drm_crtc *crtc,
 		  uint32_t src_w, uint32_t src_h)
 {
 	struct nvif_device *dev = &nouveau_drm(plane->dev)->device;
-	struct nouveau_plane *nv_plane = (struct nouveau_plane *)plane;
+	struct nouveau_plane *nv_plane =
+		container_of(plane, struct nouveau_plane, base);
 	struct nouveau_framebuffer *nv_fb = nouveau_framebuffer(fb);
 	struct nouveau_bo *cur = nv_plane->cur;
 	uint32_t overlay = 1;
@@ -423,7 +427,8 @@ static int
 nv04_disable_plane(struct drm_plane *plane)
 {
 	struct nvif_device *dev = &nouveau_drm(plane->dev)->device;
-	struct nouveau_plane *nv_plane = (struct nouveau_plane *)plane;
+	struct nouveau_plane *nv_plane =
+		container_of(plane, struct nouveau_plane, base);
 
 	nvif_mask(dev, NV_PVIDEO_OVERLAY, 1, 0);
 	nvif_wr32(dev, NV_PVIDEO_OE_STATE, 0);
-- 
1.9.1

