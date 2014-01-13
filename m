Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaAMD0v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:26:51 -0500
Received: from ozlabs.org ([203.10.76.45]:52654 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaAMD0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:26:49 -0500
Date: Mon, 13 Jan 2014 14:26:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Chris Zankel <chris@zankel.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: linux-next: manual merge of the tip tree with the xtensa tree
Message-Id: <20140113142642.6e1944155b1db50d2c70abb4@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_14_26_42_+1100_4JNwu7Z.iyuGcO1E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_14_26_42_+1100_4JNwu7Z.iyuGcO1E
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/xtensa/include/asm/barrier.h between commit dbacef090841 ("xtensa:
add SMP support") from the xtensa tree and commit 93ea02bb8435 ("arch:
Clean up asm/barrier.h implementations using asm-generic/barrier.h") from
the tip tree.

I fixed it up (I am pretty sure - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/xtensa/include/asm/barrier.h
index 8e5e5c980a7a,e1ee6b51dfc5..000000000000
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@@ -16,16 -13,10 +13,6 @@@
  #define rmb() barrier()
  #define wmb() mb()
 =20
--#ifdef CONFIG_SMP
- #define smp_mb()	mb()
- #define smp_rmb()	rmb()
- #define smp_wmb()	wmb()
- #else
- #define smp_mb()	barrier()
- #define smp_rmb()	barrier()
- #define smp_wmb()	barrier()
 -#error smp_* not defined
--#endif
--
- #define set_mb(var, value)	do { var =3D value; mb(); } while (0)
+ #include <asm-generic/barrier.h>
 =20
  #endif /* _XTENSA_SYSTEM_H */

--Signature=_Mon__13_Jan_2014_14_26_42_+1100_4JNwu7Z.iyuGcO1E
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS01zyAAoJEMDTa8Ir7ZwVpA0P/iqd5aTZvpNksYfrFh1+kjcs
JXbNwR4IfOrgYYqlRl9EvskpGbWxZPxqKrh6+zFbuw8zrAALag8LAUMKEXn56G96
18IG9lD0lai6kWtZWqNQAKdaNcXarU5ODNPSxiYOkbSzwrgXNyVOnxYVkgbr0kvo
k4rvBU1ZutD+yWcs2ybj1mCfNi5quTYO/60z2J82dxtCA/boS7000IIRAE9M4a0O
/V8FbCEVgd7dSHhxsE70XI5yudSGI95EBWCEdBBcfMBr+OdlTX0ANwh/Owksqhfy
Lm/Tv77pAGOUf2qx6p86wQcyo8swG2ZJGwoblXLWFyp1Tegaea0wJ+Bok/wIu0uN
1X2h+3ErzVL/imSW5lTWquhjCiMYzmJfIcGErmGI/I0IOpeUw992UDhBQmbbJ6CV
pGWZX1dC6koZlB+hXbkV4SPcFOrkjaD8XYbBg6+lUYEg1PEl1aag3djwudsWCTim
06vpDU+iYwt6Ty98YLl4MoHVNAycR85FDFsZ3f004dXaAbsr6jSvx6yEDhpm6G30
HeA112ZUkeUYnUrg1s5x6ZVuHbS2xk2+lB7nQjtR7EfmEJfg/aj5DaL8jyXTYQ+l
efLoQF+hOzA08AuX0FDFE1c+G+VBIUzxuoXr2matryWnkGABtFlR6X0Gn3k0iDiu
esELcQvKkskGfoDXT85I
=YaUV
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_14_26_42_+1100_4JNwu7Z.iyuGcO1E--
