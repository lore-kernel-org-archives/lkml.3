Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3GIHFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 03:05:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43551 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab3GIHFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 03:05:46 -0400
Date: Tue, 9 Jul 2013 09:05:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Huang Shijie <b32955@freescale.com>
Cc: grant.likely@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] of: match the compatible in the order set by the dts file
Message-ID: <20130709070541.GQ516@pengutronix.de>
References: <1373013818-11365-1-git-send-email-b32955@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373013818-11365-1-git-send-email-b32955@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:03:43 up 12 days, 20:13, 65 users,  load average: 0.45, 0.21,
 0.11
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 04:43:38PM +0800, Huang Shijie wrote:
> If we set the uart compatible in the dts file like this:
>    ------------------------------------------------------
>     compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
>    ------------------------------------------------------
> 
> and we set the uart compatible in the uart driver like this:
>    ------------------------------------------------------
> 	{ .compatible = "fsl,imx1-uart", ... },
> 	{ .compatible = "fsl,imx21-uart", ... },
> 	{ .compatible = "fsl,imx6q-uart", ... },
> 	{ /* sentinel */ }
>    ------------------------------------------------------
> 
> the current code will match the "fsl,imx21-uart" in the end.
> 
> Of course, this is not what we want. We want it to match the "fsl,imx6q-uart".
> 
> This patch rewrites the match code, and make it to check the compatible
> in the order set by the DTS file.

Why don't you set the matching order in the driver the way you want it
to be, i.e.:

	{ .compatible = "fsl,imx6q-uart", ... },
	{ .compatible = "fsl,imx21-uart", ... },
	{ .compatible = "fsl,imx1-uart", ... },

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
