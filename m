Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbaD3MvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:51:24 -0400
Received: from ip-78-45-166-173.net.upcbroadband.cz ([78.45.166.173]:58236
	"EHLO moskyto.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878AbaD3MvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:51:23 -0400
Date: Wed, 30 Apr 2014 14:51:20 +0200
From: Jan Moskyto Matejka <mq@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark@einon.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [linux-next] [staging] rtl8821ae: fixed defined-not-used
 warning
Message-ID: <20140430125120.GG24832@moskyto.dyndns.org>
References: <1398860143-2676-1-git-send-email-mq@suse.cz>
 <1398861590.18460.7.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ulDeV4rPMk/y39in"
Content-Disposition: inline
In-Reply-To: <1398861590.18460.7.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ulDeV4rPMk/y39in
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 02:39:50PM +0200, Paul Bolle wrote:
> On Wed, 2014-04-30 at 14:15 +0200, Jan Moskyto Matejka wrote:
> > --- a/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
> > +++ b/drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c
> > @@ -503,6 +503,7 @@ static void halbtc8192e2ant_querybt_info(struct btc=
_coexist *btcoexist)
> >  	btcoexist->btc_fill_h2c(btcoexist, 0x61, 1, h2c_parameter);
> >  }
> > =20
> > +#if (BT_AUTO_REPORT_ONLY_8192E_2ANT !=3D 0)
> >  static bool halbtc8192e2ant_iswifi_status_changed(struct btc_coexist *=
btcoexist)
> >  {
> >  	static bool pre_wifi_busy;
> > @@ -534,6 +535,7 @@ static bool halbtc8192e2ant_iswifi_status_changed(s=
truct btc_coexist *btcoexist)
> > =20
> >  	return false;
> >  }
> > +#endif
> > =20
> >  static void halbtc8192e2ant_update_btlink_info(struct btc_coexist *btc=
oexist)
> >  {
>=20
> The output of=20
>     git grep BT_AUTO_REPORT_ONLY_8192E_2ANT next-20140430
>=20
> is
>     next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c:#=
if (BT_AUTO_REPORT_ONLY_8192E_2ANT =3D=3D 1)
>     next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c:#=
if (BT_AUTO_REPORT_ONLY_8192E_2ANT =3D=3D 0)
>     next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.c:#=
if (BT_AUTO_REPORT_ONLY_8192E_2ANT =3D=3D 0)
>     next-20140430:drivers/staging/rtl8821ae/btcoexist/halbtc8192e2ant.h:#=
define     BT_AUTO_REPORT_ONLY_8192E_2ANT                  0
>=20
> So it seems that some trivial cleaning up is possible. Ie, drop the
> #define and drop the three tests that are either always true or always
> false. Is there a reason not to do that cleaning up?

I thought this part of code is here for somebody who wants to make a
custom build with this variable changed to compile in the other
behaviour. But after a while, it stopped to make sense for me. I may
clean it up. I'll send a cleanup-patch later.
--=20
Jan Mat=C4=9Bjka <mq@suse.cz>
SUSE Labs

--ulDeV4rPMk/y39in
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYPHIAAoJEDFERKcRJ1apRr4P/1bVLlZdElio7UNFLl8JUVQ2
8fDL/p1viIffB5UwF8qbn+ZSvi92NXut3PCFYVO4p1ZyHJuGhqSl7rYn+mcyvOoo
eBkuAN6nLX3XhPodqEFkZnKVwwHqriTQihJzKDoY0B0Dt1PBOnq++SRW+971DhXO
iwuvqDnV5AfWFpLqhrxpvHNzExNnzmYY1aZomKK+cNdGNukIlU6hY83g6ZTqx2kF
rpdCk4+aCfWwT4y1SeTVylRg9Rh5cdJH/Ui84dFHVTxsCRyeDdzduWVZ42aI2X2S
WALU8GawmvAky9vyuul+ALnJ+7bBZtlFqUxeWK6TrMP8+9Db/24OzeqMMM9plZFe
SXS/aMFfbsgL3arS//YLYhda5mQzUoRgwj7tHw0a+6fG9UHrJv3OW/4aZ32l5qBa
FB2OBujqyyPuV5VaqndSIdwTi2LiYCiVIWczUhfMCnSKinPVZ86d26+05JuGxqk9
daRz3OVWB/BXEkwOoi299asWSqrB0lrgzoqmn87HCowz9uEVkIo8kON8AwI9a/cJ
9tIZxBqYtKxCutOrlpMjku32qnmWe6KHbFdQP76RQYZgzFsvkCdUCb/N4QRo6x99
RppraXPXYm4E2vfNN/pnbE+WiES+4MT6DelqEswGrwdcVtiunQjhK7TzvymWlsEe
HTZcX81/pXAnnkcLJ47M
=06xL
-----END PGP SIGNATURE-----

--ulDeV4rPMk/y39in--
