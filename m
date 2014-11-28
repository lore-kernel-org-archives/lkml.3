Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaK1Buo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 20:50:44 -0500
Received: from mail-bn1on0091.outbound.protection.outlook.com ([157.56.110.91]:61051
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750981AbaK1Bul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 20:50:41 -0500
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Soren Brinkmann <sorenb@xilinx.com>
CC: "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v3] can: Convert to runtime_pm
Thread-Topic: [PATCH v3] can: Convert to runtime_pm
Thread-Index: AQHQCm9CvELYd1JskEqth0DIY+yQN5x1RccA
Date: Fri, 28 Nov 2014 01:49:12 +0000
References: <6b6db31d46074512a322eae6e4ef64d4@BN1BFFO11FD038.protection.gbl>
 <20141127182337.GF17884@xsjandreislx>
In-Reply-To: <20141127182337.GF17884@xsjandreislx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.228.144]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21136.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <d306383c84b9479d933b15c4b38da532@BN1AFFO11FD025.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377424004)(13464003)(377454003)(189002)(24454002)(51704005)(106466001)(74316001)(46102003)(54356999)(106116001)(47776003)(19580395003)(87936001)(95666004)(33646002)(76176999)(20776003)(77096003)(6806004)(2656002)(62966003)(99396003)(21056001)(120916001)(50466002)(4396001)(110136001)(107046002)(64706001)(108616004)(104016003)(23676002)(31966008)(77156002)(92566001)(53416004)(50986999)(86362001)(19580405001)(44976005)(107986001)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB065;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB065;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB065;
X-Forefront-PRVS: 04097B7F7F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1AFFO11HUB065;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAS1ooMI028533

Hi Soren,

-----Original Message-----
From: SÃ¶ren Brinkmann [mailto:soren.brinkmann@xilinx.com]
Sent: Thursday, November 27, 2014 11:54 PM
To: Appana Durga Kedareswara Rao
Cc: wg@grandegger.com; mkl@pengutronix.de; Michal Simek; grant.likely@linaro.org; robh+dt@kernel.org; devicetree@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; linux-can@vger.kernel.org; Appana Durga Kedareswara Rao; linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] can: Convert to runtime_pm

Hi Kedar,

On Thu, 2014-11-27 at 06:38PM +0530, Kedareswara rao Appana wrote:
> Instead of enabling/disabling clocks at several locations in the
> driver, use the runtime_pm framework. This consolidates the actions
> for runtime PM in the appropriate callbacks and makes the driver more
> readable and mantainable.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> ---
> Changes for v3:
>   - Converted the driver to use runtime_pm.
> Changes for v2:
>   - Removed the struct platform_device* from suspend/resume
>     as suggest by Lothar.
>
>  drivers/net/can/xilinx_can.c |  119
> +++++++++++++++++++++++++----------------
>  1 files changed, 72 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/net/can/xilinx_can.c
> b/drivers/net/can/xilinx_can.c index 8a998e3..1be28ed 100644
> --- a/drivers/net/can/xilinx_can.c
> +++ b/drivers/net/can/xilinx_can.c
> @@ -32,6 +32,7 @@
>  #include <linux/can/dev.h>
>  #include <linux/can/error.h>
>  #include <linux/can/led.h>
> +#include <linux/pm_runtime.h>
>
>  #define DRIVER_NAME  "xilinx_can"
>
> @@ -138,7 +139,7 @@ struct xcan_priv {
>       u32 (*read_reg)(const struct xcan_priv *priv, enum xcan_reg reg);
>       void (*write_reg)(const struct xcan_priv *priv, enum xcan_reg reg,
>                       u32 val);
> -     struct net_device *dev;
> +     struct device *dev;
>       void __iomem *reg_base;
>       unsigned long irq_flags;
>       struct clk *bus_clk;
> @@ -842,6 +843,13 @@ static int xcan_open(struct net_device *ndev)
>       struct xcan_priv *priv = netdev_priv(ndev);
>       int ret;
>
> +     ret = pm_runtime_get_sync(priv->dev);
> +     if (ret < 0) {
> +             netdev_err(ndev, "%s: runtime CAN resume failed(%d)\n\r",

There might be other issues than the resume that make this fail. It should probably just say 'pm_runtime_get failed'.
The CAN in the string should not be needed, the netdev_err macro makes sure the device name is printed.
Can we have a space between 'failed' and the error code?
There should not be a '\r'

K sure will modify the error message as you explained above.

> +                             __func__, ret);
> +             return ret;
> +     }
> +
>       ret = request_irq(ndev->irq, xcan_interrupt, priv->irq_flags,
>                       ndev->name, ndev);
>       if (ret < 0) {
> @@ -849,29 +857,17 @@ static int xcan_open(struct net_device *ndev)
>               goto err;
>       }
>
> -     ret = clk_prepare_enable(priv->can_clk);
> -     if (ret) {
> -             netdev_err(ndev, "unable to enable device clock\n");
> -             goto err_irq;
> -     }
> -
> -     ret = clk_prepare_enable(priv->bus_clk);
> -     if (ret) {
> -             netdev_err(ndev, "unable to enable bus clock\n");
> -             goto err_can_clk;
> -     }
> -
>       /* Set chip into reset mode */
>       ret = set_reset_mode(ndev);
>       if (ret < 0) {
>               netdev_err(ndev, "mode resetting failed!\n");
> -             goto err_bus_clk;
> +             goto err_irq;
>       }
>
>       /* Common open */
>       ret = open_candev(ndev);
>       if (ret)
> -             goto err_bus_clk;
> +             goto err_irq;
>
>       ret = xcan_chip_start(ndev);
>       if (ret < 0) {
> @@ -887,13 +883,11 @@ static int xcan_open(struct net_device *ndev)
>
>  err_candev:
>       close_candev(ndev);
> -err_bus_clk:
> -     clk_disable_unprepare(priv->bus_clk);
> -err_can_clk:
> -     clk_disable_unprepare(priv->can_clk);
>  err_irq:
>       free_irq(ndev->irq, ndev);
>  err:
> +     pm_runtime_put(priv->dev);
> +
>       return ret;
>  }
>
> @@ -910,12 +904,11 @@ static int xcan_close(struct net_device *ndev)
>       netif_stop_queue(ndev);
>       napi_disable(&priv->napi);
>       xcan_chip_stop(ndev);
> -     clk_disable_unprepare(priv->bus_clk);
> -     clk_disable_unprepare(priv->can_clk);
>       free_irq(ndev->irq, ndev);
>       close_candev(ndev);
>
>       can_led_event(ndev, CAN_LED_EVENT_STOP);
> +     pm_runtime_put(priv->dev);
>
>       return 0;
>  }
> @@ -934,27 +927,21 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
>       struct xcan_priv *priv = netdev_priv(ndev);
>       int ret;
>
> -     ret = clk_prepare_enable(priv->can_clk);
> -     if (ret)
> -             goto err;
> +     ret = pm_runtime_get_sync(priv->dev);
> +     if (ret < 0) {
> +             netdev_err(ndev, "%s: runtime resume failed(%d)\n\r",
> +                             __func__, ret);

As above.

K will modify this too.

Regards,
Kedar.
        SÃ¶ren


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
