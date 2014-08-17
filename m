Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbaHQOOX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 10:14:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41045 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbaHQOOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 10:14:21 -0400
Date: Sun, 17 Aug 2014 09:13:41 -0500
From: Mark Brown <broonie@kernel.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        a.zummo@towertech.it, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        grant.likely@linaro.org, hl@rock-chips.com, huangtao@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, xxx@rock-chips.com,
        dianders@chromium.org, heiko@sntech.de, olof@lixom.net,
        sonnyrao@chromium.org, dtor@chromium.org,
        javier.martinez@collabora.co.uk, kever.yang@rock-chips.com
Message-ID: <20140817141341.GH14537@sirena.org.uk>
References: <1408240705-29472-1-git-send-email-zyw@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKijDXBCEH69PxaN"
Content-Disposition: inline
In-Reply-To: <1408240705-29472-1-git-send-email-zyw@rock-chips.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 216.80.70.240
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] MFD: RK808: Add new mfd device for RK808
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKijDXBCEH69PxaN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 17, 2014 at 09:58:25AM +0800, Chris Zhong wrote:

> +static void rk808_device_shutdown(void)
> +{
> +	int ret;
> +	struct rk808 *rk808 = g_rk808;
> +
> +	if (!rk808) {
> +		dev_err(rk808->dev, "%s have no g_rk808\n", __func__);
> +		return;
> +	}

This is a bit dodgy but I can't think of a better way of doing it :/

> +
> +	ret = regmap_update_bits(rk808->regmap,
> +				 RK808_INT_STS_MSK_REG1,
> +				 (0x3 << 5), (0x3 << 5));
> +	/* close rtc int when power off */
> +	ret = regmap_update_bits(rk808->regmap,
> +				 RK808_RTC_INT_REG,
> +				 (0x3 << 2), 0);
> +	/* close rtc int when power off */
> +	ret = regmap_update_bits(rk808->regmap,
> +				 RK808_DEVCTRL_REG,
> +				 (0x1 << 3), (0x1 << 3));
> +	if (ret < 0)
> +		dev_err(rk808->dev, "rk808 power off error!\n");

Defines for these bits would be good, though if this turns off the RTC
alarm then it might be better not to do it - one thing people do with
RTC alarms is use them to wake the system up from deep sleep.

> +	while (1)
> +		wfi();
> +}

Just let the kernel shut down by itself - or is that last write a system
power off request?

> +	ret = regmap_read(rk808->regmap, 0x2f, &val);
> +	if (ret < 0) {
> +		dev_err(rk808->dev, "The device is not rk808 %d\n", ret);
> +		return ret;
> +	}

That error message is misleading - an error from regmap_read() means
that I/O failed, usually "device is not rk808" would mean that you'd
read back and ID register on the device and it didn't match what was
expected.

--gKijDXBCEH69PxaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8LiRAAoJELSic+t+oim9kTcP/jVwefUBbKMRbwYGCPiO4OWR
3rx1WXCQ4fmZNZ9sxKnrxya42W60vluuhddgCEuhn459If/5Ybq83Fe93dEjJyky
3cYu1CpaC9kdwMwT3iZdqDope3lo8l7njtlI57Z2b+m59Aipa67AkWGCa+53UxZQ
e87oMR9mfRN1Q8TKofATAr2DuM5+ogOTLwfPXqvfCP/Ei2DNIEuYy2zoqbqNJdLT
1rh2w/VkFtjnFdFbVX/CvBIA8Sr9tumjP93usrxWH7LmJHUC03ANFBeIDXw1fu2W
lRdPp1gj3LWK5Q0B/0TSYX2PLa8Hp7znJOyaakh5ClJAseJRC6h1YcdwM2DBSSEq
EsVxnc1Ann6g2Gco5D6RM0lkogKTW4aYCxYuHn+yJ1oB8zavxTMhByRBAxkeby1P
dR452/cJwf6Czy9Pkl0Gkfk+iYwl3AyemgZ7ipgL1ZaIOYf2S33Y1k5zvT3zHhWP
BdVxlV+623XJjpTiLpYMC0fyCUYDL/YV9nLG8S5H+HP9OcaZHWBBKIUdI0f1Q9KA
U7YAaQO8P9bi1vhJUoV5jGAe7oKBBvvMWMImT79z4f1LMqJ65VDa4JvjxLXdcbBV
UVmr4571HyKXL/aIBjsxYUY5ZozrNYGWkuPtCd1JxhDFkBodKVLJBbG0u8mwih7k
vFPk/MI83eF5xp3UF/+J
=VwfY
-----END PGP SIGNATURE-----

--gKijDXBCEH69PxaN--
