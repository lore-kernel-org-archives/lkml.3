Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967602Ab3HILJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:09:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49841 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967291Ab3HILJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:09:43 -0400
Date: Fri, 9 Aug 2013 12:09:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Alexander Shiyan <shc_work@mail.ru>
Cc: Wei Ni <wni@nvidia.com>, swarren@wwwdotorg.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-tegra@vger.kernel.org, MLongnecker@nvidia.com,
        linux-arm-kernel@lists.infradead.org, khali@linux-fr.org,
        Guenter Roeck <linux@roeck-us.net>
Message-ID: <20130809110931.GX6427@sirena.org.uk>
References: <1375944991-29182-1-git-send-email-wni@nvidia.com>
 <1376027820.695103970@f416.i.mail.ru>
 <20130809102757.GT6427@sirena.org.uk>
 <1376045411.585130456@f141.i.mail.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zN/UJhV2gvyhY9D2"
Content-Disposition: inline
In-Reply-To: <1376045411.585130456@f141.i.mail.ru>
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


--zN/UJhV2gvyhY9D2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 02:50:11PM +0400, Alexander Shiyan wrote:

> > This would need to be an array of supplies, relatively few devices need
> > only a single power supply.  This is also not something that should be
> > handled in I2C, power is not something that's uniquely needed by devices
> > on an I2C bus.

> Additional regulators can be handled in the driver, or "parent"-scheme can
> be used. Is not it?

Given how common it is to have multiple supplies it seems sensible to
just handle that in the core - it's common to have a digital supply and
an analogue supply for example.  The regulator framework already has
APIs for working with multiple regulators in a single call so it's not
going to be much more effort on the framework side.

--zN/UJhV2gvyhY9D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBM3oAAoJELSic+t+oim9lWwP/36VFWFam8wJQbJ17f69Zqdz
5gFP0wmDN4Wy7uWw73CRYZHq9BkzOYf/I2wl8D88WRAUJIbvnarcbTkg0ykHyedk
q1HJUEU3tYfOX7y5FUY2VYb32Ax5sUEp/8tNjrDwEC0QX0Xuw8gGgHcnGLkFI4fv
BCplAVxCRgddnRrpeEpEQ5UDMm4ds1NIfs7M25pXT789D0Cv7hfoVi9vya8SybSm
Vsj1QNFpw3dsUrjzdrwfv7m/GaqvsWDFk4bZ+Mm7TopG5E1KUmrdMSsKATvJYnUv
lRkEpwab/WSkyuwM75xA2AlklA8rNFyeehtQBO05A+tLclf/aAhryknHwRibrrmi
IP9HE6slrn+ZNcBwK3L9sdIj4D9dJKU7PMTFbcsNzjr1h1kKBjUY1fesYLO+lCfk
XBOfdy2t9n+RREkFdrb0bw2SrL385ucWDmaCkxMjHE/NMnhNE6qxK9VrnHpxhZE9
Y309BFCcrIGjQ7K8LbZCslM49cmUlHO6TDfgAOFPsMwNnUcjdHFd4K8B+xNRA3G9
QkmRuxM3Oxv/KwR65/jyTsw0tq2pnoiqLiJy3P+qvb5ibCwTTUO1LcuWbV3sdxI4
pqvPNzz+tO0w4aj6vyyUe0P5W7VolvtsFY+ggRDroPioTnqOwq+9BnJuknlb+98/
UmYyb+CSZq94i0NqDHoG
=EjiJ
-----END PGP SIGNATURE-----

--zN/UJhV2gvyhY9D2--
