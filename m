Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab3G0RHT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:07:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56743 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab3G0RHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:07:16 -0400
Date: Sat, 27 Jul 2013 20:07:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 3/3] Input: omap-keypad: Set irq to level instead of
 edge
Message-ID: <20130727170647.GA17360@radagast>
Reply-To: <balbi@ti.com>
References: <1374858546-25034-1-git-send-email-illia.smyrnov@ti.com>
 <1374858546-25034-4-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3uo+9/B/ebqu+fSQ"
Content-Disposition: inline
In-Reply-To: <1374858546-25034-4-git-send-email-illia.smyrnov@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--3uo+9/B/ebqu+fSQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 26, 2013 at 08:09:06PM +0300, Illia Smyrnov wrote:
> From: Axel Haslam <axelhaslam@ti.com>
>=20
> Set mpu irq to level instead of edge, since if mpu is in low power
> an edge detection may be lost if the event is a wkup event.
>=20
> Signed-off-by: Axel Haslam <axelhaslam@ti.com>
> Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>
> ---
>  Based on top of v3.11-rc2
>=20
>  Depends on:
>  Input: omap-keypad: Convert to threaded IRQ
>  https://patchwork.kernel.org/patch/2832920/
>=20
>  drivers/input/keyboard/omap4-keypad.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/input/keyboard/omap4-keypad.c b/drivers/input/keyboa=
rd/omap4-keypad.c
> index e8bdc76..7adb53e 100644
> --- a/drivers/input/keyboard/omap4-keypad.c
> +++ b/drivers/input/keyboard/omap4-keypad.c
> @@ -374,9 +374,13 @@ static int omap4_keypad_probe(struct platform_device=
 *pdev)
>  		goto err_free_keymap;
>  	}
> =20
> +	/*
> +	 * Set irq level detection for mpu. Edge event are missed in gic
> +	 * if the mpu is in low power and keypad event is a wakeup
> +	 */
>  	error =3D request_threaded_irq(keypad_data->irq, omap4_keypad_irq_handl=
er,
>  				     omap4_keypad_irq_thread_fn,
> -				     IRQF_TRIGGER_RISING,
> +				     IRQF_TRIGGER_HIGH,

omap4 is DT-only, why don't you pass zero here and expect DT to setup
IRQ type correctly for you ?

--=20
balbi

--3uo+9/B/ebqu+fSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8/48AAoJEIaOsuA1yqRElDYP+QGYEyLPwogx9u0/OQVDrX64
8LPtPtmhe/X32ZNsn6jMr1Py0lB16K1j2sDhFK+CP85BT6k/1YBzMHIO1ePbynmr
borjPWlmsptrNJh5FELxyDjxILvQ6npJ1L6DbM3gjCRZ4u9wvapnTSjm40KR/rsp
jj/co7BeDZQ+KpIDnKVx7Jfut6ane2t9TFssPC5RNClJ8UpsWdzvCuphy5foN1Os
TvShvqtsC7McMfpc1zI72tWgfeTJvr1SY5vJ5kMjkguaCCethW1Fy3iqaXghnrKV
3/yaCRbo4loeywWuj13WXv3c770BQJnS66MxBCIdDX0xBOiUmgc5UlsmOXAmLz4U
mWYRs8PFR3yesluy6Bq7S2iv6una6o4kHGVQI6K4ClTsRYQArhkTvd+BlbMKlIrH
4sqchyiAB/ZANxuCxtFoRfEL3FBpp9PZtGu34xYWRwtPKvYs+7fesUq2EjDAI43U
Qle1Pv7N5eqnKq8GIKqeVX9uwL99urcxoN6CEdzaGgAcsRE6R5B2WFF3VhvUQp6b
eZFC2eQ1xt/RiJ8OwGRG6uGCwo0Otqc/7nFz+KXDZr1nTtPG9MsxGXc3UMrEQ75y
zC8lpoZyvzJZDKAURAmpAawvgVEiSg7JaeetXEyMV4bDgV6zD5qzfl49RGTw639r
eWgnu7vvPdkYXw4ET30c
=C2Ku
-----END PGP SIGNATURE-----

--3uo+9/B/ebqu+fSQ--
