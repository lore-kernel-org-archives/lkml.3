Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab3H2ShN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:37:13 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42406 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757048Ab3H2ShK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:37:10 -0400
Date: Thu, 29 Aug 2013 20:37:06 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Dave Airlie <airlied@redhat.com>, daniel.vetter@ffwll.ch,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] imx-drm: Fix probe failure
Message-ID: <20130829183706.GZ30088@pengutronix.de>
References: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
 <20130829181412.GX30088@pengutronix.de>
 <CAOMZO5BXowdp87WavAS5t0q2K6nxFvcrAp-WK5anfDub+H+5kA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5BXowdp87WavAS5t0q2K6nxFvcrAp-WK5anfDub+H+5kA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:31:43 up 5 days,  4:02, 38 users,  load average: 0.02, 0.04, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 03:30:12PM -0300, Fabio Estevam wrote:
> >> @@ -485,11 +480,6 @@ int imx_drm_add_crtc(struct drm_crtc *crtc,
> >>
> >>       mutex_lock(&imxdrm->mutex);
> >>
> >> -     if (imxdrm->references) {
> >> -             ret = -EBUSY;
> >> -             goto err_busy;
> >> -     }
> >
> > As I told in v1: Simply removing the code is not an option. We agreed
> > that we use the drm core reference counting, so you must actually test
> > for it here...
> 
> Yes, we did, but after reading a separate thread on this topic, I
> learned that drm core does not support it currently.
> 
> Daniel mentions [1]: "And I wouldn't worry about module unloading and
> refcounting for
> now since core drm is terminally broken in that area already anyway"
> 
> [1] http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg43698.html
> 
> Can't we just apply this patch so that imx-drm can be functional again
> and fix module unloading/refcount later?

It's not about the module refcount. It's only that a on a drm device
which is in use you better do not add/remove components.

Again: The imx-drm driver does *not* do hotplugging. It will *not* add
or remove components when the device is opened. The code you remove
exactly makes (or made before Daniels patch) that sure.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
