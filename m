Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086Ab3EIEKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 00:10:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:58634 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab3EIEKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 00:10:40 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: make stat/statfs 64-bit for x86_64 kernels
Date: Thu, 9 May 2013 00:10:43 -0400
User-Agent: KMail/1.13.7 (Linux/3.8.3; KDE/4.6.5; x86_64; ; )
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
References: <1368072057-7832-1-git-send-email-vapier@gentoo.org> <518B204C.4080501@zytor.com>
In-Reply-To: <518B204C.4080501@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1553551.zqerYWfPDu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201305090010.45701.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1553551.zqerYWfPDu
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Thursday 09 May 2013 00:04:28 H. Peter Anvin wrote:
> On 05/08/2013 09:00 PM, Mike Frysinger wrote:
> > --- a/arch/x86/include/uapi/asm/statfs.h
> > +++ b/arch/x86/include/uapi/asm/statfs.h
> > +/* For x86-64, both the 64bit and x32 ABIs have 64bit fields. */
> > +#ifdef __x86_64__
> > +#define __statfs_word __u64
> > +#endif
> > +
> >=20
> >  #include <asm-generic/statfs.h>
> >  #endif /* _ASM_X86_STATFS_H */
>=20
> ... or is this what you meant to use?

i didn't intend to use this for stat.  that macro is a hook the common asm-
generic/statfs.h header provides for arches.

although maybe the better fix for statfs.h is to do:
=2D-- a/include/uapi/asm-generic/statfs.h
+++ b/include/uapi/asm-generic/statfs.h
@@ -13,7 +13,7 @@
  */
 #ifndef __statfs_word
 #if __BITS_PER_LONG =3D=3D 64
=2D#define __statfs_word long
+#define __statfs_word __u64
 #else
 #define __statfs_word __u32
 #endif
=2Dmike

--nextPart1553551.zqerYWfPDu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJRiyHFAAoJEEFjO5/oN/WBwO8QAIjXXnkx0yjZt4394X8W9cS+
smyauqrPZxATeRcPqY/R6+IlMTEIF7nvsJ261KliTxY8A2nkJbfY3ACyrVDBfiV6
4cyS/ie3wau20OT6fxERZPYdlIIdEYWxN5osRd44xEWax/RnKXSxmbWRepuenfmO
Bbf8WdOemac6c/AVZUjef/F3SttA3gHKeDAPNj2PA3Tb9NYVqp7UeJYCKgbgAkIS
z/15XzhAHOW6Oxkzu1wC7CCU2/u4G+syZ5YfPRQBHeBS9+cBl/302NQ6qcTsplOC
wxIaGrYB9GhSBIv9esgotSfgdzcbWRmi4zO8DQnJJ3Dn1MWSE3fDF9UHFyXxz0yE
MwnTArfz28KauV58h8F7uk9U0yuG/QXBwRv0tsu0azWLn4+Al0/qjJfbA1/nkZJ4
5Ih7zsjO5MGXYfkZQvU4NszJly5FRtH5SZ/aV9KLmHBVMXQsa8d2PgJvDgK7PMwr
hQrelxspIrolIYpUO4kzKSgDV+Cpz/196mFbmgVq8MpNjguCa9L1bqGl77ubiEs7
gGNhh4qiy7oA7iltt+QN4MuU8W3vVx8x+g5FTw+kf1KveS9zOZxOHCoAb9LxYcVe
2u/H7bXaZLSwz+V2rI57XCgMJWLhSnPq9bKcjvWGTH/XEweyQtCj08i2agTLh8ua
H9MQo8G7OvqZ+bfu5gcc
=n8zd
-----END PGP SIGNATURE-----

--nextPart1553551.zqerYWfPDu--
