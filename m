Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965147Ab3GCTKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:10:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33268 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964979Ab3GCTAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:25 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=qoExL3tguocA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=QAEpPFIRYDgA:10 a=pGLkceISAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184103.669274302@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [102/141] drm/gma500: Increase max resolution for mode setting
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0102-drm-gma500-Increase-max-resolution-for-mode-setting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

[ Upstream commit cbbd379aa43890f36da934f5af619d2fb8ec3d87 ]

By having a higher max resolution we can now set up a virtual
framebuffer that spans several monitors. 4096 should be ok since we're
gen 3 or higher and should be enough for most dual head setups.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/gpu/drm/gma500/framebuffer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 5732b57..71a4b61 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -793,8 +793,8 @@ void psb_modeset_init(struct drm_device *dev)
 	for (i = 0; i < dev_priv->num_pipe; i++)
 		psb_intel_crtc_init(dev, i, mode_dev);
 
-	dev->mode_config.max_width = 2048;
-	dev->mode_config.max_height = 2048;
+	dev->mode_config.max_width = 4096;
+	dev->mode_config.max_height = 4096;
 
 	psb_setup_outputs(dev);
 
-- 
1.7.10.4


