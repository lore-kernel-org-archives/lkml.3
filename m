Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab3CFE4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 23:56:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39177 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509Ab3CFE4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 23:56:10 -0500
Date: Wed, 6 Mar 2013 12:55:37 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, patches@opensource.wolfsonmicro.com,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: wm8350: Complain if we fail to reenable DCDC
Message-ID: <20130306045534.GE4896@opensource.wolfsonmicro.com>
References: <1362210046-13651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <CAK5ve-+FTv1OTfJozs_sy7B0Zd6SzzBOU_1En4AMQCw1RZjprw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gDGSpKKIBgtShtf+"
Content-Disposition: inline
In-Reply-To: <CAK5ve-+FTv1OTfJozs_sy7B0Zd6SzzBOU_1En4AMQCw1RZjprw@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 05, 2013 at 11:03:52AM -0800, Bryan Wu wrote:
> On Fri, Mar 1, 2013 at 11:40 PM, Mark Brown

> >         if (ret !=3D 0) {
> >                 dev_err(led->cdev.dev, "Failed to disable ISINK: %d\n",=
 ret);
> > -               regulator_enable(led->dcdc);
> > +               ret =3D regulator_enable(led->dcdc);
> > +               if (ret !=3D 0) {
> looks like we don't need this bracket here.
>=20
> > +                       dev_err(led->cdev.dev, "Failed to reenable DCDC=
: %d\n",
> > +                               ret);
> > +               }
> ditto.

It's not required but since it's inside a small but multi-line block
there's the whole thing about including braces at all levels for
clarity.

--gDGSpKKIBgtShtf+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNsw/AAoJELSic+t+oim9kqkP/2RV129xBbhAam1Rq+jRyYAP
2vRmzrDNHWEutOWGp641k4s9pgFj4suOTxdtqeTvzEO2rqrqusBU4uGSzbeMkP6t
htRtCamKp0DTagcABz77c99ZyX1idrsLwg6VKeb+oE9mgci0jHE4u64CwYY1rRhQ
Kord2i4KiWLtjgzFr+H+43ggzO2gKAlbvCPsPCqmdA64CTZSwg3CJbyl7Nq/k5GJ
HYnspOf9jM7Z2aKlrfMEz5U4zrdkgk3PelWYZ8VpXdiBWpd2x6G4WstxwgpaWgV8
NBp8ZdZOclZCIp3zhYwYH3cebUMFwzkHLCneF1Lj1ZOKH1zYnxew6iurpv+FaZbq
GUClICNmK4xY5ZChpfgJIQKrBa1jB27OAQXPE2ODwlAFqv1n4lDc5UkrUQYQiLqj
YeXUuyUBPgGvl3eEEntgTAtgYMsrjP6ibzB3LO7TEuJWFiARwOMZEVhjbTomcgsp
qIoZwTrzEVCV1JBW9C854HnsgIfsZ8cOdZs1ewGlIGMOihnbkFzLKu2EPZHdEl7j
p7OCIkjRUvyAfmNF5v7RWbmg9BuIKIZs0EUTes6KBTtMpFeEGN2QMsG6zmhdS1Se
PP8PRRJyDyYvk6vEesRYHqLytNBC54H65JvsPfzAaS/5l4k84Sj98aVWE0kg6Nup
1VQeT++NKaunL8//Gf1L
=707E
-----END PGP SIGNATURE-----

--gDGSpKKIBgtShtf+--
