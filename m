Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaFWLq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:46:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53535 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbaFWLqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:46:54 -0400
Message-ID: <53A81398.4030100@ti.com>
Date: Mon, 23 Jun 2014 14:46:32 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Welling <mwelling@ieee.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers:video:fbdev atmel_lcdfb.c power GPIO registration
 bug
References: <1403142732-31706-1-git-send-email-mwelling@ieee.org>
In-Reply-To: <1403142732-31706-1-git-send-email-mwelling@ieee.org>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="RS7U0BI5efxIff3b6nTWXHKLa4RlH6tpj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RS7U0BI5efxIff3b6nTWXHKLa4RlH6tpj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 19/06/14 04:52, Michael Welling wrote:
> A list that was intended for storing power control GPIOs was never
> initialized correctly or filled. Without these lines of added code
> the kernel hangs when trying to access an uninitialized list when a
> power control GPIO is registered with the device tree.
>=20
> Signed-off-by: Michael Welling <mwelling@ieee.org>
> ---
>  drivers/video/fbdev/atmel_lcdfb.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/video/fbdev/atmel_lcdfb.c b/drivers/video/fbdev/at=
mel_lcdfb.c
> index e683b6e..d36e830 100644
> --- a/drivers/video/fbdev/atmel_lcdfb.c
> +++ b/drivers/video/fbdev/atmel_lcdfb.c
> @@ -1057,6 +1057,7 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb=
_info *sinfo)
>  		goto put_display_node;
>  	}
> =20
> +	INIT_LIST_HEAD(&pdata->pwr_gpios);
>  	ret =3D -ENOMEM;
>  	for (i =3D 0; i < of_gpio_named_count(display_np, "atmel,power-contro=
l-gpio"); i++) {
>  		gpio =3D of_get_named_gpio_flags(display_np, "atmel,power-control-gp=
io",
> @@ -1082,6 +1083,7 @@ static int atmel_lcdfb_of_init(struct atmel_lcdfb=
_info *sinfo)
>  			dev_err(dev, "set direction output gpio %d failed\n", gpio);
>  			goto put_display_node;
>  		}
> +		list_add(&og->list, &pdata->pwr_gpios);
>  	}
> =20
>  	if (is_gpio_power)
>=20

Thanks, queued for 3.16-fixes.

 Tomi



--RS7U0BI5efxIff3b6nTWXHKLa4RlH6tpj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqBOYAAoJEPo9qoy8lh7124EQAJsRBgnSJUDnOd0zFXeAlQZF
OeJt4Cw5vCvxLBDvPWjLUA8AdA6FjDt/zmSPjQeAadybXbvdE6JBM/xgHb4OB6FF
bVH1VE/S2u94m5bBRQ2nbcROQBXegPBzLew/kiPLAbij3T8PTnT1zPNQNNHIpksB
dFF520sJnJ8UZxS6MBidV2C1HcGM5eZWmnW3BOHJ/1jSoOdP02pHJoSJ+PCZs2ap
KVIC21NPHbuWSApFACu/zU86+x8fMrztap365sKCveFRoiZ7RkmgRjmb8qrOUaPL
Ndug7KlFQrm9HAvyCLUXXfINN6/jyBZv8bVD97wSEfZ6mUodm87xtpcL9b9mHZ6I
YlCdiEAofuhCcUfjoLNSO9CNDkaVLntZDie705wbwwjK4TEFLrQ1ovWUiAejNTf3
EixfqRRZzq/6TbYZkY3UEKLXDtyVGWUUc3c/k4MQXis5QS7ZMbKvEGF5FFkPfHaD
gwUM5mj1BrsMJapbr8vBQY3GVMGplvX8i4USMFzefGJrEAi+O4Y2cSvy6DCfaL3C
sdQlsQzkFblBuWsPBVupmpZxuP9WWp+KPwPWTPWiTc4ZUOyER9RRaZsbqC1kp9nh
gDkwDJyb+xmFrMy1/AMIM7mPWZ2uHmcWJ3qx62y7ufU5+64bW+iriMe7z9Qc41bB
lUAURsEeQZGn88yBubh0
=XN21
-----END PGP SIGNATURE-----

--RS7U0BI5efxIff3b6nTWXHKLa4RlH6tpj--
