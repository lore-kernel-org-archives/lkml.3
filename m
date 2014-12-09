Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaLISse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 13:48:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53460 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbaLISsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 13:48:32 -0500
Date: Tue, 9 Dec 2014 18:48:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141209184817.GH11764@sirena.org.uk>
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
 <20141209161420.GJ1934@sirena.org.uk>
 <54873B8E.1060106@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tH81YkO9bF1TqYxP"
Content-Disposition: inline
In-Reply-To: <54873B8E.1060106@topic.nl>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] drivers/regulator/core.c: Don't print error on
 EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tH81YkO9bF1TqYxP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 09, 2014 at 07:12:30PM +0100, Mike Looijmans wrote:
> On 12/09/2014 05:14 PM, Mark Brown wrote:

> >>If a regulator depends on another regulator that happens to be called
> >>later, the kernel always prints a message like this:
> >>  reg-fixed-voltage regulator_sd1: Failed to find supply vin
> >>Since the deferral is not something fatal, nor even something the user
> >>may need to be aware about, reduce the message to debug level.

> Can we instead at least reduce it to WARN or INFO level then?

You appear to have deleted my reply here...  one problem with your
suggestion is that it means we have to special case all error handling
on probe for deferral which isn't wonderful.

> I have to explain over and over again that there's no problem when that
> message comes along ten times in a row. And it causes people to overlook the
> messages that really are errors.

Can we do something with the log message that triggers on probe
deferral?  There tends to be a learning curve with probe deferral but
the fact that it's generally extremely noisy tends to be useful - I
usually point people at that (not just in the context at regulators) and
tell them not to worry unless debugging.

--tH81YkO9bF1TqYxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUh0PwAAoJECTWi3JdVIfQqB8H/RYPEWBXjRWoSoiDNNfdvnSJ
d3a7UThLPKn1Y53yoKdZMx/FQhbqoPUwajUYKGUvjsFMlK1QPj104LUXUlQ6QV/q
lr9M9cloAp0xnErL+64OpRNvPh8HTYquXRMiRe1o7TKBC4/ZRZbW8t6xL3uhrEmV
onMm04MVpVKzqhlG43DBc/1xRdNU6G9sgmjPkUn/svcamXfz0xyjs3oe8y6XeEYf
UeSEsfuoehdIwRlzkn6Pearas2060lxu2K1hNVKVaHlaV22HonPpoCpGOYN/dKKP
fO82GkdBVo5bvuCRlKWtAbkeTKdLdVhSOUW4dGcVLhOHiyVyp4ksLQMvdCkvhQo=
=YB9b
-----END PGP SIGNATURE-----

--tH81YkO9bF1TqYxP--
