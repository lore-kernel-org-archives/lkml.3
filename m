Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaJFNYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:24:10 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:50238 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaJFNYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:24:08 -0400
Date: Mon, 6 Oct 2014 15:24:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, jonsmirl@gmail.com,
        Simon <longsleep@gmail.com>, linux-pwm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv7 1/2] pwm: Add Allwinner SoC support
Message-ID: <20141006132404.GC26921@ulmo>
References: <1410983638-24915-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1410983638-24915-2-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <1410983638-24915-2-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 17, 2014 at 09:53:57PM +0200, Alexandre Belloni wrote:
[...]
> diff --git a/drivers/pwm/pwm-sunxi.c b/drivers/pwm/pwm-sunxi.c
> new file mode 100644
> index 000000000000..643f84ea013e
> --- /dev/null
> +++ b/drivers/pwm/pwm-sunxi.c
> @@ -0,0 +1,371 @@
> +/*
> + * Driver for Allwinner Pulse Width Modulation Controller
> + *
> + * Copyright (C) 2014 Alexandre Belloni <alexandre.belloni@free-electrons.com>

This is somewhat weird. So you are the copyright holder, not your
employer? The email address is somewhat misleading.

> +#define BIT_CH(bit, chan)	(bit << (chan * PWMCH_OFFSET))

bit and chan could use additional parentheses here for extra safety.

> +static const u32 prescaler_table[] = {
> +	120,
> +	180,
> +	240,
> +	360,
> +	480,
> +	0,
> +	0,
> +	0,
> +	12000,
> +	24000,
> +	36000,
> +	48000,
> +	72000,
> +	0,
> +	0,
> +	0, /* Actually 1 but tested separately */
> +};

Did I already mention that this was really weird?

> +static inline u32 sunxi_pwm_readl(struct sunxi_pwm_chip *chip,
> +				  unsigned long offset)
> +{
> +	return readl(chip->base + offset);
> +}
> +
> +

There's a gratuitous blank line here.

> +static int sunxi_pwm_probe(struct platform_device *pdev)
> +{
[...]
> +
> +	ret = pwmchip_add(&pwm->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);

"chip: %d" to make it clear that it's not some kind of chip ID.

> +		goto error;
> +	}
> +
> +	ret = clk_prepare_enable(pwm->clk);
> +	if (ret) {
> +		dev_err(&pdev->dev, "failed to enable PWM clock\n");
> +		goto error;

Don't you want to remove the stale PWM chip here? Why not do this at the
very end, after everything's been set up properly?

> +MODULE_ALIAS("platform:sunxi-pwm");
> +MODULE_AUTHOR("Alexandre Belloni <alexandre.belloni@free-electrons.com>");
> +MODULE_DESCRIPTION("Allwinner PWM driver");

Perhaps "Allwinner sunxi PWM driver"? Presumably Allwinner could at some
point release a different family of SoCs.

Thierry

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMpf0AAoJEN0jrNd/PrOhmLkQAJUZdn4jVkzcKc8HBqn9yT1j
vMMcP8dbNFupi+tFAgL2iQM0CNCDU/k0SAMG3sScsUJ/VU/+HA6tRyp6uQ62ZZOV
485JYaCtknZRvvVIZyCQ7NfgU+mBbYwNHNlqtovOlFHeLMDv4TZsSgRMdk0noUQj
NZZrQGbM6auzvQklob2zXfujXKV8+g11eNtOAeI6sF/HKvGNZ0mBnGuUr9YZQvZ1
r2a9l3o5Ln0wvaZojbObxyJxdn/OOj677QorDYyLL+ZY0iowViRqQe6sjGt4HE9m
8ZIwLOqNjhWyISPQw3KbAz8Q0kzRiaxtpnJO9n6xK/HUMTaYlLw6PeRiu7XoHtWM
19P8KXo+kHi5dtxjmIzOLWDdEf9F+34/8cgonU8hfXlYzsUrX1vSQUIJVUo4ZISe
lmeFrjuJeZstg6BwmJHQ7Z6mKCDqjEbJq9auL42jG3+rEveo2AB49NUF+FdZd17x
opZ88trJmP9OJ1IE5msVmQZG0C6jZxGLF4D7dxe+rfIDVMJUaOPGaLDL4yhbxw3T
49BxtljtXTaTRwbJLiJqaZdPzh8m/gIneNbWH1e4Jhrc5BDxy/B0Ko8hkEg1fW3Q
AXSrSucwIQuMCgMER136H7yIF3EXCa42SXbd3B9r7DVmKaLZLxZYXby5q2Xq808F
C9fRR/kRf9yGPh2xNW29
=QAiK
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
