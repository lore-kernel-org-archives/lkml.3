Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933328AbaCQNyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:54:19 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:33211 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932673AbaCQNyP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:54:15 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zzbb2dI98dI9371I542I1432I1447Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h262fh906i1155h)
From: Harini Katakam <harini.katakam@xilinx.com>
To: "monstr@monstr.eu" <monstr@monstr.eu>, Rob Herring <robherring2@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>
Subject: RE: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Topic: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Index: AQHPQdlDwreFYNSC5UqDMedDfaXPCprktEcAgAAJ6wCAAIrBQA==
Date: Mon, 17 Mar 2014 13:54:07 +0000
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
 <5326F72E.7010401@monstr.eu>
In-Reply-To: <5326F72E.7010401@monstr.eu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.228.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <a353a31f-828a-42da-bca3-010b60681c3e@TX2EHSMHS014.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob/Mark,

> -----Original Message-----
> From: Michal Simek [mailto:monstr@monstr.eu]
> Sent: Monday, March 17, 2014 6:53 PM
> To: Rob Herring
> Cc: Harini Katakam; Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell;
> Kumar Gala; Rob Landley; Mark Brown; Grant Likely;
> devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-spi@vger.kernel.org
> Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
>
> Hi Rob,
>
> On 03/17/2014 01:47 PM, Rob Herring wrote:
> > On Mon, Mar 17, 2014 at 7:05 AM, Harini Katakam <harinik@xilinx.com>
> wrote:
> >> Add driver for Cadence SPI controller. This is used in Xilinx Zynq.
> >>
> >> Signed-off-by: Harini Katakam <harinik@xilinx.com>
> >> ---
> >>  .../devicetree/bindings/spi/spi-cadence.txt        |   25 +
> >
> > We prefer binding docs in separate patch.
>
> I have heard several times that also for binding review you need driver to
> look if this binding make sense that's why Harini sent this together.
> It means 2 emails instead of one.
> But if you wish to have this in two files no problem to split it but then I
> believe both should be copied to DT mailing list.
>

I can split this.

>
> >>  drivers/spi/Kconfig                                |    7 +
> >>  drivers/spi/Makefile                               |    1 +
> >>  drivers/spi/spi-cadence.c                          |  804 ++++++++++++++++++++
> >>  4 files changed, 837 insertions(+)
> >>  create mode 100644
> >> Documentation/devicetree/bindings/spi/spi-cadence.txt
> >>  create mode 100644 drivers/spi/spi-cadence.c
> >>
> >> diff --git a/Documentation/devicetree/bindings/spi/spi-cadence.txt
> >> b/Documentation/devicetree/bindings/spi/spi-cadence.txt
> >> new file mode 100644
> >> index 0000000..d25bc2d
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/spi/spi-cadence.txt
> >> @@ -0,0 +1,25 @@
> >> +Cadence SPI controller Device Tree Bindings
> >> +-------------------------------------------
> >> +
> >> +Required properties:
> >> +- compatible           : Should be "cdns,spi-r1p6".
> >
> > One problem with using IP vendor info in the compatible string is an
> > IP block typically has a variety of configuration options so the
> > actual implementations may be very different. I would recommend adding
> > a Xilinx compatible string as well even if you don't use it now.
>
> It means xlnx,zynq-spi-r1p6 should be fine.

I can add this string. "r1p6" is specific to the cadence IP used.
Is that OK?

>
> >
> >> +- reg                  : Physical base address and size of SPI registers map.
> >> +- interrupts           : Property with a value describing the interrupt
> >> +                         number.
> >> +- interrupt-parent     : Must be core interrupt controller
> >> +- clock-names          : List of input clock names - "ref_clk", "pclk"
> >> +                         (See clock bindings for details).
> >> +- clocks               : Clock phandles (see clock bindings for details).
> >> +- num-chip-select      : Number of chip selects used.
> >
> > See Documentation/devicetree/bindings/spi/spi-bus.txt. Use "num-cs"
> here.
> >
> >> +
> >> +Example:
> >> +
> >> +       spi@e0007000 {
> >> +               clock-names = "ref_clk", "pclk";
> >> +               clocks = <&clkc 26>, <&clkc 35>;
> >> +               compatible = "cdns,spi-r1p6";
> >
> > Nit. We usually put compatible first in the node.
>
> Our device-tree generator sorts them that's why it is just like this but not a
> problem to fix just in documentation.
>

Will fix.

>
> >> +               interrupt-parent = <&intc>;
> >> +               interrupts = <0 49 4>;
> >> +               num-chip-select = /bits/ 16 <4>;
>
> I was expecting you will comment this a little bit. :-) Because all just reading
> this num-cs as 32bit and then assigning this value to master-
> >num_chipselect which is 16bit.
>
> <snip>
>
> >> +/* Macros for the SPI controller read/write */
> >> +#define cdns_spi_read(addr)    readl_relaxed(addr)
> >> +#define cdns_spi_write(addr, val)      writel_relaxed((val), (addr))
> >
> > Just use readl/writel directly.
>
> There shouldn't be any problem to use these helper macros and even I think
> this is better than using readl/writel directly because you are more flexible
> if you want to change it to different IO.
>

Like Michal pointed out, this is more flexible.
Can try what Mark suggested:

"Or make them static inline structures which take the driver data structure and an
offset within the register map for the device and do the maths to resolve the actual address."

Thanks for the review.

Regards,
Harini


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


