Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbbAMAUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 19:20:24 -0500
Received: from ozlabs.org ([103.22.144.67]:52663 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbbAMAUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 19:20:22 -0500
Date: Tue, 13 Jan 2015 11:20:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Evgeni Dobrev <evgeni@studio-punkt.com>,
        Peter Robinson <pbrobinson@gmail.com>
Subject: linux-next: manual merge of the mvebu tree with the arm-soc tree
Message-ID: <20150113112016.2db3f982@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_EegXDEPZQmch._Y_BJjiZf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_EegXDEPZQmch._Y_BJjiZf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/boot/dts/Makefile between commit 6f1650f15bc4 ("ARM: dts: Only
build dtb if associated Arch and/or SoC is enabled") from the arm-soc
tree and commit dd7d2be1d2b8 ("Kirkwood: add support for Seagate
BlackArmor NAS220") from the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/Makefile
index abb810f1fe29,17ee1d6a0ac0..000000000000
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@@ -112,24 -101,18 +112,25 @@@ dtb-$(CONFIG_ARCH_EXYNOS5) +=3D=20
  	exynos5440-sd5v1.dtb \
  	exynos5440-ssdk5440.dtb \
  	exynos5800-peach-pi.dtb
 -dtb-$(CONFIG_ARCH_HI3xxx) +=3D hi3620-hi4511.dtb
 -dtb-$(CONFIG_ARCH_HIX5HD2) +=3D hisi-x5hd2-dkb.dtb
 -dtb-$(CONFIG_ARCH_HIGHBANK) +=3D highbank.dtb \
 +dtb-$(CONFIG_ARCH_HI3xxx) +=3D \
 +	hi3620-hi4511.dtb
 +dtb-$(CONFIG_ARCH_HIX5HD2) +=3D \
 +	hisi-x5hd2-dkb.dtb
 +dtb-$(CONFIG_ARCH_HIGHBANK) +=3D \
 +	highbank.dtb \
  	ecx-2000.dtb
 -dtb-$(CONFIG_ARCH_HIP04) +=3D hip04-d01.dtb
 -dtb-$(CONFIG_ARCH_INTEGRATOR) +=3D integratorap.dtb \
 +dtb-$(CONFIG_ARCH_HIP04) +=3D \
 +	hip04-d01.dtb
 +dtb-$(CONFIG_ARCH_INTEGRATOR) +=3D \
 +	integratorap.dtb \
  	integratorcp.dtb
 -dtb-$(CONFIG_ARCH_KEYSTONE) +=3D k2hk-evm.dtb \
 +dtb-$(CONFIG_ARCH_KEYSTONE) +=3D \
 +	k2hk-evm.dtb \
  	k2l-evm.dtb \
  	k2e-evm.dtb
 -dtb-$(CONFIG_MACH_KIRKWOOD) +=3D kirkwood-b3.dtb \
 +dtb-$(CONFIG_MACH_KIRKWOOD) +=3D \
 +	kirkwood-b3.dtb \
+ 	kirkwood-blackarmor-nas220.dtb \
  	kirkwood-cloudbox.dtb \
  	kirkwood-d2net.dtb \
  	kirkwood-db-88f6281.dtb \

--Sig_/_EegXDEPZQmch._Y_BJjiZf
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUtGTEAAoJEMDTa8Ir7ZwV3RgP/0wjZ+7+8TjvtbPMp9mZZJr+
qzxigyhuqtjf1qvB9MSpu6BZu4LmA7HErJeEIiKCgTbPah/finqMi18eC4D/qrkz
SkvgEuly4wCuoItj+q8LMlF2AlwRmX9Idag1HZdFe4WaHgZyC/nBguvcMz2n3b3y
r1MSaQ/ndX63kwoS0P9lp/QFaOFi/9rUYFxBpnjvgt8KgpjLGRYaFhngW9phzWn6
kldG3+cQjhqDMi9cgmVazgtpmbUTGoSZuH98Me/E5iK7y8L67cyp+nS6U3j1kX0K
b8tBwO4UPkhig1Uv/uDphaFUBcOHAFB8vMMiMt4XVcl5YZR9E72OlXeZ0z55lR9Q
7JCyOmgZgKvpAPb8yn2XrAaDdrr8/VF8SQcEgpFpfUlVWurXYd0Tkw4R9oYKsrlN
Z+0qjdyuUxf9cGUlZiWVCEn5DYalt79nzQtFAVEff5gjySlEdgL4yn8pyJZAC27G
4MdIvjH2yiqOs2JAxKUjPkrwEcK966OlKjDfnLqQqa/gVR8XZw+rKYtOwLP12wiY
Z4NsckbExcnxHNKtnGVR1/QZlMudJUQrVcRtP6HvPChoGcaZyzDgmiRg6UWvjTlT
I8hpQeA5qDD21+9slbDYYT2Oi3jlwCjCzgWfZXkxLAFNoWk+CAmIU9MO+c7JoFAt
0aIfPxiLaFvpLE3bWyVJ
=AImm
-----END PGP SIGNATURE-----

--Sig_/_EegXDEPZQmch._Y_BJjiZf--
