Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaJMLEr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:04:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50285 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbaJMLEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:04:46 -0400
Date: Mon, 13 Oct 2014 13:04:26 +0200
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        David Brown <davidb@codeaurora.org>, dri-devel@lists.freedesktop.org
Message-ID: <20141013110426.GR27755@sirena.org.uk>
References: <1412853258.21384.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vs3OeL+Kqvniamtd"
Content-Disposition: inline
In-Reply-To: <1412853258.21384.0.camel@phoenix>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND] regulator: Add stub for
 devm_regulator_get_exclusive
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vs3OeL+Kqvniamtd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 07:14:18PM +0800, Axel Lin wrote:
> Also makes regulator_get_exclusive and devm_regulator_get_exclusive stub
> functions return error pointer.
>=20
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi Mark,
> I hit below build error and then found this patch is still not yet upstre=
am.
> So here is a resend.
>=20
>   CC [M]  drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.o
> drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c: In function 'mdp4_kms_init':
> drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:2: error: implicit declaratio=
n of function 'devm_regulator_get_exclusive' [-Werror=3Dimplicit-function-d=
eclaration]
> drivers/gpu/drm/msm/mdp/mdp4/mdp4_kms.c:384:16: error: assignment makes p=
ointer from integer without a cast [-Werror]

To be honest the fact that you're hitting bugs with this is kind of
making me think that this is a good idea. =20

Looking at the code in the driver there are rather a lot of problems -
the whole way the errors are ignored in the probe function is concerning
and most likely buggy at least with deferred probe. For the immediate
problem with using regulator_get_exclusive() I can't understand why it's
being used at all.  In general all the regulator usage in the driver is
atypical and doesn't look idiomatic - do we understand what's going on
here?

--Vs3OeL+Kqvniamtd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO7G5AAoJECTWi3JdVIfQeKAH/2TiJax7MCHiyV7ZpDhcQaRa
2FDl2cU27n4phNHrwHRQLIzxouCw4kiTxb7oGpHqq6EPGa9zl60xzWsZXrImfYBh
dEYzMDljLajpZB3w8OgWoq5X4f1FDO8flvlD4OkrK7BiczwWD0vrRdT4fV2Lwf9O
6iE/MHgfWubpuVjkqVt8Tatqy8fgjxNz1HpsyO5FbYG+ICYpkIDsM6pgNPq/GQyz
4t82vmR/2O0YhTi96yhvd8g8CmyhG78LtSfxaSUGs+QRETgKvHSgdr3+V9YDib6c
TE1d0yROhMyp32v3RtcAhjVuWSC/P/wAZENrtCsdfnZQSQoU6Vs7FG597kXGDd4=
=WdsI
-----END PGP SIGNATURE-----

--Vs3OeL+Kqvniamtd--
