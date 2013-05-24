Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3EXUPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 16:15:43 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:44803 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313Ab3EXUPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 16:15:41 -0400
Date: Fri, 24 May 2013 22:15:39 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Florian Fainelli <florian@openwrt.org>,
        kevin@allwinnertech.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com
Subject: Re: [PATCHv3 5/6] ARM: cubieboard: Enable ethernet (EMAC) support in
 dts
Message-ID: <20130524201539.GB17847@lukather>
References: <1369387394-9453-1-git-send-email-maxime.ripard@free-electrons.com>
 <1369387394-9453-6-git-send-email-maxime.ripard@free-electrons.com>
 <519F62B3.8090302@elopez.com.ar>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <519F62B3.8090302@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Emilio,

On Fri, May 24, 2013 at 09:53:07AM -0300, Emilio López wrote:
> Hi,
> 
> El 24/05/13 06:23, Maxime Ripard escribió:
> > From: Stefan Roese <sr@denx.de>
> > 
> > Signed-off-by: Stefan Roese <sr@denx.de>
> > ---
> >  arch/arm/boot/dts/sun4i-a10-cubieboard.dts | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> > index b70fe0d..32d9b18 100644
> > --- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> > +++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
> > @@ -27,6 +27,21 @@
> >  	};
> >  
> >  	soc@01c20000 {
> > +		emac: ethernet@01c0b000 {
> > +			pinctrl-names = "default";
> > +			pinctrl-0 = <&emac_pins_a>;
> > +			phy = <&phy0>;
> > +			status = "okay";
> > +		};
> > +
> > +		mdio@01c0b080 {
> > +			status = "okay";
> > +
> > +			phy0: ethernet-phy@0 {
> > +				reg = <0>;
> > +			};
> 
> During my testing I found out that I needed to use 1 as reg for the
> driver to work. You can find a fixup patch enclosed that changes this;
> it's possible that some extra changes may also be needed (s/phy0/phy1/
> on the node?)

Merged, thanks for noticing!

Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
