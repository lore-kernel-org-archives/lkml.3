Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbaH2RiC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:38:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39929 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbaH2Rh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:37:58 -0400
Date: Fri, 29 Aug 2014 18:37:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140829173752.GX29327@sirena.org.uk>
References: <1409328631-1420-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3rzwkXnKuCXxoL5m"
Content-Disposition: inline
In-Reply-To: <1409328631-1420-1-git-send-email-geert@linux-m68k.org>
X-Cookie: Simulated picture.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] spi/drivers: Restrict COMPILE_TEST by HAS_DMA where
 needed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3rzwkXnKuCXxoL5m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 29, 2014 at 06:10:31PM +0200, Geert Uytterhoeven wrote:
> commit dd1053a93fdc11d4 ("spi/drivers: Enable build of drivers with
> COMPILE_TEST") allows compile-testing drivers on platforms they're not
> meant for.

> However, adding "|| COMPILE_TEST" bypasses all other implicit dependencies
> assumed by the platform dependencies before, like HAS_DMA.

I'm wondering if it isn't better to have the non-DMA platforms define
stub (always error) DMA functions instead - it's less error prone and
with SPI there's a bunch of drivers which can run perfectly usefully
without DMA while optionally supporting DMA.

--3rzwkXnKuCXxoL5m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUALptAAoJELSic+t+oim9bpkQAJHNOC2yvPbLATeGvprRG/oz
jfMp6VloNmwGxLw6pXAU3LUtsAp16PMsVmX9+e97/FnzZVTx6eDBeu4RAH+dzxiy
7yhLPiYHeUxLI4kwyDjzDyTjJeUlKuGUgxnwYnNT1AJMD3/9S378bbA6YymI2+4H
FehyFzUff7OhAZdnhPs3m16KSqczwb767bc7TbwOdcmNx3eF4O3psCgLCSWUuxn/
TQy29aVPhv7WWyY9UrM1Uwe+oFXRdJP4UvtpfERmjZ9TWk0/f4lQ06/0j8ynd0Es
TxVJmD7YvEl996KY7Tv5mp776shj9uEMY7+aPfOPCYcGoIIzn9DxvtrW5CpND0l5
RyCiBjegYEwld7QkPLezuZmD1XJ+9+boAEOUMyoHdscuo8H5U6W+KgFQdGh/jn56
J4w92hL0IcX/KckYy12Z5/oEtgaOl/cqvq9GNgC0uGRMKwjUD/22BkGvyJ1RKeTs
BIacO7qezUG1iWSuWx0FQykET5QpNxLIEO9o2+gE4YXC5KjuQSSHHhurnWjj3WDb
tK9fc1cfuQLCowBj5g7r8Sb2omRf8/48jwkR7t8qNP/6ZLd+qd6puJgnTJ/4hp3n
jHwoeoP5wQeht+IwsOKEnfO+tmcOFyTzxQIAXJtDyaz4wRZnuhXhMTj+o9nyqbOk
e7E9hl3fevS15/ILnmNj
=dTG9
-----END PGP SIGNATURE-----

--3rzwkXnKuCXxoL5m--
