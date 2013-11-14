Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab3KNSFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 13:05:23 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58516 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab3KNSFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 13:05:15 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Subject: Re: [PATCH 1/2] isp1704_charger: Add DT support
Date: Thu, 14 Nov 2013 19:05:06 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-13-generic; KDE/4.11.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1384432734-1490-1-git-send-email-sre@debian.org>
In-Reply-To: <1384432734-1490-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16505307.8pWyuiL9Yo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311141905.11046@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart16505307.8pWyuiL9Yo
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 14 November 2013 13:38:53 Sebastian Reichel wrote:
> diff --git a/drivers/power/isp1704_charger.c
> b/drivers/power/isp1704_charger.c index fc04d19..db96778
> 100644
> --- a/drivers/power/isp1704_charger.c
> +++ b/drivers/power/isp1704_charger.c
> @@ -28,6 +28,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/power_supply.h>
>  #include <linux/delay.h>
> +#include <linux/of.h>
> +#include <linux/of_gpio.h>
>=20
>  #include <linux/usb/otg.h>
>  #include <linux/usb/ulpi.h>
> @@ -89,8 +91,8 @@ static void isp1704_charger_set_power(struct
> isp1704_charger *isp, bool on) {
>  	struct isp1704_charger_data	*board =3D
> isp->dev->platform_data;
>=20
> -	if (board && board->set_power)
> -		board->set_power(on);
> +	if (board)
> +		gpio_set_value(board->enable_gpio, on);
>  }
>=20

You need to check if enable_gpio in board data was defined or not.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart16505307.8pWyuiL9Yo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKFENYACgkQi/DJPQPkQ1IBGwCeMCZVuzZCxHs5GD3ezENwZ1Tl
SF8AoL0CrsPvU74izZLBc/KLI/238TBw
=Zruq
-----END PGP SIGNATURE-----

--nextPart16505307.8pWyuiL9Yo--
