Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaFBAuI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:50:08 -0400
Received: from ozlabs.org ([103.22.144.67]:46266 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbaFBAuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:50:06 -0400
Date: Mon, 2 Jun 2014 10:49:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140602104957.21878870@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/nR5llQ7O0t=hMvsqXqEEig7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/nR5llQ7O0t=hMvsqXqEEig7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-exynos/exynos.c between commits dfbdd3d55403 ("ARM: l2c:
exynos: remove cache size override"), 25a9ef63cd2b ("ARM: l2c: exynos:
convert to common l2c310 early resume functionality") and 15b0bc4041ba
("ARM: l2c: exynos: convert to generic l2c OF initialisation (and
thereby fix it)") from the arm tree and commit b5b9324a6296 ("ARM:
exynos: don't run exynos4 l2x0 setup on other platforms") from the
arm-soc tree.

I fixed it up (the former removes the code updated by the latter) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-exynos/exynos.c
index a763c0862da9,bc43e22693b7..000000000000
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@@ -305,17 -246,25 +243,6 @@@ void __init exynos_init_io(void
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
 -	if (!soc_is_exynos4())
 -		return 0;
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

--Sig_/nR5llQ7O0t=hMvsqXqEEig7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTi8o6AAoJEMDTa8Ir7ZwVxjgP/3swq+aTB7FjKQP9c+e4BPrN
lxUE9ciGXt1R/dLxaTMZlShOzSsvzpFE1uiFlpv/MKeKuIIm6eAD/FmtuQJrHveD
orLOww+URYgbXqtiJo5t0lqd8NeWRFl6JRKLcJREtph8TQRvPJbqogUDtT+rC3zE
N9t96lqNFV3zlxGUnJGoOUT9/2M0uViE1lAdTfsPsyEdQoouVxplqgNb15Ts4FkU
ccKg+qqBOfumTuWJlKdR4W8NwlMkX3YCGAen4/yFvE7H+YxTMwS34VKNfvAK2IMI
CqN0X6UHDVlgD6Wpdi3QYv5b9+DQ7KRziODEvDu0k24njmF3x5+jXOpQboB1QUU9
aS1RczX+DJtkBC4hTrGKo/1QqxTCGyB2DRWr21AvzL6Ij1JW6tgr4yn5HLGduWH6
4FGuxXNge8YRjTN0f2VHZ1RfW/QSeIKHAnFv2FTsxJ7WkH2YD3yOSq/lgRTk47Aq
jR840KNtIt6v7gtL0upmNDg4uQ36xahFvR+uIfVvgV+1zTOxEMe2+v138gvV+W4R
ReaXHJ8Nlig8drRDVkQIwC38T+wk40auPmqICDpoCSRxy20O4aJfmQGCG4or6HgZ
eDwb1+tKLkIgiQysHWdXGbj26/t57U28YkVdw/jqUgELIqQyTyEN247zEPM23f/5
uEOUVqSl03uYuW0Pqa+B
=9Neg
-----END PGP SIGNATURE-----

--Sig_/nR5llQ7O0t=hMvsqXqEEig7--
