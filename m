Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbaBYM0z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:26:55 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51640 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBYM0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:26:53 -0500
Date: Tue, 25 Feb 2014 21:26:44 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Message-ID: <20140225122644.GC25940@sirena.org.uk>
References: <1393322627-26543-1-git-send-email-mpa@pengutronix.de>
 <1393322627-26543-3-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wGZpEX6UbbPWu7G/"
Content-Disposition: inline
In-Reply-To: <1393322627-26543-3-git-send-email-mpa@pengutronix.de>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: core: Error on not always_on dummy
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wGZpEX6UbbPWu7G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 25, 2014 at 11:03:47AM +0100, Markus Pargmann wrote:
> It does not make sense to have dummy/fixed regulators that are not
> always_on. This patch adds a check in the set_machine_constraints
> function for this case and returns -EINVAL if such a regulator is
> registered.

Such a regulator isn't going to be useful in a system but that doesn't
mean that they shouldn't be registerable since that allows people to
look at their state.  For example a device might have some GPIO managed
regulators where the GPIO is tied low if the regulator isn't in use in
the system.

--wGZpEX6UbbPWu7G/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDIwBAAoJELSic+t+oim9q98P/3AL8bdvIAMKKGl7OpfqhT13
NJ/n6fWmnWqiwtWH2s1ot7UzkxEvhBP30irCGipjlgibucpOU/NC05GSNO2Qm5KB
YXfWCOVnuSrfDaSy8FQlyjTkUcA0ZIP7FUxZ/0e52rr9ziz1tCZ2xexn5EkN0ow+
HGXHEdUy6dHj2SPiHOh1XETeEiwIgp+pMIrPwsOPiNmtf8kUKAnLOsr6ZLSRuZjU
HZ0siMpMPldtCfrG1h4El1bqmLQ95xIbZ5q6peST+5jxIeR/OT/gLYAtLLVnPyRs
DeKnqB0dbAmry5xmWSelepV7cHCcN3K62mbP5sRpbNrfWBVxYz1cNl/OHi57/TDR
7dwnqnppbuDX5rcc3F5eRp5iRadiYodxieiePzXtC9BRXIqOtXJ6gig7LGMoGRhC
ft72bk7al6xej2TIBpv/DSYbvgXR9UAogvtgUsuArelYzv1/+xuNOBoCPtqNsniC
oJflQPzryK8ACSNSrizBA+SeEjpWT0NWyYDUFd4KuMzSumHvKFTSgkY8BtxvoOhJ
AkwjTwmj471Q787XiIdrUQ21LQNmseWdj4qUrPQY6hl0uTcrW+9O6iVeWqBpGO1J
eV2AAhc6yqgT4syiPZFPdq8a+lSa4FuA1jFpF7zXsksDzjpGJjcRaI2Asp2L/g70
Z94ThsFQKhiPc4Hxgn0A
=xio0
-----END PGP SIGNATURE-----

--wGZpEX6UbbPWu7G/--
