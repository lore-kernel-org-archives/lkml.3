Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3AKDwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 22:52:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:45516 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3AKDwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 22:52:10 -0500
Date: Fri, 11 Jan 2013 14:51:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>,
        John Linn <John.Linn@xilinx.com>, Stephen Warren <swarren@nvidia.com>
Subject: linux-next: manual merge of the arm-soc tree with the xilinx tree
Message-Id: <20130111145159.dfc665289a312bf4b069eb16@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__11_Jan_2013_14_51_59_+1100_n.Q/.Qo4dlAMxP.A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__11_Jan_2013_14_51_59_+1100_n.Q/.Qo4dlAMxP.A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-zynq/common.c between commit 453708c6da9b ("arm: zynq:
timer: Replace PSS through PS") from the xilinx tree and commit
6bb27d7349db ("ARM: delete struct sys_timer") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-zynq/common.c
index 892f65e,2ae4bce..0000000
--- a/arch/arm/mach-zynq/common.c
+++ b/arch/arm/mach-zynq/common.c
@@@ -90,16 -90,9 +90,9 @@@ static void __init xilinx_zynq_timer_in
 =20
  	xilinx_zynq_clocks_init(slcr);
 =20
 -	xttcpss_timer_init();
 +	xttcps_timer_init();
  }
 =20
- /*
-  * Instantiate and initialize the system timer structure
-  */
- static struct sys_timer xttcps_sys_timer =3D {
- 	.init		=3D xilinx_zynq_timer_init,
- };
-=20
  /**
   * xilinx_map_io() - Create memory mappings needed for early I/O.
   */

--Signature=_Fri__11_Jan_2013_14_51_59_+1100_n.Q/.Qo4dlAMxP.A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ74xfAAoJEECxmPOUX5FEUUYQAIxo2bJyd6hFxDNUVopP67IY
rhd6vb+5Ae9BQcbGkQ2rrOS8r7f2USNqvHy0nSO+7aNNgbUwl4o3JCNDvuJKi1KL
dSqdfEhNAXXue2Nbb0aFDxGP1FXOIDvmiV/4qQLMYxf0edRuF5JCXJe1r3OJLZtj
sZ8YHIJuO5MZ0icKw6S5hQsCZpL+9JNNscSU+Pj37pSfGTUIXZ4WNISDkHcxosbf
wLO8XH2NouU5avfOeDYXa1nnnoeZOsFy1p1bfazav9NbFEZxTRpQQqDDxJ0Ocyml
053NFZ1O76WJyLkYMxqHGGTEbvht9VP4F+kJwYaCG0dq+9gtGZR8dv7u+QMDn+hT
125ItXkgcNmBngFi79llfHUWbvmlxo0yCCgjSFrYqthy1zCeW9N73oRxCApR6Sg4
+yU7bvM4YnKz4Uqyw1eaD48hmaxWe+liGx7CAdIy2Z5k9lSppq/BbeqRRpxFRM26
Oja7WbeakVA+cMT3mGUYgMmrfoGyYN8aTqurI0o4Sl6aiqCjrVnxWPdilEzZ1pMy
aGeqFoVbvGw5XOO1DPEmNwOrx6+GxJQaOVV38Qg1K5lp46UBlVlULdMC5WCjt2MQ
MgMNHr2G7LxOY4zL49jcH3J1IK4TP8NSBS7ovdbT2+Q0bRJo3C5i7N4TUxW62R/4
ZpqOfsHShbu9aP4udosI
=gINp
-----END PGP SIGNATURE-----

--Signature=_Fri__11_Jan_2013_14_51_59_+1100_n.Q/.Qo4dlAMxP.A--
