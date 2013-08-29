Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab3H2HrY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:47:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42618 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab3H2HrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:47:22 -0400
Date: Thu, 29 Aug 2013 17:47:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Simon Horman <horms@verge.net.au>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: manual merge of the arm-soc tree with the v4l-dvb tree
Message-Id: <20130829174717.0c3a263e468c307849507aba@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_17_47_17_+1000_HeRPXpp1AV0dl=Jc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_17_47_17_+1000_HeRPXpp1AV0dl=Jc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/include/mach/r8a7778.h between commit 803c2df21752
("[media] ARM: shmobile: r8a7778: add VIN support") from the v4l-dvb tree
and commits cfa66a81621d ("ARM: shmobile: bockw: add DT reference"),
a66c9744574c ("ARM: shmobile: r8a7778: cleanup registration of mmcif")
and 044e2121466a ("ARM: shmobile: r8a7778: cleanup registration of usb
phy") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/include/mach/r8a7778.h
index a7c6d15,41fd6da..0000000
--- a/arch/arm/mach-shmobile/include/mach/r8a7778.h
+++ b/arch/arm/mach-shmobile/include/mach/r8a7778.h
@@@ -18,21 -18,12 +18,15 @@@
  #ifndef __ASM_R8A7778_H__
  #define __ASM_R8A7778_H__
 =20
- #include <linux/mmc/sh_mmcif.h>
- #include <linux/mmc/sh_mobile_sdhi.h>
  #include <linux/sh_eth.h>
- #include <linux/platform_data/usb-rcar-phy.h>
 +#include <linux/platform_data/camera-rcar.h>
 =20
  extern void r8a7778_add_standard_devices(void);
  extern void r8a7778_add_standard_devices_dt(void);
  extern void r8a7778_add_ether_device(struct sh_eth_plat_data *pdata);
- extern void r8a7778_add_usb_phy_device(struct rcar_phy_platform_data *pda=
ta);
- extern void r8a7778_add_i2c_device(int id);
- extern void r8a7778_add_hspi_device(int id);
- extern void r8a7778_add_mmc_device(struct sh_mmcif_plat_data *info);
 +extern void r8a7778_add_vin_device(int id,
 +				   struct rcar_vin_platform_data *pdata);
+ extern void r8a7778_add_dt_devices(void);
 =20
  extern void r8a7778_init_late(void);
  extern void r8a7778_init_delay(void);

--Signature=_Thu__29_Aug_2013_17_47_17_+1000_HeRPXpp1AV0dl=Jc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHvyFAAoJEECxmPOUX5FEePEQAI1WAUBoY/oQ6GNcebjyYV0u
JGD/zKRHuJBpFrziP9IMj4N8CJ50RgYDWImJa3IkFBpZzN4zSJmBUvsHrtDtCntp
BletsCVDeT9MMmImxGpVOOVrAnWHnxAsczTe99YRCeCoB/s26+qCnqvPuvDCsfZk
uaPmokNHH3e5VAq2UZJ78TY4WUYL4ObBb1Gb4U32O1AKw3gjmFFlpKkJTPsAknkT
oJIawxXoNUv+11ckiiWZ/kQyO9efbFXacVQwQNdsmJUhKO4aRhTTEdRlgoEh2mwo
WUAwbE5/hTK1eVXXuWPW2MLtpWHrF8L6uMmpd6V4j1IzXixvbu9pciVp49lWW1ZM
OLz/T1H2jOfTYfbe/6NSFYN9kfiiU7BAkEyfPVK4zMTafmx/99OKwQQwMs5BnztL
KKoq5aqsjoY14jq0kfHglfaaM+3UiujbFWwkSYnUen5Ex5D/as37TtkGVgY4K9vl
n/5LY6tEN8Ag4J4fvxOuPzmCKA17tj91ltWmEBpRUr09QjR8S022dHirdjwNxh3u
TluVEEGV4xCw08EC1kgAzGASzYwDJdzGWJf3cUmJeiHmvNlNRXoV759U4r0RKWES
pRTXiRLOJU87dCF1ARfMImn+TOLib/6dZZUpApL433t8SsICXhYL/quRFFDJJFoz
byZvHrShn4EOxqyEIM9w
=crao
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_17_47_17_+1000_HeRPXpp1AV0dl=Jc--
