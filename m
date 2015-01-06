Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbbAFGij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 01:38:39 -0500
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:53882
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751843AbbAFGih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 01:38:37 -0500
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Soren Brinkmann <sorenb@xilinx.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
CC: "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v4] can: Convert to runtime_pm
Thread-Topic: [PATCH v4] can: Convert to runtime_pm
Thread-Index: AQHQHwHS0g8srEE1sk2hKt6qk1yee5yys/lQ
Date: Tue, 6 Jan 2015 06:23:51 +0000
References: <58f37b6fd9104ce185c413c473fe047b@BY2FFO11FD050.protection.gbl>
 <20141223224308.GC4611@xsjandreislx>
In-Reply-To: <20141223224308.GC4611@xsjandreislx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.96.253]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21226.005
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <7324bcf422d141f0b09f0cc0e8352479@BN1BFFO11FD005.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=appana.durga.rao@xilinx.com; 
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377424004)(377454003)(189002)(13464003)(24454002)(51704005)(2950100001)(53416004)(23676002)(21056001)(50986999)(4396001)(76176999)(64706001)(86362001)(92726002)(107046002)(54356999)(2656002)(87936001)(102836002)(46102003)(47776003)(99396003)(92566001)(106466001)(19580395003)(33646002)(2501002)(31966008)(19580405001)(108616004)(74316001)(62966003)(50466002)(20776003)(106116001)(120916001)(6806004)(104016003)(77156002)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB063;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB063;
X-Forefront-PRVS: 0448A97BF2
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2015 06:23:55.6581
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1BFFO11HUB063
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t066clZ1010805

Hi Marc,

        Could you please  provide your feedback on this patch ?

@Soren : Will update the driver with your comments during next version of the patch.

Regards,
Kedar.

-----Original Message-----
From: SÃ¶ren Brinkmann [mailto:soren.brinkmann@xilinx.com]
Sent: Wednesday, December 24, 2014 4:13 AM
To: Appana Durga Kedareswara Rao
Cc: wg@grandegger.com; mkl@pengutronix.de; Michal Simek; grant.likely@linaro.org; linux-can@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Appana Durga Kedareswara Rao
Subject: Re: [PATCH v4] can: Convert to runtime_pm

On Tue, 2014-12-23 at 05:55PM +0530, Kedareswara rao Appana wrote:
> Instead of enabling/disabling clocks at several locations in the
> driver, use the runtime_pm framework. This consolidates the actions
> for runtime PM in the appropriate callbacks and makes the driver more
> readable and mantainable.
>
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> ---
> Chnages for v4:
>  - Updated with the review comments.
> Changes for v3:
>   - Converted the driver to use runtime_pm.
> Changes for v2:
>   - Removed the struct platform_device* from suspend/resume
>     as suggest by Lothar.
>
>  drivers/net/can/xilinx_can.c |  123
> +++++++++++++++++++++++++-----------------
>  1 files changed, 74 insertions(+), 49 deletions(-)
>
> diff --git a/drivers/net/can/xilinx_can.c
> b/drivers/net/can/xilinx_can.c index 6c67643..c71f683 100644
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
> +             netdev_err(ndev, "%s: pm_runtime_get failed\r(%d)\n\r",

Does this create the intended output? I haven't seen '\r' anywhere else.
Shouldn't this simply be:
        netdev_err(ndev, "%s: pm_runtime_get failed (%d)\n",

[...]
> @@ -934,27 +927,20 @@ static int xcan_get_berr_counter(const struct net_device *ndev,
>       struct xcan_priv *priv = netdev_priv(ndev);
>       int ret;
>
> -     ret = clk_prepare_enable(priv->can_clk);
> -     if (ret)
> -             goto err;
> -
> -     ret = clk_prepare_enable(priv->bus_clk);
> -     if (ret)
> -             goto err_clk;
> +     ret = pm_runtime_get_sync(priv->dev);
> +     if (ret < 0) {
> +             netdev_err(ndev, "%s: pm_runtime_get failed\r(%d)\n\r",

ditto

        SÃ¶ren


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
