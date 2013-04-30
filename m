Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3D3GQv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 02:16:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46749 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3D3GQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 02:16:50 -0400
Date: Tue, 30 Apr 2013 08:16:25 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] media: i2c: mt9p031: add OF support
Message-ID: <20130430061625.GC16843@pengutronix.de>
References: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:11:28 up 51 days, 15:51, 21 users,  load average: 0.06, 0.14,
 0.13
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

One more point for your devicetree conversions,

On Mon, Apr 29, 2013 at 01:30:01PM +0530, Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the mt9p031 sensor driver.
> 
> +static struct mt9p031_platform_data
> +	*mt9p031_get_pdata(struct i2c_client *client)
> +
> +{
> +	if (!client->dev.platform_data && client->dev.of_node) {
> +		struct device_node *np;
> +		struct mt9p031_platform_data *pdata;
> +		int ret;
> +
> +		np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +		if (!np)
> +			return NULL;
> +
> +		pdata = devm_kzalloc(&client->dev,
> +				     sizeof(struct mt9p031_platform_data),
> +				     GFP_KERNEL);
> +		if (!pdata) {
> +			pr_warn("mt9p031 failed allocate memeory\n");
> +			return NULL;
> +		}
> +		ret = of_property_read_u32(np, "reset", &pdata->reset);
> +		if (ret == -EINVAL)
> +			pdata->reset = -1;
> +		else if (ret == -ENODATA)
> +			return NULL;
> +
> +		if (of_property_read_u32(np, "ext_freq", &pdata->ext_freq))
> +			return NULL;
> +
> +		if (of_property_read_u32(np, "target_freq",
> +					 &pdata->target_freq))
> +			return NULL;
> +
> +		return pdata;
> +	}

I don't know how the others see this, but IMO it would be cleaner to
first add a duplicate of the members of pdata in struct mt9p031 and then
initialize them either from pdata or from devicetree data. The
(artificial) creation of platform_data for the devicetree case adds a
new level of indirection. This may not be a problem here, but there are
cases where there is no 1:1 transcription between pdata and devicetree
possible.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
