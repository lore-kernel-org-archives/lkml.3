Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3KZOlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:41:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33023 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab3KZOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:41:01 -0500
Message-ID: <5294B2F6.5020006@ti.com>
Date: Tue, 26 Nov 2013 16:40:54 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sasha Levin <sasha.levin@oracle.com>, <plagnioj@jcrosoft.com>
CC: <gregkh@linuxfoundation.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: kyro: fix incorrect sizes when copying to userspace
References: <1384889136-15516-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1384889136-15516-1-git-send-email-sasha.levin@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="bT1B640AquPacLfehlCPT2Etrsq9d5HTa"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bT1B640AquPacLfehlCPT2Etrsq9d5HTa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2013-11-19 21:25, Sasha Levin wrote:
> kyro would copy u32s and specify sizeof(unsigned long) as the size to c=
opy.
>=20
> This would copy more data than intended and cause memory corruption and=
 might
> leak kernel memory.
>=20
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
> ---
>  drivers/video/kyro/fbdev.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
> index 50c8574..65041e1 100644
> --- a/drivers/video/kyro/fbdev.c
> +++ b/drivers/video/kyro/fbdev.c
> @@ -624,15 +624,15 @@ static int kyrofb_ioctl(struct fb_info *info,
>  			return -EINVAL;
>  		}
>  	case KYRO_IOCTL_UVSTRIDE:
> -		if (copy_to_user(argp, &deviceInfo.ulOverlayUVStride, sizeof(unsigne=
d long)))
> +		if (copy_to_user(argp, &deviceInfo.ulOverlayUVStride, sizeof(deviceI=
nfo.ulOverlayUVStride)))
>  			return -EFAULT;
>  		break;
>  	case KYRO_IOCTL_STRIDE:
> -		if (copy_to_user(argp, &deviceInfo.ulOverlayStride, sizeof(unsigned =
long)))
> +		if (copy_to_user(argp, &deviceInfo.ulOverlayStride, sizeof(deviceInf=
o.ulOverlayStride)))
>  			return -EFAULT;
>  		break;
>  	case KYRO_IOCTL_OVERLAY_OFFSET:
> -		if (copy_to_user(argp, &deviceInfo.ulOverlayOffset, sizeof(unsigned =
long)))
> +		if (copy_to_user(argp, &deviceInfo.ulOverlayOffset, sizeof(deviceInf=
o.ulOverlayOffset)))
>  			return -EFAULT;
>  		break;
>  	}
>=20

Thanks, applied for 3.13 fixes.

 Tomi



--bT1B640AquPacLfehlCPT2Etrsq9d5HTa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJSlLL2AAoJEPo9qoy8lh71rmIQAK805LMcDDUCawzRF0wy/2tR
tL/qKOVHixfjybqlXMjEKdU3Wg+Bn3r14I0iHugAY671w4pEYlX8e21l7QrDfmLp
X4Lh3HiYh6PabXo5uueCA66AXvPX9ZD16G6riT6QFJqxUUlL+xtBQ6js/o4mPyKu
Wj66YrYTHE306LnvS4iWx8PkwXsRNaHICEDXIUi3LXyAbOV+h74Cp9I609RlPTpM
WjZGaaQ8SPssTOTDEhLv8gF6LSm3PURQxjXIJVKhV5eVfbeCx2Qb+ha6Zxu9QCVw
q29sft6+BUaYY4NZdegkG5/645t0vuh/Z5Gsw78/q2Q3JIsmfiBnj38Yl6/sxfTF
/EXi5tbt2kdhRI5LQSEl0KrTf22XwQnFoIG5u4Gz1vp5ihRkbP2tWuyx3lbIrFKI
SNbPfm/QgQobGlf6VmCnp5mXt+eF5pEGeu9UOLi0HfjT7vrBInlqWAyrVFQv8hsR
j3yeHxedWkyyTj39csdJ3KgknUDxLm3FsO64t6HwDOK1wfF/VsxsLuprQfubP5in
GF+8RfMA02qYtz8pvP8TQx33eWYJkfzLQI4AwhoWZjSrEyAffDu/Mt14xtZ0NSYx
ktjAe7fArVxERF2jIsNCjc2ETI7noJO67180Zk4KoDZeYfhVIJ3SQ5uxE5Oqfzgj
IfUKPNpoa4uhNBjHjuyw
=OB8A
-----END PGP SIGNATURE-----

--bT1B640AquPacLfehlCPT2Etrsq9d5HTa--
