Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3KKQXE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:23:04 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:60519 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904Ab3KKQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:22:56 -0500
MIME-Version: 1.0
Date: Mon, 11 Nov 2013 11:22:56 -0500
X-Google-Sender-Auth: DOr7W0EAvHKoApcpnXFXQH5mrYY
Message-ID: <CA+5PVA72-oR=-T=dL=Y=+gymuDSMd1E8VrSbzGQDxxuJDfoKZg@mail.gmail.com>
Subject: imx-drm/ipuv3-crtc.ko fails to link
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Sascha Hauer <s.hauer@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Dave Airlie <airlied@gmail.com>, devel@driverdev.osuosl.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

With v3.12-2839-gedae583 (Linus' tree as of this morning), the
ipuv3-crtc.ko module fails to link with the following messages:

ERROR: "ipu_plane_disable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "ipu_plane_enable" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "ipu_plane_irq" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "ipu_plane_get_resources"
[drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "ipu_plane_init" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "imx_drm_crtc_id" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "ipu_plane_mode_set" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "ipu_plane_set_base" [drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
ERROR: "ipu_plane_put_resources"
[drivers/staging/imx-drm/ipuv3-crtc.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


The relevant .config hunks are configured as such:

CONFIG_DRM_IMX=m
CONFIG_DRM_IMX_FB_HELPER=m
CONFIG_DRM_IMX_PARALLEL_DISPLAY=m
CONFIG_DRM_IMX_TVE=m
# CONFIG_DRM_IMX_LDB is not set
CONFIG_DRM_IMX_IPUV3_CORE=m
CONFIG_DRM_IMX_IPUV3=m


I can send the full .config if people would like to see it.

I'm guessing the ipu_plane_* functions listed here need EXPORT_SYMBOL
statements added to them.  Is this currently queued in anyone's tree?

josh
