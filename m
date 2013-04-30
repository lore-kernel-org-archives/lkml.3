Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760376Ab3D3LpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:45:25 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:57791 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab3D3LpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:45:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        LMML <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] media: i2c: mt9p031: add OF support
Date: Tue, 30 Apr 2013 13:45:31 +0200
Message-ID: <2667885.kq9SiOBOqS@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130430061625.GC16843@pengutronix.de>
References: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com> <20130430061625.GC16843@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Tuesday 30 April 2013 08:16:25 Sascha Hauer wrote:
> On Mon, Apr 29, 2013 at 01:30:01PM +0530, Prabhakar Lad wrote:
> > From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> > 
> > add OF support for the mt9p031 sensor driver.
> > 
> > +static struct mt9p031_platform_data
> > +	*mt9p031_get_pdata(struct i2c_client *client)
> > +
> > +{
> > +	if (!client->dev.platform_data && client->dev.of_node) {
> > +		struct device_node *np;
> > +		struct mt9p031_platform_data *pdata;
> > +		int ret;
> > +
> > +		np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> > +		if (!np)
> > +			return NULL;
> > +
> > +		pdata = devm_kzalloc(&client->dev,
> > +				     sizeof(struct mt9p031_platform_data),
> > +				     GFP_KERNEL);
> > +		if (!pdata) {
> > +			pr_warn("mt9p031 failed allocate memeory\n");
> > +			return NULL;
> > +		}
> > +		ret = of_property_read_u32(np, "reset", &pdata->reset);
> > +		if (ret == -EINVAL)
> > +			pdata->reset = -1;
> > +		else if (ret == -ENODATA)
> > +			return NULL;
> > +
> > +		if (of_property_read_u32(np, "ext_freq", &pdata->ext_freq))
> > +			return NULL;
> > +
> > +		if (of_property_read_u32(np, "target_freq",
> > +					 &pdata->target_freq))
> > +			return NULL;
> > +
> > +		return pdata;
> > +	}
> 
> I don't know how the others see this, but IMO it would be cleaner to
> first add a duplicate of the members of pdata in struct mt9p031 and then
> initialize them either from pdata or from devicetree data. The
> (artificial) creation of platform_data for the devicetree case adds a
> new level of indirection. This may not be a problem here, but there are
> cases where there is no 1:1 transcription between pdata and devicetree
> possible.

I have no strong opinion on this. In the mt9p031 case it won't matter much, 
but it's probably a good idea in general.

-- 
Regards,

Laurent Pinchart

