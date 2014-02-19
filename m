Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBSBqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 20:46:42 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38230 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaBSBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 20:46:40 -0500
Date: Wed, 19 Feb 2014 10:46:15 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Message-ID: <20140219014615.GK2669@sirena.org.uk>
References: <1392577256-20475-1-git-send-email-mpa@pengutronix.de>
 <20140218001420.GF2669@sirena.org.uk>
 <20140218214007.GE10590@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2gg7fA5kVn3CgPY0"
Content-Disposition: inline
In-Reply-To: <20140218214007.GE10590@pengutronix.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.38
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core bugfix: Use normal enable for always_on
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2gg7fA5kVn3CgPY0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 10:40:07PM +0100, Markus Pargmann wrote:
> On Tue, Feb 18, 2014 at 09:14:20AM +0900, Mark Brown wrote:

> > I don't understand this.  Why is this called _no_delay() and why don't
> > we want to delay when applying constraints?  We don't want to ever be in
> > a position where we think a supply is enabled but it has in fact not
> > finished ramping, and of course enable() may in fact be blocking anyway.

> I tried not to modify the current behaviour of the core driver for
> non-gpio regulators. Before this patch only ops->enable() was called
> which also didn't have a delay. So I seperated the non-delay enable
> function to have the same behaviour for normal regulators.

No, that's not good.  The fact that it wasn't applying delays is going
to be a bug - it should've been doing that.

> Also the constraints are applied when registering a new regulator. For
> "boot-on" we should not delay because this regulator is already on by
> definition. But I am not sure what to do with always-on regulators?

I'd just always apply a delay, it's simpler and more robust.

--2gg7fA5kVn3CgPY0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBAzkAAoJELSic+t+oim93f0P/jsvjI3BJckhg1DQ3k8zwwE3
cOksyY6an5fwm2HcDkueQvBo/A976SzLpTlLGNugFKUDNsROGGM8VjgEDUlx8rMR
TZqkCuenvX2odT5z37HmxUeBGF4i6i7vfQwSQq2wBSe8vQ1h1+1LN1CEf9HlFseB
MyEevZ7QS3pPbrM8CgPMiQcdGgKANOpWD41mJjE4TCFXdgSuAO/T1UaPha3h5pYZ
PpFSFwZm/4V2irnG+ziYxb4eKJ2x21YjYFlXlcP4LXmRo04Qw1+4oqdgdUXvefTn
Cvk6K3amiU+4GC6Y8HtPoDpfHHXsFFM4Pn8lP2mGxZ0ASrlVuLLKpuw95WM9i92F
obv0uBJ6qwEOEqgjN9sVbNAAuzMLvhtKCjpHi76ezB+8B2RqweQDPAILjm3QyoSq
okoNfDRiWSv+MoPJ8M744ohJMRZZ+NW5rIsJi5KgwsrDpP0DLREV+qfmrsNUR1Nh
OgAj60BVc+VXUJuCLm+M4NDiSlfNyYoB2L32LVzxSIjy5blDB39wOzTJg3A+ZGOW
pJ+EjrSR2cDtj+oFUYUQKs3qzVet54c1+nLCzpM3ewXfdeFJsxk/E0a8nsMLodnu
8iHahDMJyDLfDhl6fsAGbqL2KZYEMANVCZmU0Spjwx2LCe1SDp6eoQC8MIifOaba
1PVPJZ0qW9HIwyEdTj1M
=F43P
-----END PGP SIGNATURE-----

--2gg7fA5kVn3CgPY0--
