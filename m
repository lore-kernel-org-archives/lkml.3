Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab3FQIss (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 04:48:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37051 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab3FQIsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 04:48:47 -0400
Date: Mon, 17 Jun 2013 10:48:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [RFC] Staging: imx-drm: Do not use fractional part of divider
Message-ID: <20130617084844.GP32299@pengutronix.de>
References: <1371195670.904413971@f400.i.mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371195670.904413971@f400.i.mail.ru>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:47:40 up 358 days, 23:59, 94 users,  load average: 0.51, 0.59,
 0.65
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 14, 2013 at 11:41:10AM +0400, Alexander Shiyan wrote:
> Hello.
> 
> Analysis of driver imx-drm led me to believe that the use fractional part of the divider is not always a good idea.
> For example, for a parallel display bus connected to LVDS converter chip (DS90C363), in this case the use of
> fractional part, clock will unstable and the on-chip PLL is not working properly, or rather, does not work at all.
> 
> Let me give a specific example.
> ipu_crtc_mode_set 0x36314752
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000035 outrate: 40150928 wanted: 40000000
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000035 outrate: 40150928 wanted: 40150928
> imx-ipuv3 40000000.ipu: clk_di_set_rate: inrate: 133000000 desired: 40150928 div: 0x00000035
> 
> In this case the divider is 3.5, that result to clock is incorrect. See an attached oscillogram F0000TEK.jpg.
> 
> After a patch the clocks is OK. Patch just uncomment some FSL code.
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000040 outrate: 33250000 wanted: 40000000
> imx-ipuv3 40000000.ipu: clk_di_round_rate: inrate: 133000000 div: 0x00000040 outrate: 33250000 wanted: 33250000
> imx-ipuv3 40000000.ipu: clk_di_set_rate: inrate: 133000000 desired: 33250000 div: 0x00000040
> 
> See an attached oscillogram F0001TEK.jpg.
> 
> So, I want to review this from developers and wait for comments.
> 

We may need some flag in the devicetree to specify whether the
fractional divider can be used or not.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
