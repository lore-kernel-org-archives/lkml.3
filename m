Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3GKQwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:52:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49997 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab3GKQwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:52:04 -0400
Date: Thu, 11 Jul 2013 17:51:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Message-ID: <20130711165116.GT24508@sirena.org.uk>
References: <1373464848-28146-1-git-send-email-jonas.jensen@gmail.com>
 <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BVQ1RKc6+nLPB5pT"
Content-Disposition: inline
In-Reply-To: <1373550711-18828-1-git-send-email-jonas.jensen@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] rtc: Add MOXA ART RTC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BVQ1RKc6+nLPB5pT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 11, 2013 at 03:51:51PM +0200, Jonas Jensen wrote:
> Add RTC driver for MOXA ART SoCs.

Looks good now.  A couple more minor nits.

> +void moxart_rtc_write_byte(u8 data)
> +{

> +u8 moxart_rtc_read_byte(void)
> +{

These should be static.

> +	gpio_direction_output(GPIO_RTC_DATA, 0);
> +	gpio_set_value(GPIO_RTC_RESET, 1);

I guess I'd expect the GPIOs to be configured by platform data in case
of board changes (it's a bit odd that a SoC RTC is being done with
bitbanging, I guess it's on an external chip?).

> +	devm_gpio_request(&pdev->dev, GPIO_RTC_DATA, "rtc_data");
> +	devm_gpio_request(&pdev->dev, GPIO_RTC_SCLK, "rtc_sclk");
> +	devm_gpio_request(&pdev->dev, GPIO_RTC_RESET, "rtc_reset");

Should check the errors from these.

> +	gpio_direction_output(GPIO_RTC_RESET, 0);
> +	gpio_direction_output(GPIO_RTC_SCLK, 0);

devm_gpio_request_one()?  Though it doesn't make much difference and you
do have a nice block of devm_gpio_request() above not all of which have
a direction assigned immediately.

--BVQ1RKc6+nLPB5pT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3uKBAAoJELSic+t+oim91HsP/3Pv5RqqGac2N4XkDI6qOtxP
+9qW5dANrNHJ5kyUeSmxQxzQCjz8uEgCSrX/V3l5TqJPsrBq5gTfxD0tph8FJ2Zp
38dp4lJ6GDkb68YXL8JjlcgWGqBTGAPqa3HXh7oK9wsMEmvJep1g0ytNn1VPLPur
D1qTA5ArP0qpoPEM48seGwZUIDJUGZyJ4sY7PP/LU0amd+UtivpX7ycxqpMMMcQS
mu3/HpIRssqdsl8H9wWHKI2D5FK8/PS2oFk7hD8EDKcvCJzd0YnhHN6wa0VGSB33
aLXSRuGzsgwrYzNSSktP6LB/JF3q0+kwZhOrcxOz9NnzczI418H0pWSjK5VWDOlh
bRLyifbdsiucpGlmtm84XvitQq1qINHYqRn/cwofHma1JdUIXRL+dYnzEhXta7tk
7Y0MrCT4Ca4jVpM56oZgyss4ox7ng0goxV6b8Nam4mMLRngGkHiZkR7a19iewaAy
ougL1LFvbah3Q4dMudOQXwfou38ykZBBqGf8Kn5PaHAmenRcEwZclo2x7ASs55NI
JvUai6N8AutUcwmilW6bpVIHpbU9LpFHq3zX3J4hUpnlmU3EFaa8LWTyjJVGM91x
BNATospHslWRx7JIpdlcUpqBc8ch2X0594AMuvkQYZCGbXbfbihs9jM9eushXElf
kRCDB2VcEj6h3l8YoVg6
=FlZb
-----END PGP SIGNATURE-----

--BVQ1RKc6+nLPB5pT--
