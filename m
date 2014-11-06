Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaKFOXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 09:23:09 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49581 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127AbaKFOXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 09:23:00 -0500
Message-ID: <545B8438.1040100@ti.com>
Date: Thu, 6 Nov 2014 16:22:48 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] m501fb: don't return zero on failure path in sm501fb_probe()
References: <1414795247-14686-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1414795247-14686-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="2TfT7l2iXFNMCa7BKH7tKSmLMKsxWVmq0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2TfT7l2iXFNMCa7BKH7tKSmLMKsxWVmq0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 01/11/14 00:40, Alexey Khoroshilov wrote:
> If no framebuffers found, sm501fb_probe() breaks off initialization,
> deallocates sm501fb_info, but returns zero. As a result, use after free=

> can happen in sm501fb_remove().
>=20
> The patch adds -ENODEV as a return value in this case.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).
>=20
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/video/fbdev/sm501fb.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/video/fbdev/sm501fb.c b/drivers/video/fbdev/sm501f=
b.c
> index 9e74e8fbe074..8b98b011fc04 100644
> --- a/drivers/video/fbdev/sm501fb.c
> +++ b/drivers/video/fbdev/sm501fb.c
> @@ -1988,6 +1988,7 @@ static int sm501fb_probe(struct platform_device *=
pdev)
>  	if (info->fb[HEAD_PANEL] =3D=3D NULL &&
>  	    info->fb[HEAD_CRT] =3D=3D NULL) {
>  		dev_err(dev, "no framebuffers found\n");
> +		ret =3D -ENODEV;
>  		goto err_alloc;
>  	}
> =20
>=20

Thanks, queued for 3.19.

 Tomi



--2TfT7l2iXFNMCa7BKH7tKSmLMKsxWVmq0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW4Q4AAoJEPo9qoy8lh714B4P/iELhDqNc+pIAaCzPVlTmEZy
Wlqod20MmeDJsfqy6IQvLNt4kQDC2qP3vpp5SU8xBg3HvsCdDTLH9Tnjoevo8Bu7
rfctqAByIPHwUpwuepH73zuBkkkC8RWovg680eGmXs6ve8KPIap88DcjnrVfJ2z4
8b2oSDhAwHcgV0/aQBKNCxobNFTT1Ln4o0LfHUomZOIpP/l0H2gvTdnoPIlM1vh4
OOPZ6YeE16rVNa2WoQajeXIoY735/qCCrVrmnwOiE/Ong6ujhRwuwluh2yEtyX5j
AwxBnE+31IAXMiQvCrae87/EUFQl9PAmdliLRZF/hOlTONyUAtzhwSFASZMI7ByI
QS8V72CN1v1/6w0pLcvHz+cvIRAm/tjEWsj3QMOsXl8vemBZYYeFNMH2TOoR1kJ/
eS3cX90DopnjhAVjCe8KQ1AoY7dlLAf4tcv0J4zzhrj7ycB8+pFrA5eaMx/zszzi
kv5ZmmBPuvuixwxMHLkc0lpAHoPG1alo/vEyvBk4CkhH+tjD791SnCDqIMOVd+6g
Y+qF1SvnyABthf9AJ6EdkBZV2UzaKYXIKqBjCP4vFE5mfIcDdqrNNP0BoEYaAd1E
AJotTzSVMVpHxRz5EC8EscKg+iARgvWc4EwzokCAV+lAbjB10QolS6GHfvx+atvX
FtbQAnAzliRnP8XZh+Jt
=qKma
-----END PGP SIGNATURE-----

--2TfT7l2iXFNMCa7BKH7tKSmLMKsxWVmq0--
