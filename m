Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926AbaKHSCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:02:09 -0500
Received: from sauhun.de ([89.238.76.85]:36973 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaKHSCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:02:07 -0500
Date: Sat, 8 Nov 2014 19:03:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: ludovic.desroches@atmel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        khilman@kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 3/3] i2c/at91: adopt pinctrl support
Message-ID: <20141108180314.GD4900@katana>
References: <1414133417-11530-1-git-send-email-wenyou.yang@atmel.com>
 <1414133417-11530-4-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Content-Disposition: inline
In-Reply-To: <1414133417-11530-4-git-send-email-wenyou.yang@atmel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 02:50:17PM +0800, Wenyou Yang wrote:
> Amend the i2c at91 pin controller to optionally take a pin control
> handle and set the state of the pins to:
>=20
> - "default" on boot, resume and before performing an transfer
> - "sleep" on suspend()
>=20
> This should make it possible to optimize energy usage for the pins
> both for the suspend/resume cycle
>=20
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> ---
>  drivers/i2c/busses/i2c-at91.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 6a84a2a..290caf1 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -32,6 +32,7 @@
>  #include <linux/slab.h>
>  #include <linux/platform_data/dma-atmel.h>
>  #include <linux/pm_runtime.h>
> +#include <linux/pinctrl/consumer.h>
> =20
>  #define DEFAULT_TWI_CLK_HZ		100000		/* max 400 Kbits/s */
>  #define AT91_I2C_TIMEOUT	msecs_to_jiffies(100)	/* transfer timeout */
> @@ -747,6 +748,8 @@ static int at91_twi_probe(struct platform_device *pde=
v)
>  	u32 phy_addr;
>  	u32 bus_clk_rate;
> =20
> +	pinctrl_pm_select_default_state(&pdev->dev);
> +

Do we really need this in probe? Isn't that default? I'm not sure,
though...

>  	dev =3D devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_KERNEL);
>  	if (!dev)
>  		return -ENOMEM;
> @@ -851,6 +854,8 @@ static int at91_twi_runtime_suspend(struct device *de=
v)
> =20
>  	clk_disable_unprepare(twi_dev->clk);
> =20
> +	pinctrl_pm_select_sleep_state(dev);
> +
>  	return 0;
>  }
> =20
> @@ -858,6 +863,8 @@ static int at91_twi_runtime_resume(struct device *dev)
>  {
>  	struct at91_twi_dev *twi_dev =3D dev_get_drvdata(dev);
> =20
> +	pinctrl_pm_select_default_state(dev);
> +
>  	return clk_prepare_enable(twi_dev->clk);
>  }
> =20
> --=20
> 1.7.9.5
>=20

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXlriAAoJEBQN5MwUoCm22ScP/3TRXAjMaeWrJrjzJElUvBVd
Gzlqe0zD1CAS4Bz0w56Q/mGs0XfoW7n/J1GI2gHBB2kvVtdJJJPIM40y8IO5qAU2
2+o55WvdeE+eYjqrlEHDXbm01qnueRhJlf5da1twAvQXTHox1hYIFugeJN45jjVD
q5yIKj4EHn0nEd638XrLKNZdmF1XhMDabjM81QINFbmncU7FVTAoh2kwhQMREE1s
n3Id83oIP+iaff9wu4Aun+trSk44GkKxOBQuLZYi7Q6xauhFoB3xQAUF1mDFIfsG
7zbSn9P/bj4XxZ6bJ39DQ8wgoqeWRoxFJn9Duhx74lPvIMRwg/Z93COVuFrNVI50
2dWzbScGbvJSwtUyUcv+mSpFopdur/OhNVHSU9l8NBRHPU8gXnDkoMVO7gYJ3o34
RSR/PdBZHP/F5f9rUzoYB00MPMwUdai8u9hjrvaVUXwOZNUsTQYzLd5Rn4IFqxUI
v1+7FNc4Zt3EbWekqJyr55jrG3zjcZ1KzIRhJnQRx6GS9BfAbVxE8V6TvqlPDHyU
UevXM7isI6B/MVm6WqhEYklychb8yBDhsgZQ8KUsS0tlNKfzXkM8dL2JGQ0M1MTa
eUe2ohHyk1evtwv7gQSm4zsCsq7cqXYPIwF9XGe9daJ25Sl3ZQ+t7jWCRFT1qmgW
adtXm+ZFTMqvsPU3aR3/
=3XVP
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
