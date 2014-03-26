Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaCZFjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 01:39:24 -0400
Received: from smtprelay0051.hostedemail.com ([216.40.44.51]:34228 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750727AbaCZFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 01:39:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3868:3870:3871:4250:4321:5007:6117:7652:9040:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck
X-HE-Tag: pan38_34397c25b2c09
X-Filterd-Recvd-Size: 2332
Message-ID: <1395812357.3726.14.camel@joe-AO722>
Subject: Re: [PATCH v6] can: xilinx CAN controller support
From: Joe Perches <joe@perches.com>
To: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
Cc: wg@grandegger.com, mkl@pengutronix.de, michal.simek@xilinx.com,
        grant.likely@linaro.org, robh+dt@kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Kedareswara rao Appana <appanad@xilinx.com>
Date: Tue, 25 Mar 2014 22:39:17 -0700
In-Reply-To: <5ff46a21-3047-40ff-9221-f08e476f9ce6@VA3EHSMHS030.ehs.local>
References: <5ff46a21-3047-40ff-9221-f08e476f9ce6@VA3EHSMHS030.ehs.local>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-26 at 10:56 +0530, Kedareswara rao Appana wrote:
> This patch adds xilinx CAN controller support.
> This driver supports both ZYNQ CANPS and Soft IP
> AXI CAN controller.

Just trivial notes about dmesg logging output.

> diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
[]
> +static int set_reset_mode(struct net_device *ndev)
> +{
[]
> +			netdev_warn(ndev, "timedout waiting for config mode\n");

timed out

> +static int xcan_set_bittiming(struct net_device *ndev)
> +{
[]
> +	if (!is_config_mode) {
> +		netdev_alert(ndev,
> +			"BUG! Cannot set bittiming can is notin config mode\n");

"Cannot set bit timing - CAN is not in config mode\n"

> +static int xcan_chip_start(struct net_device *ndev)
> +{

> +			netdev_warn(ndev,
> +				"time out waiting for correct mode\n");

Please be consistent.  Maybe
"timed out waiting for correct mode\n"

> +static int xcan_open(struct net_device *ndev)
> +{
> +	struct xcan_priv *priv = netdev_priv(ndev);
> +	int ret;
> +
> +	ret = request_irq(ndev->irq, xcan_interrupt, priv->irq_flags,
> +			ndev->name, ndev);
> +	if (ret < 0) {
> +		netdev_err(ndev, "Irq allocation for CAN failed\n");

irq is almost always lower case.


