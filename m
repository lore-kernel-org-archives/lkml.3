Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaLPDpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 22:45:49 -0500
Received: from ozlabs.org ([103.22.144.67]:50042 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaLPDps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 22:45:48 -0500
Date: Tue, 16 Dec 2014 14:45:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: linux-next: build failure after merge of the clk tree
Message-ID: <20141216144536.594b50c0@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mPP.J0HU4lm22fZiN6NwrBt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mPP.J0HU4lm22fZiN6NwrBt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mike,

After merging the clk tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from arch/x86/include/asm/bug.h:35:0,
                 from include/linux/bug.h:4,
                 from include/linux/cpumask.h:12,
                 from arch/x86/include/asm/cpumask.h:4,
                 from arch/x86/include/asm/msr.h:10,
                 from arch/x86/include/asm/processor.h:20,
                 from arch/x86/include/asm/atomic.h:6,
                 from include/linux/atomic.h:4,
                 from include/linux/debug_locks.h:5,
                 from include/linux/lockdep.h:23,
                 from include/linux/spinlock_types.h:18,
                 from include/linux/mutex.h:15,
                 from include/linux/notifier.h:13,
                 from include/linux/clk.h:17,
                 from include/linux/clk-provider.h:14,
                 from include/linux/clk-private.h:14,
                 from drivers/clk/clk.c:12:
drivers/clk/clk.c: In function 'clk_debug_create_one':
include/linux/lockdep.h:339:51: error: invalid type argument of '->' (have =
'struct mutex')
 #define lockdep_is_held(lock) lock_is_held(&(lock)->dep_map)
                                                   ^
include/asm-generic/bug.h:86:25: note: in definition of macro 'WARN_ON'
  int __ret_warn_on =3D !!(condition);    \
                         ^
include/linux/lockdep.h:362:27: note: in expansion of macro 'lockdep_is_hel=
d'
   WARN_ON(debug_locks && !lockdep_is_held(l)); \
                           ^
drivers/clk/clk.c:248:2: note: in expansion of macro 'lockdep_assert_held'
  lockdep_assert_held(clk_debug_lock);
  ^

Caused by commit 9a2027b99994 ("clk: Really fix deadlock with
mmap_sem").  I wonder how this ever built?

I have used the clk tree from next-20141215 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mPP.J0HU4lm22fZiN6NwrBt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUj6rpAAoJEMDTa8Ir7ZwV5P4P/jiyZZc1NurMkoF8QQnMgd52
se57RLOuFVh/6hquCgASG7TRHilLb+HvQo4aqaY3FXsSJiF1UsLcz5TC9Bhep405
loRlf+vsNTztKKUXRceSvTxmIoXm5fbih0IHGYA+mrq/Ll3+IjgsoaYcnvxDp6gT
o0+ItGNoaxPuftN+VrzlZOjJAJ+2kXcEzTcYwhnEFU5HHq5SgUE1QDbt2TxSYtUE
O7bkjr5/q0JpTJ1bbIgxMsooHOrIOAusgRWk0JbzOl+pJppJfCbx9pjusThhBj2D
hkkLnneZBNahxqCHdE7TwicZZIUqO4ivi3ZHKUpK1wJqooX3RQCYURrTa2P91Y4C
jH1esxgvXU1le5ZZHqXoUdLpO2ZE9fc4bOsnXuey+IrOSXoQA2T9JziO0+GPqotC
U4Fg+J5oj0S046FiPyAKXxSNxyRldEqzKCIkxMB79w0NJJ0EYAtecepCfzJIvpTD
YggAGO/3P1rEhwypGb1jZOjDW79syNFHKmheE/aOmr3/GuL8chZqd5nY2lDA7IxY
hiiqNRIi45naCG/rwQUZQU0K4PTu5U6yikSXQ8P8EMs/ft69Wd6AAcVNe+jshDno
PkJTdwMpxU0zo4P9U7pZhk1lZoBnd1CqehAwCe5+qJmNJbAkgjP6Jj2C50mQA6AR
QkM5cHJLrmcQYQShWzDW
=ryjm
-----END PGP SIGNATURE-----

--Sig_/mPP.J0HU4lm22fZiN6NwrBt--
