Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbaLVPxM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:53:12 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60529 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755247AbaLVPxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:53:09 -0500
Date: Mon, 22 Dec 2014 16:53:03 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: Re: [PATCH v2 4/7] imx-drm: ipuv3-crtc: Implement mode_fixup
Message-ID: <20141222155303.GB32333@pengutronix.de>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
 <1418954426-21909-5-git-send-email-steve_longerbeam@mentor.com>
 <20141220155254.GJ11285@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141220155254.GJ11285@n2100.arm.linux.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:28:56 up 68 days,  2:42, 41 users,  load average: 0,04, 0,08,
 0,11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: pza@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Sat, Dec 20, 2014 at 03:52:54PM +0000, Russell King - ARM Linux wrote:
> On Thu, Dec 18, 2014 at 06:00:23PM -0800, Steve Longerbeam wrote:
> > Ask the IPU display interface, via ipu_di_adjust_videomode(), to
> > adjust a video mode to meet any DI restrictions. The function takes
> > a subsystem independent videomode, so the drm_display_mode must be
> > converted to videomode first, and then the adjusted mode converted
> > back to a drm_display_mode.
> 
> What is the reason to use videomode (apart from it being subsystem
> independent)?  Do we forsee implementation of other output subsystems
> for the IPU?

There might be the issue of possible CSI -> IC -> DC -> DI passthrough,
where the DI timing must be synchronized to the CSI input signal.
I haven't really thought about how that should be integrated with the
DRM driver mostly because of the 1024 pixel output width maximum in the
IC, which limits the usefulness somewhat.
I like the use of struct videomode here for the symmetry with patch 6.
But currently, we could make ipu_di_adjust_videomode take a drm_display_mode
just as well.

regards
Philipp
