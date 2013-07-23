Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934090Ab3GWTcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:32:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49766 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599Ab3GWTcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:32:08 -0400
Date: Tue, 23 Jul 2013 20:31:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tomasz Figa <t.figa@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        arnd@arndb.de, swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <20130723193105.GP9858@sirena.org.uk>
References: <Pine.LNX.4.44L0.1307231017290.1304-100000@iolanthe.rowland.org>
 <51EE9EC0.6060905@ti.com>
 <20130723161846.GD2486@kroah.com>
 <1446965.6APW5ZgLBW@amdc1227>
 <20130723173710.GB28284@kroah.com>
 <20130723174456.GM9858@sirena.org.uk>
 <20130723180110.GA8688@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8lT/blNmSiRvUClR"
Content-Disposition: inline
In-Reply-To: <20130723180110.GA8688@kroah.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8lT/blNmSiRvUClR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 23, 2013 at 11:01:10AM -0700, Greg KH wrote:
> On Tue, Jul 23, 2013 at 06:44:56PM +0100, Mark Brown wrote:

> > What are the problems you are seeing with doing things with lookups?

> You don't "know" the id of the device you are looking up, due to
> multiple devices being in the system (dynamic ids, look back earlier in
> this thread for details about that.)

I got copied in very late so don't have most of the thread I'm afraid,=20
I did try looking at web archives but didn't see a clear problem
statement.  In any case this is why the APIs doing lookups do the
lookups in the context of the requesting device - devices ask for
whatever name they use locally.

> > Having to write platform data for everything gets old fast and the code
> > duplication is pretty tedious...

> Adding a single pointer is "tedious"?  Where is the "name" that you are
> going to lookup going to come from?  That code doesn't write itself...

It's adding platform data in the first place that gets tedious - and of
course there's also DT and ACPI to worry about, it's not just a case of
platform data and then you're done.  Pushing the lookup into library
code means that drivers don't have to worry about any of this stuff.

For most of the APIs doing this there is a clear and unambiguous name in
the hardware that can be used (and for hardware process reasons is
unlikely to get changed).  The major exception to this is the clock API
since it is relatively rare to have clear, segregated IP level
information for IPs baked into larger chips.  The other APIs tend to be
establishing chip to chip links.

--8lT/blNmSiRvUClR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7tn2AAoJELSic+t+oim9Lt8P/0Dr/y8rOX+c7njkBOSuJ7B1
6yi2fPPSUkKrUhOfZa5A0uxUEt8uwmS1UC2Pr8uQTkB2fUPYQlX5RKk0pIhA67cE
KskF4dEVJNR7Nbgxon+pgL4foEUG8wXM4AF+aeo4ySUyBmOxfqpZoK1qjTP1/6CF
wR9cdaQAFLVNbNcHFEhSJFST1WjoSe+irYwHVtgYWkIBz+qxkEm/LHPgBibexzOu
EhCb5gFEu0mDL4kb4UI2fVv/+3yEaa8uztspHRrsfTmQUbdW4o0D4ABTowt6XqAT
Sk9fsjG0Cch71XKNi5SlJB3JAAvgyQo7lT5pWZGRh/VCDzjnHtsl/eG2Gw7SvlPm
BttItQrUDBtYi9zkv1helwmpkEYDo+VB8zNJi1YylVTawUGUrWNcT7K9PopPi9U6
9ARkE+CdqZ+KQp2y9l7sEEuT9U6dHFP8PtQhpCyOmzW8CNSPsGuUGsIdVuXzBlnU
70AQsNLDeiER4avfEWBseWI76w70LHZr0HnwJm4CgVtlcNcLJ0bXI5bVr+TPZS2u
YaXVg8pAcaClc7USC+pJVDkQEubM7u/PwZw/AOiyx9WIWVhtmnheNM+SBs3KjVOR
YXN6/jf8T+tOa3TvP7MYenPxf6APJxtiuAenpTWffBJ7HBPhTbQb0ubHuE6fjJ4x
NxsYGz7vNFP7+uV99BsF
=Tgf5
-----END PGP SIGNATURE-----

--8lT/blNmSiRvUClR--
