Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaHULTt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:19:49 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:35440 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaHULTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:19:48 -0400
Date: Thu, 21 Aug 2014 12:19:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Gyungoh Yoo <gyungoh@gmail.com>, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, grant.likely@linaro.org, sameo@linux.intel.com,
        jack.yoo@skyworksinc.com, jason@lakedaemon.net,
        heiko.stuebner@bqreaders.com, florian.vaussard@epfl.ch, andrew@lunn.ch,
        silvio.fricke@gmail.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Adding Skyworks SKY81452 MFD driver
Message-ID: <20140821111940.GX4266@lee--X1>
References: <1407488899-31065-1-git-send-email-jack.yoo@skyworksinc.com>
 <20140821094502.GV4266@lee--X1>
 <20140821095935.GB21848@ulmo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140821095935.GB21848@ulmo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2014, Thierry Reding wrote:

> On Thu, Aug 21, 2014 at 10:45:02AM +0100, Lee Jones wrote:
> [...]
> > > diff --git a/drivers/mfd/sky81452.c b/drivers/mfd/sky81452.c
> [...]
> > > + * This program is free software; you can redistribute it and/or modify it
> > > + * under the terms of the GNU General Public License as published by the
> > > + * Free Software Foundation; either version 2, or (at your option) any
> > > + * later version.
> [...]
> > > +	{ }
> > > +};
> > > +MODULE_DEVICE_TABLE(i2c, sky81452_ids);
> > > +
> > > +#ifdef CONFIG_OF
> > > +static const struct of_device_id sky81452_of_match[] = {
> > > +	{ .compatible = "skyworks,sky81452", },
> > > +	{ }
> > > +};
> > > +MODULE_DEVICE_TABLE(of, sky81452_of_match);
> > > +#endif
> > 
> > You can drop the #differy the compiler should sort that out on the
> > back of of_match_ptr().
> 
> It won't, unfortunately. If !OF, then of_match_ptr(x) will evaluate to
> NULL, therefore sky81452_of_match will become unreferenced and cause the
> compiler to output a warning. I guess it could be made __maybe_unused,
> but I don't see that as much of an advantage over the #ifdef.

Yes, I suppose it would.  That's sad.

> > > +static struct i2c_driver sky81452_driver = {
> > > +	.driver = {
> > > +		.name = "sky81452",
> > > +		.of_match_table = of_match_ptr(sky81452_of_match),
> > > +	},
> > > +	.probe = sky81452_probe,
> > > +	.remove = sky81452_remove,
> > > +	.id_table = sky81452_ids,
> > > +};
> > > +
> > > +module_i2c_driver(sky81452_driver);
> > > +
> > > +MODULE_DESCRIPTION("Skyworks SKY81452 MFD driver");
> > > +MODULE_AUTHOR("Gyungoh Yoo <jack.yoo@skyworksinc.com>");
> > > +MODULE_LICENSE("GPL");
> > 
> > I think you want v2.
> 
> The header comment says "... version 2, or (at your option) any later
> version.", so I think "GPL" is the right one here.

Fair enough.  Withdrawn.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
