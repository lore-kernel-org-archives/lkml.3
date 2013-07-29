Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab3G2FAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 01:00:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50441 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3G2FAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 01:00:15 -0400
Date: Mon, 29 Jul 2013 06:00:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130729050011.GJ9858@sirena.org.uk>
References: <20130729134223.bbae9d9f2a9cd6ca1717c976@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XfQyFtxChl4bBa/T"
Content-Disposition: inline
In-Reply-To: <20130729134223.bbae9d9f2a9cd6ca1717c976@canb.auug.org.au>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the spi tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XfQyFtxChl4bBa/T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 01:42:23PM +1000, Stephen Rothwell wrote:

> drivers/spi/spi-pxa2xx-pxadma.c: In function 'wait_dma_channel_stop':
> drivers/spi/spi-pxa2xx-pxadma.c:136:2: error: implicit declaration of function 'DCSR' [-Werror=implicit-function-declaration]
>   while (!(DCSR(channel) & DCSR_STOPSTATE) && --limit)

> Frankly, Mark, if you are unable or unwilling to do some basic cross
> build testing, please do not do any more of these patches that add
> CONFIG_COMPILE_TEST.  Leave them to someone who can.

This was cross built.  It didn't show up due to the fact that the
minimal configs I use for build coverage (and in fact every single
config I was building) didn't have PCI turned on (which is a dependency
for this option actually building anything) which allowed this config
symbol to be enabled without showing the problem due to the slightly odd
way the config for the driver is structured; any system with PCI that's
not PXA would be affected.

Most (though not all) of the other issues have been due to similar
stuff.  I do rely on the 0 day tester for the full builds but I do pretty
routinely test (especially on x86) these days though with minimal
configs and on my full working tree.

--XfQyFtxChl4bBa/T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9fbXAAoJELSic+t+oim9rD0P/1ExWH9uwPoNp+rzUywJlqFl
uhZoqeBtXp+Q6MLLVfonMDcLxiM5hK+DyGtn0rZa1V+HuR7NYAAKkKuUiW1sElBX
oaFodOZt3u4hCda1J9ohLDLRMy+S7o0WHYkk8Ub//vzH5XJ3nKA8jsDuP+6KT52b
7hk6M2R4p0zv2GmDkhgOJDu39pE4eRZKkLo5E7N0i1CV3V8aRBPdEotn8Te1gV6S
u+e9lQg1FQ3Vjboy1Taq8VpdV9Wi2DJ7dY9TM0rDS8QfdUexXDGG/xrKYvaZDTUy
MMnltXOiyInTIPord4j1ScmPKZktdtXXGNmS3hr5RVAgyf/UpMnHIP3pw3uKhPWv
SOYYuwNOJbsWbjAjM67GTLUyPgKg+Oi4YJUYPDyhrh0i2PO2DTdxnNC3sI2nV3ja
9CNz8cm9Gb7DWOb/GFh6IDP0lZYOFyGMdeaXmNua590+uBDlUwcIdGhD6a++OWg5
6HAa8R0AFqZJYxxZQq2+73eoQ9mgnInVR5fQWn/82rfm+4TBEcHwtNbb3OIGLpgG
U2xs7jihPot9m/IqlfUw7JExw3LEFmr0RTEO6WLu9l35w6R48nySkyMHn1L/k22U
adi4tZ/kzQNJOfcjvwJ1zVhX1MrHBednM1Ly5kRRDyYzU6vVP1eHqT4QnsbpogjC
rJszbHUxLIH3icZn2Us8
=zbCY
-----END PGP SIGNATURE-----

--XfQyFtxChl4bBa/T--
