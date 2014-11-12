Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbaKLOuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:50:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35062 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbaKLOuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:50:04 -0500
Date: Wed, 12 Nov 2014 14:48:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Allen Martin <amartin@nvidia.com>, linux-kernel@vger.kernel.org
Message-ID: <20141112144837.GI3815@sirena.org.uk>
References: <1415787125-31218-1-git-send-email-thierry.reding@gmail.com>
 <20141112114505.GE3815@sirena.org.uk>
 <20141112120201.GB30821@ulmo.nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/MX9AwMJfLT5RsGw"
Content-Disposition: inline
In-Reply-To: <20141112120201.GB30821@ulmo.nvidia.com>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: Ensure voltages are within the allowed range
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/MX9AwMJfLT5RsGw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 01:02:04PM +0100, Thierry Reding wrote:

> Perhaps rather than checking that the voltage is within the valid range
> we could at least cover the case where voltage is zero, which is what
> triggered me to write this patch.

Anything which has a voltage of zero is buggy anyway, zero volts is the
off state and should show up as such.  If we don't have a voltage then
the enable should fail.

> Do you have any recommendations to work around this other than adjusting
> the actual voltage to be within the range?

Such regulators need a way of providing a bootsrapping voltage if
they're off when we start I think.

--/MX9AwMJfLT5RsGw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY3NEAAoJECTWi3JdVIfQMJQH/28By3a3sCuIgkuNRe5017jt
howjEa7ACQ8Qqw3IGVAcRxpbkTlZHGDBno5XKyBMXGi5oiRxrelabsfhe4WT7B95
4irUfhJ3frM3aacvrmC4zw9ifM0XogYdx9cdG0fw8UnX4aYBy8zhd8pfPk7G1WCx
8QdwAFNoED04Y+iNpAYQvI0mblVXRcRKT8W8DfqDxDd9Yuq/CoRKQn3hGN/SaRS/
h2daMkQn48hVzCgOGzcokmahXvnSXMGv9cZEYi00d5sf2ATCpZAI5IYV5CiBDAEE
Fz0wetY62nwKmjnSeUPLlmSclX5SOaw5EWlmg2UBfPEV3zhEnroeSxbHxUEQOug=
=GMz1
-----END PGP SIGNATURE-----

--/MX9AwMJfLT5RsGw--
