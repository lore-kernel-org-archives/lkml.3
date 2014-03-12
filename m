Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672AbaCLWEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:04:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55458 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbaCLWEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:04:05 -0400
Date: Wed, 12 Mar 2014 22:03:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@secretlab.ca>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Stephen Boyd <sboyd@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312220350.3c35bce7dff139a73a9c8262@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_22_03_50_+0000_vmFFXRA22RtmV3h9"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the devicetree tree with the arm-soc
 tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_22_03_50_+0000_vmFFXRA22RtmV3h9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in include/a=
sm-generic/vmlinux.lds.h between commit 6c3ff8b11a16ec69 ("ARM: Introduce C=
PU_METHOD_OF_DECLARE() for cpu hotplug/smp") from the  tree and commit f618=
c4703a14672d27 ("drivers: of: add support for custom reserved memory driver=
s") from the devicetree tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc include/asm-generic/vmlinux.lds.h
index bd02ca7a1d55,f10f64fcc815..000000000000
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@@ -167,15 -167,16 +167,25 @@@
  #define CLK_OF_TABLES()
  #endif
 =20
 +#ifdef CONFIG_SMP
 +#define CPU_METHOD_OF_TABLES() . =3D ALIGN(8);                           =
   \
 +                         VMLINUX_SYMBOL(__cpu_method_of_table_begin) =3D =
.; \
 +                         *(__cpu_method_of_table)                        =
 \
 +                         VMLINUX_SYMBOL(__cpu_method_of_table_end) =3D .;
 +#else
 +#define CPU_METHOD_OF_TABLES()
 +#endif
 +
+ #ifdef CONFIG_OF_RESERVED_MEM
+ #define RESERVEDMEM_OF_TABLES()                               \
+       . =3D ALIGN(8);                                   \
+       VMLINUX_SYMBOL(__reservedmem_of_table) =3D .;     \
+       *(__reservedmem_of_table)                       \
+       *(__reservedmem_of_table_end)
+ #else
+ #define RESERVEDMEM_OF_TABLES()
+ #endif
+=20
  #define KERNEL_DTB()                                                  \
        STRUCT_ALIGN();                                                 \
        VMLINUX_SYMBOL(__dtb_start) =3D .;                                \
@@@ -499,8 -500,8 +509,9 @@@
        TRACE_SYSCALLS()                                                \
        MEM_DISCARD(init.rodata)                                        \
        CLK_OF_TABLES()                                                 \
+       RESERVEDMEM_OF_TABLES()                                         \
        CLKSRC_OF_TABLES()                                              \
 +      CPU_METHOD_OF_TABLES()                                          \
        KERNEL_DTB()                                                    \
        IRQCHIP_OF_MATCH_TABLE()
 =20

--Signature=_Wed__12_Mar_2014_22_03_50_+0000_vmFFXRA22RtmV3h9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTINnGAAoJELSic+t+oim9T84P/jHXGdUJg0CaVMZPMLQYbis3
hpQRZCjrLmdV9hsTCPZA6A7enhUSYObXBJ1AIz6secN3A9MshoIcoGtyk/SayRrf
NeIZlBGsujBz7Zs7VbrE77+fHKl24xgmb9iiAZbR7J0KuH8Vj7fVIjuWDdknj+K0
mFXQ+ozWDkUFwkXL6+a3u691oqAovpQo6DM1wn9gz+i3IFWXijMsG1KPPOMiqNfg
0BBsvLHRG7u2a7qQ5/R5I0Hajlzpsz/nNl2BsIphEjOwStDvV9tF9/S9waB10hYC
yPi5YpL6XR9naRY75NyFCmwjpSdhfK9chOw7UsfNd88Q9z8vNZ4YrjUK5vHFZ7NE
cg+lMeK8NI/BVhnPG+d4D2I2WFUeau6O1DgcdmL33r05KIhjuky3SabFRYfPXs1X
UjbZPlmblWLKlfiytj5ze+KzShLmxThRHWseOdTBqnXDnFwXxgcj2N1QWatsRO1s
WSLcsPsdkA1BIlnwftafLC6S8Wt6tKL/RokaIvUKxj7cHdGutx8NjLsBsH5hgd7r
vokZnw9OuixYaUjq+/gl8kskkdos0X8mwfivj/LcqK0Sa11pvtBELLG2E/wKHbQ8
mToDRGBNe5BdqNVoViPvTPGSwh+ZvhgIIAQA2dMy0DC70m8gPWfD9eMXcxLgCmBj
vloSDCIm65dxs8mPVeqD
=1+3D
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_22_03_50_+0000_vmFFXRA22RtmV3h9--
