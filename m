Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3GEWMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:12:16 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:52508 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab3GEWMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:12:06 -0400
Date: Sat, 6 Jul 2013 00:12:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Emilio Lopez <emilio@elopez.com.ar>,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCHv3 08/10] clocksource: sun4i: Remove TIMER_SCAL variable
Message-ID: <20130705221204.GO2959@lukather>
References: <1373052877-29366-1-git-send-email-maxime.ripard@free-electrons.com>
 <1373052877-29366-9-git-send-email-maxime.ripard@free-electrons.com>
 <alpine.DEB.2.02.1307052245390.32106@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WkHPBKJ2pKcVUM5H"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307052245390.32106@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WkHPBKJ2pKcVUM5H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 05, 2013 at 10:48:45PM +0200, Thomas Gleixner wrote:
>=20
>=20
> On Fri, 5 Jul 2013, Maxime Ripard wrote:
>=20
> > The prescaler is only used when using the internal low frequency
> > oscillator (at 32kHz). Since we're using the higher frequency oscillator
> > at 24MHz, we can just remove it.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/clocksource/sun4i_timer.c | 11 +++--------
> >  1 file changed, 3 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/drivers/clocksource/sun4i_timer.c b/drivers/clocksource/su=
n4i_timer.c
> > index 00e17d9..2f84075 100644
> > --- a/drivers/clocksource/sun4i_timer.c
> > +++ b/drivers/clocksource/sun4i_timer.c
> > @@ -34,8 +34,6 @@
> >  #define TIMER_INTVAL_REG(val)	(0x10 * (val) + 0x14)
> >  #define TIMER_CNTVAL_REG(val)	(0x10 * (val) + 0x18)
> > =20
> > -#define TIMER_SCAL		16
> > -
>=20
> I can understand this one.
>=20
> >  static void __iomem *timer_base;
> > =20
> >  /*
> > @@ -139,7 +137,6 @@ static u32 sun4i_timer_sched_read(void)
> > =20
> >  static void __init sun4i_timer_init(struct device_node *node)
> >  {
> > -	unsigned long rate =3D 0;
> >  	struct clk *clk;
> >  	int ret, irq;
> >  	u32 val;
> > @@ -157,8 +154,6 @@ static void __init sun4i_timer_init(struct device_n=
ode *node)
> >  		panic("Can't get timer clock");
> >  	clk_prepare_enable(clk);
> > =20
> > -	rate =3D clk_get_rate(clk);
> > -
>=20
> But this one is bogus. Why do you want to read the clock rate five
> times in a row instead of using the single cached value?
>=20
> That does not make any sense.

Right, I'll send a new version.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--WkHPBKJ2pKcVUM5H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR10S0AAoJEBx+YmzsjxAg/KEQAKDr4Ir8/80Gwd1nWjQcZEV7
1CsHLK7LbNTXLWD/CYGvV6/dxSe7l3grbfLjegU4GFo7UxFzu86gINRPFoAdG+Ta
ASTnics6Occza3VreymfTf2+rSze+XYUhsaLyHV0Imm/rZnf8eFrEBqkc+P/UqT1
JUVi1b04WYnekMMivM/NdnYv8/T16UhDIC0mARiE9YZWYXQL5fLK+LW71C24xRMv
S1eVxX6H856fOiTt7nDZn4VIcXsTSB+kMd/z2ZCONc9TEiwT9J7FuDY2FVX9nzTn
XI16Qe3HTLCYOguyWLJUgHr8HrvhqkkCdq4ZcMUar45zAz4cprEv6KQCAEQbNiPf
LFzbgmBi+ZOpNMCUFmhFMORV/NJD1HvIwF9YHoTdYazfC0uF/BqynvN/tuCdOu/0
Wym8ijAEdtiqiQFhuLyq1Rn3zLyUsda1pG6FeU/N7pl7OicZ4jsG9DLBZny0Y8dJ
yJdMNSXujycCZINmEpLwnLuqYUM2w8HuLQRRI1wQnuOa0b69o11WBAprjteiJsJM
kj5J3EymagjNoRF428GQHlLTyjZUoXR9AgXtRStxUmLMvrAEYkU3oHFQKQiFGRn7
hX2zymlsm9x+CfFLGNt5C6w8EqlM3YEK1xd77nDdNU27ie574L0HQ8bTFoikhKc1
bdVSC80UW0fyfHYVRVr3
=Va+U
-----END PGP SIGNATURE-----

--WkHPBKJ2pKcVUM5H--
