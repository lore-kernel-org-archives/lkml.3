Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985Ab3HWRlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:41:14 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:57751 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab3HWRlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:41:11 -0400
Date: Fri, 23 Aug 2013 20:37:49 +0300
From: Sergei Trofimovich <slyfox@gentoo.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Marek <mmarek@suse.cz>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] Makefile: enable -Werror=implicit-int and
 -Werror=strict-prototypes by default
Message-ID: <20130823203749.687460c2@sf>
In-Reply-To: <CAMuHMdXRb2K+WSfFGK=SASTU=+fUZ3XRQQ-+5xoDS=04HG92OQ@mail.gmail.com>
References: <1376591851-31854-1-git-send-email-slyfox@gentoo.org>
	<CAMuHMdXRb2K+WSfFGK=SASTU=+fUZ3XRQQ-+5xoDS=04HG92OQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//XX8B9nLYH1v9hyBZ_WcGd2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//XX8B9nLYH1v9hyBZ_WcGd2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 23 Aug 2013 14:18:02 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> On Thu, Aug 15, 2013 at 8:37 PM, Sergei Trofimovich <slyfox@gentoo.org> w=
rote:
> > diff --git a/Makefile b/Makefile
> > index 6e48848..53f4776 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -374,6 +374,11 @@ KBUILD_CFLAGS   :=3D -Wall -Wundef -Wstrict-protot=
ypes -Wno-trigraphs \
> >                    -Werror-implicit-function-declaration \
> >                    -Wno-format-security \
> >                    -fno-delete-null-pointer-checks
> > +
> > +# not universally available, but nice to have ones
> > +KBUILD_CFLAGS   +=3D  $(call cc-option,-Werror=3Dimplicit-int) \
> > +                   $(call cc-option,-Werror=3Dstrict-prototypes)
> > +
>=20
> This should be _below_ the line
>=20
>     include $(srctree)/arch/$(SRCARCH)/Makefile
>=20
> , together with the other users of cc-option, else it detects the feature=
s of
> the host compiler instead of the cross-compiler when cross-compiling:
>=20
> cc1: error: unrecognized command line option "-Werror=3Dimplicit-int"
> cc1: error: unrecognized command line option "-Werror=3Dstrict-prototypes"

Oh, it was not obvious.

Does it mean the code right before is buggy as well?

>    ifdef CONFIG_CC_OPTIMIZE_FOR_SIZE
>    KBUILD_CFLAGS<->+=3D -Os $(call cc-disable-warning,maybe-uninitialized=
,)
    ^^^
>    else
>    KBUILD_CFLAGS<->+=3D -O2
>    endif
   =20
    include $(srctree)/arch/$(SRCARCH)/Makefile

Will respin fixed patch in a while.

Thanks!

--=20

  Sergei

--Sig_//XX8B9nLYH1v9hyBZ_WcGd2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iEYEARECAAYFAlIXnfAACgkQcaHudmEf86pQawCfaqJDvFw9uEUFOfo3WA1T4zjF
48wAnj5l9RPatceC1y7PXnhCn69QsP3h
=XuSN
-----END PGP SIGNATURE-----

--Sig_//XX8B9nLYH1v9hyBZ_WcGd2--
