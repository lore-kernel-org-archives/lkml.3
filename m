Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab3LRNrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 08:47:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52156 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab3LRNrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 08:47:49 -0500
Date: Wed, 18 Dec 2013 13:47:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131218134720.GU28455@sirena.org.uk>
References: <1387286601-21646-1-git-send-email-k.kozlowski@samsung.com>
 <1387286601-21646-5-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8VTUIDSAwBDIdXuf"
Content-Disposition: inline
In-Reply-To: <1387286601-21646-5-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Haste makes waste.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] regulator: s5m8767: Use GPIO for controlling
 Buck9/eMMC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8VTUIDSAwBDIdXuf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 17, 2013 at 02:23:20PM +0100, Krzysztof Kozlowski wrote:

> +static int s5m8767_reg_gpio_is_enabled(struct regulator_dev *rdev)
> +{
> +	struct s5m8767_info *s5m8767 = rdev_get_drvdata(rdev);
> +	int val;
> +
> +	if (!s5m8767->buck9_uses_gpio)
> +		return s5m8767_reg_is_enabled(rdev);
> +
> +	val = gpio_get_value(s5m8767->buck9_gpio);
> +
> +	return val == 1;
> +}

Don't open code this, use the core GPIO handling - see ena_gpio.

--8VTUIDSAwBDIdXuf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSsadlAAoJELSic+t+oim96a4P/RI6O0iQdbGWoPtkDFA1yDd8
Hrm78kVUVqsC4cglo+PqLXORbeI/K8gvH+v3pJZxfSi6hunlMm1ODR/jyuEukLFk
VkJLZ+hH96kPc3yg+KLxI/EGVSDal13pd1Pm1g7fUodi80b8URNwS5bIeQrUiPUK
6uzdhC7VAnVb5wWB6/1a5gxd+dbLDK5Y+xwcYYc8nS/bMe6IEXm8ko0Ulo5TAHBz
mcGXyjqS7xy5v0niPzgEPh7UuHjh+rcd1gZQT5t7Hec3Z3c9KD/6ST+hKSFIbhru
+Ug0RhuMKobKHZDELXEAn9VzcdhFLLhBkSnAEY880+zw2i3z0ojgpOfqRYrvXRZ3
dliXuZXibz5uTpo8oPU+XVDKfcApDRkgQerUNlBekYYWyBM4CvJrt0QP0QeHMYeQ
lIStK2OihDolpcCPm0o6VF075+1lRyUfmIGFnbPemKrW45/ZwFYamEstUwUhD3Y0
fuc5vADVMPb6kIEYLnBzk66TVb27X2lfXaMPf4yV29NVNKpO0xrQydXZPkcmb+lq
QNhRqxi4L+HOu4rScVvvicxuv0SRY5zebccZrYMxoyBEymG2JIeuz6T6pVl3Dx+9
fSkv9HXXogmDWABGOiN0DM6RReKL01HvqQA+KIdpPr1Vdb00TjwaECUT/pho2pKH
aRe7SQiqrHCqH2dyjCes
=OlrS
-----END PGP SIGNATURE-----

--8VTUIDSAwBDIdXuf--
