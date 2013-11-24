Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab3KXK2g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 05:28:36 -0500
Received: from mail-bk0-f43.google.com ([209.85.214.43]:39426 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3KXK2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 05:28:32 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 3/3] RX-51: Add platform data for bq24150a charger
Date: Sun, 24 Nov 2013 11:28:26 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <1384856285-19593-4-git-send-email-pali.rohar@gmail.com> <20131119133212.GF14587@amd.pavel.ucw.cz>
In-Reply-To: <20131119133212.GF14587@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1556635.STb31pS9vA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311241128.27783@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1556635.STb31pS9vA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 19 November 2013 14:32:13 Pavel Machek wrote:
> On Tue 2013-11-19 11:18:05, Pali Roh=C3=A1r wrote:
> > This patch will register bq24150a charger in RX-51 board
> > data.
> >=20
> > So finally charging battery on Nokia N900 (RX-51) working
> > automatically without any proprietary Nokia bits in
> > userspace.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
>=20
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
>=20
> 									Pavel
> BTW, current code says:
>=20
> That seems to limit charging voltage to 3.9V, with comment
> saying 4.11V... which means battery will not be charged
> fully. does it make sense to raise limit to 4.11V here?
>=20
> Aha, and actually will not 4.2V requested by
> rx51_bq24150a_platform_data trigger -EINVAL?
>=20
> /* set battery regulation voltage in mV */
> static int bq2415x_set_battery_regulation_voltage(struct
> bq2415x_device *bq,
>                                                   int mV)
> {
>         int val =3D (mV/10 - 350) / 2;
>=20
>         if (val < 0)
>                 val =3D 0;
>         else if (val > 94) /* FIXME: Max is 94 or 122 ? Set
> max value ? */
>                 return -EINVAL;
>=20
>         return bq2415x_i2c_write_mask(bq, BQ2415X_REG_VOLTAGE,
> val, BQ2415X_MASK_VO, BQ2415X_SHIFT_VO); }
>=20

Above bq2415x_set_battery_regulation_voltage function is updated=20
in 3.13, see commit 3ed5cd79b82e9a055e0df3275eeb471ea0f1e2d7.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1556635.STb31pS9vA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKR1MsACgkQi/DJPQPkQ1JltgCeMYUnBvg86S//Y/0rhoI9nY5m
WFYAoIaEIr+7xEuVolWQgMu94lqecd2b
=Vh3g
-----END PGP SIGNATURE-----

--nextPart1556635.STb31pS9vA--
