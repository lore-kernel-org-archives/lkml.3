Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaHYJo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 05:44:57 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34688 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaHYJoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 05:44:55 -0400
Date: Mon, 25 Aug 2014 11:44:52 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: josh@joshtriplett.org, kernel-janitors@vger.kernel.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/9] pwm: lpss: use c99 initializers in structures
Message-ID: <20140825094450.GC2399@ulmo>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr>
 <1408792831-25615-4-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2/5bycvrmDh4d1IB"
Content-Disposition: inline
In-Reply-To: <1408792831-25615-4-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2/5bycvrmDh4d1IB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 23, 2014 at 01:20:25PM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Use c99 initializers for structures.
>=20
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>=20
> // <smpl>
> @decl@
> identifier i1,fld;
> type T;
> field list[n] fs;
> @@
>=20
> struct i1 {
>  fs
>  T fld;
>  ...};
>=20
> @bad@
> identifier decl.i1,i2;
> expression e;
> initializer list[decl.n] is;
> @@
>=20
> struct i1 i2 =3D { is,
> + .fld =3D e
> - e
>  ,...};
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
> The patches in this series do not depend on each other.
>=20
>  drivers/pwm/pwm-lpss.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
> index 4df994f..441a046 100644
> --- a/drivers/pwm/pwm-lpss.c
> +++ b/drivers/pwm/pwm-lpss.c
> @@ -45,7 +45,7 @@ struct pwm_lpss_boardinfo {
> =20
>  /* BayTrail */
>  static const struct pwm_lpss_boardinfo byt_info =3D {
> -	25000000
> +	.clk_rate =3D 25000000
>  };
> =20
>  static inline struct pwm_lpss_chip *to_lpwm(struct pwm_chip *chip)

I've applied this patch to the for-next branch of the PWM tree. There
was a conflict due to a patch that was recently applied, but it was
trivial to fix it up, so I did.

Thanks,
Thierry

--2/5bycvrmDh4d1IB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT+wWSAAoJEN0jrNd/PrOhZpcP/0Fe4z6FfKJO3zjA0R9If1Ef
0BaphloBbqfcxWH14dd/YUW20WhtwttXvhUMIcLra9VWdDdrU+/HLL3OcgCmOxO7
LX56E0XcMBdxZPDqWKgTuaOZMgjbpvMSW1Xi0+LsaG7E0cY+ECBvy8Ga8P5iPXHY
dH2eDqUqI8i+Z+PSBUyZXRBkFTM+ySHlYl7u8iz7G1CHTkbqJEzWIJE2pg2qLA0m
edWVTDKuxNoVep4mAA1HazNLMKNZ2/Vq2TTx5DVhjWsNStykctzwB/XTE6phpSPm
NqDqGqnmj3bYq76dNH60TBH+BwmSztPIDHdFT4X5E9WsM17QlMWqXfxdYh3osjdr
YMrjLOvFKUozbYUyFn2M/BWT3RsQvbrfOCsNAvbGoYjvfYGMlkr2+eNdD0og48g/
JX62GAamC0wLPLjPnrn6OU+nF18NIEOPQTDl/41NNwfYJ7LdZjhasKmSpWOH1ojE
WJFT0XBK8ZTaWSp83MYmIZokevx9qa/q5P3RNPSOGKZVqt6Nz1BZNPDYj56sHfrr
ZnzrB/3w4dd3D8YjCjkqkRZ082A+Dd18aHXwKicWe/57FK0vvfI1ouEZDk0MrhRB
0m49Ehil/Oym/dI2O7nS0155QgUmdKHnOY1RsRGkPvNVC0D3JMki+PIWKnxV9Pxf
ufJdAf/ZQ9WL21bMksuR
=H9WT
-----END PGP SIGNATURE-----

--2/5bycvrmDh4d1IB--
