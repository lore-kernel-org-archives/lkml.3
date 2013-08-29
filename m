Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab3H2IEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:04:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56528 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab3H2IE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:04:28 -0400
Date: Thu, 29 Aug 2013 18:04:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sahara <keun-o.park@windriver.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: linux-next: manual merge of the arm-soc tree with the pm tree
Message-Id: <20130829180425.4aa3d164f01cc65b215187fe@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_18_04_25_+1000_zJ8Qzz224/Dy0fV6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_18_04_25_+1000_zJ8Qzz224/Dy0fV6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/cpuidle/Makefile between commits b98e01ad4ed9 ("cpuidle: Add
Kconfig.arm and move calxeda, kirkwood and zynq") and d3f2950f2ade ("ARM:
ux500: cpuidle: Move ux500 cpuidle driver to drivers/cpuidle") from the
pm tree and commit 14d2c34cfa00 ("cpuidle: big.LITTLE: vexpress-TC2 CPU
idle driver") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/cpuidle/Makefile
index 0b9d200,3b6445c..0000000
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@@ -5,9 -5,7 +5,10 @@@
  obj-y +=3D cpuidle.o driver.o governor.o sysfs.o governors/
  obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) +=3D coupled.o
 =20
 -obj-$(CONFIG_CPU_IDLE_CALXEDA) +=3D cpuidle-calxeda.o
 -obj-$(CONFIG_ARCH_KIRKWOOD) +=3D cpuidle-kirkwood.o
 -obj-$(CONFIG_CPU_IDLE_ZYNQ) +=3D cpuidle-zynq.o
 -obj-$(CONFIG_CPU_IDLE_BIG_LITTLE) +=3D cpuidle-big_little.o
 +#########################################################################=
#########
 +# ARM SoC drivers
 +obj-$(CONFIG_ARM_HIGHBANK_CPUIDLE)	+=3D cpuidle-calxeda.o
 +obj-$(CONFIG_ARM_KIRKWOOD_CPUIDLE)	+=3D cpuidle-kirkwood.o
 +obj-$(CONFIG_ARM_ZYNQ_CPUIDLE)		+=3D cpuidle-zynq.o
 +obj-$(CONFIG_ARM_U8500_CPUIDLE)         +=3D cpuidle-ux500.o
++obj-$(CONFIG_CPU_IDLE_BIG_LITTLE)       +=3D cpuidle-big_little.o

--Signature=_Thu__29_Aug_2013_18_04_25_+1000_zJ8Qzz224/Dy0fV6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHwCJAAoJEECxmPOUX5FEZTwP/1KyjYCYBHT7qYuJEexclw1C
bh3lB3/JMgpEL32bk6EZBhO76efkXh2sh74vgcRh+g0qpwVKJQ/j2qn6C3kwAZnG
Pcrz3YJfIVsTM77fvSrpa1rznRd17Q0x+m0wcik7hr11F7fX0Bkju9cGK3RXnmKl
KaiK/eSiqczD8lwUA2KZvndx08SeW7T4GUDOHHJxmbRnFFiMmv8zHptjhINS6tHJ
n2ye1wOx5W0UIBeeEZd4coUVkR8S5fe5PmmKzurdjRYzQBTs2t+e3FgxI12b/VqZ
ngTRQcJ6Wzpq1aiBu4cflVXgS5v3UjSvtJH9TQNUtY2UKEM597FblgZJ2lpRresn
Q4/3mID0JJ58L5ewVj0jDtDIDTCG34yXp+2U//8GN7/svUVXD7sxrRHhi3/trg/8
Xy1bMUE/huMFJfpGlPncoQx00Dz3KegHl8gOij7LdDXNtmmoZCK3zgWK2RyDgb2S
ZNGFEypKKOgJWKt3ZKy6mPpFSJvzvGRZbIyFGwBlEyO+PZuSiUFGxFqWv3/D22hV
loChnt+UzaTTBbg0QA6nu/edxyRp2KgFxWEC3xhmCbWp0Tgl4KHM5OG15SdQ331A
dJeEtHm3Gt587bfEMLqdizaF6P9HgZsoTHYzLWV2vljd/f2q3Pd281OMWGvgEoBd
btU4RgBZFYB+LjMgWK2N
=gz8b
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_18_04_25_+1000_zJ8Qzz224/Dy0fV6--
