Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab3GAK6U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:58:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48591 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab3GAK6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:58:18 -0400
Date: Mon, 1 Jul 2013 11:57:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Ryan Mallon <rmallon@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net, mika.westerberg@iki.fi,
        grant.likely@linaro.org
Message-ID: <20130701105750.GI27646@sirena.org.uk>
References: <201306281142.36525.hartleys@visionengravers.com>
 <51CE18FD.8010806@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c1fg3L4mF9LDY2ql"
Content-Disposition: inline
In-Reply-To: <51CE18FD.8010806@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/8] spi: spi-ep93xx: use read,write instead of __raw_*
 variants
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c1fg3L4mF9LDY2ql
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 29, 2013 at 09:15:09AM +1000, Ryan Mallon wrote:
> On 29/06/13 04:42, H Hartley Sweeten wrote:

> > -static inline u8
> > -ep93xx_spi_read_u8(const struct ep93xx_spi *spi, u16 reg)
> > -{
> > -	return __raw_readb(spi->regs_base + reg);
> > -}

> Is there a particular reason to drop these functions? It's basically just
> bike-shedding, but they can make the code more readable at very little
> cost. Even dropping the inline (which is preferred nowdays) the compiler
> will still inline these, and it would also make this patch much smaller
> to keep them.

I tend to agree, it's much more normal to have the base + reg in a
function than not.

--c1fg3L4mF9LDY2ql
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0WCqAAoJELSic+t+oim9558P/2Fd3AZOy5T6rdW6KtOLwD1Q
gpxZurP31wyt33bMMhlMk1QXSlMWNIvAe/+ItHhrA3+3zszKIpix5ZZMLGLcS2/E
flIgbWlgzRYb60zTJNBcOjjrZvEwnSU5WBhqMKAIVFVxHpLHhrsRGjqhDDdLdkh0
JG5/1OhzZ4r7pisxjznGycj4dyhlI8BCu2XlP6Mk23w8dlIb6BpOUzQiL1M8y0M9
IJ9h1I9h9caIjuRh3liuiSOWEJ01cZs/k5r4tD6MatfQ/7XeEU8SMcCU+5fc0PmO
ltLSvILqU/ckXpYTJFZzIzLaHHUXgzBzU6FIhSWsTjufaBYoE0ACE/ueQRrh59SI
tjwBv0ucfuHm9PktBK76L89uCJP5TBYlqSbe1BzlWsFeFiwqs4chaXXjMSmzNuKq
ZWuf6VaZ65/ikzaqPNjlaVQOF0WVnqQk9B5/8NNlH1zpQDNHKAr8JKGgoViJzPM+
YooAhqlGPkXGaAYNiXXiK0vil3bLRIHQKd4ngJPdbjr6NqM6usJbPetkXrl1trBZ
J/LgXMfmR7UQtHn+niZI0wR/z/x2j2lkpG6iPtyZneL7aPRWJUeGf7QBbCzd8FAo
5Yj8pjCq/Cyh1/qgV2d6oSvLo7l5In/ln9psRZphJJ+/7d96NiSSVW/V8jXp3s4n
JFVFJK+Nn94CKYcMThK8
=pdho
-----END PGP SIGNATURE-----

--c1fg3L4mF9LDY2ql--
