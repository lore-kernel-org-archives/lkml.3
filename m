Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3H3RG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 13:06:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56554 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3H3RGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 13:06:25 -0400
Date: Fri, 30 Aug 2013 19:06:18 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Fabio Estevam <fabio.estevam@freescale.com>,
        Dave Airlie <airlied@redhat.com>, daniel.vetter@ffwll.ch,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] imx-drm: Fix probe failure
Message-ID: <20130830170618.GE30088@pengutronix.de>
References: <1377784762-24045-1-git-send-email-fabio.estevam@freescale.com>
 <20130829181412.GX30088@pengutronix.de>
 <CAOMZO5BXowdp87WavAS5t0q2K6nxFvcrAp-WK5anfDub+H+5kA@mail.gmail.com>
 <20130829183706.GZ30088@pengutronix.de>
 <CAOMZO5ANriVriw5W6qPG7OxPAsbvVHfZfzoCJk-d3aiAtyQkFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5ANriVriw5W6qPG7OxPAsbvVHfZfzoCJk-d3aiAtyQkFA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 19:02:21 up 6 days,  2:33, 33 users,  load average: 0.07, 0.03, 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 01:08:14PM -0300, Fabio Estevam wrote:
> Hi Sascha,
> 
> On Thu, Aug 29, 2013 at 3:37 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > It's not about the module refcount. It's only that a on a drm device
> > which is in use you better do not add/remove components.
> >
> > Again: The imx-drm driver does *not* do hotplugging. It will *not* add
> > or remove components when the device is opened. The code you remove
> > exactly makes (or made before Daniels patch) that sure.
> 
> I am not sure what would be the correct fix for this.

Why not use (struct drm_device)->open_count as suggested earlier?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
