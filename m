Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbaHZKGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:06:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34434 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934722AbaHZKFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:05:17 -0400
Message-ID: <53FC5BD2.9010504@ti.com>
Date: Tue, 26 Aug 2014 13:05:06 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
CC: <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers: video: fbdev: atmel_lcdfb.c: fix error return
 code
References: <1407355938-10932-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1407355938-10932-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="l2S1fpfPIcjfpBNKcE3GKl2p2IpFlW26w"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--l2S1fpfPIcjfpBNKcE3GKl2p2IpFlW26w
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/08/14 23:12, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Convert a zero return value on error to a negative one, as returned
> elsewhere in the function.
>=20
> A simplified version of the semantic match that finds this problem is a=
s
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret !=3D 0\))
>  { ... return ret; }
> |
> ret@p1 =3D 0
> )
> ... when !=3D ret =3D e1
>     when !=3D &ret
> *if(...)
> {
>   ... when !=3D ret =3D e2
>       when forall
>  return ret;
> }
>=20
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
> The error codes chosen are the ones that are commonly used elsewhere or=

> these functions.  Perhaps something else is wanted.
>=20
>  drivers/video/fbdev/atmel_lcdfb.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/at=
mel_lcdfb.c
> index 92640d4..1d8bdb9 100644
> --- a/drivers/video/fbdev/atmel_lcdfb.c
> +++ b/drivers/video/fbdev/atmel_lcdfb.c
> @@ -1102,12 +1102,14 @@ static int atmel_lcdfb_of_init(struct atmel_lcd=
fb_info *sinfo)
>  	timings =3D of_get_display_timings(display_np);
>  	if (!timings) {
>  		dev_err(dev, "failed to get display timings\n");
> +		ret =3D -EINVAL;
>  		goto put_display_node;
>  	}
> =20
>  	timings_np =3D of_find_node_by_name(display_np, "display-timings");
>  	if (!timings_np) {
>  		dev_err(dev, "failed to find display-timings node\n");
> +		ret =3D -ENODEV;
>  		goto put_display_node;
>  	}
> =20
>=20

Thanks, queued for 3.17 fbdev fixes.

 Tomi



--l2S1fpfPIcjfpBNKcE3GKl2p2IpFlW26w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/FvSAAoJEPo9qoy8lh71+6YQAIj9XZAZSXAWssvH/txMAAP3
AbHih3AUdtoI6dCcFCR732zWPSxIIOz8IeC9BhkDkkamX1ZO8IyuU9YWxj+15Xko
ovqr1vX8/+fAumYyu7kpMHnSz9ivto/TVJiKvBuaQdgy1tlqJSYqevv9K7IJpoNz
U+yrVt8ASKG23LB5LVGmHgALoNNx8TDbn4eWs7hn9ONneKmv1lhVMgvE73u24hrv
Vjttc9Bnf/2FQ0WtUa8emylWtlltMQHP/d5iycjgNyoTLvdmP5g1DT5gOBcpCpA4
lpRIUWR1REc08i3g/21zNiXTOKdKYERPzgMkk7pH1tBb2UbizZ+dHU6SoOTgOPJq
EK5VWpl14rm5RfzncEf7yOvItPb7G01le/s4B0h/sfrFaqAW+z0Pai5kqkIHMHsc
q3kvWhJFW+k5x/W6bJGD6eWUN/kRkRrOsTCIoUDl0KGm59Qnj4nRvpqsfqLFuGsp
9a7fjze9N+fPQKe42LdE/nXYM6qUcO0dY91zorMWXKl8F5uUzx/KNKkI9y0uxOvF
0M9Fz8MWxUJbTsVo7muhFg9F9jv6sEZ/gOSjRB1AlL53g6pS3+/kNPJ1hDlE3KlN
9Qp2SSV/NCzqcmNc36rzgxiEI7D4bfJZE9eBX1/uxCv0Fnpu3cNi1uE7irSBZVRN
9ByBMA2mVmTXXOo+AzSR
=bkgu
-----END PGP SIGNATURE-----

--l2S1fpfPIcjfpBNKcE3GKl2p2IpFlW26w--
