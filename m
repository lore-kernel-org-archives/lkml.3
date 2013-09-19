Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab3ISVCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:02:06 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43226 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3ISVCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:02:04 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] RX-51: Add missing max_current to rx51_lp5523_led_config
Date: Thu, 19 Sep 2013 23:01:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1379541145-25934-1-git-send-email-pali.rohar@gmail.com> <20130918222642.GK9994@atomide.com>
In-Reply-To: <20130918222642.GK9994@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1398082.HzL3PXAUY9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309192301.58761@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1398082.HzL3PXAUY9
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 19 September 2013 00:26:43 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130918 15:02]:
> > Without max_current data in board file lp5523 driver does
> > not change current.
>=20
> Hmm is this a regression or are there other reasons to merge
> this during the -rc cycle?
>=20

I think this is regression, drivers/leds/leds-lp55xx-common.c=20
code refuse to change led_current sysfs attribute if value is=20
higher than max_current specified in board file. And because in=20
board file max_current is not specified it is by default zero as=20
global variable. So changing led_current is not possible because=20
any positive value is more than zero. First I saw this behaviour=20
in 3.10, but I forgot to send this patch.

> Regards,
>=20
> Tony
>=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> >=20
> >  arch/arm/mach-omap2/board-rx51-peripherals.c |    9
> >  +++++++++ 1 file changed, 9 insertions(+)
> >=20
> > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > b/arch/arm/mach-omap2/board-rx51-peripherals.c index
> > 9326890..d0f857c 100644
> > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > @@ -180,38 +180,47 @@ static struct lp55xx_led_config
> > rx51_lp5523_led_config[] =3D {
> >=20
> >  		.name		=3D "lp5523:kb1",
> >  		.chan_nr	=3D 0,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:kb2",
> >  		.chan_nr	=3D 1,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:kb3",
> >  		.chan_nr	=3D 2,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:kb4",
> >  		.chan_nr	=3D 3,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:b",
> >  		.chan_nr	=3D 4,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:g",
> >  		.chan_nr	=3D 5,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:r",
> >  		.chan_nr	=3D 6,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:kb5",
> >  		.chan_nr	=3D 7,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}, {
> >  =09
> >  		.name		=3D "lp5523:kb6",
> >  		.chan_nr	=3D 8,
> >  		.led_current	=3D 50,
> >=20
> > +		.max_current	=3D 255,
> >=20
> >  	}
> > =20
> >  };

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1398082.HzL3PXAUY9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI7ZkYACgkQi/DJPQPkQ1ItAgCgt9RvetxjzIarJNGwaRNoBBAC
cyoAoKu9STEu5Ct+/PdGDz8EvEpey5vH
=rzsc
-----END PGP SIGNATURE-----

--nextPart1398082.HzL3PXAUY9--
