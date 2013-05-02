Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326Ab3EBNYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 09:24:20 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:44068 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab3EBNYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 09:24:18 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, LMML <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC v2] media: i2c: mt9p031: add OF support
Date: Thu, 02 May 2013 15:24:28 +0200
Message-ID: <5629971.jIvxpOF1A0@avalon>
User-Agent: KMail/4.10.2 (Linux/3.7.10-gentoo-r1; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CA+V-a8sXNhiHhu9HJgFKCAZGZwvqptLy56Akqqu+xDVQ-4amyg@mail.gmail.com>
References: <1367475754-19477-1-git-send-email-prabhakar.csengg@gmail.com> <1561679.1AUpDgdnFy@avalon> <CA+V-a8sXNhiHhu9HJgFKCAZGZwvqptLy56Akqqu+xDVQ-4amyg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

On Thursday 02 May 2013 18:48:37 Prabhakar Lad wrote:
> On Thu, May 2, 2013 at 4:32 PM, Laurent Pinchart wrote:
> > On Thursday 02 May 2013 12:34:25 Prabhakar Lad wrote:
> >> On Thu, May 2, 2013 at 12:25 PM, Sascha Hauer wrote:
> >> > On Thu, May 02, 2013 at 11:52:34AM +0530, Prabhakar Lad wrote:
> >> >> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> >> >> 
> >> >> add OF support for the mt9p031 sensor driver.
> >> >> Alongside this patch sorts the header inclusion alphabetically.

[snip]

> >> >> @@ -1070,8 +1120,16 @@ static const struct i2c_device_id mt9p031_id[]
> >> >> = {
> >> >>  };
> >> >>  MODULE_DEVICE_TABLE(i2c, mt9p031_id);
> >> >> 
> >> >> +static const struct of_device_id mt9p031_of_match[] = {
> >> >> +     { .compatible = "aptina,mt9p031", },
> >> >> +     { .compatible = "aptina,mt9p031m", },
> >> >> +     {},
> >> >> +};
> >> > 
> >> > I would have expected something like:
> >> > 
> >> > static const struct of_device_id mt9p031_of_match[] = {
> >> >         {
> >> >                 .compatible = "aptina,mt9p031-sensor",
> >> >                 .data = (void *)MT9P031_MODEL_COLOR,
> >> >         }, {
> >> >                 .compatible = "aptina,mt9p031m-sensor",
> >> >                 .data = (void *)MT9P031_MODEL_MONOCHROME,
> >> >         }, {
> >> >                 /* sentinel */
> >> >         },
> >> > };
> >> > 
> >> >         of_id = of_match_device(mt9p031_of_match, &client->dev);
> >> >         if (of_id)
> >> >                 mt9p031->model = (enum mt9p031_model)of_id->data;
> >> > 
> >> > To handle monochrome sensors.
> >> 
> >> OK will do the same.
> > 
> > And please guard the table with #ifdef CONFIG_OF.
> 
> But guarding the table #ifdef CONFIG_OF would cause compilation failure
> for below code when CONFIG_OF is undefined in probe
> 
> of_id = of_match_device(of_match_ptr(mt9p031_of_match),
> 			&client->dev);
> if (of_id)
> 	mt9p031->model = (enum mt9p031_model)of_id->data;

You could guard the above code with an #ifdef CONFIG_OF as well.

> and also in mt9p031_i2c_driver structure,
> of_match_table = of_match_ptr(mt9p031_of_match),
> 
> which force me to define mt9p031_of_match to NULL when
> CONFIG_OF is undefined

of_match_ptr is defined as NULL when CONFIG_OF is disabled.

-- 
Regards,

Laurent Pinchart

