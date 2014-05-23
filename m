Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161AbaEWApo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 20:45:44 -0400
Received: from ozlabs.org ([103.22.144.67]:54055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaEWApm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 20:45:42 -0400
Date: Fri, 23 May 2014 10:45:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-ID: <20140523104534.467b452b@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fE4MEu.KO8c1fYRI9E7cmaq"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fE4MEu.KO8c1fYRI9E7cmaq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-mvebu/board-v7.c between commit 8ae2473d96f1 ("ARM: l2c:
mvebu: convert to generic l2c OF initialisation") from the arm tree and
commit 5686a1e5aa43 ("bus: mvebu: pass the coherency availability
information at init time") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mvebu/board-v7.c
index 48169caa56ea,01cfce6ac20b..000000000000
--- a/arch/arm/mach-mvebu/board-v7.c
+++ b/arch/arm/mach-mvebu/board-v7.c
@@@ -57,8 -75,10 +75,9 @@@ static void __init mvebu_timer_and_clk_
  {
  	of_clk_init(NULL);
  	clocksource_of_init();
+ 	mvebu_scu_enable();
  	coherency_init();
- 	BUG_ON(mvebu_mbus_dt_init());
+ 	BUG_ON(mvebu_mbus_dt_init(coherency_available()));
 -	l2x0_of_init(0, ~0UL);
 =20
  	if (of_machine_is_compatible("marvell,armada375"))
  		hook_fault_code(16 + 6, armada_375_external_abort_wa, SIGBUS, 0,
@@@ -121,9 -195,8 +196,10 @@@ static const char * const armada_375_dt
  };
 =20
  DT_MACHINE_START(ARMADA_375_DT, "Marvell Armada 375 (Device Tree)")
 +	.l2c_aux_val	=3D 0,
 +	.l2c_aux_mask	=3D ~0,
  	.init_time	=3D mvebu_timer_and_clk_init,
+ 	.init_machine	=3D mvebu_dt_init,
  	.restart	=3D mvebu_restart,
  	.dt_compat	=3D armada_375_dt_compat,
  MACHINE_END

--Sig_/fE4MEu.KO8c1fYRI9E7cmaq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfpozAAoJEMDTa8Ir7ZwVoe4P+wQXx3OAJfT5h+BhDXAEtYf2
+hQkd492AABHO5K+wjbgXRZ5of53N4aRq4dSsNCVkWqT/wZbP5mx1EI0I4UvrjDf
NKUV9qLllu7NkBYWCvuDNbenvsn5T0rxLh+pJOuag4AtUZhoGBMimPZmnf5atKcX
eKZEjZdEf2ODCDYaXC6mVPA5BJdaAHQQ0F/4cT8wL2DDJ1QZ7kWZ5NHnPanymhhf
6wLEbD3z7yh8edcwnxHu0gku0yqtRZPIs/9tlRdyyHq1zJyEbPbUmS760haVGG94
VcDJSl0F5AA+MiPwPkqV0QTJ5Ii24GPmky1admMVJYQie00Y3T5d9InIy1ezZs5D
hAdvj7LwqBI7lCC7wW+9OmwpJIcPSqrhw8GwWWfkj+uemDE8QRL/FpdlaFMXtSps
P657HqS+ftdQmU2wKbZmEaL3XfB1t883vNMFAw2r0L/8+yYBp5hgJAJAJ83ssHbF
xeTsxHmK7l0CAV2nWdYx0Zi3Q2mThcXDwwlzxjT7ZMJuMccentXMXiwMnBglbaS+
RRF8v1VxlynTnbaJFq7cpwOcn/8JDIBlFxWbKWIOXBkWvGxkUGsKegqNJZL0Flx0
rW+qcATtKValBzP/IKGMP1VUCSKaBm/rvz12thAivNie1aMHvS0fII1MT/GylaOd
OIDDJt4GjmloOG0UG4FR
=9889
-----END PGP SIGNATURE-----

--Sig_/fE4MEu.KO8c1fYRI9E7cmaq--
