Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab3LGLMf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 06:12:35 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:42446 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212Ab3LGLMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 06:12:33 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Mike Turquette <mturquette@linaro.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 04/10] net: stmmac: sunxi platfrom extensions for GMAC in Allwinner A20 SoC's
Date: Sat, 07 Dec 2013 12:12:26 +0100
Message-ID: <2030454.PFLhh6xOPI@flatron>
User-Agent: KMail/4.11.4 (Linux/3.12.2-gentoo; KDE/4.11.4; x86_64; ; )
In-Reply-To: <20131207102710.GK24519@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-5-git-send-email-wens@csie.org> <20131207102710.GK24519@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 of December 2013 11:27:10 Maxime Ripard wrote:
> Chen-Yu, Mike,
> 
> On Sat, Dec 07, 2013 at 01:29:37AM +0800, Chen-Yu Tsai wrote:
> > The Allwinner A20 has an ethernet controller that seems to be
> > an early version of Synopsys DesignWare MAC 10/100/1000 Universal,
> > which is supported by the stmmac driver.
> > 
> > Allwinner's GMAC requires setting additional registers in the SoC's
> > clock control unit.
> > 
> > The exact version of the DWMAC IP that Allwinner uses is unknown,
> > thus the exact feature set is unknown.
> > 
> > Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> > ---
> >  .../bindings/net/allwinner,sun7i-gmac.txt          | 22 +++++++
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig        | 12 ++++
> >  drivers/net/ethernet/stmicro/stmmac/Makefile       |  1 +
> >  drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c  | 76 ++++++++++++++++++++++
> >  drivers/net/ethernet/stmicro/stmmac/stmmac.h       |  3 +
> >  .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |  3 +
> >  6 files changed, 117 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/allwinner,sun7i-gmac.txt b/Documentation/devicetree/bindings/net/allwinner,sun7i-gmac.txt
> > new file mode 100644
> > index 0000000..271554a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/net/allwinner,sun7i-gmac.txt
> > @@ -0,0 +1,22 @@
> > +* Allwinner GMAC ethernet controller
> > +
> > +This device is a platform glue layer for stmmac.
> > +Please see stmmac.txt for the other unchanged properties.
> > +
> > +Required properties:
> > + - compatible:  Should be "allwinner,sun7i-gmac"
> 
> Please use sun7i-a20-gmac here.
> 
> > + - reg: Address and length of register set for the device and corresponding
> > +   clock control
> >
> > +Examples:
> > +
> > +	gmac: ethernet@01c50000 {
> > +		compatible = "allwinner,sun7i-gmac";
> > +		reg = <0x01c50000 0x10000>,
> > +		      <0x01c20164 0x4>;
> 
> This is actually a clock, and should probably be registered in the
> common clock framework.
> 
> Mike: This small register actually is a regular muxer/divider, except
> that it has some bits that are of interest to the ethernet controller
> (for example to set wether it's using GMII or RGMII to communicate
> with the phy), that, as far as I'm aware of, aren't really fitting
> into the CCF.
> 
> Do you have some recommendation on how to proceed?
> 
> Maybe make a thin "real" clock driver in this hardware glue, that
> provides !exported function to set this *GMII thing.

Is this register part of a bigger IP block that manages clocks for other
IP blocks than stmmac as well? If not, I don't see a point of exporting
a clock from inside of the GMAC "domain" just to feed it back into it
as the only user.

Still, without any actual knowledge about this register and registers
next to it, I can be only guessing.

Best regards,
Tomasz

