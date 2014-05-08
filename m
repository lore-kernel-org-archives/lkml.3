Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbaEHQGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:06:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:44541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaEHQGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:06:13 -0400
Date: Thu, 8 May 2014 18:06:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will.deacon@arm.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>
Subject: Re: [PATCH 07/20] arch,cris: Fold atomic_ops
Message-ID: <20140508160606.GD30445@twins.programming.kicks-ass.net>
References: <20140508135840.956784204@infradead.org>
 <20140508135852.104572724@infradead.org>
 <CAMuHMdV7FUC+p5XqwLZmqJRLYv1qhu5hf0M_e5pASBRHgFAhCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nT6ukc3bqTvTgwkF"
Content-Disposition: inline
In-Reply-To: <CAMuHMdV7FUC+p5XqwLZmqJRLYv1qhu5hf0M_e5pASBRHgFAhCA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nT6ukc3bqTvTgwkF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 05:12:31PM +0200, Geert Uytterhoeven wrote:
> Hi Peter,
>=20
> On Thu, May 8, 2014 at 3:58 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > Many of the atomic op implementations are the same except for one
> > instruction; fold the lot into a few CPP macros and reduce LoC.
> >
> > This also prepares for easy addition of new ops.
> >
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > Cc: Jesper Nilsson <jesper.nilsson@axis.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Mikael Starvik <starvik@axis.com>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> > ---
> >  arch/cris/include/arch-v10/arch/system.h |    2 -
> >  arch/cris/include/asm/atomic.h           |   57 +++++++++++++---------=
---------
> >  2 files changed, 25 insertions(+), 34 deletions(-)
> >
> > Index: linux-2.6/arch/cris/include/arch-v10/arch/system.h
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.orig/arch/cris/include/arch-v10/arch/system.h
> > +++ linux-2.6/arch/cris/include/arch-v10/arch/system.h
> > @@ -36,8 +36,6 @@ static inline unsigned long _get_base(ch
> >    return 0;
> >  }
> >
> > -#define nop() __asm__ __volatile__ ("nop");
> > -
>=20
> Is this change supposed to be part of this series?

Uhm, lemme double check that. Good spotting.

Nope, it builds just fine without that hunk, *poof* gone.

Thanks!


--nT6ukc3bqTvTgwkF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa6tuAAoJEHZH4aRLwOS69nIP/3/QXVI2z11xRK4uE5qF/IwT
zJa4lVnZPrvX/ZL6rQvnGD2onz+AcDR9ZXlkiScRNt01DS3DttPxSyeMJJ3hyaL/
nLF5NIEawhuea8JS2WB7MR1Qu7iUyuYsgtKjnM2xDw2i72VQ/q8V2D+k8po4eUXO
JklOlt4prhX2r7gQDLEsikCi6PRt+Wui/s0E9w4J0Dj42KELQK2V6Pyw49o8cV+Z
4Hyw3F6KkFYzOV55zNWR/OkO47LEsZXZojHxKZkmzT0uzVrcMSP3gkZWrLAeeDM0
Wcdd1f5JwvfOw+v7z/t3jFuV0hravDVq3B4iZ34Ue5CinPeqdYH8ZKK8Xfgzg4DC
ZX8UehxblfUBoeSqICxNERw+DiW/350GzdDBOcpyd34+aa5QUlTOi+G5/F7MwF9F
TZWLPteYCrMJe6jbSp4A7Eh7W/OUlQ8tIAu/D9lFW1OT8UwaIs64kb31aSudlqQx
niCz9cgt3ufd9CEvNDty005xMLPaG7UrsWHxW0hYp1lvbNZ5cWLukUshN5W8pwAS
amHn8JuasH9CUeVBOu2eT52Y9dqDrsoOzy0HAcZgDG+lc9+sNcaXbOjESQj3BdOA
HuphpYRE+RAVwEzGSqyZx//WWcOLj9e2J66wcZSuBrcuW8PJ95gMqJfOraddR98t
RKEishADhtLWn/UiUUhq
=F2YZ
-----END PGP SIGNATURE-----

--nT6ukc3bqTvTgwkF--
