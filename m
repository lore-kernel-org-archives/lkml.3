Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaCJCly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:41:54 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:32243
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752592AbaCJClx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:41:53 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <airlied@linux.ie>, <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
Subject: [PATCH v2] drm/fb-helper: Do the 'max_conn_count' zero check
Date: Mon, 10 Mar 2014 09:33:58 +0800
Message-ID: <1394415238-20085-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we cannot make sure the 'max_conn_count' will always be none
zero from the users, and then if max_conn_count equals to zero, the
kcalloc() will return ZERO_SIZE_PTR, which equals to ((void *)16).

So this patch fix this with just doing the 'max_conn_count' zero check
in the front of drm_fb_helper_init().

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
CC: Jani Nikula <jani.nikula@linux.intel.com>
---
 drivers/gpu/drm/drm_fb_helper.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 3d13ca6e2..a0d286c 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -514,6 +514,9 @@ int drm_fb_helper_init(struct drm_device *dev,
 	struct drm_crtc *crtc;
 	int i;
 
+	if (!max_conn_count)
+		return -EINVAL;
+
 	fb_helper->dev = dev;
 
 	INIT_LIST_HEAD(&fb_helper->kernel_fb_list);
-- 
1.8.4


