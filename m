Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbaIQV0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:26:54 -0400
Received: from mail-ig0-f181.google.com ([209.85.213.181]:34221 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbaIQV0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:26:52 -0400
Date: Wed, 17 Sep 2014 14:26:47 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Zhong <zyw@rock-chips.com>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Tao Huang <huangtao@rock-chips.com>, Eddie Cai <cf@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regulator: st-pwm: get voltage and duty table from
 dts
Message-ID: <20140917212647.GR30918@lee--X1>
References: <1410959280-29662-1-git-send-email-zyw@rock-chips.com>
 <1410959280-29662-2-git-send-email-zyw@rock-chips.com>
 <CAD=FV=XpwK+HzybKMck8KJ6VDYt3h5LHXtkU=RCa4DUX0t-MGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAD=FV=XpwK+HzybKMck8KJ6VDYt3h5LHXtkU=RCa4DUX0t-MGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Doug Anderson wrote:
> On Wed, Sep 17, 2014 at 6:07 AM, Chris Zhong <zyw@rock-chips.com> wrote:
> > Get voltage & duty table from device tree might be better, other platforms can also use this
> > driver without any modify.
> >
> > Signed-off-by: Chris Zhong <zyw@rock-chips.com>
> 
> Why didn't you CC Lee Jones on your patches?  He's the author of the
> driver and should certainly be involved in reviewing your patches.
> 
> CCed him now.

Thanks Doug.

> >  drivers/regulator/Kconfig  |    1 -
> >  drivers/regulator/st-pwm.c |   80 +++++++++++++++++++++++---------------------
> >  2 files changed, 42 insertions(+), 39 deletions(-)
> >
> > diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
> > index fb32bab..06a9632 100644
> > --- a/drivers/regulator/Kconfig
> > +++ b/drivers/regulator/Kconfig
> > @@ -495,7 +495,6 @@ config REGULATOR_S5M8767
> >
> >  config REGULATOR_ST_PWM
> >         tristate "STMicroelectronics PWM voltage regulator"

It's okay to generify the driver and remove references to ST.

> > -       depends on ARCH_STI
> 
> Seems like you should add some wording saying that this driver is also
> useful for other PWM-based voltage regulators.

In the commit message yes, I wouldn't worry about doing that here.

> >         help
> >          This driver supports ST's PWM controlled voltage regulators.
> >
> > diff --git a/drivers/regulator/st-pwm.c b/drivers/regulator/st-pwm.c
> > index 5ea78df..877381b 100644
> > --- a/drivers/regulator/st-pwm.c
> > +++ b/drivers/regulator/st-pwm.c

In order to avoid confusion to future users, rename the file too.

[...]

> > -static const struct regulator_desc b2105_desc = {
> > +static struct regulator_desc b2105_desc = {
> >         .name           = "b2105-pwm-regulator",

Generify.

> >         .ops            = &st_pwm_regulator_voltage_ops,
> >         .type           = REGULATOR_VOLTAGE,
> >         .owner          = THIS_MODULE,
> > -       .n_voltages     = ARRAY_SIZE(b2105_duty_cycle_table),
> >         .supply_name    = "pwm",
> >  };
> >
> > -static const struct st_pwm_regulator_pdata b2105_info = {
> > -       .desc             = &b2105_desc,
> > -       .duty_cycle_table = b2105_duty_cycle_table,
> > -};
> > -
> >  static const struct of_device_id st_pwm_of_match[] = {
> > -       { .compatible = "st,b2105-pwm-regulator", .data = &b2105_info, },
> > +       { .compatible = "st,b2105-pwm-regulator" },

Remove and replace with "pwm-regulator".

As we're no longer matching, you can move this down to the bottom.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
