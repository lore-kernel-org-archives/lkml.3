Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967888Ab3DSH2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 03:28:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53225 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3DSH2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 03:28:04 -0400
Date: Fri, 19 Apr 2013 17:27:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the clk tree with the arm-soc tree
Message-Id: <20130419172753.0e604e9bad0b7a26a8b52787@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Apr_2013_17_27_53_+1000_BNfprMtcbLVFwfu7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Apr_2013_17_27_53_+1000_BNfprMtcbLVFwfu7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
arch/arm/mach-vexpress/v2m.c between commit dabfd8fb84ab ("ARM: vexpress:
remove sp804 OF init") from the arm-soc tree and commit 6e973d2c4385
("clk: vexpress: Add separate SP810 driver") from the clk tree.

I fixed it up (I thnk - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-vexpress/v2m.c
index d8e2954,c5e20b5..0000000
--- a/arch/arm/mach-vexpress/v2m.c
+++ b/arch/arm/mach-vexpress/v2m.c
@@@ -23,9 -21,13 +23,11 @@@
  #include <linux/regulator/fixed.h>
  #include <linux/regulator/machine.h>
  #include <linux/vexpress.h>
+ #include <linux/clk-provider.h>
+ #include <linux/clkdev.h>
 =20
 -#include <asm/arch_timer.h>
  #include <asm/mach-types.h>
  #include <asm/sizes.h>
 -#include <asm/smp_twd.h>
  #include <asm/mach/arch.h>
  #include <asm/mach/map.h>
  #include <asm/mach/time.h>
@@@ -425,11 -433,29 +427,11 @@@ void __init v2m_dt_init_early(void
 =20
  static void __init v2m_dt_timer_init(void)
  {
- 	vexpress_clk_of_init();
 -	struct device_node *node =3D NULL;
 -
+ 	of_clk_init(NULL);
 =20
 -	do {
 -		node =3D of_find_compatible_node(node, NULL, "arm,sp804");
 -	} while (node && vexpress_get_site_by_node(node) !=3D VEXPRESS_SITE_MB);
 -	if (node) {
 -		pr_info("Using SP804 '%s' as a clock & events source\n",
 -				node->full_name);
 -		WARN_ON(clk_register_clkdev(of_clk_get_by_name(node,
 -				"timclken1"), "v2m-timer0", "sp804"));
 -		WARN_ON(clk_register_clkdev(of_clk_get_by_name(node,
 -				"timclken2"), "v2m-timer1", "sp804"));
 -		v2m_sp804_init(of_iomap(node, 0),
 -				irq_of_parse_and_map(node, 0));
 -	}
 -
 -	if (arch_timer_of_register() !=3D 0)
 -		twd_local_timer_of_register();
 +	clocksource_of_init();
 =20
 -	if (arch_timer_sched_clock_init() !=3D 0)
 -		versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
 +	versatile_sched_clock_init(vexpress_get_24mhz_clock_base(),
  				24000000);
  }
 =20

--Signature=_Fri__19_Apr_2013_17_27_53_+1000_BNfprMtcbLVFwfu7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRcPH5AAoJEECxmPOUX5FEOu4QAJcuq2e7zFYRMvFxJftgIUIz
E+OGWa4OwRI2zoMPuxw6+ZE6uU1FS5T248/8sJ2c5lkzfe8JJhyIpHG2J6aP59pX
OFpYngNeNVOK0MdxjNLD6xKWkV8FNJv/UM+IznK7XbXHAYFdA2Ez+moIuBbZoXnP
M/c4LFR2l61B4On3nzHIcWt8x4/iFWy1fkFjejYjRgyCLCR4a3UWxpgfN+WNeId/
f/ESFZ4/4OPwBA4KBHayse2CAjLeY1Wyeh82ucnvrPRNZOI2A/jL8rhXxgdWCST4
MZWCB2W2kNQ1IUOFzWxm1YS5dyHX3Ru7uUYBPB1m7zfJQ/sne+zuTaei8nh+CQfY
UpeZrgYTLgnRRWlw3NWnxhPdmmD66DwJkl/xqFFynv7BtcbH3G/dcYnPGYifFVN4
SfJI92+10UByEPaf/za8txne8Qvt0EAwcJLkHGUXcgR8g/0rmUjXu7lklF6x5q3M
zT4e7Ruka06Dg5glB77VH0Jnf0JdfQIyN4SIKVi5v6wtQ9ZMS4Nq77zKVwnfBZOD
r75U6JQZf7MbfoSnqMyib8KxgilV2cNWA0d96IymkFq2+FUIYcnQce8khUSAAHe0
8N1Hq/bMYwbSxkebwlHAgDeWqnNLDrFrNoGLD0rlBzQQlme6noyaAeWsYOl2o9Nj
xAfhTVdjKU0NuG1Gitah
=zs5A
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Apr_2013_17_27_53_+1000_BNfprMtcbLVFwfu7--
