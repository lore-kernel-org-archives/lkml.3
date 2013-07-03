Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502Ab3GCOOK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:14:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50468 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab3GCOOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:14:08 -0400
Date: Wed, 3 Jul 2013 17:13:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <nm@ti.com>
Subject: Re: [PATCH v3 2/8] wlcore: set irq_flags in the board files instead
 of hiding behind a quirk
Message-ID: <20130703141332.GO15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372860209-3504-1-git-send-email-coelho@ti.com>
 <1372860209-3504-3-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0UhZIN3Sa23/ILEd"
Content-Disposition: inline
In-Reply-To: <1372860209-3504-3-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0UhZIN3Sa23/ILEd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 03, 2013 at 05:03:23PM +0300, Luciano Coelho wrote:
> diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/bo=
ard-4430sdp.c
> index 56a9a4f..953f620 100644
> --- a/arch/arm/mach-omap2/board-4430sdp.c
> +++ b/arch/arm/mach-omap2/board-4430sdp.c
> @@ -703,12 +703,30 @@ static void __init omap4_sdp4430_wifi_init(void)
> =20
>  	omap4_sdp4430_wifi_mux_init();
>  	omap4_sdp4430_wlan_data.irq =3D gpio_to_irq(GPIO_WIFI_IRQ);
> +
> +	ret =3D gpio_request_one(GPIO_WIFI_IRQ, GPIOF_IN, "GPIO_WIFI_IRQ");
> +	if (ret) {
> +		pr_err("error requesting wl12xx gpio: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret =3D irq_set_irq_type(gpio_to_irq(GPIO_WIFI_IRQ), IRQ_TYPE_LEVEL_HIG=
H);
> +	if (ret) {
> +		pr_err("error setting wl12xx irq type: %d\n", ret);
> +		goto free;
> +	}
> +
>  	ret =3D wl12xx_set_platform_data(&omap4_sdp4430_wlan_data);
>  	if (ret)
>  		pr_err("Error setting wl12xx data: %d\n", ret);
> +
>  	ret =3D platform_device_register(&omap_vwlan_device);
>  	if (ret)
>  		pr_err("Error registering wl12xx device: %d\n", ret);
> +out:
> +	return;
> +free:
> +	gpio_free(GPIO_WIFI_IRQ);

actually, you should leave this GPIO requested in order to use it as
IRQ.

ditto for all others

--=20
balbi

--0UhZIN3Sa23/ILEd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1DGMAAoJEIaOsuA1yqREcHYP+wRgnOEDi4wZDKzRPBVC2ywm
s9K96iAkk7495ynkbBMr8pzebFppQqnBXsmFPcVCbvd6R3jrCSaObituyRJhPnoS
7LwObCnYmxKK4tRp6WyPcQ0xb2AGu3JZkKWr7jLQqXF10uUXFCT2ybYM3zmDOxBw
uhsXeN83DDdEaz94LnVjzsillJr+0TEDonrPJzUbbcpnA2u4GJ2AqQVefadJH3gL
vD3n26YGD8Kx0AfaswwWPJNXyp47a2vQjv9Y6gub49OPR504kzRXXmvuj71wdO6r
eThulC1mPbj0EamNI5ZKXf928nOITZrFPwcVaMGdNjdOh9yv6dHeV7L//sUZRDQM
PtEyDM7f3hoLRmLwTSyCW9yTkvGfcOqn5f+pP7SgHmXUBQ1h2VOtnFRgv37hfynX
eSNeQkM6ohpR4sOM0JLMQDzl5NAt6kmlVBxwzSifkjARzMwj4BZNWq8p1glMami2
S4xOH5VS2Hz2Whtzbz0CvCTPSiagTWmesjqwKvXaMcXOzyBCAL5ZuJ0maoNjVveH
0Ps3jHFlNWDj+PkxorQINno4Ra+6zFFK28UCdpTCDUehIFk8fA4MOyV+ptDeoNyU
cWyj4x0jSzC8uhUq6A7p+0igen952LckS08MAGaB3zT8asdrjlNWwByWsttRf/vw
GEGyS/zauoQScNsdmyxv
=AJxe
-----END PGP SIGNATURE-----

--0UhZIN3Sa23/ILEd--
