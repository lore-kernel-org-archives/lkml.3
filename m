Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbbAWKuw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 05:50:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43180 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbbAWKut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 05:50:49 -0500
Message-ID: <1422010236.3017.12.camel@pengutronix.de>
Subject: Re: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Date: Fri, 23 Jan 2015 11:50:36 +0100
In-Reply-To: <20150123025643.GA11412@victor>
References: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
	 <1420655248.3191.73.camel@pengutronix.de> <20150123025643.GA11412@victor>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:96de:80ff:fec2:9969
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

Am Freitag, den 23.01.2015, 10:56 +0800 schrieb Liu Ying:
> Hi,
> 
> It looks that the below commit makes my Hannstar XGA LVDS panel stop working
> on the i.MX6DL SabreSD board.  Any idea?
> 
> commit eb10d6355532def3a74aaabd115e2373cca70b9d
> Author: Steve Longerbeam <slongerbeam@gmail.com>
> Date:   Thu Dec 18 18:00:24 2014 -0800
> 
> imx-drm: encoder prepare/mode_set must use adjusted mode
> 
> The encoder ->prepare() and ->mode_set() methods need to use the
> hw adjusted mode, not the original mode.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> 
> Regards,
> Liu Ying

What are this panel timings? The adjustment should increase the vertical
back porch by up to two lines (so it is at least two lines), reducing
the front porch or vsync length by the same amount. Does this panel use
the HSYNC/VSYNC signals embedded in the LVDS stream?

regards
Philipp

