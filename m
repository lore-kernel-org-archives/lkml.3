Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759374Ab3EWQLc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 12:11:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48782 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3EWQLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 12:11:31 -0400
Date: Thu, 23 May 2013 11:10:59 -0500
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Davide Ciminaghi <ciminaghi@gnudd.com>, linux-kernel@vger.kernel.org
Message-ID: <20130523161059.GC7660@sirena.org.uk>
References: <1369314377-22873-1-git-send-email-lars@metafoo.de>
 <1369314377-22873-2-git-send-email-lars@metafoo.de>
 <519E38ED.7090202@wwwdotorg.org>
 <519E3AB7.8020103@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <519E3AB7.8020103@metafoo.de>
X-Cookie: If you can read this, you're too close.
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


--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 05:50:15PM +0200, Lars-Peter Clausen wrote:
> On 05/23/2013 05:42 PM, Stephen Warren wrote:

> > I guess the core of the issue is that you want to replace spin_lock()
> > with spin_lock_irqsave(). I'd like to see that explicitly described in
> > the commit description, if that is the core aspect of this change.

> Hm, it does.

> 	regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for
> 	locking.
> 	...
> 	This patch updates the adds a flags parameter to the regmap lock
> 	and unlock callbacks and uses spin_lock_irqsave() and
> 	spin_unlock_restore() ...

That's pretty buried in the changelog though - really all the first
paragraph needs to say is that we want to use the irqsave versions to
allow interaction with interrupt context.

--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRnj+QAAoJELSic+t+oim93n8P/AqXU1v76kfYcSTIo4s7iSyz
JZ6Ry9ofaG4Znkg3w6uyej7qEUAuohLFBNWAyLRGy+lkM73wbwgVymtAhbgnP95b
2z60zfyIwMRE/r/XVmqP1JZcQS6G54ZcyuZ7K2D0FCWyCihrKiLajMgbEC3n0u7H
03dJRykP0Iw6dPZGKdezUDMotDwopU3C+q77pEA6RlrQ0zFzsFmmrT/c2p6/yT00
pmoI55DB4+UYntu/TEfdU9zrjY3vBxBVupgYB1eC/fQde9KjmDnSJ0JzfdTUPlIZ
uVvqIzwapMjl/ItlUgrODLJEEa/bhzOgrC7Mixft8Fc3yyG/GOZPFzGLUb6BjSA3
WOaDg9xyUDNmcAqMaRweI9N1F2xxzEE/1N1fHhRVj5k3W9z6DBDfhYpwlUf+CTB7
SxLh0Jw87swOnlTQVYzlb0pRxv1DMIjcFInuRtng7/hg/0mYYEl4QezxARNc5FXL
bDcyfEjdJvdAi68mV4fsayN6trx1JjLLg8xCQNUBn0m5fiLMW0d7NKyMZAvbxM6a
c0TOHUhB0NaeTD+f8xknGUKRb5Xp4kdpE80aZOowlzXIBy8PV35RHAnX/BZWIeC9
5xStK4E78cy1T00ygjUt2tpZLjMfqLVCJSwSIoqqoO9qkORc25VzFxQXNlQicxo+
b74yQntwkAVgxXusEJrH
=ChFy
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
