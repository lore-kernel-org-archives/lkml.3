Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbaGJA1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 20:27:16 -0400
Received: from ozlabs.org ([103.22.144.67]:53012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbaGJA1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 20:27:14 -0400
Date: Thu, 10 Jul 2014 10:27:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm+renesas@opensource.se>
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20140710102700.65ff2c14@canb.auug.org.au>
In-Reply-To: <20140620165353.GA3433@kroah.com>
References: <20140620141807.45761bd0@canb.auug.org.au>
	<20140620165353.GA3433@kroah.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.NwpoSHR+4vRS9rpXIVqAkf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.NwpoSHR+4vRS9rpXIVqAkf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 20 Jun 2014 09:53:53 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Jun 20, 2014 at 02:18:07PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> >=20
> > After merging the staging tree, today's linux-next build (powerpc
> > allyesconfig) failed like this:
> >=20
> > drivers/staging/board/board.c: In function 'find_by_address':
> > drivers/staging/board/board.c:14:3: error: implicit declaration of func=
tion 'of_can_translate_address' [-Werror=3Dimplicit-function-declaration]
> >    if (of_can_translate_address(dn)
> >    ^
> >=20
> > Caused by commit 382063d91e15 ("staging: board: Initial board staging
> > support").
> >=20
> > I have disabled that driver for today.
> >=20
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 20 Jun 2014 14:14:17 +1000
> > Subject: [PATCH] staging: board: disable
> >=20
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  drivers/staging/board/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/drivers/staging/board/Kconfig b/drivers/staging/board/Kcon=
fig
> > index 09d94b48c9c9..7eda0b8b7aab 100644
> > --- a/drivers/staging/board/Kconfig
> > +++ b/drivers/staging/board/Kconfig
> > @@ -1,6 +1,7 @@
> >  config STAGING_BOARD
> >  	boolean "Staging Board Support"
> >  	depends on OF_ADDRESS
> > +	depends on BROKEN
> >  	help
> >  	  Select to enable per-board staging support code.
> > =20
>=20
> Magnus, can you send me a proper patch for this to get the code back to
> building condition?

Ping?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.NwpoSHR+4vRS9rpXIVqAkf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTvd3eAAoJEMDTa8Ir7ZwVoLMP/iEmZZbFF0ZOAmFc8k7g43QZ
cYNhC6q04pWnF9N+PKq3c/QG8HHQvH2P66u+7WOrulAzexOIJtDQfnwHTLObt/72
ZqYsLSFWlyi6/aC/FUs5ZzrybWY49zlg8FKKTFOAobpxQepdppZvYdOVCDW+HtMb
9s3OyetxsLK6rMYZGO6eqHKwB8qMk1bU7v98ofGge8re5CCPkP4Wi4V3XzsKSLLt
Cc6/XqCSv7/hTNVekmvnqkAB+IIxVi8huKIcAX21906ggYBARyWkCO8V7D6TfnXc
6F3jBxv0J6Q1x+r0KD5P7kgwjwO6tqT/U6tVZE6txEO8Xo4Cp1g1Q0u9AXNLU96S
UeLjCG/ABLHGLYB56N3TNcKiwRncQVtaMtQekA1YbD2ay0n5+QkSVHXWgGSMzst9
lVG9yFz+A2J6eFQnEmRvdDj5pZNsO5Pj6OSXT+O6BcEPgt5UT1lEWQOjTCvOp/JY
BTiDtsADVCqf4Cle/AbQNp0ZsqVLNkOgVViobjQImo+f/CCWEtDH4BAmXNAqksLz
DBMwFfQ2xc4whZeemQvLbT33Pf6ZcrccD63q08DJX20a+xB4NIg0CXUMF39pWtdk
R70ZFiowAEiZz0nT235lOVqC/dMx/EbvjsisrCswd521EFespqHyjuEGWtl5IhFI
hn14piuhdgZw3P/6S2Yh
=5EGT
-----END PGP SIGNATURE-----

--Sig_/.NwpoSHR+4vRS9rpXIVqAkf--
