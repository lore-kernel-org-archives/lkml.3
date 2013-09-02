Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960Ab3IBIVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:21:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50097 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753916Ab3IBIVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:21:18 -0400
Date: Mon, 2 Sep 2013 10:21:09 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: airlied@redhat.com, gregkh@linuxfoundation.org, daniel.vetter@ffwll.ch,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH v3] imx-drm: Fix probe failure
Message-ID: <20130902082109.GO30088@pengutronix.de>
References: <1377885192-22005-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377885192-22005-1-git-send-email-festevam@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:20:42 up 8 days, 17:51, 33 users,  load average: 1.59, 1.43, 0.95
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 02:53:12PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
> 
> Since commit b5dc0d10 (drm/imx: kill firstopen callback) the following probe
> failure is seen:
> 
> [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [drm] No driver support for vblank timestamp query.
> [drm] Initialized imx-drm 1.0.0 20120507 on minor 0
> imx-ldb ldb.10: adding encoder failed with -16
> imx-ldb: probe of ldb.10 failed with error -16
> imx-ipuv3 2400000.ipu: IPUv3H probed
> imx-ipuv3 2800000.ipu: IPUv3H probed
> imx-ipuv3-crtc imx-ipuv3-crtc.0: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.0 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.1: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.1 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.2: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.2 failed with error -16
> imx-ipuv3-crtc imx-ipuv3-crtc.3: adding crtc failed with -16.
> imx-ipuv3-crtc: probe of imx-ipuv3-crtc.3 failed with error -16
> 
> The reason for the probe failure is that now 'imxdrm->references' is incremented
> early in imx_drm_driver_load(), so the following checks in imx_drm_add_crtc()
> and imx_drm_add_encoder():
> 
> 	if (imxdrm->references) {
> 		ret = -EBUSY;
> 		goto err_busy;
> 	}
> 
> ,will always fail.
> 
> Instead of manually keeping the references in the imx-drm driver, let's use
> drm->open_count.
> 
> After this patch, lvds panel is functional on a mx6qsabrelite board.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> ---
> This one should go via Dave Airlie's tree instead of Greg's tree because
> b5dc0d10 is in Dave's tree.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
