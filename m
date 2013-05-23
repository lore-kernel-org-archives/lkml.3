Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758970Ab3EWOFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 10:05:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49107 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758716Ab3EWOFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 10:05:11 -0400
Date: Thu, 23 May 2013 09:05:03 -0500
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Davide Ciminaghi <ciminaghi@gnudd.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Message-ID: <20130523140503.GD2412@sirena.org.uk>
References: <1369314377-22873-1-git-send-email-lars@metafoo.de>
 <1369314377-22873-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="76DTJ5CE0DCVQemd"
Content-Disposition: inline
In-Reply-To: <1369314377-22873-2-git-send-email-lars@metafoo.de>
X-Cookie: You enjoy the company of other people.
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


--76DTJ5CE0DCVQemd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 23, 2013 at 03:06:16PM +0200, Lars-Peter Clausen wrote:

> This patch updates the adds a flags parameter to the regmap lock and unlock
> callbacks and uses spin_lock_irqsave() and spin_unlock_restore() for the mmio
> case. This allows us to use regmap-mmio from different contexts.

This seems really invasive, why not just have the lock that gets passed
in point to a struct which has both the lock and the flags?  As far as
the core is concerned the lock is just whatever data is required to do
the locking, the fact that it's actually two values is an implementation
detail of this locking implementation.

--76DTJ5CE0DCVQemd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRniIMAAoJELSic+t+oim9Az8QAIziXKQ1EQqsJvJCvvHF72aJ
HYL18aZ49mq64kihvipAvlUpzwtr0AMnusuyLL+oaCWcyR65dYOrR4ZnuhDjEUU5
MDiLBmmr/3nkaeYlyrso7KlZ0SHmdzDUP4+cyFAJZBXuLWZmSOyTY1aJsBTfmYG3
IH/Icz2LPE3/d77IcFN2rAlUsMcyrC0oKV+DAgC9X5TlIAVWHb5lX3gxGqFpTiqu
NLtsPCeRQGpQjwli2mth3Yczlrruu7N3uYEDVg44TNgSFfqK1mI7fiE8dY2LmOkX
NJHN0JgZWNBRSvCAXSP9A/LSPAGmRZRNhiu7YnNmMEm6Sv7X9A9Uq50flazAZSNs
oRp9rOr3PxEfaBxXI5BMYUwod87+D8r2pBYjrAdfjupjTa0bej8d80yjvI53EV0f
ZwhNoi9/1zhvu7HhFbQv2Eo2rt3OSsJe9cF3GMukrVUKDfaydaYUaV8F+1CmIVbT
R9sSmzWdympo9tczY+HBiqhejfspA56md5DSXqVy3wSeX10FIPg8LmnxbU9FN8w0
aVqLdhKzCslz8DP3qxX2ceRb+bMddkc32YlsNS6gri2jNQiDWpT90zJSvJc3T3Cp
RF7iGKGmh3WfWBQ7pUL43knXJIFxTur7+hTEnY4RdyqYttP1bO5mdXKayvfRmlUw
QgtZA5s7g7VizhXJXrWR
=e31D
-----END PGP SIGNATURE-----

--76DTJ5CE0DCVQemd--
