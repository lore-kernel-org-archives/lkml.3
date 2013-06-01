Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127Ab3FAKAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:00:21 -0400
Received: from www17.your-server.de ([213.133.104.17]:33320 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932628Ab3FAKAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 06:00:11 -0400
Message-ID: <1370080803.29224.41.camel@localhost.localdomain>
Subject: [PATCH] gpu: host1x: drm: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 12:00:03 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/host1x/drm/drm.c b/drivers/gpu/host1x/drm/drm.c
--- a/drivers/gpu/host1x/drm/drm.c
+++ b/drivers/gpu/host1x/drm/drm.c
@@ -328,10 +328,7 @@ static int tegra_gem_create(struct drm_d
 
 	bo = tegra_bo_create_with_handle(file, drm, args->size,
 					 &args->handle);
-	if (IS_ERR(bo))
-		return PTR_ERR(bo);
-
-	return 0;
+	return PTR_RET(bo);
 }
 
 static int tegra_gem_mmap(struct drm_device *drm, void *data,
diff -u -p a/drivers/gpu/host1x/drm/gem.c b/drivers/gpu/host1x/drm/gem.c
--- a/drivers/gpu/host1x/drm/gem.c
+++ b/drivers/gpu/host1x/drm/gem.c
@@ -205,10 +205,7 @@ int tegra_bo_dumb_create(struct drm_file
 
 	bo = tegra_bo_create_with_handle(file, drm, args->size,
 					    &args->handle);
-	if (IS_ERR(bo))
-		return PTR_ERR(bo);
-
-	return 0;
+	return PTR_RET(bo);
 }
 
 int tegra_bo_dumb_map_offset(struct drm_file *file, struct drm_device *drm,


