Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaAFPJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:09:48 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:36669 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbaAFPJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:09:46 -0500
Date: Mon, 6 Jan 2014 20:39:42 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 13/85] drivers: gpu: Mark functions as static and remove
 unused function in nve0.c
Message-ID: <db58f3d1210ead0743b0ed6613044977c5f6bcc9.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions nve0_gpio_intr(), nve0_gpio_intr_enable(),
nve0_gpio_intr_disable(), nve0_gpio_fini() and nve0_gpio_init() as
static in drm/nouveau/core/subdev/gpio/nve0.c because they are not used
outside this file. Remove unused function nve0_gpio_dtor() from file
drm/nouveau/core/subdev/gpio/nve0.c.

This eliminates the following warnings in
drm/nouveau/core/subdev/gpio/nve0.c:
drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c:32:1: warning: no previous prototype for ‘nve0_gpio_intr’ [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c:51:1: warning: no previous prototype for ‘nve0_gpio_intr_enable’ [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c:60:1: warning: no previous prototype for ‘nve0_gpio_intr_disable’ [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c:69:1: warning: no previous prototype for ‘nve0_gpio_fini’ [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c:78:1: warning: no previous prototype for ‘nve0_gpio_init’ [-Wmissing-prototypes]
drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c:93:1: warning: no previous prototype for ‘nve0_gpio_dtor’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c b/drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c
index 16b8c5b..428374a 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/gpio/nve0.c
@@ -28,7 +28,7 @@ struct nve0_gpio_priv {
 	struct nouveau_gpio base;
 };
 
-void
+static void
 nve0_gpio_intr(struct nouveau_subdev *subdev)
 {
 	struct nve0_gpio_priv *priv = (void *)subdev;
@@ -47,7 +47,7 @@ nve0_gpio_intr(struct nouveau_subdev *subdev)
 	nv_wr32(priv, 0xdc88, intr1);
 }
 
-void
+static void
 nve0_gpio_intr_enable(struct nouveau_event *event, int line)
 {
 	const u32 addr = line < 16 ? 0xdc00 : 0xdc80;
@@ -56,7 +56,7 @@ nve0_gpio_intr_enable(struct nouveau_event *event, int line)
 	nv_mask(event->priv, addr + 0x00, mask, mask);
 }
 
-void
+static void
 nve0_gpio_intr_disable(struct nouveau_event *event, int line)
 {
 	const u32 addr = line < 16 ? 0xdc00 : 0xdc80;
@@ -65,7 +65,7 @@ nve0_gpio_intr_disable(struct nouveau_event *event, int line)
 	nv_mask(event->priv, addr + 0x00, mask, 0x00000000);
 }
 
-int
+static int
 nve0_gpio_fini(struct nouveau_object *object, bool suspend)
 {
 	struct nve0_gpio_priv *priv = (void *)object;
@@ -74,7 +74,7 @@ nve0_gpio_fini(struct nouveau_object *object, bool suspend)
 	return nouveau_gpio_fini(&priv->base, suspend);
 }
 
-int
+static int
 nve0_gpio_init(struct nouveau_object *object)
 {
 	struct nve0_gpio_priv *priv = (void *)object;
@@ -89,13 +89,6 @@ nve0_gpio_init(struct nouveau_object *object)
 	return 0;
 }
 
-void
-nve0_gpio_dtor(struct nouveau_object *object)
-{
-	struct nve0_gpio_priv *priv = (void *)object;
-	nouveau_gpio_destroy(&priv->base);
-}
-
 static int
 nve0_gpio_ctor(struct nouveau_object *parent, struct nouveau_object *engine,
 	       struct nouveau_oclass *oclass, void *data, u32 size,
-- 
1.7.9.5

