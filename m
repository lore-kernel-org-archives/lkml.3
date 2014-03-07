Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaCGAme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:42:34 -0500
Received: from ozlabs.org ([203.10.76.45]:43429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaCGAmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:42:32 -0500
Date: Fri, 7 Mar 2014 11:42:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>, Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140307114225.17ba235975177d7173393d5a@canb.auug.org.au>
In-Reply-To: <20140306145826.4453a8edbfcf18cd2e9fa8c1@linux-foundation.org>
References: <20140306180852.b1515db3cccc1622172524c0@canb.auug.org.au>
	<20140306145826.4453a8edbfcf18cd2e9fa8c1@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Mar_2014_11_42_25_+1100_EvVgcjF/5u2Gcc7B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Mar_2014_11_42_25_+1100_EvVgcjF/5u2Gcc7B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 6 Mar 2014 14:58:26 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Thu, 6 Mar 2014 18:08:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
>=20
> > After merging the akpm-current tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >=20
> > ...
> >
> > and on and on ...
> >=20
> > Caused by commit 0d9ad4220e6d ("mm: per-thread vma caching") which adds
> > the include of linux/vmacache.h (which includes linux/mm.h) into
> > linux/sched.h ... There is a reason that we did not include linux/mm.h
> > into sched.h.
>=20
> Yeah.
>=20
> > --- /dev/null
> > +++ b/include/linux/vmacachedefs.h
> > @@ -0,0 +1,9 @@
> > +
> > +#ifndef __LINUX_VMACACHEDEFS_H
> > +#define __LINUX_VMACACHEDEFS_H
> > +
> > +#define VMACACHE_BITS 2
> > +#define VMACACHE_SIZE (1U << VMACACHE_BITS)
> > +#define VMACACHE_MASK (VMACACHE_SIZE - 1)
> > +
> > +#endif /* __LINUX_VMACACHEDEFS_H */
>=20
> I just did pretty much the same thing:
>=20
>=20
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-per-thread-vma-caching-fix-3

I will replace my patch with this today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__7_Mar_2014_11_42_25_+1100_EvVgcjF/5u2Gcc7B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTGRX2AAoJEMDTa8Ir7ZwV/UwP/i0JyQSS172zsTUQt+tsDwWo
BUavRksyhXI7dpgFHY/O5Arq3Ur33wl2N1kAyCVOAKSyGeuk2iIl2TAMtX1IU1Fj
EW77ufzU4s8MeyBVVsRo+ntDJc2StOpa4HEJ4YnuEiF4whDPjGxIZSxky4nhG9lI
mId5ZsT0NslrK+epyVVCXFvELC05pISo++RQW3Ptcz8dYNu85wnMDi26T05oM2Jg
9vg/sYjSIHjH3qbBDh1XkopbvY+7DDsFt8ot9kuu2b2nkkI/FbhSvRrOdy11Xa4W
ibZxq5bnq0x50330e9kxyzq/XJjHwiVvPOddwiJpUgI7BzfcW/WVsd4Z9YtwtZng
N6uDSAzr12BeK8z2YhyiF43sGMHRiISWS9ddqJnapuHttJFS1uDm8liWksyoxoED
XM9Umzn60zQDN+n8rKVXRYn/DCtEROlqwGRD4vMUXs/cJjROq5ciGhrBf5BhInsZ
PF6KjPMj3SU5g4ldhkhwQjeHuuPNUd8m33BCu11L+hhuzaXnechtyPawzBSfKrkf
OfMr3r20OxxkOpbYKY4Wm5NvfHHqf0gatg6QyNyqUqguSsTRRxHfLL+xvWDVCY35
e9poZ6fljib2+FnLoi+mStUIQ26BnDa4Q1ceHQAvpszH5GGeoi9G9dPUJnbpKd//
f9QBdozxrSYXKfmOHAfc
=2Jwy
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Mar_2014_11_42_25_+1100_EvVgcjF/5u2Gcc7B--
