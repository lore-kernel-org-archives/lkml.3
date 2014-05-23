Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaEWRyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:54:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40463 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaEWRx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:53:58 -0400
Date: Fri, 23 May 2014 18:53:12 +0100
From: Mark Brown <broonie@kernel.org>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: lee.jones@linaro.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        jacob.jun.pan@linux.intel.com, bin.yang@intel.com
Message-ID: <20140523175312.GI22111@sirena.org.uk>
References: <1400805629-10322-1-git-send-email-lejun.zhu@linux.intel.com>
 <1400805629-10322-3-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X/KOvfZbhhxWSrMq"
Content-Disposition: inline
In-Reply-To: <1400805629-10322-3-git-send-email-lejun.zhu@linux.intel.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.182
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND v2 2/4] mfd: intel_soc_pmic: I2C interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X/KOvfZbhhxWSrMq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 08:40:27AM +0800, Zhu, Lejun wrote:

> +static int pmic_i2c_lookup_gpio(struct device *dev, int acpi_index)
> +{
> +	struct gpio_desc *desc;
> +	int gpio;
> +
> +	desc = gpiod_get_index(dev, KBUILD_MODNAME, acpi_index);
> +	if (IS_ERR(desc))
> +		return PTR_ERR(desc);
> +
> +	gpio = desc_to_gpio(desc);
> +
> +	gpiod_put(desc);
> +
> +	return gpio;
> +}

Why not just have the driver work with the gpiod API, is there any real
need to convert to a GPIO number?

> +static const struct i2c_device_id pmic_i2c_id[] = {
> +	{ "crystal_cove", (kernel_ulong_t)&crystal_cove_pmic},
> +	{ "INT33FD", (kernel_ulong_t)&crystal_cove_pmic},
> +	{ "INT33FD:00", (kernel_ulong_t)&crystal_cove_pmic},
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, pmic_i2c_id);

The INT33FD ones here look like they should only be in the ACPI table.

> +static int __init pmic_i2c_init(void)
> +{
> +	int ret;
> +
> +	ret = i2c_add_driver(&pmic_i2c_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register pmic I2C driver: %d\n", ret);
> +
> +	return ret;
> +}
> +subsys_initcall(pmic_i2c_init);

module_i2c_driver() - you shouldn't need subsys_initcall().

--X/KOvfZbhhxWSrMq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTf4sFAAoJELSic+t+oim9/mEP/ithUto1grzbjt7jm4cfgoX6
oH2mbr+GTG8zWLqPwbeCaahGuMlWzfgFveaiIwqjtolzZwRBz16tpEfZM5WTRD0u
I4dPWfgNtL4/GlEZKhoMWYzvOAp43DMWm3pId6L7391p8IWU32oIuqtVRGf/hreQ
iGLwtw/9n6XhWzdF+/ow5sbuaMMAIriqDzVD4RfqM2uGCsC/tqeOVnTLxmjffH5l
Kcl1OafBV0QppqztmDgWNs/utPOx+Qumqs1ShUu6qbQjOAukSIgfO5INHb3n0IMR
d2p9sOpgKx72hMGSN0+3XlB4Bejem7RpermSpTDamTcZqxpKOCc6Jrn2qN4KBqhZ
How5RsjJL113PeI4SVCDfi07wVa2KittgWE/Iuf52ACYTSmKSjXlRbzdw7Gmcwt0
70YilcqcXyxujME+Ve5dqHhsobUvB1zier37SYi01nFuXEQYuN2gLC6EqreoliWP
8RUjhsGkxSukgvEs8AEwL7Olnut+xONHg5XJxKGf8DVyGocav2OwrEUSGoGo/Ia5
VDYErVVIc2X9E0fwFsovi0EhJZ/Ydl8leX1NL/LDg6YrT06PDVP1bVfVYtU2hvWc
8UJgX9ju2Ipo3ybBE2FHwcvZmdUevant1aoNbU8fOhIZpMkAN50el3Jhb+D3sMCR
3FrRl8wH4PvKteF7NZWw
=7ylG
-----END PGP SIGNATURE-----

--X/KOvfZbhhxWSrMq--
