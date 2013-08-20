Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3HTGZS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:25:18 -0400
Received: from top.free-electrons.com ([176.31.233.9]:58986 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751926Ab3HTGZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:25:16 -0400
Date: Tue, 20 Aug 2013 08:25:12 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>
Cc: Mike Turquette <mturquette@linaro.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 3/4] clk: sunxi: Add A31 clocks support
Message-ID: <20130820062512.GM3173@lukather>
References: <1375735381-18214-1-git-send-email-maxime.ripard@free-electrons.com>
 <1375735381-18214-4-git-send-email-maxime.ripard@free-electrons.com>
 <52127CC1.7030005@elopez.com.ar>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VLAOICcq5m4DWEYr"
Content-Disposition: inline
In-Reply-To: <52127CC1.7030005@elopez.com.ar>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VLAOICcq5m4DWEYr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Emilio,

On Mon, Aug 19, 2013 at 05:14:57PM -0300, Emilio L=F3pez wrote:
> El 05/08/13 17:43, Maxime Ripard escribi=F3:
> >The A31 has a mostly different clock set compared to the other older
> >SoCs currently supported in the Allwinner clock driver.
> >
> >Add support for the basic useful clocks. The other ones will come in
> >eventually.
> >
> >Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> I had another quick look at it and overall it looks good to go,
>=20
> Reviewed-by: Emilio L=F3pez <emilio@elopez.com.ar>

Thanks!

> >---
> >  Documentation/devicetree/bindings/clock/sunxi.txt  |   6 +
> >  .../bindings/clock/sunxi/sun6i-a31-gates.txt       |  83 ++++++++++++++
> >  drivers/clk/sunxi/clk-sunxi.c                      | 124 +++++++++++++=
++++++++
> >  3 files changed, 213 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/clock/sunxi/sun6i=
-a31-gates.txt
> >
> >diff --git a/Documentation/devicetree/bindings/clock/sunxi.txt b/Documen=
tation/devicetree/bindings/clock/sunxi.txt
> >index b24de10..c383d12 100644
> >--- a/Documentation/devicetree/bindings/clock/sunxi.txt
> >+++ b/Documentation/devicetree/bindings/clock/sunxi.txt
> >@@ -8,6 +8,7 @@ Required properties:
> >  - compatible : shall be one of the following:
> >  	"allwinner,sun4i-osc-clk" - for a gatable oscillator
> >  	"allwinner,sun4i-pll1-clk" - for the main PLL clock
> >+	"allwinner,sun6i-a31-pll1-clk" - for the main PLL clock on A31
> >  	"allwinner,sun4i-cpu-clk" - for the CPU multiplexer clock
> >  	"allwinner,sun4i-axi-clk" - for the AXI clock
> >  	"allwinner,sun4i-axi-gates-clk" - for the AXI gates
> >@@ -15,6 +16,8 @@ Required properties:
> >  	"allwinner,sun4i-ahb-gates-clk" - for the AHB gates on A10
> >  	"allwinner,sun5i-a13-ahb-gates-clk" - for the AHB gates on A13
> >  	"allwinner,sun5i-a10s-ahb-gates-clk" - for the AHB gates on A10s
> >+	"allwinner,sun6i-a31-ahb1-mux-clk" - for the AHB1 multiplexer on A31
> >+	"allwinner,sun6i-a31-ahb1-gates-clk" - for the AHB1 gates on A31
> >  	"allwinner,sun4i-apb0-clk" - for the APB0 clock
> >  	"allwinner,sun4i-apb0-gates-clk" - for the APB0 gates on A10
> >  	"allwinner,sun5i-a13-apb0-gates-clk" - for the APB0 gates on A13
> >@@ -24,6 +27,9 @@ Required properties:
> >  	"allwinner,sun4i-apb1-gates-clk" - for the APB1 gates on A10
> >  	"allwinner,sun5i-a13-apb1-gates-clk" - for the APB1 gates on A13
> >  	"allwinner,sun5i-a10s-apb1-gates-clk" - for the APB1 gates on A10s
> >+	"allwinner,sun6i-a31-apb1-gates-clk" - for the APB1 gates on A31
> >+	"allwinner,sun6i-a31-apb2-div-clk" - for the APB2 gates on A31
> >+	"allwinner,sun6i-a31-apb2-gates-clk" - for the APB2 gates on A31
> >
> >  Required properties for all clocks:
> >  - reg : shall be the control register address for the clock.
> >diff --git a/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gat=
es.txt b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> >new file mode 100644
> >index 0000000..fe44932
> >--- /dev/null
> >+++ b/Documentation/devicetree/bindings/clock/sunxi/sun6i-a31-gates.txt
> >@@ -0,0 +1,83 @@
> >+Gate clock outputs
> >+------------------
> >+
> >+  * AHB1 gates ("allwinner,sun6i-a31-ahb1-gates-clk")
> >+
> >+    MIPI DSI					1
> >+
> >+    SS						5
> >+    DMA						6
> >+
> >+    MMC0					8
> >+    MMC1					9
> >+    MMC2					10
> >+    MMC3					11
> >+
> >+    NAND1					12
> >+    NAND0					13
> >+    SDRAM					14
> >+
> >+    GMAC					17
> >+    TS						18
> >+    HSTIMER					19
> >+    SPI0					20
> >+    SPI1					21
> >+    SPI2					22
> >+    SPI3					23
> >+    USB_OTG					24
> >+
> >+    EHCI0					26
> >+    EHCI1					27
> >+
> >+    OHCI0					29
> >+    OHCI1					30
> >+    OHCI2					31
> >+    VE						32
> >+
> >+    LCD0					36
> >+    LCD1					37
> >+
> >+    CSI						40
> >+
> >+    HDMI					43
> >+    DE_BE0					44
> >+    DE_BE1					45
> >+    DE_FE1					46
> >+    DE_FE1					47
> >+
> >+    MP						50
> >+
> >+    GPU						52
> >+
> >+    DEU0					55
> >+    DEU1					56
> >+    DRC0					57
> >+    DRC1					58
> >+
> >+  * APB1 gates ("allwinner,sun6i-a31-apb1-gates-clk")
> >+
> >+    CODEC					0
> >+
> >+    DIGITAL MIC					4
> >+    PIO						5
> >+
> >+    DAUDIO0					12
> >+    DAUDIO1					13
> >+
> >+  * APB2 gates ("allwinner,sun6i-a31-apb2-gates-clk")
> >+
> >+    I2C0					0
> >+    I2C1					1
> >+    I2C2					2
> >+    I2C3					3
> >+
> >+    UART0					16
> >+    UART1					17
> >+    UART2					18
> >+    UART3					19
> >+    UART4					20
> >+    UART5					21
> >+
> >+Notation:
> >+ [*]:  The datasheet didn't mention these, but they are present on AW c=
ode
> >+ [**]: The datasheet had this marked as "NC" but they are used on AW co=
de
>=20
> If you have to respin this, I suppose you could drop the notation
> block, as it's not being used. But don't worry otherwise.

