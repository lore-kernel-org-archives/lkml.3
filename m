Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932241Ab3HNJRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:17:52 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:55376 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3HNJRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:17:50 -0400
Date: Wed, 14 Aug 2013 11:17:45 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 21/29] pwm: simplify use of devm_ioremap_resource
Message-ID: <20130814091744.GB2084@ulmo>
References: <1376471493-22215-1-git-send-email-Julia.Lawall@lip6.fr>
 <1376471493-22215-22-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <1376471493-22215-22-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2013 at 11:11:25AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Remove unneeded error handling on the result of a call to
> platform_get_resource when the value is passed to devm_ioremap_resource.
>=20
> Move the call to platform_get_resource adjacent to the call to
> devm_ioremap_resource to make the connection between them more clear.
>=20
> A simplified version of the semantic patch that makes this change is as
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @@
> expression pdev,res,n,e,e1;
> expression ret !=3D 0;
> identifier l;
> @@
>=20
> - res =3D platform_get_resource(pdev, IORESOURCE_MEM, n);
>   ... when !=3D res
> - if (res =3D=3D NULL) { ... \(goto l;\|return ret;\) }
>   ... when !=3D res
> + res =3D platform_get_resource(pdev, IORESOURCE_MEM, n);
>   e =3D devm_ioremap_resource(e1, res);
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/pwm/pwm-lpc32xx.c     |    3 ---
>  drivers/pwm/pwm-renesas-tpu.c |    5 -----
>  drivers/pwm/pwm-spear.c       |    7 +------
>  3 files changed, 1 insertion(+), 14 deletions(-)

Applied, thanks.

Thierry

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC0s4AAoJEN0jrNd/PrOhOIAP+wWKMMSQVavp+/ZxjG76Qebk
670Z4g/5dduzZ7taGFeeCujt+tC0GOr4CClrK7S7LRD7vmsM88bbYkTsOWKs38J2
uGUKkjbYH724o5UXIy63elkgcA3lLMn0eUAI6CbOrqPtpkBVNV+tmDASH+18crrv
fa1LsLnQQHxg2m36HNzxqmZV4DjOzCytf1hJXTufRBkgFqqeZwnV58Qt8msasExR
QNrr0y9noBxjztGdC94fBJsBImIzJreHOhyEJbodmt2k4sK75d8DWlNm4Y6MA+oU
GZ6W50VoWAEbt3vllzHvxS5uThzmwhB3h9vh4z9qnS+rQJHv1TqvMyelSIlHfYQJ
i4CvQNGZmraZKCoYtjJuvlVcgQjyFcpSASzwtrEjRofuFH/DSQ2OPtau9y+5n3SM
MGH74N11YgYFrO8f745mNj/VUgVnIrxzIFzVhjtpDs3GHZD69P0bkFTUkDVBh2DV
VaZYn2QRnlTmBVNe4HlzXjltqlM53Cq92atKkRb0uzm2KUdq+S+T5xFlW+KGis2z
/UrNrBC3Cmn4ph8/G76IFZB1m10CrmM9O3s0jkIuTho49F4vfAmI9ynKQCP6L/l1
zW/1pFxXZQepwiVNTIcwOHKExauS0x3OZledTKQHpJyznNfeAIAKMsQp0b+q/78p
sE4u7qZlSk8VVZ+67LUE
=T9i3
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
