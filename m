Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaIEQGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:06:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:42865 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaIEQGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:06:44 -0400
Date: Fri, 5 Sep 2014 09:06:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "wim@iguana.be" <wim@iguana.be>, "mpa@pengutronix.de" <mpa@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
 endianness method.
Message-ID: <20140905160640.GB12374@roeck-us.net>
References: <1408953277-2069-1-git-send-email-Li.Xiubo@freescale.com>
 <54446636ab294eed83c4a4e3d405dfe7@BY2PR0301MB0613.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54446636ab294eed83c4a4e3d405dfe7@BY2PR0301MB0613.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 07:11:31AM +0000, Li.Xiubo@freescale.com wrote:
> Hi,
> 
> Ping :)
> 
Wim usually picks up patches shortly before the next release window opens.

It is in my watchdog-next branch, so it is not forgotten. I'll send a pull
request to Wim after -rc5.

Wim, I am wondering - should I ask Stephen to add my watchdog-next branch to
linux-next ? I know it isn't really perfect, and there is no guarantee that
you will accept the patches in my branch, but it would expose the pending
patches to earlier visibility in -next.

Thanks,
Guenter

> Thanks,
> 
> BRs
> Xiubo
> 
> 
> > -----Original Message-----
> > From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> > Sent: Monday, August 25, 2014 3:55 PM
> > To: wim@iguana.be; linux@roeck-us.net; mpa@pengutronix.de; linux-
> > watchdog@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; Xiubo Li-B47053
> > Subject: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
> > endianness method.
> > 
> > Regmap framework will contain some patches to handle endianess, and there
> > does not need any parsing of endianness DT properties of individual driver,
> > so we can savely remove it here.
> > 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > Cc: Markus Pargmann <mpa@pengutronix.de>
> > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> > 
> > Changes in v2:
> > - Remove useless header file.
> > 
> > 
> > 
> > 
> >  Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt | 4 ++--
> >  drivers/watchdog/imx2_wdt.c                                | 9 +--------
> >  2 files changed, 3 insertions(+), 10 deletions(-)
> > 
> > diff --git a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > index e52ba2d..9e1ebe2 100644
> > --- a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > +++ b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> > @@ -6,8 +6,8 @@ Required properties:
> >  - interrupts : Should contain WDT interrupt
> > 
> >  Optional property:
> > -- big-endian: If present the watchdog device's registers are implemented
> > -  in big endian mode, otherwise in little mode.
> > +- big-endian: Boolean property, required if all the i.MX WDT registers
> > +  are big-endian rather than little-endian.
> > 
> >  Examples:
> > 
> > diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> > index 68c3d37..afc8738 100644
> > --- a/drivers/watchdog/imx2_wdt.c
> > +++ b/drivers/watchdog/imx2_wdt.c
> > @@ -28,7 +28,6 @@
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> >  #include <linux/moduleparam.h>
> > -#include <linux/of_address.h>
> >  #include <linux/platform_device.h>
> >  #include <linux/regmap.h>
> >  #include <linux/timer.h>
> > @@ -182,7 +181,7 @@ static struct watchdog_ops imx2_wdt_ops = {
> >  	.set_timeout = imx2_wdt_set_timeout,
> >  };
> > 
> > -static struct regmap_config imx2_wdt_regmap_config = {
> > +static const struct regmap_config imx2_wdt_regmap_config = {
> >  	.reg_bits = 16,
> >  	.reg_stride = 2,
> >  	.val_bits = 16,
> > @@ -191,12 +190,10 @@ static struct regmap_config imx2_wdt_regmap_config = {
> > 
> >  static int __init imx2_wdt_probe(struct platform_device *pdev)
> >  {
> > -	struct device_node *np = pdev->dev.of_node;
> >  	struct imx2_wdt_device *wdev;
> >  	struct watchdog_device *wdog;
> >  	struct resource *res;
> >  	void __iomem *base;
> > -	bool big_endian;
> >  	int ret;
> >  	u32 val;
> > 
> > @@ -204,10 +201,6 @@ static int __init imx2_wdt_probe(struct platform_device
> > *pdev)
> >  	if (!wdev)
> >  		return -ENOMEM;
> > 
> > -	big_endian = of_property_read_bool(np, "big-endian");
> > -	if (big_endian)
> > -		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> > -
> >  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >  	base = devm_ioremap_resource(&pdev->dev, res);
> >  	if (IS_ERR(base))
> > --
> > 1.8.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
