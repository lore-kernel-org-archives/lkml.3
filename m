Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966933Ab3HIK2p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 06:28:45 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47074 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966467Ab3HIK2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 06:28:43 -0400
Date: Fri, 9 Aug 2013 11:27:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Guenter Roeck <linux@roeck-us.net>, Wei Ni <wni@nvidia.com>,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org, khali@linux-fr.org, MLongnecker@nvidia.com,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130809102757.GT6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <20130808211825.GN6427@sirena.org.uk>
 <52040DE2.50201@roeck-us.net>
 <1376027820.695103970@f416.i.mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yE3esYaFu3yg/VEv"
Content-Disposition: inline
In-Reply-To: <1376027820.695103970@f416.i.mail.ru>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Proposal: I2C device power (Was: hwmon: (lm90) Add power control)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yE3esYaFu3yg/VEv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 09:57:00AM +0400, Alexander Shiyan wrote:

> Instead of adding the support of regulators in each device, let's think about
> whether it is possible to create a global regulator for any device on the I2C bus.

> I see it like this:
> We add an extra field in the i2c_board_info structure "power_name" and handle
> it in the i2c_device_{probe/remove} functions.

This would need to be an array of supplies, relatively few devices need
only a single power supply.  This is also not something that should be
handled in I2C, power is not something that's uniquely needed by devices
on an I2C bus.

> The question remains how to maintain such regulator in the PM functions,
> but we can discuss it.

Well, there's some basic stuff for this for clocks already - a similar
pattern should work.  You need to use runtime PM to hook in the power
management and it's not going to work for everything (especially things
that can be wake sources) but there's some value in trying to factor out
the basic use case.

--yE3esYaFu3yg/VEv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBMQpAAoJELSic+t+oim9cQoP/RcdidXGGHhCkcvMOrc+QtgR
tneK0C9EATYUhNFc0xGQufplPt8r5TobiyRK/Fxkq5Yl4XTH0y9gca8j5TSldY1v
oHM0d88qFY0ZaR9k5YKaY3iSYT+Iq1O+ItCcIOXlqYjgOs37sAfMmbUovAXFsEvD
A7douB517YoaJm2JPsEz7FRrwsNUjgJ4XT+DT9OYcEr2LJp8aU6dZ02bZ82a0l8W
DdSJgnFrna7G89yKNNQjcxzb+qDSf7SEsg4qXmIa7/E4KsiRB+4BHCb7ujmbLs2A
dUdRCBdGn4sJaoj0czMMyG9KY2hUih0BX3laa1LrMLSmzTEyFgxU7v/wcb5Si57Y
hFVdyWx4fgFuueORP0eqwpcSB16g5RQaM6toBRMzW4o8Thm+yhZyE+LVvpZSpOa1
R9ciYkmiBWvRKHrTz2n8L3BgXRUArTLTm8cG58n4HJwQkrHO+GRz1rQwMTLa9s9e
WpItvPoSKvJ8ooZapYWygrS7paytX/RQVYH+03URtVYKMA632lnXvljFsi3qlBcY
ry3/FAD472dFFr/6TC3yH4+ZcPYjz5RYJWs0SReadmXxIfDNihzvDHDuomDZbZhj
kdb+H13E+K8ivvMQtq6hn5EbTSHidRj/7sIkJzXTuYMAYb1Mp2/hv6j5MmEwPy6/
BRsIAVyEQjJ3AgIkL94M
=FlkJ
-----END PGP SIGNATURE-----

--yE3esYaFu3yg/VEv--
