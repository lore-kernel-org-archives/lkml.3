Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbaJXUL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 16:11:56 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46820 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaJXULy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 16:11:54 -0400
Date: Fri, 24 Oct 2014 21:11:38 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: lgirdwood@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        airlied@linux.ie, robdclark@gmail.com, davidb@codeaurora.org,
        dri-devel@lists.freedesktop.org
Message-ID: <20141024201138.GL3729@sirena.org.uk>
References: <1414178111-19525-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z1OTrj3C7qypP14j"
Content-Disposition: inline
In-Reply-To: <1414178111-19525-1-git-send-email-balbi@ti.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: stub out devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z1OTrj3C7qypP14j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2014 at 02:15:11PM -0500, Felipe Balbi wrote:
> If we don't stup that call out, we will have
> build failures for any drivers using that function
> when .config happens to have CONFIG_REGULATOR=3Dn.
>=20
> One such case below, found with randconfig
>=20
> drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c: In function =E2=80=98mdp4_kms_in=
it=E2=80=99:
> drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:2: error: implicit declaratio=
n \

As previously and repeatedly reported the regulator usage in this driver
appears extremely problematic, among these problems is that it almost
certainly has no sensible reason to be using regulator_get_exclusive()
or any variant of it.  Sadly every time it's been raised with the video
people they've completely ignored the mail so here we are.

Right now not having the stub seems to only be affecting buggy users
(which given the use cases for _exclusive() isn't *that* surprising) so
I'm more inclined to leave this there in the hope that the users get
fixed or we can at least get some sort of dialogue with the relevant
maintainers.

--Z1OTrj3C7qypP14j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSrJ2AAoJECTWi3JdVIfQCwoH/2k9n54oF/0ncPcTBJFadIft
xJsA1y5EfYGKlCTw8rGCnM+NdMlOlHaOsvCFNwSZ+iCHsHTuviBXeM+rjOyuJhL5
77Q88xTOwHvd2uUdRn6Z6gryRspLyPAg80LThFwyYfzKTppAHZCcpqZ2W4Lx4V3M
MXGnUWGsGyUFZ9Ek4qNp9E2aW2bNilvwXbr03s7GSiJpDQ68kzOsn6KM6wPxR+fo
Nu1Virv61n8UooGiypZfDEYjPxRJ1qEQ13iWJLENRff+rt62nWKmvFroVOzX+2iM
ncWTSJhEFtrftgGsfDyML983mUXY1VhOf/TCF9AX1QnZaPv62iMBzrUqausXzac=
=ryRz
-----END PGP SIGNATURE-----

--Z1OTrj3C7qypP14j--
