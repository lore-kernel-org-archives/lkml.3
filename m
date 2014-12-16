Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaLPAbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:31:25 -0500
Received: from ozlabs.org ([103.22.144.67]:47938 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbaLPAbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:31:24 -0500
Date: Tue, 16 Dec 2014 11:31:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "George Spelvin" <linux@horizon.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, rusty@rustcorp.com.au
Subject: Re: [PATCH v2] VERIFY_OCTAL_PERMISSIONS: Move to <linux/sysfs.h>
 where it belongs
Message-ID: <20141216113117.1c8b0bb6@canb.auug.org.au>
In-Reply-To: <20141216001453.1808.qmail@ns.horizon.com>
References: <20141216100957.6f42e898@canb.auug.org.au>
	<20141216001453.1808.qmail@ns.horizon.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/sD5HWS.eXjCvYopjnnNEp=0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sD5HWS.eXjCvYopjnnNEp=0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi George,

On 15 Dec 2014 19:14:53 -0500 "George Spelvin" <linux@horizon.com> wrote:
>
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Please do *not* mix changes up like this.  Split this out into a
> > separate patch, please (1 logical change per patch).
>=20
> Um... I thought I was doing that.  More particularly, the task of
> untangling header file dependencies eseemed sufficiently cohesive
> that it could be considered one logical change.

Well, given the subject of the commit, I expected a simple change that
just did the move (and any immediately associated include changes).
You then said "Some other extraneous header files pruned while I was at
it" and that part I would expect to be in a separate patch.

> It was one round of thinking and analysis about what declarations the
> affected files depend on.

Which is separate from what VERIFY_OCTAL_PERMISSIONS() requires.

> Although syntactically possible, given the small size of the change (I
> deleted a total of 5 #includes, 2 from moduleparam.h and 3 from sysfs.h),
> it didn't seem worth breaking it up further.
>=20
> > And testing only
> > on x86_64 is not "sure" when talking about header file pruning (but at
> > least you did the "all" configs).
>=20
> Well, the first round was reading and understanding the headers; the
> compile was just to make sure.

Understood, it was more a "actually changing architectures was more
likely to show breakage than building lots of stuff".  I guess I see
more breakage from pruning includes than most people since I build for
multiple architectures more than most.

> The files I was messing with (moduleparam.h and sysfs.h) don't have a
> lot of architecture-specificness within them.  The main danger is that
> they're used in a zillion places and some caller might depend on the
> over-inclusion.

The problem is not the direct includes and direct architecture
depenedencies, but the fact that lost of stuff ends up include asm/
include files at some point in the chain and that affects the set of
files implicitly included.  X86 seems to implicitly include more than
some other architectures.

> If my haste made me judge wrong, I apologize.  Was I very wrong, or
> just a bit over the line?

Probably just a bit over the line.  The advantage of the split would be
that when it hits Andrew's tree and then breaks linux-next (for me), I
can pick on a smaller patch to get rid of/correct.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/sD5HWS.eXjCvYopjnnNEp=0
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj31ZAAoJEMDTa8Ir7ZwVuN4P/R4lh5qwv5DK/jAPJeQ6X5x4
Rh7Ce3mCnsMINxZJmnr5dVJp8aanwMa8uPJSPCYnXxqejipWdp1XhOmeDEWhjs9K
A0e9SWhYiHeLyJm5H6ScOZmF8v9i6/c6g1NNCz7lq0WcUDYLG3/5lcav+8LCHyCl
HAgBhyeyuHfoEynPwuBnsV/IPPGAoglKw22JoaNQ8WEa22Kx5sbh9zGVRh9Z1pXx
8kwLaSPaszcsgIIz9YE1Z4FRaJWFvKiwwSLX3IEEpiOQC+Su1qBWmOE5ICyrWiO8
VJaSny6p4NI5lfIvDb8WWWS7K1Ez/B5gtFtULxU7gt/m3S2b1J8aN216Hp7eVMD3
bWp+FdCGxXI8fe7fMmX8oJMfAczVBbBnbGuaXTQTEHtLfUAtINIgjO+GVv5p+Ol7
kjWQ3aVrYtxXc1jSua1W+jKlR2Z49wPLw9f3sRInP9X5MRXgoxmTD/4WU53ZfqUE
qlEYd2TQo2iE8M4xZBiwCJfmjlgHInQwWUs009RFz95MRKpyTA9oAzjzyXVUzooU
nQ9bVh4Wv6oTmYb9aqpa/H3PCPVMgPmvH6oGRzHiUpaGbB6Dbvd0iTSf3Eiy9qvh
OiY5zIH3tau1mT+XP14WVKYyLr3iHswSYpJFb/1UmFead8BI89mhX1OE+sw5naAN
XJQhxbajgj9wBbFSsxPQ
=TGLa
-----END PGP SIGNATURE-----

--Sig_/sD5HWS.eXjCvYopjnnNEp=0--
