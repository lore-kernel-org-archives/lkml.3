Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161545Ab3DEFDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 01:03:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59584 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3DEFDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 01:03:15 -0400
Date: Fri, 5 Apr 2013 16:02:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20130405160256.7ca6f52e25e0d2231eb1fcfe@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Apr_2013_16_02_56_+1100_o7040RbB=VtDLCDB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Apr_2013_16_02_56_+1100_o7040RbB=VtDLCDB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
drivers/irqchip/irq-s3c24xx.c between commit de88cbb7b244 ("arm: Move
chained_irq_(enter|exit) to a generic file") from the arm-soc tree (where
it is called arch/arm/mach-s3c24xx/irq.c) and commit f0774d41da0e
("irqchip: s3c24xx: add devicetree support") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/irqchip/irq-s3c24xx.c
index 8296d94,5e40b34..0000000
--- a/drivers/irqchip/irq-s3c24xx.c
+++ b/drivers/irqchip/irq-s3c24xx.c
@@@ -25,8 -25,11 +25,12 @@@
  #include <linux/ioport.h>
  #include <linux/device.h>
  #include <linux/irqdomain.h>
 +#include <linux/irqchip/chained_irq.h>
+ #include <linux/of.h>
+ #include <linux/of_irq.h>
+ #include <linux/of_address.h>
 =20
+ #include <asm/exception.h>
  #include <asm/mach/irq.h>
 =20
  #include <mach/regs-irq.h>

--Signature=_Fri__5_Apr_2013_16_02_56_+1100_o7040RbB=VtDLCDB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRXlsAAAoJEECxmPOUX5FE9uwP/i7WjEciiAx+Vr1IllWEpLS/
c5uQH6Gv5E7ikYpRb9iFOmr6k8o41B9ba4GSw1X7HqnuCMiquVCauWpOVFX4pRdb
2cmkpb3GPOz4RJaIQ4KSZVWN3Qiu0c9+d7NQju/UQhORZ2SHWQJ+q0RR/EICeLpl
PxxdwrKvs2dGJAGK/z232+O2fYDXCRuBJvGDUhsQGBzr/mFBzxuRqWcMud12sEL9
2hNZGkhaVEYojaP/2mkppyAUoCu5L0yprEGlrplVszpPAdtgoPRM4D1UdpfaWQlA
ADcSV4m8mORXml8Du4MWy+1Jem7rdBwAkwqX1WCbPbpudr9MDlUfSedPf1ES68N/
pj9VGdRics/BY56SRiQPMMs6PQ4/H4RokibYrPjGsU/X6PPxMDNHP5bg+IYCtUo3
CAarS6u3rzqMKnKGDaTg+sS0UR3b2fV7zMExKLflrmUW+Z++FztMYnmB8YAvSwKk
hcmddOIX2shyH8QRDCp6jhyhrh8WT747mXP4PAtCW1g4YC/itrwTZOPSHbLG64i6
pO1maqbQfKZ7RoTVn2gim03G32oF0OaoI29xjF4Vszw++ACjsLMiQV1ji+lf4CnE
iJ9feV9UDEv8qq85SJhZe3m8hWutlIfoS4l0Q0so8IIKSeaLAeKAlkXVdusE79Qx
pM7XWGlYMAllAMpuU+9G
=dFKJ
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Apr_2013_16_02_56_+1100_o7040RbB=VtDLCDB--
