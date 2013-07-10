Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab3GJC5I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:57:08 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43726 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3GJC5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:57:06 -0400
Date: Wed, 10 Jul 2013 12:56:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the slab tree
Message-Id: <20130710125654.dd36f8fb19588697226b99be@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Jul_2013_12_56_54_+1000_IjTmZTge9HataiPj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jul_2013_12_56_54_+1000_IjTmZTge9HataiPj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the slab tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from include/linux/slab.h:17:0,
                 from include/linux/crypto.h:24,
                 from arch/x86/kernel/asm-offsets.c:8:
include/linux/kmemleak.h: In function 'kmemleak_alloc_recursive':
include/linux/kmemleak.h:44:16: error: 'SLAB_NOLEAKTRACE' undeclared (first=
 use in this function)
  if (!(flags & SLAB_NOLEAKTRACE))
                ^
include/linux/kmemleak.h: In function 'kmemleak_free_recursive':
include/linux/kmemleak.h:50:16: error: 'SLAB_NOLEAKTRACE' undeclared (first=
 use in this function)
  if (!(flags & SLAB_NOLEAKTRACE))
                ^

Probably caused by commit 590a63973e36 ("mm/sl[aou]b: Move kmalloc
definitions to slab.h").

I have used the slab tree from next-20130709 for today.

And, yes, I am a little annoyed by this.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Jul_2013_12_56_54_+1000_IjTmZTge9HataiPj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR3M16AAoJEECxmPOUX5FEBEkP/jrCY+t40wGDNEPOEAMy5KKS
uorkS1OdAPhE/n9XUAEZWih0WGyl9kDPFAnypCwuLNj0SQ6LC+6zuGMx3Q715vTc
rU+tDLu56GIsS2oBrbJTcPniMS3+tFB9DhzdwDepFLbfG60IiQUVzfp/yGezxQzJ
Rvgb0Fmx7U0Fbs5442ipGj9SUJi7vYFPQ+aQPqQ0nFLBdssEDyfMN33lWlNIZeA7
L1gaXaKUxSOY+fqMFYIIKAHkhWMEhCsDOl2nhPYCPN7zqrvFWZaRJLcLurVvtGWb
xiALpcbzw5wyRf8uo4y3HKalHXP1PtrnvlOGtqdJ77rKipTv+7/+CJvJNts4ohBc
gDm4KFO9jyDL3UA7gF0C0Q+Lgb9qTTEsX43NRrR1KbT1lET4zrDMZuAhpVlYhbyU
q1LSb5bLpAY1czsXux9x9m4mr77ky3gagbt0R0yvtKd6JmFlN4fxSOPlprE15aPw
5IYuKg5g3Xwnbq6vfXXyb0ppJdCBHc7KhwvYxc/Q0CIniFDkZfJu5TLudGZJrZBS
6hbB0uybH7SNqYWARJuGxRNeqPdl7WidkfIZFj+DCXYLJwxl85nB/MSl+IT5mCKq
XDVNzakZCs5kBalG2TUVglOo0GnthXhqK+CEKXF2CRNXG3xXy0A/QcM08ScMkfC2
uiW+DDHSXDoVxUqk/65E
=Vdtu
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jul_2013_12_56_54_+1000_IjTmZTge9HataiPj--
