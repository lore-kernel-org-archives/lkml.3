Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbaHGJz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:55:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51138 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287AbaHGJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:55:26 -0400
Date: Thu, 7 Aug 2014 10:55:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Nick Krause <xerofoiify@gmail.com>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Message-ID: <20140807095517.GD17528@sirena.org.uk>
References: <1407387060-28992-1-git-send-email-xerofoiify@gmail.com>
 <20140807052219.GA21124@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9SduuEsPMGkuhdq"
Content-Disposition: inline
In-Reply-To: <20140807052219.GA21124@roeck-us.net>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Initialize variable to prevent uninitialized warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9SduuEsPMGkuhdq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 10:22:19PM -0700, Guenter Roeck wrote:

> So if we ever hit that uninitialized case, where bits_per_word is
> neither 8 nor 16, we'll have ops set to NULL and end up wondering
> why the kernel crashes a bit further down in the code. Not really
> sure if that is an improvement.

It's not.  The goal isn't to fix the warning, it's to fix the problem
the compiler is telling you about - initialising to the wrong value is
just as bad as not being initialised at all.

--/9SduuEsPMGkuhdq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT400CAAoJELSic+t+oim9SHUP/35bVakt6XIRGvlrUfQdozO3
lS4FSF+xCtXibqyfFdYdaWqeCml8ZRDoyvc2YZOpr89ecyS7pYsxQZ4ks7sq4x8U
+XpNbzPI3LnQ2yyAVRDGDzUtILLdTgiI8/qaqpzJrFxAwLRSvHNuK3LppqIAZBcM
7U7nKU/gc5daMZTxrKf/AEw2smifZHiE+iu19+2HIoIxytG/kJtOGd2NSyGIMzS8
0YbubZaHAV33j8QdR6qw9i9eQ0gC/1FKgXmavwlHLuq3NfUB3WILIe8Granam9CV
h13INCbyIEdYiY/9dkBlwtLtnMH0MHmDyM/JyHJC+KzdZJuwjY8gAHqlsTWeSQmC
P5YHfkOrJa/hyNChanvJZ7Yl0eZQrQQQkhJFa4+mpUTplE9MuA/p0ZVfFQxkoUZM
vaKRTqkrS90nDBMsbMDiwlT34GFhrLuNJRzmIxHRCN514zwP7tAR9wJBwWRv6VDH
JqJEsA8OjGN0HNh3i5AXu3Wxe/T8zduk8mHVAiP9XDUd7IySxT0zon3pkZcwnp44
HP+GFczLMrf34vubr466WPkSS0o/df1ei0U9DtdXujccrY9ivGSYcBB6O4J7qZvw
xXbdWRSPokDSg3wh4c2OfbYPZ2UUzA15RXyyHuAROcOYpnfZUjKM/bS1axK6GUxI
nHtOLyOx3tFkYCyr6MTm
=9VsM
-----END PGP SIGNATURE-----

--/9SduuEsPMGkuhdq--
