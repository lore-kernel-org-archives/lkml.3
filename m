Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaKZTWU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 14:22:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39730 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaKZTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 14:22:18 -0500
Date: Wed, 26 Nov 2014 19:20:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20141126192021.GU7712@sirena.org.uk>
References: <546B5EF9.3080102@mentor.com>
 <546CAB49.8030103@mentor.com>
 <20141125121749.GV7712@sirena.org.uk>
 <54760D6A.9080306@mentor.com>
 <20141126175304.GM7712@sirena.org.uk>
 <5476266E.9040901@mentor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W9xFwOr4e03bkzx5"
Content-Disposition: inline
In-Reply-To: <5476266E.9040901@mentor.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Question about fixed regulator DT properties
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W9xFwOr4e03bkzx5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 26, 2014 at 09:13:50PM +0200, Vladimir Zapolskiy wrote:

> If I want to enable a fixed regulator (not controlled by
> bootloader/firmware) by Linux on boot or when fixed.ko module is bound,
> shall I specify the same "regulator-boot-on" property? At least this is
> the practical way to enable a fixed and/or gpio regulator right now, but
> is it correct?

It depends what you're trying to accomplish by doing this.

> Or should the regulator always be enabled externally (assuming
> "regulator-always-on" is omitted) after registration independently on
> "regulator-boot-on" property?

Best practice is that there should be a consumer which keeps the
regulator enabled whenever it is required.  There should normally be
little use for boot-on, it's mostly there to ease handover from the
bootloader in cases where we can't read the hardware state - if you're
not sure if you should use it the chances are you shouldn't.

--W9xFwOr4e03bkzx5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdif0AAoJECTWi3JdVIfQdvEIAIWJAQI7FT9Arcn6lb2DZpVq
j8uwo03bPTlytutv0HSFoj2/koSbCh8VkBOKzmoOmcsk6JFELEpN6NsMnIhN0qwM
9D8Defe3YqyYAoPwmBLnOl/6ygO9ICNZf8nZDZk45QHf1Q2GcWocCj+yhP33U/Ei
aCBXtrQPi/fvv2hwsT8LlAujj9llg+AEhrKfc/HMX/V2oTCs/RjuqmmGzxvPCWoM
jIXVzG4BggbxxFQEPZeOsbNXBBPzPjDInIsOOqfQ1uyqn3h1UFxuMF34K33PTwAc
WaqE8kBc34/cb7cbwlSRiV2Ly8GO7YGA39n0fucaIv4uC3bcY2CHx5sZPIP9Rwk=
=364J
-----END PGP SIGNATURE-----

--W9xFwOr4e03bkzx5--
