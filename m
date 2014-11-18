Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbaKRPBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:01:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48774 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754427AbaKRPBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:01:09 -0500
Date: Tue, 18 Nov 2014 15:00:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>, linus.walleij@linaro.org,
        gnurou@gmail.com, alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org
Message-ID: <20141118150039.GO22111@sirena.org.uk>
References: <20141111165227.GA24344@opensource.wolfsonmicro.com>
 <20141111171532.GA26106@opensource.wolfsonmicro.com>
 <20141113101228.GE24004@x1>
 <20141113164017.GA12443@opensource.wolfsonmicro.com>
 <20141117121648.GP24004@x1>
 <20141117125433.GA29518@opensource.wolfsonmicro.com>
 <20141117151318.GE12443@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XMHqbYJb993HXwLR"
Content-Disposition: inline
In-Reply-To: <20141117151318.GE12443@opensource.wolfsonmicro.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 81.128.185.34
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] mfd: arizona: Add support for CS47L24
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XMHqbYJb993HXwLR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 17, 2014 at 03:13:18PM +0000, Charles Keepax wrote:

> 1) We could add #defines for various IP blocks and the readable
> callback could include these defines for various blocks. Which
> would reduce the duplication between chips. Although a lot of the
> blocks have small differences between chips which might hurt some
> of the benefits and this does also have some negative affects on the
> greppability of it all. This could also be done as functions then
> some of the differences could be taken into account locally for
> each block but that hurts the performance and probably
> readability.

I don't follow this suggestion, sorry.

> 2) We could add a function to the regmap core that makes any
> register with a default or marked as volatile readable. That
> would remove the readable callback completely and not really hurt
> greppability (assuming we could change the default array to use
> the #defines for the register) but at fairly large runtime cost.
> We would have to search the default array everytime we wanted to
> check if a register is readable.

This sounds far too expensive at runtime, especially for large register
sets.  You can do tables of ranges but that's much more efficient since
the expecation is that if you're using that there's an order of
magnitude size difference.

Honestly I'm not sure I see a big problem with the large tables; they're
large but not hard to think about, from my point of view large blocks of
code are scary but large blocks of data, meh.

--XMHqbYJb993HXwLR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUa18WAAoJECTWi3JdVIfQx3wH/RKKaJBIleU5rrOwi5AxJweQ
xRRFSuhxjq6i357ZPoDctGjsU9AEBsm1NjgreyqgxeL2t8PZv6GiICmRMo9KWU3e
CgoqlfsVZYvtt8jZZ+NLkBy39oPIaJbFPZEDhe+F2Gks5SgNsPyGJWLAwEneTTt7
NrahWPA9j304ll4bco+4MVCOs5IE7YXx+PNADTCFiIV3mcWq2AdVi90ZT8Thi//A
W8GUVj8oTcfK4ntIKCrm5TxX9TH/FOIcTMHiwBYI3V0cfNTTxpRlb+9NqwAWL+ZF
pwFEm87CMzB8Ph0Q5XhaazgHklZJzkEyGkTVP7QKf83dgMa9X1+UavESWddYclc=
=xleV
-----END PGP SIGNATURE-----

--XMHqbYJb993HXwLR--
