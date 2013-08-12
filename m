Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab3HLUoH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 16:44:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:56483 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755027Ab3HLUoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 16:44:05 -0400
Date: Mon, 12 Aug 2013 22:44:02 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "kevin.z.m.zh@gmail.com" <kevin.z.m.zh@gmail.com>,
        "sunny@allwinnertech.com" <sunny@allwinnertech.com>,
        "shuge@allwinnertech.com" <shuge@allwinnertech.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv3 3/4] clk: sunxi: Add A31 clocks support
Message-ID: <20130812204402.GA24556@lukather>
References: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375735381-18214-4-git-send-email-maxime.ripard@free-electrons.com>
 <20130812141410.GB27165@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20130812141410.GB27165@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

On Mon, Aug 12, 2013 at 03:14:10PM +0100, Mark Rutland wrote:
> [Adding devicetree list to Cc]
>=20
> Hi,
>=20
> On Mon, Aug 05, 2013 at 09:43:00PM +0100, Maxime Ripard wrote:
> > The A31 has a mostly different clock set compared to the other older
> > SoCs currently supported in the Allwinner clock driver.
> >=20
> > Add support for the basic useful clocks. The other ones will come in
> > eventually.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  Documentation/devicetree/bindings/clock/sunxi.txt  |   6 +
> >  .../bindings/clock/sunxi/sun6i-a31-gates.txt       |  83 ++++++++++++++
> >  drivers/clk/sunxi/clk-sunxi.c                      | 124 +++++++++++++=
++++++++
> >  3 files changed, 213 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun6i=
-a31-gates.txt
> >=20
> > diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Docume=
ntation/devicetree/bindings/clock/sunxi.txt
> > index b24de10..c383d12 100644
> > --- a/Documentation/devicetree/bindings/clock/sunxi.txt
> > +++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> > @@ -8,6 +8,7 @@ Required properties:
> >  - compatible : shall be one of the following:
> >         "allwinner,sun4i-osc-clk" - for a gatable oscillator
> >         "allwinner,sun4i-pll1-clk" - for the main PLL clock
> > +       "allwinner,sun6i-a31-pll1-clk" - for the main PLL clock on A31
> >         "allwinner,sun4i-cpu-clk" - for the CPU multiplexer clock
> >         "allwinner,sun4i-axi-clk" - for the AXI clock
> >         "allwinner,sun4i-axi-gates-clk" - for the AXI gates
> > @@ -15,6 +16,8 @@ Required properties:
> >         "allwinner,sun4i-ahb-gates-clk" - for the AHB gates on A10
> >         "allwinner,sun5i-a13-ahb-gates-clk" - for the AHB gates on A13
> >         "allwinner,sun5i-a10s-ahb-gates-clk" - for the AHB gates on A10s
> > +       "allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer o=
n A31
> > +       "allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
> >         "allwinner,sun4i-apb0-clk" - for the APB0 clock
> >         "allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
> >         "allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
> > @@ -24,6 +27,9 @@ Required properties:
> >         "allwinner,sun4i-apb1-gates-clk" - for the APB1 gates on A10
> >         "allwinner,sun5i-a13-apb1-gates-clk" - for the APB1 gates on A13
> >         "allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A=
10s
> > +       "allwinner,sun6i-a31-apb1-gates-clk" - for the APB1 gates on A31
> > +       "allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
> > +       "allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
> >=20
> >  Required properties for all clocks:
> >  - reg : shall be the control register address for the clock.
>=20
> This looks sensible, but I have a couple of questions below:
>=20
> > diff --git a/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-ga=
tes.txt b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> > new file mode 100644
> > index 0000000..fe44932
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> > @@ -0,0 +1,83 @@
> > +Gate clock outputs
> > +------------------
> > +
> > +  * AHB1 gates ("allwinner,sun6i-a31-ahb1-gates-clk")
> > +
> > +    MIPI DSI                                   1
> > +
> > +    SS                                         5
> > +    DMA                                                6
> > +
> > +    MMC0                                       8
> > +    MMC1                                       9
> > +    MMC2                                       10
> > +    MMC3                                       11
> > +
> > +    NAND1                                      12
> > +    NAND0                                      13
> > +    SDRAM                                      14
> > +
> > +    GMAC                                       17
> > +    TS                                         18
> > +    HSTIMER                                    19
> > +    SPI0                                       20
> > +    SPI1                                       21
> > +    SPI2                                       22
> > +    SPI3                                       23
> > +    USB_OTG                                    24
> > +
> > +    EHCI0                                      26
> > +    EHCI1                                      27
> > +
> > +    OHCI0                                      29
> > +    OHCI1                                      30
> > +    OHCI2                                      31
> > +    VE                                         32
> > +
> > +    LCD0                                       36
> > +    LCD1                                       37
> > +
> > +    CSI                                                40
> > +
> > +    HDMI                                       43
> > +    DE_BE0                                     44
> > +    DE_BE1                                     45
> > +    DE_FE1                                     46
> > +    DE_FE1                                     47
> > +
> > +    MP                                         50
> > +
> > +    GPU                                                52
> > +
> > +    DEU0                                       55
> > +    DEU1                                       56
> > +    DRC0                                       57
> > +    DRC1                                       58
> > +
> > +  * APB1 gates ("allwinner,sun6i-a31-apb1-gates-clk")
> > +
> > +    CODEC                                      0
> > +
> > +    DIGITAL MIC                                        4
> > +    PIO                                                5
> > +
> > +    DAUDIO0                                    12
> > +    DAUDIO1                                    13
> > +
> > +  * APB2 gates ("allwinner,sun6i-a31-apb2-gates-clk")
> > +
> > +    I2C0                                       0
> > +    I2C1                                       1
> > +    I2C2                                       2
> > +    I2C3                                       3
> > +
> > +    UART0                                      16
> > +    UART1                                      17
> > +    UART2                                      18
> > +    UART3                                      19
> > +    UART4                                      20
> > +    UART5                                      21
> > +
>=20
> Are those the specific names of the clock outputs, or just what they're
> wired to on the A31? I noticed the a13 gate bindings mentioned a clock
> called MALI400, which seemed awfully specific, but I don't have a
> datasheet handy.

