Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbaCKPtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:49:00 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:9165
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755133AbaCKPs5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:48:57 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh936eIe0eah1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Tue, 11 Mar 2014 08:48:47 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 7/7] ARM: zynq: DT: Migrate UART to Cadence binding
References: <1394487610-2419-1-git-send-email-soren.brinkmann@xilinx.com>
 <1394487610-2419-8-git-send-email-soren.brinkmann@xilinx.com>
 <62cd32ad-8743-4d49-a1b6-c178054a9756@CO9EHSMHS011.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <62cd32ad-8743-4d49-a1b6-c178054a9756@CO9EHSMHS011.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <fbca0284-8a38-4767-bd17-8e5f52b21ef7@CH1EHSMHS005.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 09:52AM +0100, Michal Simek wrote:
> On 03/10/2014 10:40 PM, Soren Brinkmann wrote:
> > The Zynq UART is Cadence IP and the driver has been renamed accordingly.
> > Migrate the DT to use the new binding for the UART driver.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> > Acked-by: Rob Herring <robh@kernel.org>
> > ---
> > This change depends on 'tty: xuartps: Rebrand driver as Cadence UART',
> > which introduces the new clock-names.
> > ---
> >  arch/arm/boot/dts/zynq-7000.dtsi | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
> > index 8b67b19392ec..0ed0d4b0579a 100644
> > --- a/arch/arm/boot/dts/zynq-7000.dtsi
> > +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> > @@ -67,19 +67,19 @@
> >  		};
> >  
> >  		uart0: uart@e0000000 {
> > -			compatible = "xlnx,xuartps";
> > +			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
> >  			status = "disabled";
> >  			clocks = <&clkc 23>, <&clkc 40>;
> > -			clock-names = "ref_clk", "aper_clk";
> > +			clock-names = "uart_clk", "pclk";
> >  			reg = <0xE0000000 0x1000>;
> >  			interrupts = <0 27 4>;
> >  		};
> >  
> >  		uart1: uart@e0001000 {
> > -			compatible = "xlnx,xuartps";
> > +			compatible = "xlnx,xuartps", "cdns,uart-r1p8";
> >  			status = "disabled";
> >  			clocks = <&clkc 24>, <&clkc 41>;
> > -			clock-names = "ref_clk", "aper_clk";
> > +			clock-names = "uart_clk", "pclk";
> >  			reg = <0xE0001000 0x1000>;
> >  			interrupts = <0 50 4>;
> >  		};
> 
> This should be at least the part of 5/7 because between 5/7 and 7/7
> driver will fail to probe.

The driver should never fail to probe. The old bindings will continue to
work. So, only dependency for this is, the new clock names must be
merged in. So, it has to be rather late in the series.

	Sören


