Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847Ab3H2HfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 03:35:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59943 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3H2HfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 03:35:18 -0400
Date: Thu, 29 Aug 2013 17:35:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>
Subject: linux-next: manual merge of the arm-soc tree with the v4l-dvb tree
Message-Id: <20130829173507.d46106011201747a12a70eaf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_17_35_07_+1000_a./s5GhrBwxwt.w+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_17_35_07_+1000_a./s5GhrBwxwt.w+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/board-bockw.c between commit 9c43952d0f1e
("[media] ARM: shmobile: BOCK-W: add VIN and ML86V7667 support") from the
v4l-dvb tree and commit bockw_init ("ARM: shmobile: r8a7778: cleanup
registration of mmcif") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-shmobile/board-bockw.c
index 35dd7f2,255e97e..0000000
--- a/arch/arm/mach-shmobile/board-bockw.c
+++ b/arch/arm/mach-shmobile/board-bockw.c
@@@ -217,21 -205,7 +235,17 @@@ static void __init bockw_init(void
  	r8a7778_clock_init();
  	r8a7778_init_irq_extpin(1);
  	r8a7778_add_standard_devices();
- 	r8a7778_add_usb_phy_device(&usb_phy_platform_data);
  	r8a7778_add_ether_device(&ether_platform_data);
- 	r8a7778_add_i2c_device(0);
- 	r8a7778_add_hspi_device(0);
- 	r8a7778_add_mmc_device(&sh_mmcif_plat);
 +	r8a7778_add_vin_device(0, &vin_platform_data);
 +	/* VIN1 has a pin conflict with Ether */
 +	if (!IS_ENABLED(CONFIG_SH_ETH))
 +		r8a7778_add_vin_device(1, &vin_platform_data);
 +	platform_device_register_data(&platform_bus, "soc-camera-pdrv", 0,
 +				      &iclink0_ml86v7667,
 +				      sizeof(iclink0_ml86v7667));
 +	platform_device_register_data(&platform_bus, "soc-camera-pdrv", 1,
 +				      &iclink1_ml86v7667,
 +				      sizeof(iclink1_ml86v7667));
 =20
  	i2c_register_board_info(0, i2c0_devices,
  				ARRAY_SIZE(i2c0_devices));

--Signature=_Thu__29_Aug_2013_17_35_07_+1000_a./s5GhrBwxwt.w+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHvmvAAoJEECxmPOUX5FE/dYP/3adtfHbkhbgtChN5ueSURPU
1sWZQIJMNYjc7vYmdXZYY1j3iKuWhtlsTGxbHHkDbrpgpLjyrUWt3LfSwdREzPv3
9LXp4BgSqcn4s9bfx57UwVN5oIJGKSICt4vqEpkaRJxyIfMUCkdUUzmoxTh56Itw
DZlJxLUPb2NTvPjc3v3snK9iQ8UVXMozu1grGc26xhzEbY6Wyajba9w5Gklfjsvw
oRTH4v1pFko105Tl5WHXGJMfX5bh6eJza+1jSB6Sdn3OIstG/hRRnhlCTXrP81mI
zNq+OK+0ehsg7zOnIBngiI7QTVhwPvnpos9sjaXyKhqZHKIHIxD9o8jB0kUFvsGx
DQ9H2+2iEd1idp2zNvCUorLWtIlg/6WHSM0NJB8QMjXhyeo7tuKksAjSxsvl1kLD
eDxIEsg/ujoFl5wAVuNkCsiCm8BeFbwUkMoU34PUjzsYnK5+B45oMgrgFx4hgreS
DIkNhMyaS1DGVqBcEEwLG4O2SE2csgDYI59KZoDgUi3OwYUzT2bCgysgKb+s+N6E
P1cHn94q05nqEbuR7HEVFfWdUOXtES/10uDjXaeaXSBcg8mG3Ghzfthc/zpchLRr
o4FIF9pkb0BWHDw6ZAsBV34GswHY6nuDOrcNZIxr+Jtiinyfp7yN/hvUpwVM8+Su
RgcTmPOvNN94kDfFd62O
=y8Np
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_17_35_07_+1000_a./s5GhrBwxwt.w+--
