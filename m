Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaIIX2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:28:30 -0400
Received: from ozlabs.org ([103.22.144.67]:32793 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaIIX22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:28:28 -0400
Date: Wed, 10 Sep 2014 09:28:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jade Bilkey <herself@thefumon.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-ID: <20140910092819.7b0b0ae7@canb.auug.org.au>
In-Reply-To: <20140908184253.74ff5470@canb.auug.org.au>
References: <20140908184253.74ff5470@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/N8YvbWTjIwnUXeIAQRymE+8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/N8YvbWTjIwnUXeIAQRymE+8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 8 Sep 2014 18:42:53 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Hi John,
>=20
> After merging the wireless-next tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>=20
> drivers/net/wireless/ath/ath5k/debug.c: In function 'open_file_eeprom':
> drivers/net/wireless/ath/ath5k/debug.c:933:2: error: implicit declaration=
 of function 'vmalloc' [-Werror=3Dimplicit-function-declaration]
>   buf =3D vmalloc(eesize);
>   ^
> drivers/net/wireless/ath/ath5k/debug.c:933:6: warning: assignment makes p=
ointer from integer without a cast
>   buf =3D vmalloc(eesize);
>       ^
> drivers/net/wireless/ath/ath5k/debug.c:960:2: error: implicit declaration=
 of function 'vfree' [-Werror=3Dimplicit-function-declaration]
>   vfree(buf);
>   ^
>=20
> Caused by commit db906eb2101b ("ath5k: added debugfs file for dumping
> eeprom").  Also reported by Guenter Roeck.
>=20
> I have used Geert Uytterhoeven's suggested fix of including vmalloc.h
> and so added this patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 8 Sep 2014 18:39:23 +1000
> Subject: [PATCH] ath5k: fix debugfs addition
>=20
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Suggested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/ath/ath5k/debug.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/wireless/ath/ath5k/debug.c b/drivers/net/wireles=
s/ath/ath5k/debug.c
> index 30e4e1fd4b04..399728618fb9 100644
> --- a/drivers/net/wireless/ath/ath5k/debug.c
> +++ b/drivers/net/wireless/ath/ath5k/debug.c
> @@ -62,6 +62,7 @@
> =20
>  #include <linux/export.h>
>  #include <linux/moduleparam.h>
> +#include <linux/vmalloc.h>
> =20
>  #include <linux/seq_file.h>
>  #include <linux/list.h>
> --=20
> 2.1.0

This fix patch is now needed in the net-next tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/N8YvbWTjIwnUXeIAQRymE+8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUD40ZAAoJEMDTa8Ir7ZwV1JkQAIpoZl8KftErnObOwN/yP/dG
v+Ak/pMyEOWRjCRhcFqaxXvabrzCiDP/84Hqx2rxBRMC68ssp4vD6Acfp8r7Mpb+
hRLsGCxJgksMgn+fXuwhwAkzwnYVwmSYa7phFD0V4ZIv/oJvQd29Q7YIfR5bO4t2
tZfJWo/o8F4bGeASbGaIo5mlKJeHYrK/mJ6cu1xXhCY1WDL/Iqv945PGS+bGMMS9
cUOS9KfzlCvKI8CFPMOYAQHntrf1sjghFmZV13+LVwwWtDc0hQtQ0zM+PhrJ8Kox
0LwQBKdCo+3lHj5WLKkRdF5bKShCW3vEWwYQAlRWnwQOG8GiYkYSbBuel0DOKGrv
22LP4DM4tySEtny+69nz4LYlP0+D27kxvtUI+Bkgct2vQQp8PzPw9LnZ35klNZvS
Cf96G18KloLGN9c7A+S4knIzNRr/n9s7CJFvV3UwS4gizR4u0Tc4MzXSJeUxQ2YY
3TmuvRnvF7ITtanKLTWDNGQ5aXeCaK2a9P4wnDh97Rinl20RJrHzZIJ/DLaEjevz
0FHUAvlcpXwA5qRJWV0kMfcx5VHqdFPVFgIzM8LwWl/qKGotypQiqrY8avGV2o7i
6E2uZ1DBAQvY33g01j4LmUo+dVqGWMHSiZbAubCjeUlDy0aoj38dAx79e7nXbV/4
ELEeStmNrOPJSelnxINm
=btMl
-----END PGP SIGNATURE-----

--Sig_/N8YvbWTjIwnUXeIAQRymE+8--
