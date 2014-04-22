Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932AbaDVH46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 03:56:58 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:46114
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbaDVH4y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 03:56:54 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I542I1432I4015Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h17326ah8275bh1de097h186068h18602ehz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h262fh268bh26d3h906i2673i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: "monstr@monstr.eu" <monstr@monstr.eu>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>
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
Subject: RE: [PATCH v7 1/2] can: xilinx CAN controller support
Thread-Topic: [PATCH v7 1/2] can: xilinx CAN controller support
Thread-Index: AQHPUi6MgKhFQ40Q102/VIe4iyjo45sdW5cg
Date: Tue, 22 Apr 2014 07:56:46 +0000
References: <3e750ec3-9d47-4b4e-8173-56698ab19786@CH1EHSMHS029.ehs.local>
 <53424C32.7090000@monstr.eu>
In-Reply-To: <53424C32.7090000@monstr.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.18.45]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <707ea084-ed82-407b-8967-1e82a994b784@AM1EHSMHS003.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Monday, April 07, 2014 12:27 PM
> To: Appana Durga Kedareswara Rao
> Cc: wg@grandegger.com; mkl@pengutronix.de; Michal Simek;
> grant.likely@linaro.org; robh+dt@kernel.org; linux-can@vger.kernel.org;
> netdev@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; Appana Durga
> Kedareswara Rao
> Subject: Re: [PATCH v7 1/2] can: xilinx CAN controller support
>
> On 04/02/2014 03:13 PM, Kedareswara rao Appana wrote:
> > This patch adds xilinx CAN controller support.
> > This driver supports both ZYNQ CANPS and Soft IP AXI CAN controller.
> >
> > Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> > ---
> > Changes for v7:
> > - Updated the driver with review comments.
> > - Moved the driver bindings doc as a separte patch.
> > Changes for v6:
> > - Updated the driver with review comments.
> > - Used the clock names specified in the data sheet.
> > - Updated the devicetree bindings doc as per Rob suggestion.
> > Changes for v5:
> > - Updated the driver with the review comments.
> > - Remove the check for the tx fifo full interrupt condition
> >   form Tx interrupt routine as we are checking it in the _xmit
> >   routine.
> > - Clearing the txok interrupt in the tx interrupt routine for
> >   every Tx can frame.
> > Changes for v4:
> > - Added check for the tx fifo full interrupt condition in Tx interrupt
> > routine.
> > - Added be iohelper functions.
> > - Moved the clock enable/disable to probe/remove because of
> >   Added big endian support for AXI CAN controller case(reading
> >   a register during probe for that we need to enable clock).
> > Changes for v3:
> > - Updated the driver with the review comments.
> > - Modified the tranmit logic as per Marc suggestion.
> > - Enabling the clock when the interface is up to reduce the
> >   Power consumption.
> > Changes for v2:
> > - Updated with the review comments.
> > - Removed the unnecessary debug prints.
> > - include tx,rx fifo depths in ZYNQ CANPS case also
> > ---
> >  drivers/net/can/Kconfig      |    7 +
> >  drivers/net/can/Makefile     |    1 +
> >  drivers/net/can/xilinx_can.c | 1176
> > ++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 1184 insertions(+), 0 deletions(-)  create mode
> > 100644 drivers/net/can/xilinx_can.c
>
> Mark: Any update on this one?
> BTW: When you apply these patches you should apply 2/2 before 1/2. There
> is new checking for binding.
>

Ping?

Regards,
Kedar.

> Thanks,
> Michal
>
> --
> Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
> Maintainer of Linux kernel - Xilinx Zynq ARM architecture Microblaze U-
> BOOT custodian and responsible for u-boot arm zynq platform
>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


