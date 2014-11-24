Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaKXP0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 10:26:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36858 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaKXP0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 10:26:35 -0500
Date: Mon, 24 Nov 2014 15:24:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Alban Bedel <alban.bedel@avionic-design.de>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
Message-ID: <20141124152433.GD7712@sirena.org.uk>
References: <1416834123-23139-1-git-send-email-alban.bedel@avionic-design.de>
 <1416834123-23139-3-git-send-email-alban.bedel@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tEFtbjk+mNEviIIX"
Content-Disposition: inline
In-Reply-To: <1416834123-23139-3-git-send-email-alban.bedel@avionic-design.de>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] devicetree: add a binding for a group of regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tEFtbjk+mNEviIIX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 02:02:02PM +0100, Alban Bedel wrote:

> +This binding allow creating a group of regulators for use with simple
> +drivers that only expect a single power supply. Additionally it is
> +possible to enforce the enable ordering to create simple power up
> +sequences.

Absoutely not, this sort of scripting is not sensible - if the consumer
device has multiple supplies the consumer device should be working with
them independently and if the consumer has ordering constraints it needs
to enforce them itself.  Trying to solve this problem with a bodge in
the regulator API just isn't the right place, leaving aside the above
most power sequences involve things other than regulators like clocks
and reset signals so just doing things purely at the regulator API level
isn't ging to solve the problem. =20

Please look for the generic power sequence stuff that was getting
discussed a while back and try to resurrect that if you feel there's a
compelling reason to have this functionality without doing it for
drivers.

--tEFtbjk+mNEviIIX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUc02xAAoJECTWi3JdVIfQAb0H+wYUhYLOS3n1+LVp11OOqK07
4PQp5AtIDF5crOcHO5pivr7gB5eqNE6KpZZWZFk5ON7HbBIkIhnSlG/6QLOSvW8v
CIZk6SRZrhemYMJ5KdqNy76ytk1jdTFPWlJ0QXKeJ+X/r7VDbyvRTFh/BIKx4EP6
Ut6WFKvYfTJZIaJ+b0FpNGd5s7kdQ+S9iGsbvjpRszM+lqJH1upNlK2GK6R9WVW7
MiIMgJBGgsohsY/YUmyY5QbqsDg9ZDLSBWWx1qzCZgRvJBVTyvl+GSo7GdctxcQV
4Dd0xZlwtJ8zh4hATHOTaFi7eDrutEsrIAiSpEOr0+yly/whwhbK2RvQrC8RDsk=
=qh7o
-----END PGP SIGNATURE-----

--tEFtbjk+mNEviIIX--
