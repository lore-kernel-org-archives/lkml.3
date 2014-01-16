Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352AbaAPR5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:57:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55756 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaAPR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:57:10 -0500
Date: Thu, 16 Jan 2014 17:56:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Saurabh Singh <saurabh1.s@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "celinux-dev@tree.celinuxforum.org" 
	<celinux-dev@tree.celinuxforum.org>,
        SREEVATSA D B <srevatsa@samsung.com>,
        Praveen BP <bp.praveen@samsung.com>
Message-ID: <20140116175653.GJ17314@sirena.org.uk>
References: <8217085.584601389885483146.JavaMail.weblogic@epml20>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3bvv0EcKsvvYeex"
Content-Disposition: inline
In-Reply-To: <8217085.584601389885483146.JavaMail.weblogic@epml20>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Re: [PATCH] Parse missing regulator constraints from device tree
 blob
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3bvv0EcKsvvYeex
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2014 at 03:18:03PM +0000, Saurabh Singh wrote:
> Hi Mark,
>=20
> > Please send patches using the process in SubmittingPatches, the formatt=
ing
> > of the submission is very important for tools like git am which people =
use to
> > work with patches.
>=20
> As per your request sending the patch and description in git format.
> Please find below the patch.
>=20
> Regards,

No, please do as I asked and follow the process in SubmittingPatches -
as I said the format things are sent in is very important for the
tooling.  Pasting the patch into a mail after some other text definitely
doesn't give a mail in the format covered in SubmittingPatches.  If in
doubt send the mail to yourself and then compare it with other patches
sent to the list and test by applying with git am and make sure the
patch and changelog come out OK.

> +- regulator-valid-modes-mask: valid operations for regulator on particul=
ar machine

This is not adequately documented, what are "valid operations" and how
would they be encoded?

> +- regulator-input-uv: regulator input voltage, only if supply is another=
 regulator

Why provide a property for this, surely if there is another regulator we
can just find out from that regulator what voltage it is outputting?

> +- regulator-initial-mode: default mode to set on startup

It is not documented what a mode is here or how one would specify it in
the property.

> +- regulator-initial-state: suspend state to set at init

Again, no semantics are provided for this.

> +- regulator-state-mem, regulator-state-disk, regulator-state-standby:
> +	defines regulator suspend to memory, suspend to disk (hibernate) and st=
andby respectively.
> +	have following sub-constarints:
> +	- regulator-state-uv: suspend voltage
> +	- regulator-state-mode: suspend regulator operating mode
> +	- regulator-state-enabled: is regulator enabled in this suspend state
> +	- regulator-state-disabled: is the regulator disbled in this suspend st=
ate

I am very nervous about the idea of putting this stuff into DT.  This
matches less and less well with modern system designs which are becoming
more and more dynamic, and of course the concepts of suspending to
memory, disk and standby are unclear and fluid - what is the difference
between memory and standby for example?

I'd be interested to know if there are real systems that need this and
can't figure out what to do dynamically.

--u3bvv0EcKsvvYeex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2B1iAAoJELSic+t+oim9iAYP/AuJHsyrofRiQ0I5yVcxno42
8nlrM5F9aDq2zrRNZhM0actKSc1tm5eGWz0hCWSO5DI6UXY4vPSd0iRYR/sP+Z+q
AzjxqTYVbUDY/zSExm0YNIZ4xSPqX4Ta6LGRxWG+t6LPPZc6YePkOrquBA72AKNS
MGEVKWdx0m0mRLEAFniqvf58FZ5NXVibCs7haZHFwg+11h+E53xIl0RlB2jlz9Ci
tnU9yWIpuX4ddizNt7089NVym9GCYo1kydPEShQd0QNPKgCviwQQAz88zwKRWXjp
HEtwgZFcqOsNL5EYOFJ+81XJiYzK91FWU2F8OXOUvbs+jLUpJZYdfb6PhGmjkG5p
bZEb3/eAn0ubToerir8uenz9Z0agCKem8JLPiMY/83I8S6kh9kD5088Xpzd4TDkF
2UQgkSQyKXLQkWYxLRdrFUI1LD/TNgQyJ9PsVbUYl25QMC7dsSPbQjlauedUqaBc
r+urFnye9StNkQRlqSXZ38V0+cjUuERcqGniyYniNGntHREgckCdkZB2bHLW23LI
6azsXzCyIwGZZ6C6qUxqzn5GStVyjRhytL2XVpBObP8yzM2FCjzz0dzGF4wLSLql
Q5hTyBLyjJDSK4pYJVnFYatuhAhrC3vQu/zAD7jHtRH1WmQnQM65dPZThLnYu0Qw
Un24a0dPkrGQHKbPwUwW
=k/RX
-----END PGP SIGNATURE-----

--u3bvv0EcKsvvYeex--
