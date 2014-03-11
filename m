Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbaCKMf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:35:29 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:35582
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753550AbaCKMf1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:35:27 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I542I1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
From: Appana Durga Kedareswara Rao <appana.durga.rao@xilinx.com>
To: Michal Simek <michals@xilinx.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Michal Simek <michals@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robherring2@gmail.com" <robherring2@gmail.com>
Subject: RE: [PATCH v5] can: xilinx CAN controller support.
Thread-Topic: [PATCH v5] can: xilinx CAN controller support.
Thread-Index: AQHPPHOJe+/Jq2y0+ECMRZjewV7XtprZ6iaAgAGNKzA=
Date: Tue, 11 Mar 2014 12:35:13 +0000
References: <5254bfec-c6fd-4681-a34d-706d51e60fbb@VA3EHSMHS004.ehs.local>
 <CAL_JsqL3V7Gmkx5MoAhzwbM8Po6QURUY+g3ytxs+H_u-FLR6SQ@mail.gmail.com>
 <531DD8C3.5050006@xilinx.com>
In-Reply-To: <531DD8C3.5050006@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.16.248]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <21dba33d-9def-43e1-becd-335f6cb5fd83@CO9EHSMHS011.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

> -----Original Message-----
> From: Michal Simek [mailto:michal.simek@xilinx.com]
> Sent: Monday, March 10, 2014 8:53 PM
> To: Rob Herring
> Cc: Appana Durga Kedareswara Rao; Wolfgang Grandegger; Marc Kleine-
> Budde; Michal Simek; Grant Likely; Rob Herring; linux-can@vger.kernel.org;
> netdev; linux-arm-kernel@lists.infradead.org; linux-
> kernel@vger.kernel.org; devicetree@vger.kernel.org; Appana Durga
> Kedareswara Rao
> Subject: Re: [PATCH v5] can: xilinx CAN controller support.
>
> On 03/10/2014 04:15 PM, Rob Herring wrote:
> > On Tue, Mar 4, 2014 at 7:20 AM, Kedareswara rao Appana
> > <appana.durga.rao@xilinx.com> wrote:
> >> This patch adds xilinx CAN controller support.
> >> This driver supports both ZYNQ CANPS and Soft IP AXI CAN controller.
> >>
> >> Signed-off-by: Kedareswara rao Appana <appanad@xilinx.com>
> >> ---
> >> This patch is rebased on the 3.14 rc5 kernel.
> >> Changes for v5:
> >> - Updated the driver with the review comments.
> >> - Remove the check for the tx fifo full interrupt condition
> >>   form Tx interrupt routine as we are checking it in the _xmit
> >>   routine.
> >> - Clearing the txok interrupt in the tx interrupt routine for
> >>   every Tx can frame.
> >> Changes for v4:
> >> - Added check for the tx fifo full interrupt condition in
> >>   Tx interrupt routine.
> >> - Added be iohelper functions.
> >> - Moved the clock enable/disable to probe/remove because of
> >>   Added big endian support for AXI CAN controller case(reading
> >>   a register during probe for that we need to enable clock).
> >> Changes for v3:
> >> - Updated the driver with the review comments.
> >> - Modified the tranmit logic as per Marc suggestion.
> >> - Enabling the clock when the interface is up to reduce the
> >>   Power consumption.
> >> Changes for v2:
> >> - Updated with the review comments.
> >> - Removed the unnecessary debug prints.
> >> - include tx,rx fifo depths in ZYNQ CANPS case also.
> >> ---
> >>  .../devicetree/bindings/net/can/xilinx_can.txt     |   45 +
> >>  drivers/net/can/Kconfig                            |    7 +
> >>  drivers/net/can/Makefile                           |    1 +
> >>  drivers/net/can/xilinx_can.c                       | 1195 ++++++++++++++++++++
> >>  4 files changed, 1248 insertions(+), 0 deletions(-)  create mode
> >> 100644 Documentation/devicetree/bindings/net/can/xilinx_can.txt
> >>  create mode 100644 drivers/net/can/xilinx_can.c
> >>
> >> diff --git a/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> >> b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> >> new file mode 100644
> >> index 0000000..0e57103
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/net/can/xilinx_can.txt
> >> @@ -0,0 +1,45 @@
> >> +Xilinx Axi CAN/Zynq CANPS controller Device Tree Bindings
> >> +---------------------------------------------------------
> >> +
> >> +Required properties:
> >> +- compatible           : Should be "xlnx,zynq-can-1.00.a" for Zynq CAN
> >> +                         controllers and "xlnx,axi-can-1.00.a" for Axi CAN
> >> +                         controllers.
> >> +- reg                  : Physical base address and size of the Axi CAN/Zynq
> >> +                         CANPS registers map.
> >> +- interrupts           : Property with a value describing the interrupt
> >> +                         number.
> >> +- interrupt-parent     : Must be core interrupt controller
> >> +- clock-names          : List of input clock names - "ref_clk", "aper_clk"
> >> +                         (See clock bindings for details. Two clocks are
> >> +                          required for Zynq CAN. For Axi CAN
> >> +                          case it is one(ref_clk)).
> >> +- clocks               : Clock phandles (see clock bindings for details).
> >> +- tx-fifo-depth                : Can Tx fifo depth.
> >> +- rx-fifo-depth                : Can Rx fifo depth.
> >> +
> >> +
> >> +Example:
> >> +
> >> +For Zynq CANPS Dts file:
> >> +       zynq_can_0: zynq-can@e0008000 {
> >
> > The preferred node name convention is to use the type of device. There
> > is no standard in this case, but I would use just "can@...".
> >
> > Otherwise, for the binding:
> >
> > Acked-by: Rob Herring <robh@kernel.org>
>
> Thanks Rob for your ACK.
>
> Kedar: You have got more things to change from Marc that's why please
> change this too.
>
Thanks Rob for the ACk
Michal@  I  will do

Regards,
Kedar.


> Thanks,
> Michal
>
>



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


