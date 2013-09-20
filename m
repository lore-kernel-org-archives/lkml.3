Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3ITQlW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:41:22 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:48769 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752414Ab3ITQlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:41:20 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 1/3] omap2: Change clk dev id for rng to omap3-rom-rng
Date: Fri, 20 Sep 2013 18:41:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.hengli.com.au>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com> <1379683507-30793-2-git-send-email-pali.rohar@gmail.com> <20130920162342.GS9994@atomide.com>
In-Reply-To: <20130920162342.GS9994@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1626309.BAQjC3SRxv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309201841.16197@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1626309.BAQjC3SRxv
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 20 September 2013 18:23:43 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130920 06:33]:
> > Name omap_rng is already used by omap_rng driver which is
> > for omap2 and omap4. For omap3 HS devices there is new
> > driver omap3-rom-rng which needs that clk. And because
> > there cannot be two drivers with same name, rename omap3
> > clk dev id.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  arch/arm/mach-omap2/cclock3xxx_data.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c
> > b/arch/arm/mach-omap2/cclock3xxx_data.c index
> > 334b767..5059338 100644
> > --- a/arch/arm/mach-omap2/cclock3xxx_data.c
> > +++ b/arch/arm/mach-omap2/cclock3xxx_data.c
> > @@ -3274,7 +3274,7 @@ static struct omap_clk omap36xx_clks[]
> > =3D {
> >=20
> >   */
> > =20
> >  static struct omap_clk omap34xx_omap36xx_clks[] =3D {
> > =20
> >  	CLK(NULL,	"aes1_ick",	&aes1_ick),
> >=20
> > -	CLK("omap_rng",	"ick",		&rng_ick),
> > +	CLK("omap3-rom-rng",	"ick",		&rng_ick),
> >=20
> >  	CLK(NULL,	"sha11_ick",	&sha11_ick),
> >  	CLK(NULL,	"des1_ick",	&des1_ick),
> >  	CLK(NULL,	"cam_mclk",	&cam_mclk),
>=20
> Hmm are you sure the omap_rng is not available on
> any of the omap3 GP versions? If so, the omap_rng
> alias should be kept as well.
>=20
> Regards,
>=20
> Tony

I really do not know, but driver char/hw_random/omap-rng.c=20
support only omap2 and omap4 platforms. So "omap_rng" dev id for=20
omap3 is not used.

In email [1] you suggested to use clk_get instead clk_get_sys. If=20
I understand correctly clk_get calling clk_get_sys with driver=20
name. So dev in in CLK macro must be same as driver name. And=20
because in cclock3xxx_data.c is dev id "omap_rng" and there is=20
already driver with name "omap_rng", I need to rename dev in=20
cclock3xxx_data.c to get new omap3-rom-rng driver working.

Or if you know better way how to do it, let me know.

[1] - https://lkml.org/lkml/2013/4/1/278

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1626309.BAQjC3SRxv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI8eqwACgkQi/DJPQPkQ1Lv4QCdGE6cUWP92PYiNEgXFisUjsDw
m/sAnA7ufOwUWlSHSobuOjfU0wUrb6Ko
=/cE6
-----END PGP SIGNATURE-----

--nextPart1626309.BAQjC3SRxv--
