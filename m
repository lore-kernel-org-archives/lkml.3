Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaEABSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 21:18:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53352 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaEABSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 21:18:20 -0400
Date: Wed, 30 Apr 2014 18:18:11 -0700
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-ID: <20140501011811.GF3245@sirena.org.uk>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140429183758.GH15125@sirena.org.uk>
 <20140430180609.GC3000@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Content-Disposition: inline
In-Reply-To: <20140430180609.GC3000@lukather>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 12.104.145.3
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 30, 2014 at 11:06:09AM -0700, Maxime Ripard wrote:
> On Tue, Apr 29, 2014 at 11:37:58AM -0700, Mark Brown wrote:

> > Why can we not handle this by using sysfs to bind spidev to the
> > device?

> I just tried it, and apparently, you can't really use this, since spi
> devices are created from the device tree (or ACPI) whenever the master
> registers.

Can you be more specific as to what the issue is here?  If we actually
have a specific kernel driver for a device I would strongly expect that
we would want to use it and not spidev, if we don't have one I don't see
the issue.

> It doesn't really work either for a device that would be bound to a
> driver, that you unbind, and then try to bind to spidev instead. It
> looks like the device is released whenever you unbind it, so you can't
> really use it afterwards.

I guess this is the issue...  what exactly is the use case here?  I
would only expect spidev to be used if there is no in kernel driver for
a device.

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTYaDLAAoJELSic+t+oim9RtMP/R8l2pDy3bqibqmHefkf49sM
hAPUtyVAW8E7b9ZafpJBwSov5k7zhsIk9mMqVLGtYQ2FH4TDc6mOTqfC9c5ykynu
gHWvbMifqZbFfIk+kARGw93ezt403DpM/N1nzOdoqyk7QL83r7AjhtWYCyaYmGxi
ORqpGkC787ppKZYdG0SdO8+SVem9esBGPf9fwwWlnfQAa6uH60k0U/3UkyRgm892
U0tuEpi5/Es19IfZdGIdKwP3x9yBzTe5yKGMjvXX/1oEtXrCKAp1UMgZzyXwmlwV
gzS7S3FgdoPB512AV8d/FllXaU7BbCTjORxa1P018lq3YPL2e1cHeOBcqIQf4nQL
rsSantc1xety9avVtVeDyiQqclnuMLr+4t/xJ4Lt50P+N+lCms1kUGWRg+4TmMzT
xJ0n6cA3Zkso4rcCECSL1I4uC2uSHH2yZ4O+DZowZ2oV1nnj7E9wI2fyF+bH8Ha7
miEGewzxYfGF/wR0IVhHaTveOKH6XImFN5/pFYL6lJdk8ASARVI1JPRWIxeV0JEi
2q06gUmy3JT19fELJUMsZxEFCPkxjaC7B8GSE3ij78DlzbaswEOvT0An5ULTxptP
jkvxr2xWacn5yI8M/ttJqPrv0hHB2P+sdXbBRsS1b9pLI8sLMqVby7w2rgl3TSU7
ADYu6PDek4BqTJwXQA9U
=4Smf
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
