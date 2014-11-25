Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751076AbaKYOgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:36:03 -0500
Received: from gloria.sntech.de ([95.129.55.99]:35898 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKYOgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:36:01 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Roger Chen <roger.chen@rock-chips.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, mark.yao@rock-chips.com,
        eddie.cai@rock-chips.com
Subject: Re: [PATCH 3/4] GMAC: dts: add gmac info for rk3288
Date: Tue, 25 Nov 2014 15:39:37 +0100
Message-ID: <1773507.kOcjDCLbcs@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <547486EB.5080702@cogentembedded.com>
References: <1416906536-26158-1-git-send-email-roger.chen@rock-chips.com> <547486EB.5080702@cogentembedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 25. November 2014, 16:40:59 schrieb Sergei Shtylyov:
> Hello.
> 
> On 11/25/2014 12:08 PM, Roger Chen wrote:
> > add gmac info in rk3288.dtsi for GMAC driver
> > 
> > Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
> > ---
> > 
> >   arch/arm/boot/dts/rk3288.dtsi |   59
> >   +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 59
> >   insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> > index 0f50d5d..949675d 100644
> > --- a/arch/arm/boot/dts/rk3288.dtsi
> > +++ b/arch/arm/boot/dts/rk3288.dtsi
> 
> [...]
> 
> > @@ -490,6 +497,25 @@
> > 
> >   		reg = <0xff740000 0x1000>;
> >   	
> >   	};
> > 
> > +	gmac: eth@ff290000 {
> 
>     Please name the node "ethernet@ff290000" to comply with the ePAPR
> standard.
> > +		compatible = "rockchip,rk3288-gmac";
> > +		reg = <0xff290000 0x10000>;
> > +		interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;  /*irq=59*/
> > +		interrupt-names = "macirq";
> > +		rockchip,grf = <&grf>;
> > +		clocks = <&cru SCLK_MAC>, <&cru SCLK_MAC_PLL>,
> > +			<&cru SCLK_MAC_RX>, <&cru SCLK_MAC_TX>,
> > +			<&cru SCLK_MACREF>, <&cru SCLK_MACREF_OUT>,
> > +			<&cru ACLK_GMAC>, <&cru PCLK_GMAC>;
> > +		clock-names = "stmmaceth", "clk_mac_pll",
> > +			"mac_clk_rx", "mac_clk_tx",
> > +			"clk_mac_ref", "clk_mac_refout",
> > +			"aclk_mac", "pclk_mac";
> > +		phy-mode = "rgmii";
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&rgmii_pin /*&rmii_pin*/>;
> 
>     Hm, pinctrl props in a .dtsi file? Those are usually board dependent.

yep, especially as there is a board-dependent selection needed of what to use 
[rgmii or rmii] depending on the phy on the board.


> 
> [...]
> 
> > @@ -1040,5 +1066,38 @@
> > 
> >   				rockchip,pins = <7 23 3 &pcfg_pull_none>;
> >   			
> >   			};
> >   		
> >   		};
> > 
> > +
> > +		gmac {
> > +			rgmii_pin: rgmii-pins {

please add the "s" to the label - "rgmii_pins"


> > +				rockchip,pins = <3 30 3 &pcfg_pull_none>,
> > +						<3 31 3 &pcfg_pull_none>,
> > +						<3 26 3 &pcfg_pull_none>,
> > +						<3 27 3 &pcfg_pull_none>,
> > +						<3 28 3 &pcfg_pull_none>,
> > +						<3 29 3 &pcfg_pull_none>,
> > +						<3 24 3 &pcfg_pull_none>,
> > +						<3 25 3 &pcfg_pull_none>,
> > +						<4 0 3 &pcfg_pull_none>,
> > +						<4 5 3 &pcfg_pull_none>,
> > +						<4 6 3 &pcfg_pull_none>,
> > +						<4 9 3 &pcfg_pull_none>,
> > +						<4 4 3 &pcfg_pull_none>,
> > +						<4 1 3 &pcfg_pull_none>,
> > +						<4 3 3 &pcfg_pull_none>;
> > +			};
> > +
> > +			rmii_pin: rmii-pins {

same here


> > +				rockchip,pins = <3 30 3 &pcfg_pull_none>,
> > +						<3 31 3 &pcfg_pull_none>,
> > +						<3 28 3 &pcfg_pull_none>,
> > +						<3 29 3 &pcfg_pull_none>,
> > +						<4 0 3 &pcfg_pull_none>,
> > +						<4 5 3 &pcfg_pull_none>,
> > +						<4 4 3 &pcfg_pull_none>,
> > +						<4 1 3 &pcfg_pull_none>,
> > +						<4 2 3 &pcfg_pull_none>,
> > +						<4 3 3 &pcfg_pull_none>;
> > +			};
> > +		};
> 
>     These are usually define in the board .dts file...

The pinctrl settings itself are soc-specific, i.e. the pins and their settings 
to use to enable r{g}mii functionality are the same for all boards using this 
soc, so the pinctrl definitions should stay here and not be redefined in each 
and every board file.


Heiko
