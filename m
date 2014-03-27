Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbaC0OVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 10:21:11 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:45207 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755244AbaC0OVI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 10:21:08 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I936eI542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h1de097hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h262fh268bh906i2673i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Joe Perches <joe@perches.com>
CC: "wg@grandegger.com" <wg@grandegger.com>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Michal Simek <michals@xilinx.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [PATCH v6] can: xilinx CAN controller support
Thread-Topic: [PATCH v6] can: xilinx CAN controller support
Thread-Index: AQHPSLW61/zn+huQD0m6uCOrbAavrJr0/cOg
Date: Thu, 27 Mar 2014 14:20:58 +0000
References: <5ff46a21-3047-40ff-9221-f08e476f9ce6@VA3EHSMHS030.ehs.local>
 <1395812357.3726.14.camel@joe-AO722>
In-Reply-To: <1395812357.3726.14.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.230.81]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <8cbdd3af-afb3-4a2d-a4b7-38ce4e34b73d@TX2EHSMHS018.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe perches,


> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Wednesday, March 26, 2014 11:09 AM
> To: Appana Durga Kedareswara Rao
> Cc: wg@grandegger.com; mkl@pengutronix.de; Michal Simek;
> grant.likely@linaro.org; robh+dt@kernel.org; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; Appana Durga
> Kedareswara Rao
> Subject: Re: [PATCH v6] can: xilinx CAN controller support
>
> On Wed, 2014-03-26 at 10:56 +0530, Kedareswara rao Appana wrote:
> > This patch adds xilinx CAN controller support.
> > This driver supports both ZYNQ CANPS and Soft IP AXI CAN controller.
>
> Just trivial notes about dmesg logging output.
>
> > diff --git a/drivers/net/can/xilinx_can.c
> > b/drivers/net/can/xilinx_can.c
> []
> > +static int set_reset_mode(struct net_device *ndev) {
> []
> > +                   netdev_warn(ndev, "timedout waiting for config
> mode\n");
>
> timed out
>
OK will do

> > +static int xcan_set_bittiming(struct net_device *ndev) {
> []
> > +   if (!is_config_mode) {
> > +           netdev_alert(ndev,
> > +                   "BUG! Cannot set bittiming can is notin config
> mode\n");
>
> "Cannot set bit timing - CAN is not in config mode\n"
>
> > +static int xcan_chip_start(struct net_device *ndev) {
>
> > +                   netdev_warn(ndev,
> > +                           "time out waiting for correct mode\n");
>
> Please be consistent.  Maybe
> "timed out waiting for correct mode\n"
>
Ok Will change.

> > +static int xcan_open(struct net_device *ndev) {
> > +   struct xcan_priv *priv = netdev_priv(ndev);
> > +   int ret;
> > +
> > +   ret = request_irq(ndev->irq, xcan_interrupt, priv->irq_flags,
> > +                   ndev->name, ndev);
> > +   if (ret < 0) {
> > +           netdev_err(ndev, "Irq allocation for CAN failed\n");
>
> irq is almost always lower case.
>
Ok Will change.

Regards,
Kedar.

>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


