Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaKCQkM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:40:12 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:59102 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbaKCQkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:40:09 -0500
Date: Mon, 3 Nov 2014 10:39:36 -0600
From: Felipe Balbi <balbi@TI.COM>
To: Felipe Balbi <balbi@TI.COM>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>, <nsekhar@TI.COM>,
        <grant.likely@linaro.org>, George Cherian <george.cherian@TI.COM>
Subject: Re: [PATCH 4/4] extcon: gpio: Add support for using cable names
Message-ID: <20141103163936.GO27425@saruman>
Reply-To: <balbi@TI.COM>
References: <1415032350-8459-1-git-send-email-balbi@ti.com>
 <1415032350-8459-5-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="da9oBGf5DLtF9ehv"
Content-Disposition: inline
In-Reply-To: <1415032350-8459-5-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--da9oBGf5DLtF9ehv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 03, 2014 at 10:32:30AM -0600, Felipe Balbi wrote:
> From: George Cherian <george.cherian@ti.com>
>=20
> Add support for using cable names. Enables other drivers to register inte=
rest
> and get notified using extcon provided notifier call backs.
>=20
> Signed-off-by: George Cherian <george.cherian@ti.com>
> Signed-off-by: Sekhar Nori <nsekhar@ti.com>

Signed-off-by: Felipe Balbi <balbi@ti.com>

> ---
>  Documentation/devicetree/bindings/extcon/extcon-gpio.txt | 2 ++
>  drivers/extcon/extcon-gpio.c                             | 4 ++++
>  2 files changed, 6 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt b/D=
ocumentation/devicetree/bindings/extcon/extcon-gpio.txt
> index 5fe6846..f19aeb4 100644
> --- a/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> +++ b/Documentation/devicetree/bindings/extcon/extcon-gpio.txt
> @@ -7,6 +7,7 @@ Required Properties:
>   - compatible: should be:
>     * "linux,extcon-gpio"
>   - gpios: specifies the gpio pin used.
> + - cable-name: Name of the cable used.
> =20
>  Optional Properties:
>   - debounce: Debounce time for GPIO IRQ in ms
> @@ -18,4 +19,5 @@ Eg:
>  		compatible =3D "linux,extcon-gpio";
>  		gpios =3D <&gpio3 12 GPIO_ACTIVE_HIGH>;
>  		debounce =3D <20>;
> +		cable-name =3D "USB-HOST";
>  	};
> diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
> index 7191d28..cbe35af 100644
> --- a/drivers/extcon/extcon-gpio.c
> +++ b/drivers/extcon/extcon-gpio.c
> @@ -42,6 +42,7 @@ struct gpio_extcon_data {
>  	struct delayed_work work;
>  	unsigned long debounce_jiffies;
>  	bool check_on_resume;
> +	const char *cable_name[1];
>  };
> =20
>  static void gpio_extcon_work(struct work_struct *work)
> @@ -112,6 +113,9 @@ static int gpio_extcon_probe(struct platform_device *=
pdev)
>  		of_property_read_u32(np, "debounce", &debounce);
>  		irq =3D gpiod_to_irq(extcon_data->gpiod);
>  		irq_flags =3D irq_get_trigger_type(irq);
> +		of_property_read_string_index(np, "cable-name", 0,
> +					      extcon_data->cable_name);
> +		extcon_data->edev->supported_cable =3D extcon_data->cable_name;
>  	} else {
>  		if (!pdata)
>  			return -EBUSY;
> --=20
> 2.1.0.GIT
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--da9oBGf5DLtF9ehv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUV6/IAAoJEIaOsuA1yqRExQsP/jJZzqn3jEF83alziM5V2qGr
tJEEq3oHlFgm6goPX4A+T9sEE7tj0L9N6UWD0dpj0ik87NsmWGmT9QIyLte9W9xE
Ep0RFqmveLigNqDNhY2OfB9BgmQGxBkIMDDlS9x39FV5kVugOc0cCTifpXU4deZ3
DMMq3x1pKVZqHT332lRDCK8ZYVxpGMJee8dWfUA4rL0Vne1X6KZ+jS1vKjCAEpCz
G2R6Yc0K3BIoLVvnRt/UJAsjDCMNLLBJHGoB5cwwJpGC7tefKNWBMi+TVU3uSolN
bkebLA6YT+dqg4ErOgUt92UzJTMITEwzPPQoqxsRRL+rfCvkPVn+A/4rUIBtEwZm
c+o3mhOaC1E1BWzFHqcSjxa3ce43SaWaOEecGTMMNYtSGlYz99C/57OVdwCwb/PZ
hm3aF2PuRSYIUJWA6J9OR+xM7u/wTyIbV1fDu/DzbfpRFQlHcnlLcQQEpNn41jyh
/79dp8bry/gznD+viKSAucZMUkWu95Xis6dzAkT0XgtCdrynmjnVBI1Gi4RDuFSZ
XBQQnFDUrWCTzbD0ioJKAeMF+7fxuxerRhoLK2renjqGSsxWkOWp0KKZ6Vr/4WvR
BCCDbZ+NwzIAnRzhHgoa+5RrQT8LX9+yACa+pJ18zDhqOyxXu05AVOMuDh+yFUyq
IyuXRwyhg8D+h4VJLdDO
=JYLr
-----END PGP SIGNATURE-----

--da9oBGf5DLtF9ehv--
