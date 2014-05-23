Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751147AbaEWBUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 21:20:12 -0400
Received: from ozlabs.org ([103.22.144.67]:56158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaEWBUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 21:20:10 -0400
Date: Fri, 23 May 2014 11:20:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>, Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Subject: linux-next: manual merge of the samsung tree with the  tree
Message-ID: <20140523112003.3da4b5f5@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BQ.qXnhMtslwnXiMDFAFTb6"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BQ.qXnhMtslwnXiMDFAFTb6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/mach-exynos/exynos.c between commit 46bfc99c9225 ("ARM: l2c:
exynos: convert to generic l2c OF initialisation (and thereby fix it)")
from the arm tree and commit 3919fb954b3a ("ARM: EXYNOS: Remove
exynos_subsys registration") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/exynos.c
index afce154f83f9,93507ee98c86..000000000000
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@@ -241,17 -246,22 +243,6 @@@ void __init exynos_init_io(void
  	exynos_map_io();
  }
 =20
- struct bus_type exynos_subsys =3D {
- 	.name		=3D "exynos-core",
- 	.dev_name	=3D "exynos-core",
- };
-=20
- static int __init exynos_core_init(void)
 -static int __init exynos4_l2x0_cache_init(void)
--{
- 	return subsys_system_register(&exynos_subsys, NULL);
 -	int ret;
 -
 -	ret =3D l2x0_of_init(L2_AUX_VAL, L2_AUX_MASK);
 -	if (ret)
 -		return ret;
 -
 -	if (IS_ENABLED(CONFIG_S5P_SLEEP)) {
 -		l2x0_regs_phys =3D virt_to_phys(&l2x0_saved_regs);
 -		clean_dcache_area(&l2x0_regs_phys, sizeof(unsigned long));
 -	}
 -	return 0;
--}
- core_initcall(exynos_core_init);
 -early_initcall(exynos4_l2x0_cache_init);
--
  static void __init exynos_dt_machine_init(void)
  {
  	struct device_node *i2c_np;

--Sig_/BQ.qXnhMtslwnXiMDFAFTb6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfqJIAAoJEMDTa8Ir7ZwV36gP/iwUuYXSJkA5I6uWKpg0enMz
zQgIaAttEgu4XygXyes7YgUv1oah9q8nbdCBQHuiBhYfGIs+fO0goo2484FEsqix
wBxyzCoCrTe3lsTQDKYv5oNR138Y4/AqmI82TS5KdJtfyxWwvzwrMwEFRofzv5LH
rcc+R1uNrpBSemU/3SDlgMcY6PAg/bkLxRUp6QNgL8JZXT6gqgyu/zlB+5qRsqwb
lzYBr16+S1HbvMZxSWHlRtBFv9nEgjCIk29lZMaJeoy9z2hndFelixBQaoq3Wm59
D5dHWWSaAJQvkUpnFvxyrpqxquX7mYnxmOauzuLhPFFt5jyWL5mKNmjvWNYcuESr
VTLhRfkf4Y/OGJQh+t0WEIisDAQNDJ7UCymppDgyi3ObY7TO39JsgMY6FUf6p8Qw
KPR41Ol2oSuk3crqDr0LZQ4iirZDjlTkmXk0+JnuOEClHFZHscM2C4unmDy+3CG1
m3TRzsSxgldEIGAkuaZgZYXdqldXjyJ9qfUXlaZmF8siWFK2iiYX2XgCvoUoZl2F
Dis9KKh5Bs44faFWteE8XI95htgkKBovdjMpN/zfWPUwYlUEo1EsGefcTWCAf80C
i59aYEOWKC/MX/ziKjdUIW2sEhE7GQV6GxtUqlDtT7RPO/80Cxsz/c4lmgMRccti
AjWdk5BSpwgGRu9h/ti8
=NQbG
-----END PGP SIGNATURE-----

--Sig_/BQ.qXnhMtslwnXiMDFAFTb6--
