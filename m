Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaI3KBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:01:11 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48871 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaI3KBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:01:09 -0400
Message-ID: <542A7F5C.8030200@ti.com>
Date: Tue, 30 Sep 2014 13:01:00 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: fbdev: sis: sis_main.c:  Cleaning up missing null-terminate
 in conjunction with strncpy
References: <1410716148-16243-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1410716148-16243-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="h5Op2XSvhKoobEP3hkRgQmlFPsi9f1QFH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--h5Op2XSvhKoobEP3hkRgQmlFPsi9f1QFH
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 14/09/14 20:35, Rickard Strandqvist wrote:
> Replacing strncpy with strlcpy to avoid strings that lacks null termina=
te.
>=20
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital=
=2Ese>
> ---
>  drivers/video/fbdev/sis/sis_main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/s=
is/sis_main.c
> index 3f12a2d..1f4c216 100644
> --- a/drivers/video/fbdev/sis/sis_main.c
> +++ b/drivers/video/fbdev/sis/sis_main.c
> @@ -5830,7 +5830,7 @@ static int sisfb_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *ent)
>  			ivideo->cardnumber++;
>  	}
> =20
> -	strncpy(ivideo->myid, chipinfo->chip_name, 30);
> +	strlcpy(ivideo->myid, chipinfo->chip_name, sizeof(ivideo->myid));
> =20
>  	ivideo->warncount =3D 0;
>  	ivideo->chip_id =3D pdev->device;
>=20

Thanks, queued for 3.18.

 Tomi



--h5Op2XSvhKoobEP3hkRgQmlFPsi9f1QFH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKn9cAAoJEPo9qoy8lh71m6cQAK4+zzcHnKTdSCQXfVjryIZf
b2P8A26pdQQkzJXDhiUG8XzKLYrRYIoxons/L7SaY/upep5RaDpMfqL/rjMyhVbJ
kydxmqrMVXDzIjK8UVisH7MNrYP5xcIYCiEKU5Hr0mHvYpDiPGXerfoJCEX4oZmn
cGwVO/ohv8bF+OV4hbJVgkbE2jSsHb9YGcLm06Pkl1myHNy+qVMBCu1nt7q+05RP
Na05zxgJFbw77sWoRF0+vQikABErqBv4sJ7wY2y4oeCUvAQS6Un/r6QAtBUXmfgX
UMgMUmfw9krfeAvBhZrt4RqRYCl6edB5AdJo057s+N3/GQNZZyMv3kEaTh7PFumy
pvKGGfh+IOf3LQKUS44of0LsAvgg/GjrAkkE5uPSQ2M55bcJvSjpJBrCLuNQAZER
26gFBVWCoNk/lg/y17NJnGshdD9M6xuo1Dyqmy+BGuFuUHU4kkLRehTek7rG+AjY
JoVcrEr/edjDUoOKQLaU7Kd6ScCVtET+RVQ9020olkVPv5VlSluB3hGk/XUvqEmV
5jlBykZEGlvj8/IG1W/JniE96xLQcjRWSq6VlCRogVGwRQrN1tIBv7zL6K0fLovK
6WN6GwH9tUIb8oOhgJRlYS5cvsiN/zqUdgX4Z1jHDdOlaBWu3P8H41MthZh/Q0mi
O9tMSbbHX+cqhDR3p8Bx
=wJD+
-----END PGP SIGNATURE-----

--h5Op2XSvhKoobEP3hkRgQmlFPsi9f1QFH--
