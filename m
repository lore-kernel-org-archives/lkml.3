Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaGNNrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 09:47:35 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50871 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaGNNr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 09:47:27 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-11-53c3df6ca978
From: Kamil Debski <k.debski@samsung.com>
To: "'Guenter Roeck'" <linux@roeck-us.net>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-pwm@vger.kernel.org,
        thierry.reding@gmail.com
References: <1404917600-4430-1-git-send-email-k.debski@samsung.com>
 <20140709165817.GA24842@roeck-us.net>
In-reply-to: <20140709165817.GA24842@roeck-us.net>
Subject: RE: [lm-sensors] [PATCH] hwmon: pwm-fan: Add pwm-fan driver
Date: Mon, 14 Jul 2014 15:47:24 +0200
Message-id: <126901cf9f6a$2503f5c0$6f0be140$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+blwAJnEaTCVqDQXqAN4TbaxFC4wD0D3bw
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xK7o59w8HG3y9pG8x/8g5VovLu+aw
	Wdy9u4rR4snCM0wWd6btZbNYe+Quu8X6Ga9ZLH7umsfiwOGxc9Zddo8HE3ezeez83sDu0bdl
	FaPH501yAaxRXDYpqTmZZalF+nYJXBn7tm9lLdjPW3FwzlHWBsapXF2MnBwSAiYSz6ZtYIKw
	xSQu3FvP1sXIxSEksJRR4tqyP6wQTgOTxNpZG1m6GDk42AQ0JVbd8wBpEBHQkLg+ZQ4jSA2z
	wENGiZ8/t7CBJIQEsiWuf7vPDGJzChhJzJi6AmyDsICLxK1rP8DiLAKqEv+uHmEHsXkFHCTu
	vXrNDGELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkBskBNQlHv3VhbjBSOLNgkOMECUiEncb
	nrNOYBSahWTSLCSTZiGZNAtJywJGllWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIXHzdQfj
	0mNWhxgFOBiVeHgL+A8HC7EmlhVX5h5ilOBgVhLh9bgBFOJNSaysSi3Kjy8qzUktPsTIxMEp
	1cAYIPz2O2++lxib6RZtP89mB0b+ib+35G8P9fH2rm7YNUNP99TDzdvTOVadcn5jHrqCJeLi
	sQXi33+8UVmxZpGnmvuSK1pOty+73X/41eiDkYCuqKDKUp68/z6+PyPXa/Wt5Ko0WVxW0uSV
	zqAxeZvshVlbGSVWm2W/UDlj8O/U3jzWqaYGf4qVWIozEg21mIuKEwFBqv0MeQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I forgot to address one of the comments.

> From: Guenter Roeck [mailto:groeck7@gmail.com] On Behalf Of Guenter
> Roeck
> Sent: Wednesday, July 09, 2014 6:58 PM
> To: Kamil Debski
> Cc: devicetree@vger.kernel.org; linux-kernel@vger.kernel.org; lm-
> sensors@lm-sensors.org; t.figa@samsung.com; m.szyprowski@samsung.com
> Subject: Re: [lm-sensors] [PATCH] hwmon: pwm-fan: Add pwm-fan driver
> 
> On Wed, Jul 09, 2014 at 04:53:20PM +0200, Kamil Debski wrote:
> > The pwm-fan driver enables control of fans connected to PWM lines.
> > This driver uses the PWM framework, so it is compatible with all PWM
> > devices that provide drivers through the PWM framework.
> >
> > Signed-off-by: Kamil Debski <k.debski@samsung.com>
> > ---
> >  .../devicetree/bindings/hwmon/pwm-fan.txt          |   12 ++
> >  drivers/hwmon/Kconfig                              |    9 +
> >  drivers/hwmon/Makefile                             |    1 +
> >  drivers/hwmon/pwm-fan.c                            |  199

<snip>

> > +static int pwm_fan_remove(struct platform_device *pdev) {
> > +	struct pwm_fan_ctx *ctx = platform_get_drvdata(pdev);
> > +
> > +	pwm_disable(ctx->pwm);
> 
> Is this needed ? I don't see it used by the leds-pwm driver on cleanup.

The pwm-samsung driver does not disable the PWM channel according to my
understanding of the code. But for example the pwm-renesas-tpu does
stop the PWM timer on free. What is the correct behavior?

Is the channel should be disabled on free then I agree that pwm_disable
is not necessary.

> > +	hwmon_device_unregister(ctx->hwmon);
> > +
> > +	return 0;
> > +}
> > +

<snip>

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

