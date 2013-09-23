Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3IWTQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:16:24 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60440 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab3IWTQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:16:22 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a charger
Date: Mon, 23 Sep 2013 21:16:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <201309202122.06327@pali> <20130923180259.GJ2684@atomide.com>
In-Reply-To: <20130923180259.GJ2684@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6426680.jIMmcvTp1x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309232116.19161@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6426680.jIMmcvTp1x
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Monday 23 September 2013 20:03:00 you wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [130920 12:29]:
> > On Sunday 08 September 2013 10:50:39 Pali Roh=C3=A1r wrote:
> > > This patch will register bq24150a charger in RX-51 board
> > > data. Patch also adding platform function between isp1704
> > > and bq2415x drivers for detecting charger type.
> > >=20
> > > So finally charging battery on Nokia N900 (RX-51) working
> > > automatically without any proprietary Nokia bits in
> > > userspace.
>=20
> ...
>=20
> > > @@ -277,6 +316,7 @@ static void
> > > rx51_charger_set_power(bool on)
> > >=20
> > >  static struct isp1704_charger_data rx51_charger_data =3D {
> > > =20
> > >  	.set_power	=3D rx51_charger_set_power,
> > >=20
> > > +	.set_current	=3D rx51_charger_set_current,
> > >=20
> > >  };
>=20
> We want to get rid of the platform data callbacks here,
> there no longer any need to keep these under arch/arm.
>=20

Where to put rx51 board specified functions?
It cannot go to DT, because DT does not support C/ASM code.

> > Tony, can you look and review this board patch?
>=20
> Yes, looks like this can all be done in the driver nowadays.
> You can use drivers/reset for the set_power. Or if it's really
> controlling the regulator, then the regulator framework. The
> info can be passed in a .dts file for those.
>=20
> The .set_current you can do in the driver based on the
> compatible flag.
>=20

It is not as simple as it looks. This is reason why I submited=20
this patch long time after I submited bq2415x driver.

Problem is that for rx51 is needed specific function which connect=20
to two drivers (bq2415x and isp1704) plus it call specific rx51=20
board functions.

Something which cannot be in DT (unless DT support C/ASM code).

> > I think that this patch series it the most important for
> > Nokia N900, because it finally bringing charging support.
> > And without charging battery it very hard to use phone
> > which has power supply only from battery.
>=20
> Right, let's get this driver updated to use the device tree
> based init and that way this file is no longer needed.
> I would like to $ grep -i grandmom ~/.phonebook | call too :)
>=20

Patches for modem support are being prepared for upstreaming :-)=20
so after that it is up to you to create "call" script as you want

> I forgot how this charger is wired up, but maybe take a
> look at commit d7bf353f (bq24190_charger: Add support for TI
> BQ24190 Battery Charger) for the DT parts.
>=20
> Regards,
>=20
> Tony

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6426680.jIMmcvTp1x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlJAk4MACgkQi/DJPQPkQ1LuowCgxKJNyuhlrfPODV2s+0rhvP8P
JEkAnR4pHRveuixYEpsx30u1vywf5aI6
=uNyE
-----END PGP SIGNATURE-----

--nextPart6426680.jIMmcvTp1x--
