Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760516Ab3DBKe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:34:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48995 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714Ab3DBKez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:34:55 -0400
Message-ID: <515AB443.4060407@ti.com>
Date: Tue, 2 Apr 2013 13:34:43 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Wang YanQing <udknight@gmail.com>, <spock@gentoo.org>,
        <linux-fbdev@vger.kernel.org>, <FlorianSchandinat@gmx.de>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]video:uvesafb: Fix dereference NULL pointer code path
References: <20130330025330.GA25246@udknight>
In-Reply-To: <20130330025330.GA25246@udknight>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3D1B5BF4A1575E49B5861BCF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig3D1B5BF4A1575E49B5861BCF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-03-30 04:53, Wang YanQing wrote:
> platform_device_alloc could failed and return NULL,
> we should check this before call platform_device_put.
>=20
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  drivers/video/uvesafb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
> index 2f8f82d..230bd45 100644
> --- a/drivers/video/uvesafb.c
> +++ b/drivers/video/uvesafb.c
> @@ -1975,7 +1975,8 @@ static int __devinit uvesafb_init(void)
>  			err =3D -ENOMEM;
> =20
>  		if (err) {
> -			platform_device_put(uvesafb_device);
> +			if (uvesafb_device)
> +				platform_device_put(uvesafb_device);
>  			platform_driver_unregister(&uvesafb_driver);
>  			cn_del_callback(&uvesafb_cn_id);
>  			return err;
>=20

Thanks, queued to fbdev fixes.

 Tomi



--------------enig3D1B5BF4A1575E49B5861BCF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRWrRDAAoJEPo9qoy8lh71WiQP/iN8cIg9igTchq8wAHbA6Kaw
KCYsHLXI1AOxyg2n0F7l3o/7WwHzwG59D5tJEatvtwYDKQifW2qSdu1/8W1sGWbR
PEeOUTJ5U2nFj7cs5gtbjL6FytFjCtm5FYjP+pWhiBj2EwKCyfr4qBr2Ec0a+Jv+
L0WlD5/gP7gefvqdQGUxKlB5LCdwd4haHUuWP+qIPjLR8xLuI84c/6NEHGUzN+yl
iI3hAaawMsm4ZuPNOYTo2gejH6XXVJn/jo25fPhzaRK5jYoGGQK56emHUzho+sya
xsV1diNQ0bmIkFPNQKYbYewWgyScy/G8zBBs/pu1qP1FQWE3VrNyUa3w6IHTf3vX
rLHEME5Sll1HuNMVi1t5q/coo0FHasjgcNI1IELFTwyvi/ZXs+qYlx4OhRf02OD6
bhNaqahHE5CZ7djToFczmbl3duNbAq90/o3QNn50l3e1bcIQYrbKDpF9tkv1Hwxm
XnglnvVsh+DGl+nnzBmlUUqh3/oo5mV1HR4L//m2hpiBSGCZomyeu9x7I8Fqluh5
xnZobrMqQoK8adRvvplZVLphEhZ7yd4Ezfe3NsbAo+pN5Oym9k7FJ0DUpZQLdo5k
sctMElN4KoIC2C4QBfkWGZILw0gLrwWqTkD8wqIfSnYPWRPcqf3f6sM5jJCkc2YB
TZrcyna6eK98HQYtKegZ
=auSt
-----END PGP SIGNATURE-----

--------------enig3D1B5BF4A1575E49B5861BCF--
