Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbaBDJPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 04:15:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:55124 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310AbaBDJPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 04:15:04 -0500
Date: Tue, 4 Feb 2014 10:13:16 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/8] ARM: dts: sun7i: Add GMAC clock node to sun7i DTSI
Message-ID: <20140204091316.GJ25625@lukather>
References: <1391398346-5094-1-git-send-email-wens@csie.org>
 <1391398346-5094-3-git-send-email-wens@csie.org>
 <20140203193431.GD25625@lukather>
 <CAGb2v660qoKDC6SKjoD29b-r5y9OwkeKoWZ9PWBF5tC5PgeEYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VSaCG/zfRnOiPJtU"
Content-Disposition: inline
In-Reply-To: <CAGb2v660qoKDC6SKjoD29b-r5y9OwkeKoWZ9PWBF5tC5PgeEYQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VSaCG/zfRnOiPJtU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2014 at 11:06:24AM +0800, Chen-Yu Tsai wrote:
> On Tue, Feb 4, 2014 at 3:34 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > On Mon, Feb 03, 2014 at 11:32:20AM +0800, Chen-Yu Tsai wrote:
> >> The GMAC uses 1 of 2 sources for its transmit clock, depending on the
> >> PHY interface mode. Add both sources as dummy clocks, and as parents
> >> to the GMAC clock node.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  arch/arm/boot/dts/sun7i-a20.dtsi | 28 ++++++++++++++++++++++++++++
> >>  1 file changed, 28 insertions(+)
> >>
> >> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7=
i-a20.dtsi
> >> index 1595e9a..fc7f470 100644
> >> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> >> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> >> @@ -314,6 +314,34 @@
> >>               };
> >>
> >>               /*
> >> +              * The following two are dummy clocks, placeholders used
> >> +              * on gmac_tx clock. The actual frequency and availabili=
ty
> >> +              * depends on the external PHY, operation mode and link
> >> +              * speed.
> >> +              */
> >
> > If it depends on the external PHY, I guess that means it also depends
> > on the board, right? Or is the GMAC supposed to always have that clock
> > running at 25MHz, no matter what PHY is connected to it?
>=20
> What I meant in the comment is that we cannot control the actual clock
> rate of the TX clock. We can only select the source, and this is what
> gmac_tx clock does. It is just a clock mux. The 125MHz and 25MHz clock
> rates are used by the clk_set_rate in the stmmac glue layer to do
> auto-reparenting.
>=20
> The board dependent factor is what _type_ of PHY it is using, i.e.
> MII, GMII, or RGMII. If it's MII, the PHY should provide the clock.
> If it's RGMII, the internal clock would be used. GMII is a mix of
> both. The actual clock rate depends on the link speed.
>=20
> I should rephrase the comment along the lines of:
>=20
> The following two are dummy clocks, placeholders used in the gmac_tx
> clock. The gmac driver will choose one parent depending on the PHY
> interface mode, using clk_set_rate auto-reparenting.
> The actual TX clock rate is not controlled by the gmac_tx clock.

Ok, thanks for the clarification.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--VSaCG/zfRnOiPJtU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS8K8sAAoJEBx+YmzsjxAgiPwP/1AO1R8VKNB3hj+0BogRrf/k
7LK0/RlU1y+/hKJk4XxNOKvNcNkKCn9hoWBZ14HFJYNLjCSHKspb+9axRLtsCxLe
g4k2Tq2ci7gNEYSXMq05yCg3hHX8o9eszNHhuQ4bfkX0qgv8mpSMA25T2d4ghB21
kkiEymtnaeMjOw6OWwkydtX57JFTT+Yz6dS0h0XCnXEEL2FojYQbdYYq+Hz1D3Ga
EjtowC56W+jfzotuPkhq9YPx8djyIt2e+hc4Om7Lq3r/bi2ZlIyLgvY4TCcfRiam
xNw7bUjOjGfijsLepGseV9RPpwa4ocOLI9FljCf7IkSCEx1tyJxe4ocbq/IY+Kyk
/Wo8QS3XE3pRs40ZuAd9yxXk+9bqX5izlaslNEG1CrQTFlf67njHYhcCrhlvtq6x
J2R79CaS4KBMSNDCZtUcX50bwOGbZ0VJeUafEvTAb5SYVsAkZExkO15P6TzzSoUo
9FyKXSOEsyvYCW00M8nIkMgfKtv1Yf9ZSanqSUOGp6UjVP+rRyLIZoMQYIWTAdgV
LKmRuePoubeJ6DLk1sMY/1sCNU2FLaV6/twDi9xKzbRtHnG3BqCG/XjqyVtRj6mG
JbcvC9q4VI1RK7D9XTBxEOOJIYXKe8xXyOvx0GVRJaFw8w4sAeXgJhz19TQoCccl
YYtkxunK+jxWS1HMBNli
=iFvB
-----END PGP SIGNATURE-----

--VSaCG/zfRnOiPJtU--
