Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaKFSDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:03:45 -0500
Received: from mail.kernel.org ([198.145.19.201]:36243 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaKFSDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:03:42 -0500
Date: Thu, 6 Nov 2014 19:03:36 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141106180335.GA21513@earth.universe>
References: <20141104205117.GA17606@amd>
 <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
 <20141106124711.GA26944@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20141106124711.GA26944@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 06, 2014 at 01:47:11PM +0100, Pavel Machek wrote:
> > On Wed, Nov 05, 2014 at 11:03:59PM +0100, Pavel Machek wrote:
> > > > Maybe you need to enable modem?
> > > >=20
> > > > This is n900 init sequence from script: nokia-n900-configs.sh
> > >=20
> > > From the dts, it looks like this should somehow work without this.
> >=20
> > Right :) The n900-modem driver will take care of this if the "pm"
> > parameter is set to 1 (which should be the default).
>=20
> I actually had pm=3D0 on the command line, but I removed it now, and no
> change: [...]
>=20
> Let me try with explicit =3D1. .. aha, that helps. Thanks!

mh seems I actually missed to make 1 the default value. I will
prepare a patch for that.

I assume, that the example ofono commands work for you now?

> Do you have an example client that can talk to ofonod?

I have not yet played with userland stuff. You could try
telepathy-ring, which integrates the ofono into the telepathy
framework.

> What is needed to get voice calls to work?

There's still a kernel driver missing in mainline for exchanging
voice data between the modem and the cpu (called cmt-speech).

BTW the CMT driver should be removed from your kernel tree; its a
deprecated variant of mainline's nokia-modem driver. Thus I guess
the cmt-speech driver, which is available in your kernel tree, is
not properly integrated into the changes I did during mainlining
the other modem related drivers.

-- Sebastian

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUW7f3AAoJENju1/PIO/qa4S4P/1oT1u/Q9qiCjz//20hvwJZb
sj9ry5QeqffQTTeT+bM7VippN2reG6uJloCrFIZ32j4xzS30fEmvY9jtQoM61fm7
Z4OgC7lgzE/hnJAPQnn4ix/Bk7n50fF91l6wSBaiGZxRoEK03pEAcxRcBLchyvFC
OF1Eofp90v7SsGSBWR6aLS3lBSQr48NlHrQBwFe0riklQunWdF8b9ccNHJIz29rO
az/VwJHoIt3sDeu7WsOzU+YhPhVaL+rkuTltmKKOxXMu1wQ6kVQcygTb1rJFcuSe
TKr5YmR3NSKt46yWQUAHdGf/gBgdVwrD9oRMF7BNhq3B+Vkn3qVgYaO3j5iSN799
kg4g8nnkZqv4rJJg6Y8+EUoG7jlzm+F+04ppgByZYhXhh81e7cLH3+/2/2Mw9VY3
sNfN65OHt4vWAmHUX9vUW1P2r7HvKMn1AI4oDRehTlZoGhYtT33N3f4mMDuqxcnU
ljZhPV7aUNg9Feo3LGGEyxsPXzN6nxg6ohpY6hkDppO6HlPXTT716Osp5WXaVpR7
EATNTPqbu3fee+fGZg3/A10/Z+6TGo+3v9Cadn/8aZmSke/MCpjKvYglBrBdTSwY
TRl+S5YJ7BsXhLUlgHHXW4/asSUNVCvTEQMn9tseF4MEbpmUfJBhFBryd40RjCet
nw2Y/qm0/MCok0jre+6F
=Xz0L
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
