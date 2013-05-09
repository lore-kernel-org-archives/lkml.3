Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab3EIW3T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:29:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756456Ab3EIW0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:26:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@redhat.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 65/73] drm/tilcdc: Fix an incorrect condition
Date: Thu,  9 May 2013 15:25:55 -0700
Message-Id: <20130509222533.032455663@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130509222526.480204972@linuxfoundation.org>
References: <20130509222526.480204972@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sachin Kamat <sachin.kamat@linaro.org>

commit 9e48854c58ca9a0f39e716dcb18247bfc21e2022 upstream.

Instead of checking if num_encoders is zero, it is being assigned 0.
Convert the assignment to a check.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Acked-by: Rob Clark <robdclark@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -75,7 +75,7 @@ static int modeset_init(struct drm_devic
 		mod->funcs->modeset_init(mod, dev);
 	}
 
-	if ((priv->num_encoders = 0) || (priv->num_connectors == 0)) {
+	if ((priv->num_encoders == 0) || (priv->num_connectors == 0)) {
 		/* oh nos! */
 		dev_err(dev->dev, "no encoders/connectors found\n");
 		return -ENXIO;


