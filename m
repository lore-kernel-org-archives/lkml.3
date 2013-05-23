Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284Ab3EWOcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:32:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41055 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab3EWOcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:32:10 -0400
Date: Thu, 23 May 2013 09:31:37 -0500
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Message-ID: <20130523143137.GH2412@sirena.org.uk>
References: <1369314377-22873-1-git-send-email-lars@metafoo.de>
 <1369314377-22873-2-git-send-email-lars@metafoo.de>
 <20130523140503.GD2412@sirena.org.uk>
 <519E25AB.4060406@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wj9ZLJVQDRFjGSdK"
Content-Disposition: inline
In-Reply-To: <519E25AB.4060406@metafoo.de>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regmap: Make regmap-mmio usable from different
 contexts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wj9ZLJVQDRFjGSdK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 04:20:27PM +0200, Lars-Peter Clausen wrote:
> On 05/23/2013 04:05 PM, Mark Brown wrote:

> > This seems really invasive, why not just have the lock that gets passed
> > in point to a struct which has both the lock and the flags?  As far as
> > the core is concerned the lock is just whatever data is required to do
> > the locking, the fact that it's actually two values is an implementation
> > detail of this locking implementation.

> I think that won't work. spin_lock_irqsave() will write to the flags
> parameter before it has successfully taken the look. So if a process running
> on another CPU tries to acquire the the lock while it is already held we'll
> end up overwriting the flags. E.g:

So you'd have to allocate a struct on the stack with a pointer and the
flags in it and initialise the pointer.  Not awesome but not the end of
the world.

--wj9ZLJVQDRFjGSdK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnihGAAoJELSic+t+oim9G8YP/0lGQLa/ImbsQu8whWyaUPq7
9RXraaHRIiQbyt/kf/GQFZx1udaUD0hr55wH6xCh++AjacEAZS+PutDPVrlZ8LrU
a8Wu5SULm0jDLsN14iR0zjpTBogULsYOek6ypdP91LGEMW07IAWKzTjJYiqT/c4T
kxfu3yFkCbRus5UvI/BXhLzy+XkxwMffSZTaJAEqGJaT28aGySzQOgsizrfFJHJf
2A3G86vpm6O2LHMiANqdIAUSyFrGS6PDONAKd3dOoM2++qD2PWU/AnUOqdjk1Ymg
IVeGYNFVS2lzQQxrAtWKAZejY8gYIDjlkoLqxIuks4H84FUrRd1nkJbH/ypMq/kL
elcP5pRI/zRUSCdKdlKD6ziScFCOCvBvIsEWRdAuiUQSUIThHbsQwPlHef2vkbvX
IFSSo95+n74PQdae/wwMdG/ex8TVpLreIjE3obTDAMStCRmIcnfTMMHZCy2tNHrK
+mzx2OYf9paujgWZ6S5Wa0346Zxj6p2VfqT7vu89osO4HwmkBoX6BWCoHUqYkAqs
G+BjKpAF/8iuA5q16lZfmp3RvJTtMWN46/rDx0mfZWKSoBDMaR/KQVBhjHXbCe/T
U3pVUXNnss6sInHaYINZcfMCWB9HbGj7urH9A0m2SXFvTtamI8xbgYT6YdYxxQOT
KZV7H7IW/jehLWZ6splL
=VqBj
-----END PGP SIGNATURE-----

--wj9ZLJVQDRFjGSdK--
