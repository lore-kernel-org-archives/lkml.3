Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751397AbaG1D7Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:59:16 -0400
Received: from ozlabs.org ([103.22.144.67]:35632 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaG1D7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:59:13 -0400
Date: Mon, 28 Jul 2014 13:58:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the modules tree
Message-ID: <20140728135859.7977890b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gL3bHl2GGDaXJlJYtfW.P8N"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gL3bHl2GGDaXJlJYtfW.P8N
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the modules tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from include/linux/thread_info.h:11:0,
                 from arch/powerpc/include/asm/ptrace.h:151,
                 from arch/powerpc/include/asm/processor.h:44,
                 from arch/powerpc/include/asm/mmu-hash64.h:25,
                 from arch/powerpc/include/asm/mmu.h:189,
                 from arch/powerpc/include/asm/lppaca.h:36,
                 from arch/powerpc/include/asm/paca.h:20,
                 from arch/powerpc/include/asm/current.h:16,
                 from include/linux/mutex.h:13,
                 from include/linux/kernfs.h:13,
                 from include/linux/sysfs.h:15,
                 from include/linux/kobject.h:21,
                 from include/linux/of.h:21,
                 from arch/powerpc/platforms/powernv/opal-elog.c:13:
include/linux/bug.h:33:45: error: negative width in bit-field '<anonymous>'
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
                                             ^
include/linux/kernel.h:853:3: note: in expansion of macro 'BUILD_BUG_ON_ZER=
O'
   BUILD_BUG_ON_ZERO((perms) & 2) +    \
   ^
include/linux/sysfs.h:75:12: note: in expansion of macro 'VERIFY_OCTAL_PERM=
ISSIONS'
    .mode =3D VERIFY_OCTAL_PERMISSIONS(_mode) },  \
            ^
arch/powerpc/platforms/powernv/opal-elog.c:85:2: note: in expansion of macr=
o '__ATTR'
  __ATTR(id, 0666, elog_id_show, NULL);
  ^
include/linux/bug.h:33:45: error: negative width in bit-field '<anonymous>'
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
                                             ^
include/linux/kernel.h:853:3: note: in expansion of macro 'BUILD_BUG_ON_ZER=
O'
   BUILD_BUG_ON_ZERO((perms) & 2) +    \
   ^
include/linux/sysfs.h:75:12: note: in expansion of macro 'VERIFY_OCTAL_PERM=
ISSIONS'
    .mode =3D VERIFY_OCTAL_PERMISSIONS(_mode) },  \
            ^
arch/powerpc/platforms/powernv/opal-elog.c:87:2: note: in expansion of macr=
o '__ATTR'
  __ATTR(type, 0666, elog_type_show, NULL);
  ^
In file included from include/linux/thread_info.h:11:0,
                 from arch/powerpc/include/asm/ptrace.h:151,
                 from arch/powerpc/include/asm/processor.h:44,
                 from arch/powerpc/include/asm/mmu-hash64.h:25,
                 from arch/powerpc/include/asm/mmu.h:189,
                 from arch/powerpc/include/asm/lppaca.h:36,
                 from arch/powerpc/include/asm/paca.h:20,
                 from arch/powerpc/include/asm/current.h:16,
                 from include/linux/mutex.h:13,
                 from include/linux/kernfs.h:13,
                 from include/linux/sysfs.h:15,
                 from include/linux/kobject.h:21,
                 from arch/powerpc/platforms/powernv/opal-dump.c:12:
include/linux/bug.h:33:45: error: negative width in bit-field '<anonymous>'
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
                                             ^
include/linux/kernel.h:853:3: note: in expansion of macro 'BUILD_BUG_ON_ZER=
O'
   BUILD_BUG_ON_ZERO((perms) & 2) +    \
   ^
include/linux/sysfs.h:75:12: note: in expansion of macro 'VERIFY_OCTAL_PERM=
ISSIONS'
    .mode =3D VERIFY_OCTAL_PERMISSIONS(_mode) },  \
            ^
arch/powerpc/platforms/powernv/opal-dump.c:105:2: note: in expansion of mac=
ro '__ATTR'
  __ATTR(id, 0666, dump_id_show, NULL);
  ^
include/linux/bug.h:33:45: error: negative width in bit-field '<anonymous>'
 #define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
                                             ^
include/linux/kernel.h:853:3: note: in expansion of macro 'BUILD_BUG_ON_ZER=
O'
   BUILD_BUG_ON_ZERO((perms) & 2) +    \
   ^
include/linux/sysfs.h:75:12: note: in expansion of macro 'VERIFY_OCTAL_PERM=
ISSIONS'
    .mode =3D VERIFY_OCTAL_PERMISSIONS(_mode) },  \
            ^
arch/powerpc/platforms/powernv/opal-dump.c:107:2: note: in expansion of mac=
ro '__ATTR'
  __ATTR(type, 0666, dump_type_show, NULL);
  ^

Caused by commit 37549e94c77a ("sysfs: disallow world-writable files")
interacting with commit c7e64b9ce04a ("powerpc/powernv Platform dump
interface") from v3.15-rc1.  I guess this patch needs updating ...

I have used the modules tree form next-20140725 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Sig_/gL3bHl2GGDaXJlJYtfW.P8N
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1cqNAAoJEMDTa8Ir7ZwVwlcP/jK+DdrPiiMNlHKZqu6Fk5qr
j6tJhTeOrVozONervQ8kKCBBW8EO4JojUMEbLp8965JfGkk+cJF4jfF6ZylNNjEf
Kla6EFkFq0v0hmUJHnL5Gf7CmYF6w4h/RNPrTHJLM5PLJOaTWkIG5yUU37r2O6rq
zoRz1hJk0iNNFrmy7DeXssisPlvObL/yRPg+v5NmL4tSXR3nkwFMyEumWsvwvQji
scSuKzy3Zwno6l5YOyX4yO24So2stryUROJdx0eHV2IPGd5MPraLuhX4akXRWE7V
CWZBZ15Xm3NxbKHWB92pt8MSC6Hatp437OqP8MJsk8yI8U/YniHiDmg6cLrOprCb
zq4MEbVA+iw78WBnMauacvSXlAu7Br3UTV1ZsB6mB2W1C5ux3KiqBoDZWbdMjjXE
1j4tixuBRmvru8Pdri/yXYd/zn/2qIrMtSNf10xkM/YvGTTrCTB9phsY720QnLKI
7NgtgDpt2VPTS0hJ8uDMrlBuJ72Ht8NPLLIZtE6iWKo9PUliuNdOkQtuBjRzUgbT
CNipHwEwCflSGLmP2H2U2X25cwVw4e5BQ32WusjZdznxGhbkBCzKB4gTjJXszreP
TT5VfjKEpyNkr5LYT2R+vy+cB9uJbc3z3wEx/XRmtvW9bNfoSaHkkSuDPml93zSe
B+BE0DxczbOeiOjBPEZh
=ABT8
-----END PGP SIGNATURE-----

--Sig_/gL3bHl2GGDaXJlJYtfW.P8N--
