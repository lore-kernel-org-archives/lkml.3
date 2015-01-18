Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751465AbbARWFL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 17:05:11 -0500
Received: from omr1.cc.vt.edu ([198.82.141.52]:42796 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbbARWFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 17:05:08 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Siddhartha De <siddhartha.de87@gmail.com>
Cc: kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: Question about kernel interfaces
In-Reply-To: Your message of "Sun, 18 Jan 2015 15:03:55 +0530."
             <CADxyqMEjs7Xpy7Xqi7zbyOtCwNWfT1bK22Paf3wSMP8YEVjyUQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com> <CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com> <20150108134849.671ee761@lxorguk.ukuu.org.uk> <CADxyqME4=vnZh4J8BDw63r6L=hA8OpO4GJWxuuOgwuFwHb+8Lg@mail.gmail.com> <20150114163317.46a1ecec@lxorguk.ukuu.org.uk> <CADxyqMGtew47Gfzq=1u46qjkLsn+AkB-fGWbAtODAbHgi3DM9g@mail.gmail.com>
            <CADxyqMEjs7Xpy7Xqi7zbyOtCwNWfT1bK22Paf3wSMP8YEVjyUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1421618631_1896P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 18 Jan 2015 17:03:51 -0500
Message-ID: <53946.1421618631@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1421618631_1896P
Content-Type: text/plain; charset=us-ascii

On Sun, 18 Jan 2015 15:03:55 +0530, Siddhartha De said:

> Let's say you need to call an ioctl from a shell script ( I know its a
> very rare use case but please bear with me ... :) )

There's a *reason* it's very rare...

> So the current way of doing it is probably to write a C program which
> actually calls the ioctl and then call the C program from the shell
> script ...
>
> However if we exposed the IOCTL as a web url we could easily call its
> services by using a simple utility like curl . So in our shell script
> we would probably write :-
>
> curl http://localhost:7000/IOCTL/IOCTL_EJECT?device=/dev/cdrom
>
> and the IOCTL_EJECT ioctl would get called on /dev/cdrom
> that is ioctl ( &handle_to_/dev/cdrom , IOCTL_EJECT , &some_buffer )
> would get called ( by our translator running as a separate program or
> as a service daemon )
>

Why use curl when /usr/bin/eject is almost certainly available?

Can you point at an *actual* case where (a) shell script access even makes
*sense*, and also (b) there *isn't* already a program available for the
shell script to call to issue the ioctl?

Or point at a non-shell language that *doesn't* have already have access to the
ioctl() wrapper that's in whatever libc you have?

I think you're trying to solve a non-problem here.

(For bonus points, instead of EJECT, explain how you form a curl URL
that does TCSETS. Yes, you *do* have to handle *all* the fields of a
struct termios, for both 32 and 64 bit environments....)

--==_Exmh_1421618631_1896P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVLwtxwdmEQWDXROgAQJ55Q/9H2nBYj/m+QFipIU6IPNGWnE09G4Q2g+p
gPD3ByXBODDIEsxaHX42uOCaEbRfC3eUgjqaTlqw4ZgjLgy8LxAu8n0oNymbixZb
kchUsWaxIgKEOQ4GsZsC6IVgI7RecrsazJNG4LWVvPufLxfowRaHHm3mogUWelKS
dFMEtSKSuSPMtIk4fYts6QF+njcuWLzzSE7EzNc5+/La9XFBHkAau63GKVT9sP0c
8kIMU/bo+aSgRztybWMgptzQi6cdKBUWr6oFPrnZv6glrOjF5MktSOpvTdMlVaA8
hzd/I+X7SAQtYa2DxGRXXYOKDeH+clJAZdTpz2DZIkK5+6rQObjVxDRWLzY/1xg3
e7L5IxXaqgwBl8dIiW/KltMnTZXQC4vZy8lMhk5i/RPD32VBlMUkP/rHms0eu2fB
ZaF6XDsPfD41nOerGMXKpukFghXzFslXpTKM+RAmYqeH+7PP34LIyVPT7zQT4MRy
TuyjWqs2m2e7OF15MGpLRJZo0o7RZ7gE0tanssDXHuSRzL2gY16Ydf863OhGN+i4
fMI1SLjOjqoueI+JxbdZ3lyrHQ2mPrM3U6TrNvA7onXeL+/FTE22kA0pHOKLnG+N
6icRRvBmRFRwfD9OFWJZG9UOjEzS1f6VzvC6aunKJDVw83EU+uEgIHK/59GmMj4d
rnXQ0Pokr0w=
=EA/D
-----END PGP SIGNATURE-----

--==_Exmh_1421618631_1896P--
