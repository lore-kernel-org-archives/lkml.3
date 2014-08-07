Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbaHGKE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:04:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51151 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaHGKEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:04:55 -0400
Date: Thu, 7 Aug 2014 11:04:50 +0100
From: Mark Brown <broonie@kernel.org>
To: James Ban <james.ban.opensource@diasemi.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Support Opensource <support.opensource@diasemi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Message-ID: <20140807100450.GE17528@sirena.org.uk>
References: <201408050102.s7512cAr016807@krsrvapps-01.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BdJDzairM7OG/tdu"
Content-Disposition: inline
In-Reply-To: <201408050102.s7512cAr016807@krsrvapps-01.diasemi.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V1] regulator: DA9211 : support DA9213
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BdJDzairM7OG/tdu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 05, 2014 at 09:56:45AM +0900, James Ban wrote:

This is mostly good, just one fairly small thing:

> +static const int da9211_current_limits[2][16] = {
> +	/* DA9211 current limits */
> +	{2000000, 2200000, 2400000, 2600000, 2800000, 3000000, 3200000, 3400000,
> +	3600000, 3800000, 4000000, 4200000, 4400000, 4600000, 4800000, 5000000},
> +	/* DA9213 current limits */
> +	{3000000, 3200000, 3400000, 3600000, 3800000, 4000000, 4200000, 4400000,
> +	4600000, 4800000, 5000000, 5200000, 5400000, 5600000, 5800000, 6000000},
>  };

It's going to be more robust to have two arrays here, C doesn't deal
with multiply nested arrays well and indexing by arbatrary number is
generally fragile.

> +	if (chip->chip_id == DA9213)
> +		row = 1;

switch statement, what happens when there's another derivative?

> +	if (!(chip->chip_id == DA9211 && data == DA9211_DEVICE_ID)
> +		&& !(chip->chip_id == DA9213 && data == DA9213_DEVICE_ID)) {
> +		dev_err(chip->dev, "Chip ID and configuration is mismatched\n");
> +		ret = -ENODEV;
> +		return ret;
> +	}

You could convert this to a switch statement and then set driver data
pointing to the right tables and so on so you don't have conditional
code elsewhere in the driver.

--BdJDzairM7OG/tdu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT408+AAoJELSic+t+oim98xoQAJ4pFwttsCtYGyNJo7dtZJIp
GzPs+nTAVRAfocvzl8gOWWjINUcu/I3ObKgk6wX3O6Dzn1tgueLKGxoC4JDkrU6G
rnxC7KIt1/Ogi13KXKTKj/exUyGr6BXqThduPYJyoHPc7yOP7nVXKwr9sHYkLtvS
Hq5g6gvqgqNkaexaCB9UbblYbE0Ld9mOy42YBKJ7Pvvl3DEeON4T9bwlJep6KkSL
ZPoHpAQs5Wc5fIeJodIKsOAE1lYW0WguNlWvypddo2z456j1Xq8Rvy+SAcA2QrFD
gDk7eGePUpEGa/juz7ZACRkhiHUMmyRowDpYRZg639dkcr70jTs4pKJk9VF3ozzd
ZHQAwfN7FADzg95ihbwAabyT3+VpVsp99u3YSiwZFLed3pO2m1Q6Ob0q/yYgoGoL
iewcSocRNXh2EF028J/nd3CAt5/mgOXs3yILBeMF8ofdepBhRDLERbrVKHHZrgJI
P2bnMkIScsnUhb5Rie/IaytC68YOLFWxDYws7OgjT+0K+uMoGq87MILT6b/SHalq
T3rF/mxA4K0B7CWpb3HRUjm/wgT+/JkVyKZCFzRMDUz+CHj3wOJSDgUkAy8AQdyL
2EyCuZYTwa5/PjU99glL4lD0DyLZbV7h1wwQ5EQV9XruRkh/xxn1p1khMtIswf5C
ARvKEfaWT5JH2nkWfVgQ
=LpvC
-----END PGP SIGNATURE-----

--BdJDzairM7OG/tdu--
