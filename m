Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259Ab3HHNIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:08:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35540 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934211Ab3HHNIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:08:54 -0400
Date: Thu, 8 Aug 2013 14:08:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wei Ni <wni@nvidia.com>, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, MLongnecker@nvidia.com,
        khali@linux-fr.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130808130840.GC6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1375944991-29182-2-git-send-email-wni@nvidia.com>
 <20130808110136.GA6427@sirena.org.uk>
 <52038035.7030803@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dUQ3G7okZyz11iOi"
Content-Disposition: inline
In-Reply-To: <52038035.7030803@roeck-us.net>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] hwmon: (lm90) Add power control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dUQ3G7okZyz11iOi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 08, 2013 at 04:25:41AM -0700, Guenter Roeck wrote:
> On 08/08/2013 04:01 AM, Mark Brown wrote:

> >That said if you *are* going to do this you should request the
> >regulator using devm_regulator_get_optional(), this is intended to
> >support things that don't need regulators (though that's not the case
> >here).

> The lm90 driver works perfectly fine without regulator.

I'd be most surprised if the device worked without power, if the driver
fails to get and enable a regulator for it then that's not great
(especially if it does so silently).

Note that the regulator API is written to stub itself out if not
enabled, the code should be able to assume that it's there.

--dUQ3G7okZyz11iOi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIbBAEBAgAGBQJSA5hVAAoJELSic+t+oim9t0gP92irDevC9fvT52swMQvNruRs
ogXmFlGn4wuUsZPa81UK5wCmj8eWjV5sCqxeO3l2xlyBlA5UDzfmWQAjMEuJzTSg
T0yOaXZq2vDUwvEuhpBfvvd1f3dDAAoSlIL/QN9uYfwLKSQCKMT/Ls4nG/3rmj5K
jfumdG2JtSy8c1KHW4L6MHYcE5n/88Dzkb8WcSKS0cKYbAT1uCBSC/7PCg/5O/IT
PhPTBzOo/DeUpk8RjBF+59mmkIHzytgR6c8WbVwtvg0wMnhfMv6O7Mhv5RaekWcA
2SfYGdhGKBzHjz9a4Tw8pUhpO9jy2RzEW6PkbfI7vnHw7Fa7Lh9/ZU/pcu4JYcUW
YZH+9vO7IAqJllQuxrKRI7rq51ukav0SKtgYfb/2Jqn3eEFSO4o6hStSR5NNQvhJ
cA5GAdXQ5FIxgHLK7Ze7ijEmZHvW2WKcdGdtaPbkvCUjyzK8yhiMZin/sB3Yh1H3
8MwoFBZqEvyUMmDVuB7QpHya9F/pQlAFYg9UcnUBt38+jSipBUn2i5mdEB/IbwHi
GbMVeWTVMKExQlfaL+wcSIf0ZeT9heoWQT7gC/ARrYWkOS//u4BcKcB7BKm2UiAO
r+iAQFGPjGQJOL7N8NPYRrvUta4Ing+GIFNjQ00m+sIRWlb/sucXAmPGT25Gw4jQ
uOf2FdHbtv3oBXJEA9M=
=j9PC
-----END PGP SIGNATURE-----

--dUQ3G7okZyz11iOi--
