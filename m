Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaJ0QxH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 12:53:07 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:59935 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbaJ0QxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 12:53:03 -0400
MIME-Version: 1.0
In-Reply-To: <20141027164338.GE2006@localhost>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
	<1414427215-14380-6-git-send-email-romain.perier@gmail.com>
	<1414427749.2421.5.camel@pengutronix.de>
	<20141027164153.GE14253@saruman>
	<20141027164338.GE2006@localhost>
Date: Mon, 27 Oct 2014 17:53:01 +0100
Message-ID: <CABgxDoJJ26nT4CmQoChOaWRYK8RzJDP7TRxmg6eow+MgjoQm8Q@mail.gmail.com>
Subject: Re: [PATCH v2 06/10] mfd: tps65910: Use the standard DT property system-power-controller
From: Romain Perier <romain.perier@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>, Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        devicetree <devicetree@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        mark.rutland@arm.com, linux-pm@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        robh+dt@kernel.org, "pawel.moll" <pawel.moll@arm.com>,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please take a look at "PATCH v1 1/10" of this serie, read it
carefully... it's already handled ^^

2014-10-27 17:43 GMT+01:00 Johan Hovold <johan@kernel.org>:
> On Mon, Oct 27, 2014 at 11:41:53AM -0500, Felipe Balbi wrote:
>> On Mon, Oct 27, 2014 at 05:35:49PM +0100, Lucas Stach wrote:
>> > Am Montag, den 27.10.2014, 16:26 +0000 schrieb Romain Perier:
>> > > No longer use custom property to define poweroff capability, use the standard
>> > > DT property instead.
>> > >
>> > > Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> > > ---
>> > >  drivers/mfd/tps65910.c | 3 +--
>> > >  1 file changed, 1 insertion(+), 2 deletions(-)
>> > >
>> > > diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
>> > > index 7612d89..a7faff2 100644
>> > > --- a/drivers/mfd/tps65910.c
>> > > +++ b/drivers/mfd/tps65910.c
>> > > @@ -423,8 +423,7 @@ static struct tps65910_board *tps65910_parse_dt(struct i2c_client *client,
>> > >
>> > >   board_info->irq = client->irq;
>> > >   board_info->irq_base = -1;
>> > > - board_info->pm_off = of_property_read_bool(np,
>> > > -                 "ti,system-power-controller");
>> > > + board_info->pm_off = of_is_system_power_controller();
>> > >
>> > >   return board_info;
>> > >  }
>> > You are breaking compatibility with older DTs here. This is not
>> > acceptable.
>> >
>> > You may change all in-tree DTs to use the new property and also patch
>> > the driver to understand it, but you must make sure that the driver
>> > still understands the old, custom property. And especially in this case
>> > it isn't really hard to do.
>>
>> correct, it should be simple to hide that under
>> of_is_system_power_controller() itself.
>
> Guys, take a look at the code (PATCH 1/10). ;)
>
> Johan
