Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3JYKQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:16:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41839 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752025Ab3JYKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:16:37 -0400
Date: Fri, 25 Oct 2013 11:16:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20131025101613.GS18506@sirena.org.uk>
References: <5256A626.4060107@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="daC8KDjlMyCcZyAo"
Content-Disposition: inline
In-Reply-To: <5256A626.4060107@nvidia.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 149.254.181.129
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Issue seen with FET re-enable during auto discharge time
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--daC8KDjlMyCcZyAo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 10, 2013 at 06:35:42PM +0530, Laxman Dewangan wrote:
> Hi Mark,

Please send messages to advertised maintainer addresses; for me upstream
things sent to my work address will not get dealt with so quickly.

> In one of our system, we are using TPS65090 which has FET switches
> for  power control. This has also the auto discharger resistance for
> turning -off.

> We observed that when we disable the FET and re-enable before it
> completely off (during power discharge time), it does not get
> enabled. It enable only if wait for it to completely off.

> Does this mean we should also provide the disable time for tuning
> off (optional) so that disable_regulator() should return after
> actually tuning off?
> In downstream, we stressed this after putting delay and it worked fine.

This is the first time I've heard of hardware with that sort of
breakage, you probably want to interview the hardware engineers...  in
any case I'd not implement this just as a delay, it seems better to
return immediately on disable and instead store or set a timer for the
earliest time that we can reenable the regulator.  The delay can then be
implemented on enable if required.  This will be more consistent with
the normal behaviour so will avoid surprises for consumers.  Of course
this is pretty uncommon so perhaps it's as well to start off with the
trivial implementation...

--daC8KDjlMyCcZyAo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSakTqAAoJELSic+t+oim95bIP/RiZQYV8t/2gR5maaiRmPysk
2pyEc9t4N85sLU07wrQAIc9V3Kv6418cHcsuXR4lMiiMf/cnB86kpIIcs7vqhNyM
dXeW5g2pKXg+k/AShUCwC+Z6eATR5MHo6losFfpUO+V20NRqwrIxVJbp6llI6uyg
78sq/OfGaFpObGBg8GAZOmQUtM8PuQV8uYFYrGXrxq1BaSqbunj/6GAyHrY/81e1
TXSTZpPRZeGf3MhB7dFEP0qVXQforn2y+MKzTyYLrpDXccOdRjZAuZV5KQrNRvW/
WoJIu6BQ9WPmOeujWmkPbuaqLBqyBDqQ3k0cJqgXZ4CEodzJCDqp8Vy4HCsFalLp
v5bZGSgg3l1P2lIaF3M7P60UTCwtvACQNUYIMRsdJz5T1pziJCQ5W0TDSwnMGg0n
4m9c3EMULK8PYAqDYaMCHGyXupaW5zKbhGwJaSC0Pbhg4y87o7Dflc0dhqVRK1Rb
Uybh6iEVWaFzjN8zKWrlINTzwrUSykGJuYjq7dPw4v2bpgbUUcwiLBFBt30qeNWW
y9QdOg3sz8q8LUKtTgsPbZV6HyIiLUcU0Mk9/FoXqBruSDnEOyjKRz/s/EN82KaE
RF1phBjiYsNUxU4QurooXgPjXnVRbkjCtXSWZSxP4yPn/d/2U6UPnzhwmN5oZXu2
O4gvpQsmqBy8OCVX3BM7
=6k+Q
-----END PGP SIGNATURE-----

--daC8KDjlMyCcZyAo--