It's what it's wired to on the A31, and more generally on all of the
Allwinner SoCs, since it's what we've been using on the other SoCs as
well.

> Does the binding cover all clocks (even if the driver doesn't yet
> support them)? Is there any reason we can't document those clock names
> and associated IDs in the binding now even if we can't yet drive them?

No, it covers only the clocks that are a gated output of the clocks
listed here. Some IPs might require additional clocks that are not
implemented yet (such as USB), that we didn't document yet, because we
added no support.

But every clock listed in that document is actually working and
supported, and the documentation should cover all the gates supported by
the A31 for the clocks implemented (given that the documentation is
accurate).

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCUkSAAoJEBx+YmzsjxAg3eUP/3yRxr88ryJCKvQ2zevj/uOf
CGJCOEmmOVT9eonhcX7gj65VnooGgT0icVuW2CSjBg9JzBgCJlSrBBDnpci53fnI
6s0STgY4/kv/id28m6Lvk3CD+ITj2RSMXm3uSeHNiQMRCIiOILNrIwFHwYwWUS3d
DM2y2upFRjfdtCw2+8pxmZ64tczP/wQ6OCM8apnikWWAPOaX55xDdqxaD5EmFCf0
YT03m3EvcI5gky/P/PcqvSLCzZqAB3o/oh0AJwMUN0D/kWaemwsQR0MAyjYmmWOd
+SEN25FOvU+FW1cRDegltessf3DeKHdR98cLv9hUarYaIfruWXz3CcthXi/WVE4H
4uj3u7r6BH8bNdib4YggjT6n4NfoVGL3k5O1El+dcZir0m2Rs1yUZkka70RSNxfe
Koug8y7cNcwYVOzIWNDc+eoS80OubOGN5bca2ccrD+HmFGHHuZWFdpH3y55bOq/H
qSrulc1uLaaz20vNhHbkzzijky2WqLXVJMkFdoNd9W2GkvYA6vyidzKbn2fQMKy+
sUlGE5mtJ4NrXYcMaOg832+18Y0/0/vcyp1xac1wgDPsVKTFErYbSQxQXnJStIc1
HXjA8t93oEPiM2nxczg4E6COuJyUpYH6I8oeXNY8n+jeKEk9Nnmteiki9j57H+wa
Wu9vrJYexRv7CS3dwhsz
=NHU0
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
