Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbaFDHNJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:13:09 -0400
Received: from ozlabs.org ([103.22.144.67]:40904 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932723AbaFDHNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:13:06 -0400
Date: Wed, 4 Jun 2014 17:12:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mike Turquette <mturquette@linaro.org>, Chris Ball <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonas Jensen <jonas.jensen@gmail.com>,
        David =?UTF-8?B?TGFuemVuZMO2cmZlcg==?= 
	<david.lanzendoerfer@o2s.ch>,
        Hans de Goede <hdegoede@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: linux-next: manual merge of the clk tree with the mmc tree
Message-ID: <20140604171254.6a67ba4f@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hk+wA3/htSoINFtBWvEXyNe"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hk+wA3/htSoINFtBWvEXyNe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mike,

Today's linux-next merge of the clk tree got a conflict in
drivers/mmc/host/Makefile between commit 1b66e94e6b99 ("mmc: moxart:
Add MOXA ART SD/MMC driver") from the mmc tree and commit 3cbcb16095f9
("mmc: sunxi: Add driver for SD/MMC hosts found on Allwinner sunxi
SoCs") from the clk tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/Makefile
index 997912262499,3072bfb6d26a..000000000000
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@@ -50,10 -50,9 +50,11 @@@ obj-$(CONFIG_MMC_JZ4740)	+=3D jz4740_mmc.
  obj-$(CONFIG_MMC_VUB300)	+=3D vub300.o
  obj-$(CONFIG_MMC_USHC)		+=3D ushc.o
  obj-$(CONFIG_MMC_WMT)		+=3D wmt-sdmmc.o
 +obj-$(CONFIG_MMC_MOXART)	+=3D moxart-mmc.o
+ obj-$(CONFIG_MMC_SUNXI)		+=3D sunxi-mmc.o
 =20
  obj-$(CONFIG_MMC_REALTEK_PCI)	+=3D rtsx_pci_sdmmc.o
 +obj-$(CONFIG_MMC_REALTEK_USB)	+=3D rtsx_usb_sdmmc.o
 =20
  obj-$(CONFIG_MMC_SDHCI_PLTFM)		+=3D sdhci-pltfm.o
  obj-$(CONFIG_MMC_SDHCI_CNS3XXX)		+=3D sdhci-cns3xxx.o

--Sig_/hk+wA3/htSoINFtBWvEXyNe
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjscAAAoJEMDTa8Ir7ZwVCdgQAJBKdZk1VTSq+PaIVV0yY/Sf
1E7i+KkNULu2TTzbUSEUHVg8wm3OQuMX3warY+2sA3gI0+OWEf6JX56vCMED5fZV
w/CiHNtnl66ovq2Ms5Tsw7N2W/dbXLujws6CKAWMgGRDIsIpXSZea3IxieV9Rzm2
FTUGFWMScU54EAS6CB9hiAfDdX36KfAyHYCQXhstETO8ONPDzUDB2S8Wl3Y9Vup4
zxIe2It64wiP8sCb2jm6k6CDHI17Nn2A6DORi+ElaZGfWWEI9pmSMIILH/ZpTraa
FdZaiY592Jh3R5Lk06fQOYFP+ZXgq0+B/Lot8/WSgTtLAA89Ui6vZPHKpaR7zNxC
dhOOa0xeCd0CeEohh378QAWQDgYWmg7JwSRmRQN5pOh3KF0AvAXEcbLiKccJUQms
sjRyh+ihNI14vd75WCojkkktqOAxI1axUPkU5F+ezTfgmev9MfdWZhIjwwq40mD5
6VRnIiYLtH6IfC5U+TvisTF2SA6U53fazJfdIZkTQSMS4/TKrs6Stz668OAbcUSH
Blxthi/ffIRfHo20s3rMD324J/s82yY8GfSUipkTc+E3imztwRui/zFjwn27g4p6
5Fi3vx3WFA+a4rj6DqbCEsGPYRXb6MXizXRiCWwBYFCZU1/kZGSj/oS/nb59oDVZ
RENqFH7QjyPiTjuXpxxz
=mgQo
-----END PGP SIGNATURE-----

--Sig_/hk+wA3/htSoINFtBWvEXyNe--
