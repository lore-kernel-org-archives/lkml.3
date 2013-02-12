Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057Ab3BLD4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 22:56:11 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37609 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab3BLD4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 22:56:10 -0500
Date: Tue, 12 Feb 2013 14:56:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Hogan <james.hogan@imgtec.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: linux-next: manual merge of the arm-soc tree with the metag tree
Message-Id: <20130212145601.09b536bef18ae4f3c8d3b3cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Feb_2013_14_56_01_+1100_9pCAUBstOMIKg_41"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Feb_2013_14_56_01_+1100_9pCAUBstOMIKg_41
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got conflicts in
drivers/clocksource/Makefile and drivers/clocksource/Kconfig between
commit 3fedb0674fbc ("metag: Time keeping") from the metag tree and
commits 8a4da6e36c58 ("arm: arch_timer: move core to
drivers/clocksource") and  ("arm64: move from arm_generic to
arm_arch_timer") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/clocksource/Kconfig
index 75bc752,e920cbe..0000000
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@@ -54,12 -60,5 +60,10 @@@ config CLKSRC_DBX500_PRCMU_SCHED_CLOC
  	help
  	  Use the always on PRCMU Timer as sched_clock
 =20
- config CLKSRC_ARM_GENERIC
- 	def_bool y if ARM64
- 	help
- 	  This option enables support for the ARM generic timer.
+ config ARM_ARCH_TIMER
+ 	bool
 +
 +config CLKSRC_METAG_GENERIC
 +	def_bool y if METAG
 +	help
 +	  This option enables support for the Meta per-thread timers.
diff --cc drivers/clocksource/Makefile
index 09dcd49,7d671b8..0000000
--- a/drivers/clocksource/Makefile
+++ b/drivers/clocksource/Makefile
@@@ -16,6 -17,7 +17,8 @@@ obj-$(CONFIG_CLKSRC_DBX500_PRCMU)	+=3D cl
  obj-$(CONFIG_ARMADA_370_XP_TIMER)	+=3D time-armada-370-xp.o
  obj-$(CONFIG_ARCH_BCM2835)	+=3D bcm2835_timer.o
  obj-$(CONFIG_SUNXI_TIMER)	+=3D sunxi_timer.o
+ obj-$(CONFIG_ARCH_TEGRA)	+=3D tegra20_timer.o
+ obj-$(CONFIG_VT8500_TIMER)	+=3D vt8500_timer.o
 =20
- obj-$(CONFIG_CLKSRC_ARM_GENERIC)	+=3D arm_generic.o
+ obj-$(CONFIG_ARM_ARCH_TIMER)		+=3D arm_arch_timer.o
 +obj-$(CONFIG_CLKSRC_METAG_GENERIC)	+=3D metag_generic.o

--Signature=_Tue__12_Feb_2013_14_56_01_+1100_9pCAUBstOMIKg_41
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRGb1RAAoJEECxmPOUX5FERSQP/jS1Wi4w4hwP7CVra7K0lsAx
rHDR9/tMpmgodUG5VLkS3u1pcD6PZ5P4NXtXfX1a7GZ4wYJoiaLlvKK4enC2/0bk
VwA98SgCXsTBkW9ojSI53XNhZ2nrUnpWjYK5sc7PgpmhYShsaxYEQ0dohWKz1oZ4
NMflET+9e/zUqwqyTJABGJmzUxhV+aDiFN03XaQZCxsjaaKhSp5NIwkxcBdeqv4X
jvJzbBvAKmXHRmzo86TdzycPfrJn5tOs5PM1vhOT7OOn7RG6vqiI8R0kC6fp6OVj
X/Z3OGzPiWwUVTzsH6l+fh/pCGRoHKivp5P23kNmAdYotv7MztKDLKpsfMwpRE0V
ScbrBWiBOWGh+O6kWL7s06wAp0DTKphLruJVCGBFbvkw5fKaymnNBBwO58bP3e/A
VGsqh1yAICxOTZ3Ft28zRD3rFeAgQZKkPWLXZU6tD1y5S693pdVrYmtJB/T25EML
ytGfhTvkKkKECEmM6h4xX1mK6v+CUOJWQqQfC0UMdn1zmGJrfBTQc9IJN0vrWkuz
cG7wVeT35jZbjxlntCWe9iqiHPS9HhHDylEZBvfYqlBRy979oUOit9VTC/eFzn2R
3d0T5yiuROAlkvtgdRN7Nj20siLy+B1YlhWu+p8eow6ddLMd1YFas+klq94FGS7C
3zAdBNiDJEFGxwqYpOmn
=eElI
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Feb_2013_14_56_01_+1100_9pCAUBstOMIKg_41--
