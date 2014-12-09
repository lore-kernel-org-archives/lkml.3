Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343AbaLIQOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:14:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53302 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaLIQOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:14:34 -0500
Date: Tue, 9 Dec 2014 16:14:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141209161420.GJ1934@sirena.org.uk>
References: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/qIPZgKzMPM+y5U5"
Content-Disposition: inline
In-Reply-To: <1418130764-22440-1-git-send-email-mike.looijmans@topic.nl>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.171.30.28
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] drivers/regulator/core.c: Don't print error on
 EPROBE_DEFER
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/qIPZgKzMPM+y5U5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 09, 2014 at 02:12:43PM +0100, Mike Looijmans wrote:
> If a regulator depends on another regulator that happens to be called
> later, the kernel always prints a message like this:
>   reg-fixed-voltage regulator_sd1: Failed to find supply vin
> Since the deferral is not something fatal, nor even something the user
> may need to be aware about, reduce the message to debug level.

No, we need to tell users if we're deferring since there's no guarantee
that the device blocking registration is ever going to be loaded - we
need to let the user know why the device isn't appearing so that they
can diagnose problems.  Yes, it's noisy and ideally we'd have something
more efficient than deferred probe but there we are.

--/qIPZgKzMPM+y5U5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhx/bAAoJECTWi3JdVIfQ29MH/2kydy0SpwwfeK5eoWSo3CQL
LQtN6hcr6+BXkHP1bWGzoKlsFMxJH21xXMZt6mTe3GutqQdOPr4brbm7TU3arQTm
J2KBQGncHMhBEFO3NhYVuDqEQrEkf/0jyQdKqrs0+KA5pU9qQeuyu6MX0LhmKlcY
jXYd03/5+Uy79pt6o0JkDtlCK0i6AL5spUulNHFsPDDiNrN5Vr73890Aw2kWD1lb
C0C4a9hW1g/kbRqbob8//xfBvqwcpx8qt+QKTuBgVM9c89v7ndGZlrTwBuZCBXHQ
gtAPRx7KoDcA4lK6lyOQ2lTL0qb8gYqs7FEfAjgV17Ctfldd4bQBVCMBairZnHU=
=l2Qh
-----END PGP SIGNATURE-----

--/qIPZgKzMPM+y5U5--
