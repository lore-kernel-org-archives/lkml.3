Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaCRLLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:11:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48398 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbaCRLLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:11:08 -0400
Date: Tue, 18 Mar 2014 11:10:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140318111049.GJ11706@sirena.org.uk>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395139757-6907-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5EqXjnbnoPR4rQBx"
Content-Disposition: inline
In-Reply-To: <1395139757-6907-4-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/8] regulator: arizona-ldo1: Move setup processing from
 arizona-core
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5EqXjnbnoPR4rQBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 10:49:12AM +0000, Charles Keepax wrote:

> +#ifdef CONFIG_OF
> +static int arizona_ldo1_get_pdata(struct arizona *arizona,
> +				  struct regulator_config *config)
> +{
> +	arizona_of_get_named_gpio(arizona, "wlf,ldoena", true,
> +				  &config->ena_gpio);
> +
> +	return 0;
> +}
> +#else
> +static inline int arizona_ldo1_get_pdata(struct arizona *arizona,
> +					 struct regulator_config *config)
> +{
> +	struct arizona_pdata *pdata = &arizona->pdata;
> +
> +	config->ena_gpio = arizona->pdata.ldoena;

This breaks non-DT systems booting a kernel which has DT support
compiled in.  It's also more than simple code motion which is what the
changelog claimed this was doing.

--5EqXjnbnoPR4rQBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKCm2AAoJELSic+t+oim9HMkP/1GucK1N32y3mywN8JaYtEWf
Sgr7yY+dIHkZXTtFbbzSleHWj6ghO/zJ1JfueZpHOxyfdANiZroGHgAEj4uQhhvI
KJPOdr+btATXzKlgz8t4L4w1CVXlMxeTdZR2dQuvk6g2ITQ9ONhS955OjdFqSGZv
Xzz3MkpaVRTTEDBec5Zol2VOv/y7Q2BIWNpzAU93h/KJcswpYssjWLmKOYnu/Y0Y
8EC1MoukIkdmVrN9kGysg+/sVKxCJWrQQuJT4sJEDKgOCmmgLe0iZxiSqMVr9Dh4
Ii9x21NWN89DyeDt24aFnc4UItziZEbOL16rcLOwsMbYG7nvftwmdATFHFX3JRHV
8ln43iCjdUfYn18msEbttBBDGXH6t6hfcy2l61tQKg+9oBRPdFMl62QPOjXtIFNz
8khSqhI1a07pASSAFCECxbkQDcIfe2UwLretwi00BCw3xyuaqQdZzCFFyZ21MU5W
kF5BPzgVYbyI1rCEDpfcqxoELYnb0qtSPb8QC7eU/5oNuZc5uE8IYRqH8e9/1aLI
SLIqeEtnw+C4qeO3smONHhm8EeDJ/ouoXylNIHc10CkIK8wh/en/wwpXbSgiZdVq
IW+m7mCHbL4BZrra5wtF7tM4yIC6XvSuT2zYEm62hw1lAqasr7gE4IxdS5jN4v3a
mABYLBvWBavx3a6tOJlx
=LKSK
-----END PGP SIGNATURE-----

--5EqXjnbnoPR4rQBx--