Actually, I left it here on purpose, if we ever need to add such clocks.
That way we would have the same notation than on the other files of the
documentation.

>=20
> >diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi=
=2Ec
> >index cd07169..bd01a02 100644
> >--- a/drivers/clk/sunxi/clk-sunxi.c
> >+++ b/drivers/clk/sunxi/clk-sunxi.c
> >@@ -125,7 +125,89 @@ static void sun4i_get_pll1_factors(u32 *freq, u32 p=
arent_rate,
> >  	*n =3D div / 4;
> >  }
> >
> >+/**
> >+ * sun6i_a31_get_pll1_factors() - calculates n, k and m factors for PLL1
> >+ * PLL1 rate is calculated as follows
> >+ * rate =3D parent_rate * (n + 1) * (k + 1) / (m + 1);
> >+ * parent_rate should always be 24MHz
> >+ */
> >+static void sun6i_a31_get_pll1_factors(u32 *freq, u32 parent_rate,
> >+				       u8 *n, u8 *k, u8 *m, u8 *p)
> >+{
> >+	/*
> >+	 * We can operate only on MHz, this will make our life easier
> >+	 * later.
> >+	 */
> >+	u32 freq_mhz =3D *freq / 1000000;
> >+	u32 parent_freq_mhz =3D parent_rate / 1000000;
> >+
> >+	/*
> >+	 * Round down the frequency to the closest multiple of either
> >+	 * 6 or 16
> >+	 */
> >+	u32 round_freq_6 =3D round_down(freq_mhz, 6);
> >+	u32 round_freq_16 =3D round_down(freq_mhz, 16);
> >+
> >+	if (round_freq_6 > round_freq_16)
> >+		freq_mhz =3D round_freq_6;
> >+	else
> >+		freq_mhz =3D round_freq_16;
> >
> >+	*freq =3D freq_mhz * 1000000;
> >+
> >+	/*
> >+	 * If the factors pointer are null, we were just called to
> >+	 * round down the frequency.
> >+	 * Exit.
> >+	 */
> >+	if (n =3D=3D NULL)
> >+		return;
> >+
> >+	/* If the frequency is a multiple of 32 MHz, k is always 3 */
> >+	if (!(freq_mhz % 32))
> >+		*k =3D 3;
> >+	/* If the frequency is a multiple of 9 MHz, k is always 2 */
> >+	else if (!(freq_mhz % 9))
> >+		*k =3D 2;
> >+	/* If the frequency is a multiple of 8 MHz, k is always 1 */
> >+	else if (!(freq_mhz % 8))
> >+		*k =3D 1;
> >+	/* Otherwise, we don't use the k factor */
> >+	else
> >+		*k =3D 0;
> >+
> >+	/*
> >+	 * If the frequency is a multiple of 2 but not a multiple of
> >+	 * 3, m is 3. This is the first time we use 6 here, yet we
> >+	 * will use it on several other places.
> >+	 * We use this number because it's the lowest frequency we can
> >+	 * generate (with n =3D 0, k =3D 0, m =3D 3), so every other frequency
> >+	 * somehow relates to this frequency.
> >+	 */
> >+	if ((freq_mhz % 6) =3D=3D 2 || (freq_mhz % 6) =3D=3D 4)
> >+		*m =3D 2;
> >+	/*
> >+	 * If the frequency is a multiple of 6MHz, but the factor is
> >+	 * odd, m will be 3
> >+	 */
> >+	else if ((freq_mhz / 6) & 1)
> >+		*m =3D 3;
> >+	/* Otherwise, we end up with m =3D 1 */
> >+	else
> >+		*m =3D 1;
> >+
> >+	/* Calculate n thanks to the above factors we already got */
> >+	*n =3D freq_mhz * (*m + 1) / ((*k + 1) * parent_freq_mhz) - 1;
> >+
> >+	/*
> >+	 * If n end up being outbound, and that we can still decrease
> >+	 * m, do it.
> >+	 */
> >+	if ((*n + 1) > 31 && (*m + 1) > 1) {
> >+		*n =3D (*n + 1) / 2 - 1;
> >+		*m =3D (*m + 1) / 2 - 1;
> >+	}
> >+}
> >
>=20
> And again, I'm purely nitpicking, but it'd be good to keep the space
> between functions consistent.

