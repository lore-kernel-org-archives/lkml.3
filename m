Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab3IPVUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 17:20:05 -0400
Received: from www17.your-server.de ([213.133.104.17]:59940 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3IPVUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 17:20:03 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Sep 2013 17:20:03 EDT
Message-ID: <1379366394.3828.10.camel@localhost.localdomain>
Subject: [PATCH] drm/msm: Odd PTR_ERR usage
From: Thomas Meyer <thomas@m3y3r.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        airlied <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
Date: Mon, 16 Sep 2013 23:19:54 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable priv->kms is not initialized yet.

Found by "scripts/coccinelle/tests/odd_ptr_err.cocci".
PTR_ERR should access the value just tested by IS_ERR.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -199,7 +199,7 @@ static int msm_load(struct drm_device *d
 		 * imx drm driver on iMX5
 		 */
 		dev_err(dev->dev, "failed to load kms\n");
-		ret = PTR_ERR(priv->kms);
+		ret = PTR_ERR(kms);
 		goto fail;
 	}
 

