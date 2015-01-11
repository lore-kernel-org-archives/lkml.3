Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbbAKNuY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:50:24 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:35215 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbAKNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:50:23 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] gpu: drm: nouveau: nvif: device: Remove unused function
Date: Sun, 11 Jan 2015 14:53:28 +0100
Message-Id: <1420984409-17330-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function nvif_device_new() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/gpu/drm/nouveau/nvif/device.c |   18 ------------------
 drivers/gpu/drm/nouveau/nvif/device.h |    2 --
 2 files changed, 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvif/device.c b/drivers/gpu/drm/nouveau/nvif/device.c
index f477579..8522aa9 100644
--- a/drivers/gpu/drm/nouveau/nvif/device.c
+++ b/drivers/gpu/drm/nouveau/nvif/device.c
@@ -53,24 +53,6 @@ nvif_device_del(struct nvif_device *device)
 	kfree(device);
 }
 
-int
-nvif_device_new(struct nvif_object *parent, u32 handle, u32 oclass,
-		void *data, u32 size, struct nvif_device **pdevice)
-{
-	struct nvif_device *device = kzalloc(sizeof(*device), GFP_KERNEL);
-	if (device) {
-		int ret = nvif_device_init(parent, nvif_device_del, handle,
-					   oclass, data, size, device);
-		if (ret) {
-			kfree(device);
-			device = NULL;
-		}
-		*pdevice = device;
-		return ret;
-	}
-	return -ENOMEM;
-}
-
 void
 nvif_device_ref(struct nvif_device *device, struct nvif_device **pdevice)
 {
diff --git a/drivers/gpu/drm/nouveau/nvif/device.h b/drivers/gpu/drm/nouveau/nvif/device.h
index 43180f9..8440848 100644
--- a/drivers/gpu/drm/nouveau/nvif/device.h
+++ b/drivers/gpu/drm/nouveau/nvif/device.h
@@ -22,8 +22,6 @@ int  nvif_device_init(struct nvif_object *, void (*dtor)(struct nvif_device *),
 		      u32 handle, u32 oclass, void *, u32,
 		      struct nvif_device *);
 void nvif_device_fini(struct nvif_device *);
-int  nvif_device_new(struct nvif_object *, u32 handle, u32 oclass,
-		     void *, u32, struct nvif_device **);
 void nvif_device_ref(struct nvif_device *, struct nvif_device **);
 
 /*XXX*/
-- 
1.7.10.4

