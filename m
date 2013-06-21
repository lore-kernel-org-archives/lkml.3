Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161457Ab3FUHgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:36:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58036 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901Ab3FUHgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:36:23 -0400
Date: Fri, 21 Jun 2013 17:36:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        Robin Holt <holt@sgi.com>
Subject: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20130621173618.5e86932305b15b0fe4af6b8b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_17_36_18_+1000_dG37eAD.1YqamccA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_17_36_18_+1000_dG37eAD.1YqamccA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/arm/mach-davinci/include/mach/tnetv107x.h between commit
b464e3cb2945 ("ARM: davinci: remove __init atrribute from function
declaration") from the arm-soc tree and commit "reboot: arm: change
reboot_mode to use enum reboot_mode" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-davinci/include/mach/tnetv107x.h
index 366e975,bc9479d..0000000
--- a/arch/arm/mach-davinci/include/mach/tnetv107x.h
+++ b/arch/arm/mach-davinci/include/mach/tnetv107x.h
@@@ -51,10 -52,10 +52,10 @@@ struct tnetv107x_device_info=20
  extern struct platform_device tnetv107x_wdt_device;
  extern struct platform_device tnetv107x_serial_device;
 =20
 -extern void __init tnetv107x_init(void);
 -extern void __init tnetv107x_devices_init(struct tnetv107x_device_info *);
 -extern void __init tnetv107x_irq_init(void);
 +extern void tnetv107x_init(void);
 +extern void tnetv107x_devices_init(struct tnetv107x_device_info *);
 +extern void tnetv107x_irq_init(void);
- void tnetv107x_restart(char mode, const char *cmd);
+ void tnetv107x_restart(enum reboot_mode mode, const char *cmd);
 =20
  #endif
 =20

--Signature=_Fri__21_Jun_2013_17_36_18_+1000_dG37eAD.1YqamccA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRxAJyAAoJEECxmPOUX5FEQ6IP/0zMO1tAv5BP6/BdngNnXfxo
5AQ0QONrctd50yoqQTXnxMU/P6Rwhm/eBelYVsFHLRfp/eGxmq8lEgYZ1AInk67v
j4/6L5XewhuO8a9gCxh5ar3DJSvII/i9HFK7eGKG5J02GDp787aN8PVnzHAVQWsH
krvdjEe0uG6SRjFTHn1+YLMAK7uz8xoV/2nQmwpqxQxdD3bDtx54GzBm96aL+wDj
zMr4eYgw9UrJnTx7cUSsOr80gqthY5CU7nJtyl6sM2UUA1LMpeS0zlZ92XSzv4I0
7G+c6fharxQJlxQljsFvW5oncL9romwy0rB65XUnhdJFkcTuOsPJLRpiNezfLWwe
EMnq6q2Zk2fe9pfJePDF5G3RmevQJ5bN1vQ/7/aEr1cR857T8khXBLfxj3O+SSrP
AV7uU165PejK2lON4vp8isOnpN4hCPOLivVK/pChTYqtPP3pSOqiNGS/0VLdNycV
Ba4zRuFfrbTUuvDQ460KKBZvbx4ZJJJpS1gMDAmNJ9uhkTCyTKfwNb2CeaTweU1V
yR15Ni0rPoORW3NI2cy7QSvbsVxyJo02NTNpDH1S5AXUXQMj3tFvsdMd5TquRU+6
xzTQDkPmORoEphZ3tSRb/wNnioBBQlJpC3He6KdB49GZAKeo2aH0TjpNpoCIy38/
Ii59R6jAvlNTyF279pkD
=cjBB
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_17_36_18_+1000_dG37eAD.1YqamccA--
