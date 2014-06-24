Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaFXPiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:38:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55807 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaFXPiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:38:20 -0400
Date: Tue, 24 Jun 2014 16:38:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140624153812.GT23300@sirena.org.uk>
References: <1402757665-15102-1-git-send-email-robert.jarzmik@free.fr>
 <20140617144323.GU5099@sirena.org.uk>
 <87oaxrs5wb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9r3HF47jptiQlX4s"
Content-Disposition: inline
In-Reply-To: <87oaxrs5wb.fsf@free.fr>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: max1586 add device-tree support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9r3HF47jptiQlX4s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 17, 2014 at 09:16:52PM +0200, Robert Jarzmik wrote:
> Mark Brown <broonie@kernel.org> writes:
> > On Sat, Jun 14, 2014 at 04:54:24PM +0200, Robert Jarzmik wrote:

> >> +	matched = of_regulator_match(dev, np, rmatch, ARRAY_SIZE(rmatch));
> >> +	of_node_put(np);
> >> +	if (matched <= 0)
> >> +		return matched;

> > Why is this treating zero as an error?  We should be able to at least
> > report the current state of regulators even if none are configured in
> > the device tree.

> Euh how so an error ?

> If 0 is returned, this means no regulators are found in device-tree. It's not an
> error, it's a lack of regulators (ie. no Output_V3 and no Output_V6), and no
> more handling is necessary in this function, while returning "ok", ie 0 ...

OK, so there's just nothing to do in that case.  That's fine, but it's
just not at all clear from the code.  A comment would help.

> As for the "state report", this max1586 doesn't report anything, it cannot even
> be queried about the current voltage, sic ...

It can't?  That's unfortunate, though I was able to turn up a datasheet
which appears to support that.

> If you want me to modify this bit I need a bit more of an explanation to
> understand.

Where the driver is doing unusual things if they are actually sensible
then the change needs to be clearer about why.

--9r3HF47jptiQlX4s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqZthAAoJELSic+t+oim9Fz8P/3emk2uOeeFB7ylGHAa942DQ
9A0tfjtpqeWiae0JkYfUFfZ0ZtagqiJ1OwEHJH+6ccQM1bRtff1+RHSs32N90FDv
B7J0VPzAhCLnOwI9gO/gvebdQx5Ig0LYeVHAAishl7a9nE4JDgNziMchXuI/BCJr
6W1qVgq6Dzgi5KcnyAjEkqY1sj/qfRENhCfoLps/X+V0U5xPr9pNavG9O7zTOz0L
mvLJWz2vkpzkgLhNVEoi7T2G5/lRfbZcOy44yu492tbpvZV5cJpH0LYEYW0AtXEE
Lf+319qluANzwalsrG1QA58wVSsWcO06kLSw43NSj6eO/8XE2hsnLMTCUvUM27f8
+cNRmfdf2rAXeczivFqjABgStTLgaJtYwLVwzGkzC4wGXGRmR7MRM6lGTHYwEc24
PlBG00NAc/R/XPbviX4y3Vv9PgKFQbCMH8IiOYEj08yPf6esqf/IMRj/Ld5tVPWL
ohDxAtB68kao4ev/W1l6i5VSBQS7f/1WmpMYHHAIYOhZ2xxGQdK2nul5RlirqJsc
Pap8aPi1bRde0HSL3e5YKBUPELRto2iDnKLdMBMkKdOmxq/ISKGwgexNGrixF047
DElPDJSOPRSohZ8YOSFuHQuZhHs9MEpVilTVwwUlxI3R4RBG3ehkVW+j2rNOIRRf
nkXQouG7qRruKK04QcLT
=10eV
-----END PGP SIGNATURE-----

--9r3HF47jptiQlX4s--
