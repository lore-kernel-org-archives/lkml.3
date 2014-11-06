Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaKFQKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:10:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:51781 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751122AbaKFQKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:10:05 -0500
Date: Thu, 6 Nov 2014 17:06:21 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] input: touchscreen: of: Register multitouch axes
Message-ID: <20141106160621.GM2989@lukather>
References: <1415200070-19346-1-git-send-email-maxime.ripard@free-electrons.com>
 <1415200070-19346-3-git-send-email-maxime.ripard@free-electrons.com>
 <20141105175635.GA22754@dtor-ws>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p/1JFEOz/hVXxMAZ"
Content-Disposition: inline
In-Reply-To: <20141105175635.GA22754@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p/1JFEOz/hVXxMAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 05, 2014 at 09:56:35AM -0800, Dmitry Torokhov wrote:
> On Wed, Nov 05, 2014 at 04:07:49PM +0100, Maxime Ripard wrote:
> > So far, the DT parsing code was only setting up the regular input axes,
> > completely ignoring their multitouch counter parts.
> >=20
> > Fill them with the same parameters than the regular axes.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> >  drivers/input/touchscreen/of_touchscreen.c | 12 +++++++++---
> >  1 file changed, 9 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/drivers/input/touchscreen/of_touchscreen.c b/drivers/input=
/touchscreen/of_touchscreen.c
> > index 74d6b0eb50ac..cf2a753edd96 100644
> > --- a/drivers/input/touchscreen/of_touchscreen.c
> > +++ b/drivers/input/touchscreen/of_touchscreen.c
> > @@ -42,17 +42,23 @@ void touchscreen_parse_of_params(struct input_dev *=
dev)
> > =20
> >  	maximum =3D of_get_optional_u32(np, "touchscreen-size-x");
> >  	fuzz =3D of_get_optional_u32(np, "touchscreen-fuzz-x");
> > -	if (maximum || fuzz)
> > +	if (maximum || fuzz) {
> >  		input_set_abs_params(dev, ABS_X, 0, maximum, fuzz, 0);
> > +		input_set_abs_params(dev, ABS_MT_POSITION_X, 0, maximum, fuzz, 0);
>=20
> Not all devices are multitouch so you shoudl not be setting multitouch
> bits unconditionally.

Hmmm, right.

> In I think we should rely on driver to set capability bits properly and
> then here test them and apply the readings. Probably also issue a
> warning if we see max/fuzz setting but neither ABS_<N>/ABS_MT_<N>
> capabilities.

What I was aiming at was to avoid DT parsing duplication for the
!multitouch and multitouch axis. I don't think there's a way to copy
the parameters.

The mt_init_slots might be a solution, but it does the copy the other
way around: from the multitouch to the !multitouch axis, and without
enabling it, which renders using both input_mt_init_slots and the
of_touchscreen code together impossible.

Is there a way to just enable an axis without calling
input_set_abs_params? Is __set_bit enough?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--p/1JFEOz/hVXxMAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW5x8AAoJEBx+YmzsjxAgdr4P/RAjlgX4Ye264WFKTYZCfMgl
Xf6PQD5K8yfeuczohFSwT1AuEqXlNYsCb5SUg+f6omLsepCK/DsapIm31SMYjC9a
0X0ifYCPFDe+szYEVPXhqVTSJyQcd8wXmA+b19gVtcBqjCtGwNFMRtkX8ABb3Xqy
VFx4+Yjt5Kf0G29q7BR5+RGej+Skv0YeUjF9nVi+p4cYHKo4dxQ51lJlFgwC+7lO
YGv7qg6OHEzWPw8ibcWtxmPCsKTwJXP+swviqrtGwwA0ElmqDPdSPtMZYqaBX4wp
aClQwpzn9fXk2GLZ8xmrgmnwKuEOyI/XhnCTfcZ8zrEzvqMGgilsWkE7YUZ82NEA
unTwUluJIPRw6DaFiNw6g3w3M/GFyGMYw+iwnl4NTqdU1lF4GtaxJNJJfZW7CYEj
7Wb7UjjEAjjzxFJmLWNuI9rRmQjIuGdJHcfop5WWfEzQefLGa4UQLyOqprOKpWLw
8G3GU/fVA7f1AU1J7auOJvaDpMxDA5tO369eC40okyym9GFJ7A5R3WQ2YQJyQpSe
I4Tk2lK/XkimdA2u3xWislwPxCbToobBUQ+PsHz7ccAcOc+RE0Y4/PZJYIbetakT
Cu1kGi4JClf/STZ2qqxzSs7d9Y80voL5RNEZAaWsQpgo+E51fTdThXNdgUXHw1eq
Sn5oMmnKBVN1hqCWlaPs
=vUAa
-----END PGP SIGNATURE-----

--p/1JFEOz/hVXxMAZ--
