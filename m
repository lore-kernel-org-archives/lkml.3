Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab3JHGgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 02:36:33 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:28079 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752579Ab3JHGga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 02:36:30 -0400
X-Greylist: delayed 577 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Oct 2013 02:36:30 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiIQAESlU1JbdWOb/2dsb2JhbABZgweEMrV3GYdqgR8WdIIlAQEBAwEBAiBWBQsLGCoCAigvBhOIAAqof5Isj0EHgmqBOQOVNo0Ih0ODJjo
X-IPAS-Result: AiIQAESlU1JbdWOb/2dsb2JhbABZgweEMrV3GYdqgR8WdIIlAQEBAwEBAiBWBQsLGCoCAigvBhOIAAqof5Isj0EHgmqBOQOVNo0Ih0ODJjo
X-IronPort-AV: E=Sophos;i="4.90,1055,1371074400"; 
   d="asc'?scan'208";a="100065231"
Message-ID: <1381213600.27795.7.camel@fourier>
Subject: Re: [PATCH 2/8] ipack: convert bus code to use dev_groups
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        industrypack-devel@lists.sourceforge.net
Date: Tue, 08 Oct 2013 08:26:40 +0200
In-Reply-To: <1381195662-28009-3-git-send-email-gregkh@linuxfoundation.org>
References: <1381195662-28009-1-git-send-email-gregkh@linuxfoundation.org>
	 <1381195662-28009-3-git-send-email-gregkh@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-deN2QCTMMHUnYQF70am5"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-deN2QCTMMHUnYQF70am5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On lun, 2013-10-07 at 18:27 -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct bus_type is going away soon, dev_groups
> should be used instead.  This converts the ipack bus code to use the
> correct field.
>=20
> Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
> Cc: Jens Taprogge <jens.taprogge@taprogge.org>
> Cc: <industrypack-devel@lists.sourceforge.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>=20
> Samuel and Jens, I can take this through my driver-core tree if you
> don't want to take it through yours, just let me know what works best
> for you.
>=20

OK, you can take it through your driver-core tree.

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

>  drivers/ipack/ipack.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
> index 6e066c5..d0016ba 100644
> --- a/drivers/ipack/ipack.c
> +++ b/drivers/ipack/ipack.c
> @@ -180,20 +180,28 @@ static ssize_t modalias_show(struct device *dev, st=
ruct device_attribute *attr,
> =20
>  ipack_device_attr(id_format, "0x%hhu\n");
> =20
> -static struct device_attribute ipack_dev_attrs[] =3D {
> -	__ATTR_RO(id),
> -	__ATTR_RO(id_device),
> -	__ATTR_RO(id_format),
> -	__ATTR_RO(id_vendor),
> -	__ATTR_RO(modalias),
> +static DEVICE_ATTR_RO(id);
> +static DEVICE_ATTR_RO(id_device);
> +static DEVICE_ATTR_RO(id_format);
> +static DEVICE_ATTR_RO(id_vendor);
> +static DEVICE_ATTR_RO(modalias);
> +
> +static struct attribute *ipack_attrs[] =3D {
> +	&dev_attr_id.attr,
> +	&dev_attr_id_device.attr,
> +	&dev_attr_id_format.attr,
> +	&dev_attr_id_vendor.attr,
> +	&dev_attr_modalias.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(ipack);
> =20
>  static struct bus_type ipack_bus_type =3D {
>  	.name      =3D "ipack",
>  	.probe     =3D ipack_bus_probe,
>  	.match     =3D ipack_bus_match,
>  	.remove    =3D ipack_bus_remove,
> -	.dev_attrs =3D ipack_dev_attrs,
> +	.dev_groups =3D ipack_groups,
>  	.uevent	   =3D ipack_uevent,
>  };
> =20

Thanks,

Sam

--=-deN2QCTMMHUnYQF70am5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJSU6WgAAoJEH/0ujLxfcNDoPQP/10DTiIUfPN93jKQ90Hj7VdG
YFExmpux/QhB0OJcDZtzJsIQwfrTvSwaWz9HiB+hEzqp0R6J9E8d7mUquHRCCGVc
cCixCqSb5rd1ScGc/9h8/9GJ799VoGqcJ0D5cxCHIpU+V4GHBDVvaW4Vh0j1jWD3
9Sl1QUPF/n0z0Y/FpRomAuGRaCmv+ID1jQISOisD26O9KajgLJGqF1wTPcWxxStc
UE8GhjrmpwEhT+YeZa1lAyj6J2h8Tvmt7NloyoHPVV5zlApUf1T5o0XLyaE1qtRA
r9XFdEjPW2lWrc6nRbUaBDGR+OMif3cbvNBoW5hMp3MsJy0AYNzbhWWUFJKVE2xd
fOw71YZLOKlFtRja+zRxcgwd+7EsB0D4AihQADJ0vir7QEEPpYOqVR82IGtPqAIa
X7E0V/lXftKm59Ujy6MHIcJbgzGHNt3Ue4nHU6ft8BIh0cudfjKTur0eNaFNH9X5
ZIZoMB2aVmQmmCJK+C8B9mgelvUO/IUbTdLG60t6ZWaUr13cSj6bT+gidBAycWoU
8jxxDvrZXkuRkT67xy+Q1w5EveScmi5QnJTtFeSpTA1GqyYLvDI+p6cxLnT3nA2C
ACHqkHxzXvN9/ICjqhM0JmxSyMjngCZ7DoocWBufr/p/7YT5CipWPxkwkifp20Vc
xsySs0cQYwHMTu2A/t3P
=lQkP
-----END PGP SIGNATURE-----

--=-deN2QCTMMHUnYQF70am5--

