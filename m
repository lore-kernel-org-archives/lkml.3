Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935446Ab3DHMB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 08:01:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60927 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760345Ab3DHMB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 08:01:27 -0400
Date: Mon, 8 Apr 2013 13:01:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH] regmap: don't corrupt work buffer in _regmap_raw_write()
Message-ID: <20130408120059.GF9243@opensource.wolfsonmicro.com>
References: <1363820522-25954-1-git-send-email-swarren@wwwdotorg.org>
 <20130321190939.GI15926@opensource.wolfsonmicro.com>
 <1365416662.1830.86.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cgrdyab2wu3Akvjd"
Content-Disposition: inline
In-Reply-To: <1365416662.1830.86.camel@x61.thuisdomein>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 08, 2013 at 12:24:22PM +0200, Paul Bolle wrote:

> 0) This patch ended up as mainline commit
> bc8ce4afd7ee7e1421c935d24b1f879f82afdd4e, which is part of v3.9-rc6.

Numbering your paragraphs and using full commit IDs like this doesn't
help with legibility...

> 2) The following (draft) patch silences this warning. I'm a bit
> uncertain what the regmap_parse_*() functions are meant to do. So I'd
> like to first ask whether something along these lines is acceptable.

Nope, this breaks v3.9 - in that version they both modify in place and
return the parsed value.  In v3.10 it already does what you have because
the in place and return value versions have been split.

We need to either revert the commit from v3.9 on the basis that nobody
noticed the issue until some other work so it can't be that bad or come
up with a more invasive fix, at this point in the cycle I'm more
inclined to do the latter.

--Cgrdyab2wu3Akvjd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRYrGDAAoJELSic+t+oim9YvIP/17UYidvAm5xHTplNed1yhcq
jnX11NehQnnMDomPxeIJebyKUbAwC5lxz1xwaVcwKHdtobHgkJUWz1iPu2CfINlr
FDQhpPQsMU9eSHqcM8n7XkV6rsKfe9J92cf3z9bNUSfTcfUhvrX0DnYHBHsyX5lk
ExCuHULiAUgOpf9SHjMpUoKGXj2QbrrckNVrQY+e5yhuUC91bVsX8SjmJ4dea/pQ
7YNrFZe2Ep7IcH2hXowcotfKJbf8EBzHmo9Lg15UMZ0KNz9EtJuXpXpupExvF6C1
ShmkTrM/sflvQ/wOswMgdL2j0dk+Un5jwItj8h2GOVsShfoCDAhhWnk10JFYyBkV
lrNu9hPj0bSO5D70y44kLuDYsvVJza9Il0O8c93l8/XcpSrH3+lxczczrYTpelDV
oSTyDj/s93FzWIAbNkkS+AIkYzQpSKQnDemIs0UGT3zbvWP2PELQadfJAVABf7gN
dOxFraJS6CYSeEqZppTsvQp52uG+ZTMl4WbP1ZjjLnR5HnlH5R9kgv3Gl91vfO3F
I6SE+jJqU6wW6r5kdEiiAp7eqB4wT1VNclB/yVm/ybTNc+S+fwDJ5uXaXncYzgcl
hq7GIzjd9m4WtSlLjPzJxCuisEZzGdP6BqEzd9KnWLmXJViv5xDxmCIcAGybsKZC
hJW6zCwhTzHc9t/JdTRx
=iXfk
-----END PGP SIGNATURE-----

--Cgrdyab2wu3Akvjd--
