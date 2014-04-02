Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbaDBNwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:52:06 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:46639
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758639AbaDBNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:52:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz98dI1432I1447Izz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h262fh268bh26d3h1155h)
Date: Wed, 2 Apr 2014 21:39:56 +0800
From: Nicolin Chen <Guangyu.Chen@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: <broonie@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <alsa-devel@alsa-project.org>,
        <timur@tabi.org>, <Li.Xiubo@freescale.com>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <rob@landley.net>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>
Subject: Re: [PATCH v2 2/2] ARM: dts: Append clock bindings for sai2 on VF610
 platform
Message-ID: <20140402133955.GB29440@MrMyself>
References: <cover.1396432924.git.Guangyu.Chen@freescale.com>
 <d09da3eb629143abd3f61ae037af4ddaf7286a83.1396432924.git.Guangyu.Chen@freescale.com>
 <20140402130302.GC8558@dragon>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140402130302.GC8558@dragon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

   Thanks for the comments, but...

On Wed, Apr 02, 2014 at 09:03:04PM +0800, Shawn Guo wrote:
> On Wed, Apr 02, 2014 at 06:10:20PM +0800, Nicolin Chen wrote:
> > Since we added fours clock to the DT binding, we should update the current
> > SAI dts/dtsi so as not to break their functions.
> > 
> > Signed-off-by: Nicolin Chen <Guangyu.Chen@freescale.com>
> > ---
> >  arch/arm/boot/dts/vf610.dtsi | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/boot/dts/vf610.dtsi b/arch/arm/boot/dts/vf610.dtsi
> > index d31ce1b..9fd0007 100644
> > --- a/arch/arm/boot/dts/vf610.dtsi
> > +++ b/arch/arm/boot/dts/vf610.dtsi
> > @@ -139,8 +139,10 @@
> >  				compatible = "fsl,vf610-sai";
> >  				reg = <0x40031000 0x1000>;
> >  				interrupts = <0 86 0x04>;
> > -				clocks = <&clks VF610_CLK_SAI2>;
> > -				clock-names = "sai";
> > +				clocks = <&clks VF610_CLK_SAI2>,
> > +				       <&clks VF610_CLK_SAI2>,
> > +				       <&clks 0>, <&clks 0>;
> 
> So it seems that SAI on vf610 does work with only one clock.  So the
> driver change will break old DTB for vf610?  If that's case, we will
> have to need a new compatible for cases where 4 clocks are needed.

According to Vybrid's RM Chapter 9.11.12 SAI clocking, the SoC actually
connects SAI with two clocks: SAI_CLK and Platform Bus Clock. So the DT
binding here still needs to be corrected even if ignoring driver change.

Besides, I've checked both SAI on imx and vf610 and found that they are
seemly identical, especially for the clock part -- "The transmitter and
receiver can independently select between the bus clock and up to three
audio master clocks to generate the bit clock." And the driver that was
designed for vf610 already contains the code to switch the clock between
Bus Clock and Three MCLKs. What I want to say is, even if SAI on vf610
does work with only one clock, it still doesn't have the full function
on vf610 -- driving clock from Platform Bus Clock unless we make this
improvement to the DT binding.

So I think it's fair to complete the code here for both platforms, even
though we might take the risk of merging conflict. And I understand
your point to avoid function break on those platform both of us aren't
convenient to test. But I've already involved Xiubo in the list. And
we can wait for his test result.

Hope you can understand the circumstance,
Nicolin