Hmmm, what space? The coding style documentation clearly states that
there should be only one line between two functions.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--VLAOICcq5m4DWEYr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSEwvHAAoJEBx+YmzsjxAgF98P/0iuPYciSHXwkrLb7JnIwr5M
83mLPeva7xYQYO+U8IYXMbeEN1pYbGAqCpQZaeF5bQszRDgYigLW/e0hjmO/pu4+
nF00RqZp7P7EzvBVcxZ/RHVF8LqOdgGK0AkE1lcMpkAucgLW4O4PiH3NLyM6O/UW
2uaRhAwG9XNDXz+XNO5IOK+6hpkUfBHsoidRCpvezL9YDSusdCo35xvmiJQtkCmT
AJ+bC30vrR7n490s1Nax5LiCsmr7FRmPA06GLYqnhWWSjvsLEvjvzM0P/Pmt+UHB
EHn/ngUMtn1gp31UPwZIveGzlf30hwrlYckpfJk9z+/QKmJ6KEo2xduUuwuwU0J5
ti9NNlLreIkpTab/5BAE7aG58hUGvHCBzmgevZ+e/AN/2ZZlyvvg2sWP1fYT4gyP
ptnkZAgkHb9pj3u3PxrY7MI5lHrSkdjTuEwwEiCaSEFfYOlChGADIYxA3c7+xNvZ
DVNEDzEB7x1U+L2TUMNirQUGbfuZT+qnWqGkuh7cjHm+VfAMHb0zWSLfFbYRIrmw
Jz5YxKzLQPiLBPnTuUzB8GWDP99Ld17c63NAUMovTJ2ZU9IIysktNA0jeAgmWOoa
mYZwlxEhZw7ZDvRNCMi1v9gVP0/nDOXcOD9T4SOYi8ruFxxpbCE+Gqvi7wVlhU2Q
SngeNDWHjA78wXheBHTX
=uqJi
-----END PGP SIGNATURE-----

--VLAOICcq5m4DWEYr--
