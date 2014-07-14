Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaGNJLK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:11:10 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:52871 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaGNJLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:11:03 -0400
Date: Mon, 14 Jul 2014 11:10:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
Message-ID: <20140714091057.GP2081@ulmo>
References: <1405092672-18549-1-git-send-email-thierry.reding@gmail.com>
 <53C05E4A.2030708@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qSHHer9gQ0dtepKr"
Content-Disposition: inline
In-Reply-To: <53C05E4A.2030708@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qSHHer9gQ0dtepKr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 11, 2014 at 02:59:38PM -0700, Stephen Boyd wrote:
> On 07/11/14 08:31, Thierry Reding wrote:
> > From: Thierry Reding <treding@nvidia.com>
> >
> > This patch implements generic versions of readsb(), readsw(), readsl(),
> > readsq(), writesb(), writesw(), writesl() and writesq(). Variants of
> > these string functions for I/O accesses (ins*() and outs*() as well as
> > ioread*_rep() and iowrite*_rep()) are now implemented in terms of the
> > new functions.
> >
> > While at it, also make sure that any of the functions provided as
> > fallback for architectures that don't override them can't be overridden
> > subsequently.
> >
> > This is compile- and runtime-tested on 32-bit and 64-bit ARM and compile
> > tested on Microblaze, s390, SPARC and Xtensa. For ARC, Blackfin, Metag,
> > OpenRISC, Score and Unicore32 which also use asm-generic/io.h I couldn't
> > find or build a cross-compiler that would run on my system. But by code
> > inspection they shouldn't break with this patch.
> >
> > Signed-off-by: Thierry Reding <treding@nvidia.com>
>=20
> There isn't any mention of why we're doing this in the commit text. It
> looks like patch 2 and 3 sort of mention why.
>=20
> I also wonder if it could be explained how this about turn is desired,
> given that patch b2656a138ab7 (asm-generic: io: remove {read,write}
> string functions, 2012-10-17) did the complete opposite. Can you please
> explain?

The reason behind this was that people have been told to migrate towards
using io{read,write}{8,16,32}_rep() because {read,write}s{b,w,l}() are
not as "portable". The only reason why the aren't portable is because no
generic versions of them existed. That's what this series originally
started out as.

Also, it's somewhat backwards (and inconsistent) to go through the io*()
functions when it's known up front that the device will always only be
memory-mapped and never I/O mapped. So with these patches going forward,
people should be using either {read,write}{,s}{b,w,l}() *or* their
io{read,write}{8,16,32}{,_rep}() counterparts, not mixing them.

Thierry

--qSHHer9gQ0dtepKr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw56hAAoJEN0jrNd/PrOhddUP/2HJZ6+7D6xGrNZJPdkmR6U1
AI6tUVRDowELJEK4ZMRMKroFRIg6+jUKB/oHPcbYXJdnSuk1CvZImemUexPlJlK/
VLy4BY5jHXds4hP+bte/VSmkRYRDwIjMMMzQN1Ar2M+ejFgdsuBOSdzB0zgMhsH2
5SeLvx6B9AtfTx3oi2/Spo5L0iW8uL7H3nhbGPP1jnoDKOc6feFvPfPpi8hrGvvd
lqpzi7dr/u/XFhDRAZMZThcpAehPhWyU2pBE9YGm5TO9kL1RyJTgZf7hpoTUBpb4
4FwpQTAe+OoyjfNp6huyhSJitZkrCMWTx+XmrS3vj7ty3To5F8CHO6GANYd10WW5
glpw+MNUk4IRljiSZzj/RFeCD5SEsx1nNdYRnN6IPJ/WpHIeP6NhrobPcCtG5G6/
3Q9Td1Xb/On8cQmLJxDo6jEzBtl4O6xdNG8Fg0OC0EXW0ywbwFhJDsZG0Tg6V8eJ
/wbh0hmCqm8E1bxENmDwqi8s8y+k1zuTQpyql8z5mFR4MCNdISJ8EfHwxJJEWwGo
7rXYntrLOdE0ZXV9O/pXppnUVqWI+A7SHCmZI/FtJkKsr6g/dV57Fc/z+kzyVWNK
Xy+G/wkx1XZmFtlRpxAK+HSD89G5D+QJzn4LJVMzNsnduy+x2wQapYL5EfWcrbfx
AnkOqX2mZDDfkx8Gk0kT
=r4DG
-----END PGP SIGNATURE-----

--qSHHer9gQ0dtepKr--
