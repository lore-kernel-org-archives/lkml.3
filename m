Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaAZMj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 07:39:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59606 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaAZMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:39:26 -0500
Date: Sun, 26 Jan 2014 12:39:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <groeck7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140126123921.GE11727@sirena.org.uk>
References: <52E4E913.6030300@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0uCeA/GhJk5vQd80"
Content-Disposition: inline
In-Reply-To: <52E4E913.6030300@roeck-us.net>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Using an optional regulator in a driver running on a PC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0uCeA/GhJk5vQd80
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 02:53:07AM -0800, Guenter Roeck wrote:

> This leads to an interesting question: How are drivers which require
> regulators (optional or not) supposed to run on a system
> which does not support devicetree, and does not have any
> regulators installed (such as a PC) ? REGULATOR_DUMMY
> isn't there anymore, and the dummy code it replaces only
> executes on devicetree based systems.

A feature like regulator_get_optional() can only work if we know about
all the regulator mappings that exist which with the current way of
registering mappings via platform data we can only do once regulators
have been registered.  This is a bit unfortunate and is why we never
used to have get_optional().

> Also, how are non-dt systems supposed to determine if an optional
> regulator exists or not ? AFAICS the regulator code always returns
> -EPROBE_DEFER, which isn't very helpful. If I just assume that
> -EPROBE_DEFER means that the regulator is not there, I end up with
> a conflict with a system which _does_ support devicetree, where
> -EPROBE_DEFER really means that the probe needs to be deferred.

It's nothing to do with devicetree, other systems can do it if they
specify full constraints.  All the core is doing is saying that it might
get told about more registrations later and not knowing if the regulator
might appear or not it's going with a conservative report.  Other
platforms need to either call regulator_have_full_constraints() when
they've registered all the mappings or do something else (OF is doing
the something else because it embeds the lookup code into the regulator
framework rather than translating and registering the mappings at boot
time).

I think platforms like PCs need to add a new way of registering mappings
outside of regulator registrations and then use those especially for
things like regulators on PCI cards.

--0uCeA/GhJk5vQd80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5QH2AAoJELSic+t+oim9dhkP/1LvrNOVs45IxlHnz+Md8Bqf
RZETDcT//N3+uwUV634qXVu3tEK2f+9U44pOVoRidlob7xLZoLEJLBjvdeH5JyVq
Mkraj4ULK983viT9YrlrvmIIoVPO0/dJR9os9j9gWHKYwW6v2INQDCM5necXZPoX
y8RZXNb+MpsDhWaE00wJpJYqyMV7XaXs/yr5SIbOet9YmqA/ZviDHaNm6BkQM3bR
xxKfwg1R7ZbmZKkEWViFDEFYdHWUM4NOAVn6U7CBpAVlQ1ynKV+qz+Rkhnf9/i4e
yPh0RipAROGc5y9Ji8rNtGENfVJtgI5XkoMTn65mmOX7324mKvgrkFeDmkfHvGNB
OidYKkOohorgkIGZl37nTeM6ROZXz7AU6pwuCRvDRlXhqRQbimItPPzTLEZjwrhk
ADOKS5253XIbjlHb3B2MBYkiLOyLGw6k6o0j/FxMaY0JGT/ditpRdWe38pIdwQhu
cmrvruT2Nr3b8vvm1HbkpK3CVMtnRKXPvVE9+lMfSynBEX5JBei5Jb3Y2+5l1iMO
BFMfgPHQAioJPdx1gpd0tuVp/HnmmFf0s9SaUdeDNQNJHibMQgLL0gAQ1FroPE1t
5IXjH4X5GpbyALkd0deOfnA87wbppxeWdc+tUCVyDKSaNRXvRK+TcTQn+lqf4dkg
wQHq0sWPCbaC2tXBwZ51
=Yprt
-----END PGP SIGNATURE-----

--0uCeA/GhJk5vQd80--
