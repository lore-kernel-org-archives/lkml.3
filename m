Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab3LQGAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 01:00:10 -0500
Received: from ozlabs.org ([203.10.76.45]:50306 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3LQGAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 01:00:08 -0500
Date: Tue, 17 Dec 2013 16:59:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20131217165956.b5c92af06a83392e8bfb5d46@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Dec_2013_16_59_56_+1100_tv=u5lnbm+nyB0ft"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Dec_2013_16_59_56_+1100_tv=u5lnbm+nyB0ft
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/rtc/rtc-hym8563.c:90:17: error: field 'clkout_hw' has incomplete ty=
pe
  struct clk_hw  clkout_hw;
                 ^
In file included from include/asm-generic/bug.h:13:0,
                 from arch/powerpc/include/asm/bug.h:127,
                 from include/linux/bug.h:4,
                 from include/linux/thread_info.h:11,
                 from include/asm-generic/preempt.h:4,
                 from arch/powerpc/include/generated/asm/preempt.h:1,
                 from include/linux/preempt.h:18,
                 from include/linux/spinlock.h:50,
                 from include/linux/seqlock.h:35,
                 from include/linux/time.h:5,
                 from include/linux/stat.h:18,
                 from include/linux/module.h:10,
                 from drivers/rtc/rtc-hym8563.c:20:
drivers/rtc/rtc-hym8563.c: In function 'hym8563_clkout_recalc_rate':
include/linux/kernel.h:801:48: warning: initialization from incompatible po=
inter type [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:305:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
include/linux/kernel.h:801:48: warning: (near initialization for 'hym8563')=
 [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:305:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
drivers/rtc/rtc-hym8563.c: In function 'hym8563_clkout_set_rate':
include/linux/kernel.h:801:48: warning: initialization from incompatible po=
inter type [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:331:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
include/linux/kernel.h:801:48: warning: (near initialization for 'hym8563')=
 [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:331:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
drivers/rtc/rtc-hym8563.c: In function 'hym8563_clkout_control':
include/linux/kernel.h:801:48: warning: initialization from incompatible po=
inter type [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:352:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
include/linux/kernel.h:801:48: warning: (near initialization for 'hym8563')=
 [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:352:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
drivers/rtc/rtc-hym8563.c: In function 'hym8563_clkout_is_prepared':
include/linux/kernel.h:801:48: warning: initialization from incompatible po=
inter type [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:379:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
include/linux/kernel.h:801:48: warning: (near initialization for 'hym8563')=
 [enabled by default]
  const typeof( ((type *)0)->member ) *__mptr =3D (ptr); \
                                                ^
drivers/rtc/rtc-hym8563.c:293:35: note: in expansion of macro 'container_of'
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout=
_hw)
                                   ^
drivers/rtc/rtc-hym8563.c:379:28: note: in expansion of macro 'clkout_hw_to=
_hym8563'
  struct hym8563 *hym8563 =3D clkout_hw_to_hym8563(hw);
                            ^
drivers/rtc/rtc-hym8563.c: At top level:
drivers/rtc/rtc-hym8563.c:389:14: error: variable 'hym8563_clkout_ops' has =
initializer but incomplete type
 const struct clk_ops hym8563_clkout_ops =3D {
              ^
drivers/rtc/rtc-hym8563.c:390:2: error: unknown field 'prepare' specified i=
n initializer
  .prepare =3D hym8563_clkout_prepare,
  ^
drivers/rtc/rtc-hym8563.c:390:2: warning: excess elements in struct initial=
izer [enabled by default]
drivers/rtc/rtc-hym8563.c:390:2: warning: (near initialization for 'hym8563=
_clkout_ops') [enabled by default]
drivers/rtc/rtc-hym8563.c:391:2: error: unknown field 'unprepare' specified=
 in initializer
  .unprepare =3D hym8563_clkout_unprepare,
  ^
drivers/rtc/rtc-hym8563.c:391:2: warning: excess elements in struct initial=
izer [enabled by default]
drivers/rtc/rtc-hym8563.c:391:2: warning: (near initialization for 'hym8563=
_clkout_ops') [enabled by default]
drivers/rtc/rtc-hym8563.c:392:2: error: unknown field 'is_prepared' specifi=
ed in initializer
  .is_prepared =3D hym8563_clkout_is_prepared,
  ^
drivers/rtc/rtc-hym8563.c:392:2: warning: excess elements in struct initial=
izer [enabled by default]
drivers/rtc/rtc-hym8563.c:392:2: warning: (near initialization for 'hym8563=
_clkout_ops') [enabled by default]
drivers/rtc/rtc-hym8563.c:393:2: error: unknown field 'recalc_rate' specifi=
ed in initializer
  .recalc_rate =3D hym8563_clkout_recalc_rate,
  ^
drivers/rtc/rtc-hym8563.c:393:2: warning: excess elements in struct initial=
izer [enabled by default]
drivers/rtc/rtc-hym8563.c:393:2: warning: (near initialization for 'hym8563=
_clkout_ops') [enabled by default]
drivers/rtc/rtc-hym8563.c:394:2: error: unknown field 'round_rate' specifie=
d in initializer
  .round_rate =3D hym8563_clkout_round_rate,
  ^
drivers/rtc/rtc-hym8563.c:394:2: warning: excess elements in struct initial=
izer [enabled by default]
drivers/rtc/rtc-hym8563.c:394:2: warning: (near initialization for 'hym8563=
_clkout_ops') [enabled by default]
drivers/rtc/rtc-hym8563.c:395:2: error: unknown field 'set_rate' specified =
in initializer
  .set_rate =3D hym8563_clkout_set_rate,
  ^
drivers/rtc/rtc-hym8563.c:395:2: warning: excess elements in struct initial=
izer [enabled by default]
drivers/rtc/rtc-hym8563.c:395:2: warning: (near initialization for 'hym8563=
_clkout_ops') [enabled by default]
drivers/rtc/rtc-hym8563.c: In function 'hym8563_clkout_register_clk':
drivers/rtc/rtc-hym8563.c:403:23: error: storage size of 'init' isn't known
  struct clk_init_data init;
                       ^
drivers/rtc/rtc-hym8563.c:413:15: error: 'CLK_IS_ROOT' undeclared (first us=
e in this function)
  init.flags =3D CLK_IS_ROOT;
               ^
drivers/rtc/rtc-hym8563.c:413:15: note: each undeclared identifier is repor=
ted only once for each function it appears in
drivers/rtc/rtc-hym8563.c:419:2: error: implicit declaration of function 'c=
lk_register' [-Werror=3Dimplicit-function-declaration]
  clk =3D clk_register(&client->dev, &hym8563->clkout_hw);
  ^
drivers/rtc/rtc-hym8563.c:422:3: error: implicit declaration of function 'o=
f_clk_add_provider' [-Werror=3Dimplicit-function-declaration]
   of_clk_add_provider(node, of_clk_src_simple_get, clk);
   ^
drivers/rtc/rtc-hym8563.c:422:29: error: 'of_clk_src_simple_get' undeclared=
 (first use in this function)
   of_clk_add_provider(node, of_clk_src_simple_get, clk);
                             ^
drivers/rtc/rtc-hym8563.c:403:23: warning: unused variable 'init' [-Wunused=
-variable]
  struct clk_init_data init;
                       ^

Caused by commit 34ef6d7fe467 ("rtc: add hym8563 rtc-driver") from the
akpm-current tree.  Probably some missing include(s).

I just reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Dec_2013_16_59_56_+1100_tv=u5lnbm+nyB0ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSr+hhAAoJEMDTa8Ir7ZwVvrwP/j/MxdI3eqp7XylwJn5AXXg1
i1MmV02Je5L1Wusv0CpluCNsbzIaaXZijK7OfDNRlXrv7Qg1pCQA1Jlw+vFf16jG
KZkcyqLJ/hth9jsgoE2LEnUlXb6Z/7p5dvK3SuJxNQ4fyO1KiUztvmeCmJovy91p
qcKM0fzskoo9Lm0rfmPgvN1Jei4gReSok60fC9ldoCn7mDgE5ZjkvLgg/k0P460e
p4YeGEFXckYvOO/Q500Za8TVFJ2oPdsOWBgP//4zEf0hj7PJDVtlP4QvSBlolyrX
Vs6B0hrnbMWhz0Rki2mfy1tK5wl2QuFqXMThq3yW3Nh4L7cj/RiC0yI8t1h+Ep4b
I+AbAds+uWNGK73eicTX46baDbF28GhtOMw91At4epq3ESwUSJa6o8SMjZ/HfA1+
bJuGmFWWndX+2/k9jQEk0FSbaJEZnKrxRLziilALEISdIjid3lfM0QJMnRZojOAR
ZFD5U4ba7g+O/apAm444niZuscAPmThlJSs99+wuolv6Io/bj7Bt/6ocB9WFJioQ
AA8Tgag9LlRCuSakU0A5fzOi+hcnPdzWrW9YeN9BiryZAJtVKuuAn6Iuq43uRCHl
ABY123l9XhA5Yg7d9//9fy/Y+EfyAtmhcbThehmQAqju4uBmJirn/Lm8jcOMvvVL
OROj5rn8OwxY7vdrIVD6
=x6Xw
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Dec_2013_16_59_56_+1100_tv=u5lnbm+nyB0ft--
