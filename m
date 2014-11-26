Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222AbaKZIoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 03:44:15 -0500
Received: from gloria.sntech.de ([95.129.55.99]:42589 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaKZIoN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 03:44:13 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Roger <roger.chen@rock-chips.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        kever.yang@rock-chips.com, mark.yao@rock-chips.com,
        eddie.cai@rock-chips.com
Subject: Re: [PATCH 3/4] GMAC: dts: add gmac info for rk3288
Date: Wed, 26 Nov 2014 09:47:56 +0100
Message-ID: <2888396.enB18gaD2a@diego>
User-Agent: KMail/4.14.1 (Linux/3.16-3-amd64; KDE/4.14.2; x86_64; ; )
In-Reply-To: <54753FAD.8040908@rock-chips.com>
References: <1416906536-26158-1-git-send-email-roger.chen@rock-chips.com> <1773507.kOcjDCLbcs@diego> <54753FAD.8040908@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 26. November 2014, 10:49:17 schrieb Roger:
> On 2014/11/25 22:39, Heiko Stübner wrote:
> > Am Dienstag, 25. November 2014, 16:40:59 schrieb Sergei Shtylyov:
> >> Hello.
> >> 
> >> On 11/25/2014 12:08 PM, Roger Chen wrote:
> >>> add gmac info in rk3288.dtsi for GMAC driver
> >>> 
> >>> Signed-off-by: Roger Chen <roger.chen@rock-chips.com>
> >>> ---
> >>> 
> >>>    arch/arm/boot/dts/rk3288.dtsi |   59
> >>>    +++++++++++++++++++++++++++++++++++++++++ 1 file changed, 59
> >>>    insertions(+)
> >>> 
> >>> diff --git a/arch/arm/boot/dts/rk3288.dtsi
> >>> b/arch/arm/boot/dts/rk3288.dtsi
> >>> index 0f50d5d..949675d 100644
> >>> --- a/arch/arm/boot/dts/rk3288.dtsi
> >>> +++ b/arch/arm/boot/dts/rk3288.dtsi
> >> 
> >> [...]
> >> 
> >>> @@ -490,6 +497,25 @@
> >>> 
> >>>    		reg = <0xff740000 0x1000>;
> >>>    	
> >>>    	};
> >>> 
> >>> +	gmac: eth@ff290000 {
> >>> 
> >>      Please name the node "ethernet@ff290000" to comply with the ePAPR
> >> 
> >> standard.
> >> 
> >>> +		compatible = "rockchip,rk3288-gmac";
> >>> +		reg = <0xff290000 0x10000>;
> >>> +		interrupts = <GIC_SPI 27 IRQ_TYPE_LEVEL_HIGH>;  /*irq=59*/
> >>> +		interrupt-names = "macirq";
> >>> +		rockchip,grf = <&grf>;
> >>> +		clocks = <&cru SCLK_MAC>, <&cru SCLK_MAC_PLL>,
> >>> +			<&cru SCLK_MAC_RX>, <&cru SCLK_MAC_TX>,
> >>> +			<&cru SCLK_MACREF>, <&cru SCLK_MACREF_OUT>,
> >>> +			<&cru ACLK_GMAC>, <&cru PCLK_GMAC>;
> >>> +		clock-names = "stmmaceth", "clk_mac_pll",
> >>> +			"mac_clk_rx", "mac_clk_tx",
> >>> +			"clk_mac_ref", "clk_mac_refout",
> >>> +			"aclk_mac", "pclk_mac";
> >>> +		phy-mode = "rgmii";
> >>> +		pinctrl-names = "default";
> >>> +		pinctrl-0 = <&rgmii_pin /*&rmii_pin*/>;
> >>> 
> >>      Hm, pinctrl props in a .dtsi file? Those are usually board
> >>      dependent.
> > 
> > yep, especially as there is a board-dependent selection needed of what to
> > use [rgmii or rmii] depending on the phy on the board.
> 
> of course pinctrl props is redefined in the rk3288-evb-rk808.dts,
> IMO, pinctrl props in .dtsi is used to fit for the "phy-mode" prop as
> default. if pinctrl props should be removed, how about "phy-mode" prop?

yep, the phy-mode should also move to the board file - as it of course also 
depends on the phy-chip used there.


