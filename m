Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832AbaIEHLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 03:11:35 -0400
Received: from mail-by2on0133.outbound.protection.outlook.com ([207.46.100.133]:17952
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751566AbaIEHLe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 03:11:34 -0400
From: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
To: "wim@iguana.be" <wim@iguana.be>, "linux@roeck-us.net" <linux@roeck-us.net>,
        "mpa@pengutronix.de" <mpa@pengutronix.de>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
 endianness method.
Thread-Topic: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
 endianness method.
Thread-Index: AQHPwDpuCOL/HMzK6EOO8Uq1kEa2JJvyMIWA
Date: Fri, 5 Sep 2014 07:11:31 +0000
Message-ID: <54446636ab294eed83c4a4e3d405dfe7@BY2PR0301MB0613.namprd03.prod.outlook.com>
References: <1408953277-2069-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1408953277-2069-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [123.151.195.49]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;UriScan:;
x-forefront-prvs: 0325F6C77B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019016)(979002)(6009001)(13464003)(377454003)(51704005)(164054003)(189002)(199003)(81542001)(106116001)(107046002)(31966008)(106356001)(74316001)(108616004)(105586002)(76576001)(83322001)(86362001)(2656002)(99396002)(4396001)(77982001)(79102001)(77096002)(19580405001)(19580395003)(76482001)(74662001)(46102001)(90102001)(74502001)(99286002)(95666004)(83072002)(85852003)(87936001)(66066001)(20776003)(76176999)(81342001)(101416001)(2201001)(2501002)(21056001)(80022001)(50986999)(33646002)(85306004)(54356999)(92566001)(64706001)(24736002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0614;H:BY2PR0301MB0613.namprd03.prod.outlook.com;FPR:;MLV:ovrnspm;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Ping :)

Thanks,

BRs
Xiubo


> -----Original Message-----
> From: Xiubo Li [mailto:Li.Xiubo@freescale.com]
> Sent: Monday, August 25, 2014 3:55 PM
> To: wim@iguana.be; linux@roeck-us.net; mpa@pengutronix.de; linux-
> watchdog@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; devicetree@vger.kernel.org; Xiubo Li-B47053
> Subject: [PATCHv2] watchdog: imx2_wdt: Convert to use regmap framework's
> endianness method.
> 
> Regmap framework will contain some patches to handle endianess, and there
> does not need any parsing of endianness DT properties of individual driver,
> so we can savely remove it here.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> Cc: Markus Pargmann <mpa@pengutronix.de>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> ---
> 
> Changes in v2:
> - Remove useless header file.
> 
> 
> 
> 
>  Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt | 4 ++--
>  drivers/watchdog/imx2_wdt.c                                | 9 +--------
>  2 files changed, 3 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> index e52ba2d..9e1ebe2 100644
> --- a/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> +++ b/Documentation/devicetree/bindings/watchdog/fsl-imx-wdt.txt
> @@ -6,8 +6,8 @@ Required properties:
>  - interrupts : Should contain WDT interrupt
> 
>  Optional property:
> -- big-endian: If present the watchdog device's registers are implemented
> -  in big endian mode, otherwise in little mode.
> +- big-endian: Boolean property, required if all the i.MX WDT registers
> +  are big-endian rather than little-endian.
> 
>  Examples:
> 
> diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
> index 68c3d37..afc8738 100644
> --- a/drivers/watchdog/imx2_wdt.c
> +++ b/drivers/watchdog/imx2_wdt.c
> @@ -28,7 +28,6 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/moduleparam.h>
> -#include <linux/of_address.h>
>  #include <linux/platform_device.h>
>  #include <linux/regmap.h>
>  #include <linux/timer.h>
> @@ -182,7 +181,7 @@ static struct watchdog_ops imx2_wdt_ops = {
>  	.set_timeout = imx2_wdt_set_timeout,
>  };
> 
> -static struct regmap_config imx2_wdt_regmap_config = {
> +static const struct regmap_config imx2_wdt_regmap_config = {
>  	.reg_bits = 16,
>  	.reg_stride = 2,
>  	.val_bits = 16,
> @@ -191,12 +190,10 @@ static struct regmap_config imx2_wdt_regmap_config = {
> 
>  static int __init imx2_wdt_probe(struct platform_device *pdev)
>  {
> -	struct device_node *np = pdev->dev.of_node;
>  	struct imx2_wdt_device *wdev;
>  	struct watchdog_device *wdog;
>  	struct resource *res;
>  	void __iomem *base;
> -	bool big_endian;
>  	int ret;
>  	u32 val;
> 
> @@ -204,10 +201,6 @@ static int __init imx2_wdt_probe(struct platform_device
> *pdev)
>  	if (!wdev)
>  		return -ENOMEM;
> 
> -	big_endian = of_property_read_bool(np, "big-endian");
> -	if (big_endian)
> -		imx2_wdt_regmap_config.val_format_endian = REGMAP_ENDIAN_BIG;
> -
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	base = devm_ioremap_resource(&pdev->dev, res);
>  	if (IS_ERR(base))
> --
> 1.8.5

