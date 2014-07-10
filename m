Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090AbaGJPTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 11:19:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55614 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbaGJPTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 11:19:34 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-6d-53beaf024106
From: Kamil Debski <k.debski@samsung.com>
To: "'Tobias Klauser'" <tklauser@distanz.ch>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, Tomasz Figa <t.figa@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <1404917600-4430-1-git-send-email-k.debski@samsung.com>
 <20140709174939.GE27655@distanz.ch>
In-reply-to: <20140709174939.GE27655@distanz.ch>
Subject: RE: [PATCH] hwmon: pwm-fan: Add pwm-fan driver
Date: Thu, 10 Jul 2014 17:19:36 +0200
Message-id: <107501cf9c52$5cc21bb0$16465310$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+bnitDs++D7F5HTpmhQIstxIudiQAs/sHA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t/xy7pM6/cFGxx/Y2Ax/8g5VovLu+aw
	WdyZtpfNYu2Ru+wW62e8ZrE4cOAvowObx5VTp9k9HkzczebRt2UVo8fnTXIBLFFcNimpOZll
	qUX6dglcGWtbt7IWPBCtmHx+BVMD422BLkZODgkBE4meXXtYIGwxiQv31rOB2EICSxklnl2M
	hbAbmCQ+LnTrYuTgYBPQlFh1zwMkLCKgJTHzcDdYK7PAKkaJU8slIMozJWZ/28AIYnMKGEgs
	XHIIzBYWMJc41rwNzGYRUJWYN/s32CpeAQeJfTMes0PYghI/Jt+DmqklsX7ncSYIW15i85q3
	zCAnSAioSzz6qwtiiggYSbTv44OoEJG42/CcdQKj0Cwkg2YhGTQLyaBZSFoWMLKsYhRNLU0u
	KE5KzzXUK07MLS7NS9dLzs/dxAiJiC87GBcfszrEKMDBqMTDq1G7O1iINbGsuDL3EKMEB7OS
	CG/5in3BQrwpiZVVqUX58UWlOanFhxiZODilGhjlluZfZChiivQVrvzK/nmGBYuJ1Tb/3Vfn
	CdovdHj76PHF/OjN17I7MhJ3fT6qyffs/wGTitbEGyWzTryseVh/y6vlxsXwSLbVGX5SPvlf
	WO7rl4WVzA7albtQ0Yg7IS0xatWfj2yCBh5iff/Dj27couSR5cDx0K1r2RObjLi/ij5r94YX
	NymxFGckGmoxFxUnAgATlYCcZgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

Thank you for your review.

> From: Tobias Klauser [mailto:tklauser@distanz.ch]
> Sent: Wednesday, July 09, 2014 7:50 PM
> 
> On 2014-07-09 at 16:53:20 +0200, Kamil Debski <k.debski@samsung.com>
> wrote:
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
> ++++++++++++++++++++
> >  4 files changed, 221 insertions(+)
> >  create mode 100644
> > Documentation/devicetree/bindings/hwmon/pwm-fan.txt
> >  create mode 100644 drivers/hwmon/pwm-fan.c
> 
> [...]
> 
> > diff --git a/drivers/hwmon/pwm-fan.c b/drivers/hwmon/pwm-fan.c new
> > file mode 100644 index 0000000..78fa627
> > --- /dev/null
> > +++ b/drivers/hwmon/pwm-fan.c
> > @@ -0,0 +1,199 @@
> 
> [...]
> 
> > +#ifdef CONFIG_PM_SLEEP
> > +static int pwm_fan_suspend(struct device *dev) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	return pwm_config(ctx->pwm, 0, ctx->pwm->period); }
> > +
> > +static int pwm_fan_resume(struct device *dev) {
> > +	struct pwm_fan_ctx *ctx = dev_get_drvdata(dev);
> > +
> > +	return pwm_config(ctx->pwm, ctx->duty_cycle, ctx->pwm->period); }
> > +
> > +static SIMPLE_DEV_PM_OPS(pwm_fan_pm, pwm_fan_suspend,
> > +pwm_fan_resume);
> 
> If you move this out of #ifdef CONFIG_PM_SLEEP, you won't need the
> #ifdef around driver.pm below [1]. SIMPLE_DEV_PM_OPS will just define
> an empty struct dev_pm_os if CONFIG_PM_LSEEP is not defined.

Thanks for this suggestion.

> 
> > +#endif
> > +
> > +
> > +
> > +static struct of_device_id of_pwm_fan_match[] = {
> > +	{ .compatible = "pwm-fan", },
> > +	{},
> > +};
> > +
> > +static struct platform_driver pwm_fan_driver = {
> > +	.probe		= pwm_fan_probe,
> > +	.remove		= pwm_fan_remove,
> > +	.driver	= {
> > +		.name		= "pwm-fan",
> > +#ifdef CONFIG_PM_SLEEP
> > +		.pm		= &pwm_fan_pm,
> > +#endif
> 
> [1] #ifdef CONFIG_PM_SLEEP not needed with the above change.
> 
> > +		.of_match_table	= of_match_ptr(of_pwm_fan_match),
> > +	},
> > +};
> > +
> > +module_platform_driver(pwm_fan_driver);
> > +
> > +MODULE_AUTHOR("Kamil Debski <k.debski@samsung.com>");
> > +MODULE_ALIAS("platform:pwm-fan");
> > +MODULE_DESCRIPTION("PWM FAN driver"); MODULE_LICENSE("GPL");
> > --
> > 1.7.9.5

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

