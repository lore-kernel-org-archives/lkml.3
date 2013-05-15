Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab3EOC5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 22:57:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59678 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150Ab3EOC5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 22:57:16 -0400
Date: Wed, 15 May 2013 12:57:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        User-mode Linux Kernel Development 
	<user-mode-linux-devel@lists.sourceforge.net>,
        Tony Breeds <tony@bakeyournoodle.com>
Subject: Re: Build regressions/improvements in v3.10-rc1 (um)
Message-Id: <20130515125712.a6e04f8dd3345f1f4980e107@canb.auug.org.au>
In-Reply-To: <1368447352.10679.0.camel@concordia>
References: <alpine.DEB.2.00.1305122130270.3789@ayla.of.borg>
	<alpine.DEB.2.00.1305122239040.5463@ayla.of.borg>
	<alpine.DEB.2.00.1305122247320.5463@ayla.of.borg>
	<CAFLxGvzA5nzpQjOKWgz0nBKG2s3gPspted-25uduqkr7_ySj6A@mail.gmail.com>
	<CAMuHMdWt0i6Q+i9Qh+tMs910a388NoddhHmq2LGr50f1=dJPvQ@mail.gmail.com>
	<38896893-83c7-4eb4-848a-bb35663d945b@email.android.com>
	<CAFLxGvyKANuy_vezO+E1aL3FzvdjiNgCD3j-BVGSyL_ne015Xw@mail.gmail.com>
	<1368447352.10679.0.camel@concordia>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__15_May_2013_12_57_12_+1000_3b0Oy=dY+1CZxjg7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_May_2013_12_57_12_+1000_3b0Oy=dY+1CZxjg7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 13 May 2013 22:15:52 +1000 Michael Ellerman <michael@ellerman.id.au=
> wrote:
>
> On Mon, 2013-05-13 at 12:07 +0200, richard -rw- weinberger wrote:
> > On Mon, May 13, 2013 at 11:54 AM, Michael Ellerman
> > <michael@ellerman.id.au> wrote:
> > >
> > >
> > > Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > >
> > >>On Sun, May 12, 2013 at 11:17 PM, richard -rw- weinberger
> > >><richard.weinberger@gmail.com> wrote:
> > >>> On Sun, May 12, 2013 at 10:47 PM, Geert Uytterhoeven
> > >>> <geert@linux-m68k.org> wrote:
> > >>>> On Sun, 12 May 2013, Geert Uytterhoeven wrote:
> > >>>>> However, the full list of errors isn't that unmanageable, so I'm
> > >>following
> > >>>>> up with a digested list...
> > >>>>
> > >>>> arch/um/drivers/cow_user.c:216: error: implicit declaration of
> > >>function 'htobe32': 1 errors in 1 logs
> > >>>> arch/um/drivers/cow_user.c:249: error: implicit declaration of
> > >>function 'htobe64': 1 errors in 1 logs
> > >>>> arch/um/drivers/cow_user.c:303: error: implicit declaration of
> > >>function 'be32toh': 1 errors in 1 logs
> > >>>> arch/um/drivers/cow_user.c:330: error: implicit declaration of
> > >>function 'be64toh': 1 errors in 1 logs
> > >>>>         v3.10-rc1/um-i386/um-defconfig
> > >>>>         Old host environment on kissb?
> > >>>
> > >>> This really looks like a host environment issue.
> > >>> PTRACE_O_TRACESYSGOOD for example is defined in
> > >>/usr/include/linux/ptrace.h
> > >>
> > >>Yep, just like e.g. htobe32().
> > >>
> > >>Michael, Stephen: Any chance this can be fixed?
> > >
> > > Possibly. We're cross compiling these on powerpc so perhaps we need t=
o update the cross compiler.
> >=20
> > Looks like you are the first man on planet earth who tries do build
> > UML/x86 on powerpc. :D
>=20
> :)  It has given us some trouble over the years.
>=20
> I'll talk to Stephen tomorrow about it and see if we can get it working
> again.

So htobe32 etc were introduced in glibc 2.9 - our build environment is
glibc 2.3 ... Documentation/Changes does not specify a minimum version of
glibc.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__15_May_2013_12_57_12_+1000_3b0Oy=dY+1CZxjg7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRkvmIAAoJEECxmPOUX5FE+8EQAKLvNhBuk3E5PsVO6y06SWHl
BzURnibgr8Un5TPZW0Ey1S7183Tp8W6guPrr0YNKDHVluyxJ/ce7niPba8282/pX
cLogFjFgHPDSqxnKvyG74ym9/Bz5eAG5rkoQuWNEHyr6Pb4ybHTS+mEOtwX5xhSG
3ZBfmlXFJf5BQShDJ7fGuFOY6EfNuEVM6L+jd9elTw95VFd1mlkoUcegZSrabYte
UCq+hDsVrvCp+YuBsYfrS9YNwe9AdWUsvGILuamXKpqbUquZ1cll/d9VxEgAMtfP
7c/7ZMZxPKjMMdpPop9pZX/0oGOuBlbbBbUy3PUaLF9TW1Z8xf6DyyvAfil6naoC
hz+cvLJup2T5+E/bO9fCZjGQJvWSf7V1KN6vP1OnIUdfRQfsU/qpT3mo1IIVVrhc
HftvgIX+TpA/Id8Qv9YSwIbXQjbgvbVptDSa+9PEGW7/yRvWfJs4+XMjsQHMTFoY
kpfnu7S4t4WjvQUxsW2ae57Sk434bZcSqyLt6mNnjZtinObdu8urb44Id/Ra/Ytj
Fc66WU5LEdgYqGElAwbYBOCMdSlaECpLEFkfhDYRyHAXDP4U39xLJWeUCEhiNpT1
Gd6IlqXVnI9Mnnw8nbsEpmOnAay8YUh+q8c97/x1dU7dhysfKdUmRSJFAFr9JIEw
8RnEnhm6H9PrKkdUjx0q
=9F1N
-----END PGP SIGNATURE-----

--Signature=_Wed__15_May_2013_12_57_12_+1000_3b0Oy=dY+1CZxjg7--
