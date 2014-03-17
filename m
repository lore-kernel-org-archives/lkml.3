Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbaCQOBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 10:01:37 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:36388
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933182AbaCQOBc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 10:01:32 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI9371I542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hz8dhz1de098h8275bh1de097hz2fh95h109h839h944hc61hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h262fh906i1155h)
From: Harini Katakam <harini.katakam@xilinx.com>
To: Rob Herring <robherring2@gmail.com>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        Michal Simek <michals@xilinx.com>
Subject: RE: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Topic: [PATCH] SPI: Add driver for Cadence SPI controller
Thread-Index: AQHPQdlDwreFYNSC5UqDMedDfaXPCprktEcAgACZw5A=
Date: Mon, 17 Mar 2014 14:01:17 +0000
References: <1395057936-8643-1-git-send-email-harinik@xilinx.com>
 <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
In-Reply-To: <CAL_JsqKacetGytGUJir7ky3qOgCy-3ny1pT_Bx4eCYV2wMgcTg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.228.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <d0d4dc5c-aade-4155-b998-3d177b6581c2@CH1EHSMHS004.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,

> -----Original Message-----
> From: Rob Herring [mailto:robherring2@gmail.com]
> Sent: Monday, March 17, 2014 6:17 PM
> To: Harini Katakam
> Cc: Rob Herring; Pawel Moll; Mark Rutland; Ian Campbell; Kumar Gala; Rob
> Landley; Mark Brown; Grant Likely; devicetree@vger.kernel.org; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> spi@vger.kernel.org; Michal Simek
> Subject: Re: [PATCH] SPI: Add driver for Cadence SPI controller
>
> On Mon, Mar 17, 2014 at 7:05 AM, Harini Katakam <harinik@xilinx.com>
> wrote:
> > Add driver for Cadence SPI controller. This is used in Xilinx Zynq.
> >
> > Signed-off-by: Harini Katakam <harinik@xilinx.com>
> > ---
>
> > +- reg                  : Physical base address and size of SPI registers map.
> > +- interrupts           : Property with a value describing the interrupt
> > +                         number.
> > +- interrupt-parent     : Must be core interrupt controller
> > +- clock-names          : List of input clock names - "ref_clk", "pclk"
> > +                         (See clock bindings for details).
> > +- clocks               : Clock phandles (see clock bindings for details).
> > +- num-chip-select      : Number of chip selects used.
>
> See Documentation/devicetree/bindings/spi/spi-bus.txt. Use "num-cs"
> here.

I'll check that.
> > +
> > +       irq = platform_get_irq(pdev, 0);
> > +       if (irq < 0) {
>
> I believe this returns NO_IRQ which could be 0.
>
> s/</<=/
>
> > +       dev_dbg(&pdev->dev, "suspend succeeded\n");
>
> Not needed. The kernel already has suspend/resume tracing printks.

Will remove.

> > +       dev_dbg(&pdev->dev, "resume succeeded\n");
>
> Not needed. The kernel already has suspend/resume tracing printks.

Will remove.

Regards,
Harini



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


