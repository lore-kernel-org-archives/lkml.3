Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab3FAJ5C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:57:02 -0400
Received: from www17.your-server.de ([213.133.104.17]:60742 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759161Ab3FAJ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:56:51 -0400
Message-ID: <1370080606.29224.31.camel@localhost.localdomain>
Subject: [PATCH] drm/cma: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:56:46 +0200
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

diff -u -p a/drivers/gpu/drm/drm_gem_cma_helper.c b/drivers/gpu/drm/drm_gem_cma_helper.c
--- a/drivers/gpu/drm/drm_gem_cma_helper.c
+++ b/drivers/gpu/drm/drm_gem_cma_helper.c
@@ -174,10 +174,7 @@ int drm_gem_cma_dumb_create(struct drm_f
 
 	cma_obj = drm_gem_cma_create_with_handle(file_priv, dev,
 			args->size, &args->handle);
-	if (IS_ERR(cma_obj))
-		return PTR_ERR(cma_obj);
-
-	return 0;
+	return PTR_RET(cma_obj);
 }
 EXPORT_SYMBOL_GPL(drm_gem_cma_dumb_create);
 


