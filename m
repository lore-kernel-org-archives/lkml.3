Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbbAUQFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 11:05:50 -0500
Received: from mail.kernel.org ([198.145.29.136]:49200 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbbAUQFn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 11:05:43 -0500
Date: Wed, 21 Jan 2015 17:05:33 +0100
From: Sebastian Reichel <sre@kernel.org>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] power: bq24190_charger: suppress build warning
Message-ID: <20150121160533.GF13715@earth.universe>
References: <1417704964-23155-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vKFfOv5t3oGVpiF+"
Content-Disposition: inline
In-Reply-To: <1417704964-23155-1-git-send-email-prabhakar.csengg@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vKFfOv5t3oGVpiF+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 04, 2014 at 02:56:04PM +0000, Lad, Prabhakar wrote:
> This patch fixes following build warning:
>=20
> In file included from include/linux/printk.h:261:0,
>                  from include/linux/kernel.h:13,
>                  from include/linux/list.h:8,
>                  from include/linux/module.h:9,
>                  from drivers/power/bq24190_charger.c:11:
> drivers/power/bq24190_charger.c: In function =E2=80=98bq24190_irq_handler=
_thread=E2=80=99:
> include/linux/dynamic_debug.h:86:20: warning: =E2=80=98ss_reg=E2=80=99 ma=
y be used uninitialized in this function [-Wmaybe-uninitialized]
>    __dynamic_dev_dbg(&descriptor, dev, fmt, \
>                     ^
> drivers/power/bq24190_charger.c:1211:5: note: =E2=80=98ss_reg=E2=80=99 wa=
s declared here
>   u8 ss_reg, f_reg;
>      ^
> In file included from include/linux/printk.h:261:0,
>                  from include/linux/kernel.h:13,
>                  from include/linux/list.h:8,
>                  from include/linux/module.h:9,
>                  from drivers/power/bq24190_charger.c:11:
> include/linux/dynamic_debug.h:86:20: warning: =E2=80=98f_reg=E2=80=99 may=
 be used uninitialized in this function [-Wmaybe-uninitialized]
>    __dynamic_dev_dbg(&descriptor, dev, fmt, \
>                     ^
> drivers/power/bq24190_charger.c:1211:13: note: =E2=80=98f_reg=E2=80=99 wa=
s declared here
>   u8 ss_reg, f_reg;
>=20
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  drivers/power/bq24190_charger.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_char=
ger.c
> index ad3ff8f..72e552d 100644
> --- a/drivers/power/bq24190_charger.c
> +++ b/drivers/power/bq24190_charger.c
> @@ -1208,7 +1208,7 @@ static irqreturn_t bq24190_irq_handler_thread(int i=
rq, void *data)
>  {
>  	struct bq24190_dev_info *bdi =3D data;
>  	bool alert_userspace =3D false;
> -	u8 ss_reg, f_reg;
> +	u8 ss_reg =3D 0, f_reg =3D 0;
>  	int ret;
> =20
>  	pm_runtime_get_sync(bdi->dev);

Thanks, applied.

-- Sebastian

--vKFfOv5t3oGVpiF+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUv85MAAoJENju1/PIO/qaUKgP/2q1N/MUWcK2XYRr6PYfJ55I
uj3M89QPVjv+SSimIw1HSF4Byifv5ikSN2P7OuUxippDaT0hpJqirX7ouY3fm462
LEWl6E4h+Lz2fu9Ug+MY03sJoIuPuXG4004AjMC3R2wjKhH9X9WOabf2+mwbotTB
on1MA9Zmb2fAE7a7Xu4raMIOaZljCjRw5jc6HPlKZu/FHrlH0WePz0CrfcFYA7lB
MvURRcmPVQpQGQZQS28dkjtHCvnYWRcLjISczYLxdFUlTtgc0gVK36yCjAmLSN1w
WRCKh8hNQZD7FSOh/hsDPBV+LTrJLGabMS4BJl2MoZmcFSrjBXfXWFOfpLurjWGt
GxEqQjBCuw+ZRDisnZWLyC/AN2b/eUE1Ik038zMM8f8yAzcU85eMbm3SOYu5QRbQ
v12Wm2ndrSa016a7BBieX7TI09KWBpqYRdWSe1LOBK4WkoFz3THulHsFSrEIiSCl
XxEz7HiHMG+jHFbuzuJ2yA7h3dsvs4AFcH/WnlhstZeopTyPBINVSBS0wJ1eDX5t
Yuf77Bjqz0D7VwBN+JXl34jiWAOYF6bgsufHEw8p3nsMjmm1hx6aaUDVOswHkjDG
boF7JzpK70sxu9EaObWmW7+FqfGCHUBamNZUk28a3PI3JU3QMYQ+UjPQ8EKT2cCt
VJ4F5XlILQS/0qoW2hpw
=rBKJ
-----END PGP SIGNATURE-----

--vKFfOv5t3oGVpiF+--
