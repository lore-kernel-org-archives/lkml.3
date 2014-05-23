Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaEWKuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:50:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38680 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaEWKuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:50:09 -0400
Message-ID: <537F27D2.40301@ti.com>
Date: Fri, 23 May 2014 13:49:54 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH] video: fbdev: grvga.c:  Fix for possible null pointer
 dereference
References: <1400621759-7814-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400621759-7814-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="KDO98ILTmGgpurB4dIgi2BWd350aPX4PK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KDO98ILTmGgpurB4dIgi2BWd350aPX4PK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 21/05/14 00:35, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
>=20
> Was largely found by using a static code analysis program called cppche=
ck.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital=
=2Ese>
> ---
>  drivers/video/fbdev/grvga.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/grvga.c b/drivers/video/fbdev/grvga.c
> index c078701..2db5bb1 100644
> --- a/drivers/video/fbdev/grvga.c
> +++ b/drivers/video/fbdev/grvga.c
> @@ -514,9 +514,10 @@ free_fb:
>  static int grvga_remove(struct platform_device *device)
>  {
>  	struct fb_info *info =3D dev_get_drvdata(&device->dev);
> -	struct grvga_par *par =3D info->par;
> +	struct grvga_par *par;
> =20
>  	if (info) {
> +		par =3D info->par;
>  		unregister_framebuffer(info);
>  		fb_dealloc_cmap(&info->cmap);
> =20

Thanks, queued this and the next one (video: fbdev: s3fb.c:  Fix for
possible null pointer dereference) for 3.16.

 Tomi




--KDO98ILTmGgpurB4dIgi2BWd350aPX4PK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTfyfSAAoJEPo9qoy8lh71MbMP+wZ+61e+QEhGJyWC/YMnIfIj
xUvIxB7QtDLaMMebfj1PY0v9A1rEc+WTOKodxBL/2lulsFMlje50lwHnDHAem7mY
frmkEt3CK+r2F6Sf1ZG6q6cHhEEXMjMl1rmvp8U1FkgYmvqr7oM6OfZeSmHxSAz5
W1ykKoYMJZFhyJZ7QBlenzZIpJT09iiSTWM0PU2a+ywzUpapb3aUXgPoX04MCHPQ
bXIpm8BTaXdRXbhgbbZUmouhf90k/YHs4iQ/yFIBR68dYyJXNekmEHAE+3Dg50bC
KjhnNJIT1Pf0kXn0NM/fawjJcFHKc2KWLYNJG/jDKJM+Lww7PuYBaFRQuc9iB5xN
Bp8lQo7sHlJNgnNqw9jwhjTfAKSINEMzGdDTRUuU+UmwZf8NCH+kGuxXyZH7yqoa
12/vHJK4TpkcQ86v9lJBcmaSLUXJiApbnLO3l0r2laDyl+jjuRbf/R39vjqBBuc8
+Ry17Oa9bZxm4ZwTBxpI7JtG8GMMJlQGKIdZntOtfJ01YIBAvjXtyWtG17MZWl9E
rAnqeR7nsrcHbtTcdr8yDA1aLqQ8sFtN+UzwSbxI2uC7INKwR5Z8N/LDU/qYJ3Xh
uJ+EJ+ouM1KFgDU7MO/hbDZsqD8sUqkDkBk/zgjv4ngNl0J/CFdd8PgvxYPa0KPv
IDLLbOPLlcJnzKXhPsma
=Vz5T
-----END PGP SIGNATURE-----

--KDO98ILTmGgpurB4dIgi2BWd350aPX4PK--
