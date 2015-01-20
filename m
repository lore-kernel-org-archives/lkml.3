Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbbATAJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:09:56 -0500
Received: from ozlabs.org ([103.22.144.67]:51236 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbbATAJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:09:55 -0500
Date: Tue, 20 Jan 2015 11:09:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Robinson <pbrobinson@gmail.com>
Subject: linux-next: manual merge of the omap tree with the arm-soc tree
Message-ID: <20150120110947.1a92a416@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oAkGM_z/RtGgN4ELerfgzY8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oAkGM_z/RtGgN4ELerfgzY8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tony,

Today's linux-next merge of the omap tree got a conflict in
arch/arm/boot/dts/Makefile between commit cb612390e546 ("ARM: dts: Only
build dtb if associated Arch and/or SoC is enabled") from the arm-soc
tree and commit ac7452cee743 ("ARM: dts: Add minimal support for
dm8168-evm") from the omap tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/Makefile
index a240d2d07b38,a6ace4d57ea5..000000000000
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@@ -392,8 -348,8 +392,9 @@@ dtb-$(CONFIG_ARCH_OMAP3) +=3D=20
  	omap3-sbc-t3730.dtb \
  	omap3-thunder.dtb \
  	omap3-zoom3.dtb
+ dtb-$(CONFIG_SOC_TI81XX) +=3D dm8168-evm.dtb
 -dtb-$(CONFIG_SOC_AM33XX) +=3D am335x-base0033.dtb \
 +dtb-$(CONFIG_SOC_AM33XX) +=3D \
 +	am335x-base0033.dtb \
  	am335x-bone.dtb \
  	am335x-boneblack.dtb \
  	am335x-evm.dtb \
@@@ -410,20 -365,17 +411,21 @@@ dtb-$(CONFIG_ARCH_OMAP4) +=3D=20
  	omap4-sdp-es23plus.dtb \
  	omap4-var-dvk-om44.dtb \
  	omap4-var-stk-om44.dtb
 -dtb-$(CONFIG_SOC_AM43XX) +=3D am43x-epos-evm.dtb \
 +dtb-$(CONFIG_SOC_AM43XX) +=3D \
 +	am43x-epos-evm.dtb \
  	am437x-sk-evm.dtb \
+ 	am437x-idk-evm.dtb \
  	am437x-gp-evm.dtb
 -dtb-$(CONFIG_SOC_OMAP5) +=3D omap5-cm-t54.dtb \
 +dtb-$(CONFIG_SOC_OMAP5) +=3D \
 +	omap5-cm-t54.dtb \
  	omap5-sbc-t54.dtb \
  	omap5-uevm.dtb
 -dtb-$(CONFIG_SOC_DRA7XX) +=3D dra7-evm.dtb \
 +dtb-$(CONFIG_SOC_DRA7XX) +=3D \
 +	dra7-evm.dtb \
  	am57xx-beagle-x15.dtb \
  	dra72-evm.dtb
 -dtb-$(CONFIG_ARCH_ORION5X) +=3D orion5x-lacie-d2-network.dtb \
 +dtb-$(CONFIG_ARCH_ORION5X) +=3D \
 +	orion5x-lacie-d2-network.dtb \
  	orion5x-lacie-ethernet-disk-mini-v2.dtb \
  	orion5x-maxtor-shared-storage-2.dtb \
  	orion5x-rd88f5182-nas.dtb

--Sig_/oAkGM_z/RtGgN4ELerfgzY8
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvZzQAAoJEMDTa8Ir7ZwVhTwP/R8UO2vZbV/ef/GGVF1gcZVd
7zB3esx5IH5eIF9Ntybd9TGZQuQNfK7zIQEzq7ldh++Eb/5S5RW4/HIecRgRBPjU
i5Qf4Slct/B/C67zqBsrQLrpXrfRjTU98DWpUFKI4/eNFUfZQBGh1Yq33rskJIPj
WL+8ELzEqLylbFyo4lDQA5s7NcRYr1KJZ6DFU7jTZe49edo/6C1N8BEAzk57IWaG
XzCdBnpEUgQAE+kmBtLwIzupXxxbAjHhkKjEM9+key0ph1tWnl9kbdWugbIoQA4E
kJi0hryojY8tJ+aW6Xuqv/wFbXULnRNqvcQtKIhI/IL7yy1IeCxnNEofAcZnsmFf
1IPEvVwR2WrZjIylScpTKeItBVhRookeZISG5bNauGKzOo6lYbcfMZawJpQAKcGM
a+qgH+mtKX5hucdTVJj7YjHcU/KDaodBlkOZbVINhYN7YkfBvrVe2CXPGSBpBG6Z
lKo72/KZrgT2Ds/1UIsdypRjCamfLmyVO9QtS9W0bMkoUCWtg2RXv91Sm7UvB02f
MkWJ4ujEUSDI0o1HJ/eB1U94dFCU8T4U2nwk39QGUvzNTV77XGNiV2uVOGHmfSV7
ybuZHMHkK33FNejdLqfPpzOpNkNCldHyxz24Uya+gPkGOk7oEJyuaUpRGhD8xopa
J8Lnk/kaGmXVlhG1M08X
=E5si
-----END PGP SIGNATURE-----

--Sig_/oAkGM_z/RtGgN4ELerfgzY8--
