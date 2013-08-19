Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab3HSTqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:46:11 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:51037 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab3HSTqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:46:09 -0400
Date: Mon, 19 Aug 2013 21:46:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND] i2c: move of helpers into the core
Message-ID: <20130819194603.GC4961@mithrandir>
References: <1376918361-7014-1-git-send-email-wsa@the-dreams.de>
 <1376935183-11218-1-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Content-Disposition: inline
In-Reply-To: <1376935183-11218-1-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 19, 2013 at 07:59:40PM +0200, Wolfram Sang wrote:
[...]
> diff --git a/drivers/i2c/i2c-core.c b/drivers/i2c/i2c-core.c
[...]
> +#if IS_ENABLED(CONFIG_OF)
> +static void of_i2c_register_devices(struct i2c_adapter *adap)
> +{
[...]
> +}
[...]
> +#endif /* CONFIG_OF */

Isn't this missing the dummy implementation for !OF.

>  static int i2c_do_add_adapter(struct i2c_driver *driver,
>  			      struct i2c_adapter *adap)
>  {
> @@ -1058,6 +1160,8 @@ static int i2c_register_adapter(struct i2c_adapter =
*adap)
> =20
>  exit_recovery:
>  	/* create pre-declared device nodes */
> +	of_i2c_register_devices(adap);

Alternatively you could remove the of_i2c_register_devices() from the
"#ifdef CONFIG_OF" block so that it will always be compiled. You could
turn the above into

	if (IS_ENABLED(CONFIG_OF))
		of_i2c_register_devices(adap);

and let the compiler throw the static function away if it sees that the
condition is always false.

Thierry

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEnX7AAoJEN0jrNd/PrOhtxEP/2Ulur33dk711CAHb3j6OaCw
JZ633M09rA84w4ngGfFM/2IfZFUBeqoyQ7wDnrtW7N89A+COpTqCAOpqo1LQ4WdU
aehQXm1JyGXPiKb9hvgNXfL9Xz5U1VALvivFJs4kroXVIUlceGmoBZ/ywXYp8SH3
0C9ClEkxCyvzaIBVmuwDVYZrr42pQduXnbTa/AwwIDlYcUfhELm8a3vfxteP3d9d
pjrqsxmhTgGHoVp2EvGKXacaf2ISiwMe/FUK1dSrbRf69TU9KTVnUh8eIPlBCJ8s
bjolz/LfRakgSmQpnzru+3apNnpkPOqApQhWd15E2o2ZUM0XRQx1ratt+meZEbbZ
GWZj4jPeXWSDWkxtQwFgtPlltyMzJ11AvMxpgs93hjNmdDsjH5uPbrC5Cvz2S2MC
UB5QOBMRb+DcdQhb72cg4GSiSv08loIFwRQb3lPuDQe2CzbcinHvTUANlzQXKmnF
R8ZZ2UL1akR3zULh7CmzvQzNHplLOuS4T/J1gu9V7EhOJs2I7xWcoHqCVsqhfIk7
MGSyYf7te7elOJKNomD/v22ojmbcmPapAf1yn1GBr74mk2t8SdH/QszRMem27oh5
iL1yw/CIktcr6/EhOlQjIePBum4yQNAxnbtfbFc9ZBkLpR9YsDOw/CE7gEDQargW
H56h2el3+6kiSlao+UmT
=ukb7
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
