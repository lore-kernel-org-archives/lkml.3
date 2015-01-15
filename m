Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbbAOSqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:46:08 -0500
Received: from mail-qg0-f45.google.com ([209.85.192.45]:41387 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930AbbAOSqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:46:04 -0500
Date: Thu, 15 Jan 2015 12:45:57 -0600
From: Clark Williams <clark.williams@gmail.com>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "jkacur@redhat.com" <jkacur@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "Vineet Gupta" <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH] Makefile: allow building selected tests with non-NPTL
 toolchain
Message-ID: <20150115124557.5d2d34ad@sluggy>
In-Reply-To: <1421307300.3008.2.camel@synopsys.com>
References: <1415603814-7682-1-git-send-email-abrodkin@synopsys.com>
	<1421307300.3008.2.camel@synopsys.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gj+h4Or+poHF0sk.1f6_RJ3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gj+h4Or+poHF0sk.1f6_RJ3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Jan 2015 07:35:01 +0000
Alexey Brodkin <Alexey.Brodkin@synopsys.com> wrote:

> Hi Clark, John,
>=20
> On Mon, 2014-11-10 at 10:16 +0300, Alexey Brodkin wrote:
> > Some architectures are still stuck with non-NPTL toolchains.
> > These are for example ARC, Blackfin, Xtensa etc.
> >=20
> > Still rt-tests are very good benchmarks and it would be good to enable =
use of
> > at least selected (those that will be built) tests on those architectur=
es.
> >=20
> > This change makes it possible to only build subset of tests that don't =
require
> > NPTL calls.
> >=20
> > By default behavior is not modified - all tests are built, but if one w=
ants
> > to build with non-NPTL toolchain just add "HAVE_NPTL=3Dno" in command l=
ine
> > or modify "HAVE_NPTL" variable right in Makefile and execute "make".
> >=20
> > Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> > Cc: Vineet Gupta <vgupta@synopsys.com>
> > Cc: Clark Williams <clark.williams@gmail.com>
> > ---
> >  Makefile | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/Makefile b/Makefile
> > index 318a5c6..675edf7 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,8 +1,13 @@
> >  VERSION_STRING =3D 0.89
> > =20
> > -sources =3D cyclictest.c signaltest.c pi_stress.c rt-migrate-test.c	\
> > -	  ptsematest.c sigwaittest.c svsematest.c pmqtest.c sendme.c 	\
> > -	  pip_stress.c hackbench.c
> > +HAVE_NPTL ?=3D yes
> > +
> > +ifeq ($(HAVE_NPTL),yes)
> > +sources =3D cyclictest.c pi_stress.c pip_stress.c pmqtest.c rt-migrate=
-test.c
> > +endif
> > +
> > +sources +=3D signaltest.c ptsematest.c sigwaittest.c svsematest.c send=
me.c \
> > +	  hackbench.c
> > =20
> >  TARGETS =3D $(sources:.c=3D)
>=20
> I'm wondering if there's a chance to get this patch reviewed and if
> there're no objections applied?
>=20
> Regards,
> Alexey

Changes looked good to me. I've pulled it in and it will be in the next
release.

Clark

--Sig_/gj+h4Or+poHF0sk.1f6_RJ3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUuArlAAoJEEersVlSw9NziSQP/RSPeQX+CybelMFWUiK+5s9v
e9KqAF8qwXHD26tjo5y/q7FS2rq9i7vU8tgN/u2jQwzl87zxiwoGxwVzq2GZc+Wd
jD+T13obAbi5Utuk/X2U6sHzjY0VVhcEK1SF5PrMLjbCctmAmzSI+ymhg+3IZ3tt
cYCLTblmutrCExl4QvRuqXcQvPscrUeKtAdqN2Y3+7jYtjQYKQyZPDn7QLL972q6
m5VBg9Q49E1dV8gpivlj0ziSaEyRSXYtsp0f1hXQw9kJurrK5JZMoSl6TOPdvfJs
BlLr6kZzXFEVWWsNWPHT5VlGjAHxbf1cALz1qHSw7sPHupBQcbtX/aFJFC3n2FZu
7Bdce5hJvxyu6GChWzqEtosI983i5aHYExDLFGKaMcFDB0eo0kWNWWzJGUYGK2Zt
pNclV21KnkBwq4TTK4A0I0dsdTLciqQSYb56H4AKKF64aBFFKtkjuIM2ljo7zMEo
z1PXEmUPWJ2MyRXR9URX9k43xCiHXZKwlTYwalDn6vYupZZsTTnDTJj873uaYHeE
C0ndrUMIwrv4CnUA7BByOmCR1HtUpG2vjxuFHie8Ufbx4e00JuAywBhcJCk9mJMY
yfJbYo3VF1AqJqi1CRGhC3IJDYoeH+nXW+C3OdoTqT3aTfxVc/fa14qHHonA+PXu
yBT41sQFJx9z4k3BJPyt
=KAzq
-----END PGP SIGNATURE-----

--Sig_/gj+h4Or+poHF0sk.1f6_RJ3--
