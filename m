Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaHTVM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 17:12:56 -0400
Received: from omr1.cc.vt.edu ([198.82.141.52]:34592 "EHLO omr1.cc.vt.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612AbaHTVMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 17:12:55 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.6+dev
To: Pavel Machek <pavel@ucw.cz>, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Nick Krause <xerofoiffy@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
In-Reply-To: Your message of "Wed, 20 Aug 2014 22:26:02 +0200."
             <20140820202235.GA28350@xo-6d-61-c0.localdomain>
From: Valdis.Kletnieks@vt.edu
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com> <17153.1407349640@turing-police.cc.vt.edu>
            <20140820202235.GA28350@xo-6d-61-c0.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1408569162_20555P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 20 Aug 2014 17:12:42 -0400
Message-ID: <26099.1408569162@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1408569162_20555P
Content-Type: text/plain; charset=us-ascii

(Adding Al Viro and linux-fsdevel, dropping Mark Brown and the SPI list, because this is
heading off in a different direction now)

On Wed, 20 Aug 2014 22:26:02 +0200, Pavel Machek said:
> On Wed 2014-08-06 14:27:20, Valdis.Kletnieks@vt.edu wrote:
> > On Wed, 06 Aug 2014 13:53:17 -0400, Nick Krause said:
> > > Remove unused definition which cause the following warnings
> > >
> > > drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
> > > include/linux/fs.h:193:0: note: this is the location of the previous definition
> > > drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
> > > include/linux/fs.h:192:0: note: this is the location of the previous definition
> >
> > > -#define WRITE 0
> > > -#define READ  1
> >
> > NAK.  Full stop.  These are potentially used in an inner macro someplace, and by
> > removing these, the conflicting values from fs.h will be used instead.
> >
> > #define READ                    0
> > #define WRITE                   RW_MASK
> >
> > So if there *is* a use in an inner macro, you just screwed the pooch
> > and introduced a bug in this "clean up" - somebody will be expecting to see
> > a 0 for a READ, and will receive a 1 instead.  This can't end well.
>
> Actually.. having macros called READ and WRITE in fs.h is already something I'd say
> can't end well. Can we rename those?

I had the same thought, but other than a test rename to XYZZY_READ and PLUGH_WRITE
and doing a 'make allmodconfig' and seeing what throws an error, I'm not sure how
to track down all the users.  On my fairly stripped-down .config, I have:

[/usr/src/linux-next] find * -name '.*.cmd' | wc -l
4671
[/usr/src/linux-next] find * -name '.*.cmd' | xargs grep include/linux/fs.h | wc -l
2339

Which is telling me that pretty much half the world ends up including fs.h indirectly.

Now for the mandatory bikeshedding:

What do we want to rename them to? :)

--==_Exmh_1408569162_20555P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBU/UPSgdmEQWDXROgAQKizw//WFKOlwVsd1PVMK1GeQgJsgKZm49s0Hir
ki8B++Hxx4FlkErRzCj5EJiSfHbyyua0Fz4jyBB6jOTsWpWTwszXGA41DQuzeCam
o2gjKVdlrpuIEUdEOseikYTayOXnhsjj/3gA/2VHIzw9EFQ0CNg3Hj01phMDSDkP
wQq/LGlygGU/uswUySus0ADeeeu/S9mwcHhSPNSkbMuYM9StV8CVG9VEu9mC5fWO
m8dMm3kXVXZngGFdrReLxa/yyIexWxC5ZP6U6rXanADRHoDGxfqX012qglTNjrmI
Ae0iRneq9SdyZf6mcYwZlb7nk4dzrpzG+LWYNdRq892FdA1fuRSFoUt1DEWbQvTF
oelrS3aRS2Q5MtbhQtuYDgU0a7caoArLXVdgVP4g5ZS/OgHlaHgF3PPA+wwqJyF7
oZbHDx3bPb6e8/jqS63jgROJSY7XWMd3+uunkMYfNq94Z1Ga0Kl8hJ5XpBmm5lUw
uoDJRmb+D71xtRpRiWqj6zLf+yVJrjZYOjt3+2b5gxE+ODRAQv8V4VL9s6/uN6H+
M5aew9QrkPDmlpeU6obi71L8vvESS5sEKXwA636W2pTgGSGfFkJ/VsoZZ+yq1b4y
GuBoE1pU6CdFmJDSv5gwExgfOQAcv17EVlmFCzFO30VlEIWk5ny5Q2IFUz4z6vsZ
7u1NU+qW6y4=
=TLcV
-----END PGP SIGNATURE-----

--==_Exmh_1408569162_20555P--
