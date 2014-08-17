Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbaHQWsC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 18:48:02 -0400
Received: from ozlabs.org ([103.22.144.67]:40106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaHQWsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 18:48:00 -0400
Date: Mon, 18 Aug 2014 08:47:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: linux-next: build failure after merge of the staging tree
Message-ID: <20140818084750.28ea751a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/lNSwixqVJEekdzDC/LctU2c"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/lNSwixqVJEekdzDC/LctU2c
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (powerpc allyescon=
fig)
failed like this:

drivers/staging/built-in.o:(.opd+0xaab8): multiple definition of `rtl88e_ph=
y_rf_config'
drivers/net/built-in.o:(.opd+0x78840): first defined here
drivers/staging/built-in.o:(.opd+0xa9f8): multiple definition of `rtl88e_do=
wnload_fw'
drivers/net/built-in.o:(.opd+0x781b0): first defined here
drivers/staging/built-in.o: In function `.rtl88e_phy_rf_config':
(.text+0xe0a00): multiple definition of `.rtl88e_phy_rf_config'
drivers/net/built-in.o:(.text+0xe85a48): first defined here
drivers/staging/built-in.o: In function `.rtl88e_download_fw':
(.text+0xdf28c): multiple definition of `.rtl88e_download_fw'
drivers/net/built-in.o:(.text+0xe6f330): first defined here
drivers/staging/built-in.o: In function `.rtl88e_phy_mac_config':
(.text+0xdf984): multiple definition of `.rtl88e_phy_mac_config'
drivers/net/built-in.o:(.text+0xe84a8c): first defined here
drivers/staging/built-in.o: In function `.rtl88e_phy_bb_config':
(.text+0xdfa2c): multiple definition of `.rtl88e_phy_bb_config'
drivers/net/built-in.o:(.text+0xe84d14): first defined here
drivers/staging/built-in.o:(.opd+0xaa58): multiple definition of `rtl88e_ph=
y_bb_config'
drivers/net/built-in.o:(.opd+0x78828): first defined here
drivers/staging/built-in.o:(.opd+0xaa28): multiple definition of `rtl88e_ph=
y_mac_config'

Caused by commits d6c28c23f89b ("staging: rtl8188eu: Cleanup firmware
initialization code") and 586b60877244 ("staging: rtl8188eu: Cleanup
and simplify RF configuration code") and probably others.

I applied this fix up patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Aug 2014 08:40:48 +1000
Subject: [PATCH] staging: rtl8188eu: using unique names is good

fixes:

drivers/staging/built-in.o:(.opd+0xaab8): multiple definition of `rtl88e_ph=
y_rf_config'
drivers/net/built-in.o:(.opd+0x78840): first defined here
drivers/staging/built-in.o:(.opd+0xa9f8): multiple definition of `rtl88e_do=
wnload_fw'
drivers/net/built-in.o:(.opd+0x781b0): first defined here
drivers/staging/built-in.o: In function `.rtl88e_phy_rf_config':
(.text+0xe0a00): multiple definition of `.rtl88e_phy_rf_config'
drivers/net/built-in.o:(.text+0xe85a48): first defined here
drivers/staging/built-in.o: In function `.rtl88e_download_fw':
(.text+0xdf28c): multiple definition of `.rtl88e_download_fw'
drivers/net/built-in.o:(.text+0xe6f330): first defined here
drivers/staging/built-in.o: In function `.rtl88e_phy_mac_config':
(.text+0xdf984): multiple definition of `.rtl88e_phy_mac_config'
drivers/net/built-in.o:(.text+0xe84a8c): first defined here
drivers/staging/built-in.o: In function `.rtl88e_phy_bb_config':
(.text+0xdfa2c): multiple definition of `.rtl88e_phy_bb_config'
drivers/net/built-in.o:(.text+0xe84d14): first defined here
drivers/staging/built-in.o:(.opd+0xaa58): multiple definition of `rtl88e_ph=
y_bb_config'
drivers/net/built-in.o:(.opd+0x78828): first defined here
drivers/staging/built-in.o:(.opd+0xaa28): multiple definition of `rtl88e_ph=
y_mac_config'

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c  | 2 +-
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c | 2 +-
 drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c  | 2 +-
 drivers/staging/rtl8188eu/hal/fw.c                | 2 +-
 drivers/staging/rtl8188eu/hal/usb_halinit.c       | 8 ++++----
 drivers/staging/rtl8188eu/include/fw.h            | 2 +-
 drivers/staging/rtl8188eu/include/phy.h           | 6 +++---
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c b/drivers/sta=
ging/rtl8188eu/hal/HalHWImg8188E_BB.c
index 00f9cd737193..0c5dc26fd5a2 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_BB.c
@@ -687,7 +687,7 @@ static bool config_parafile(struct adapter *adapt)
 	return true;
 }
=20
-bool rtl88e_phy_bb_config(struct adapter *adapt)
+bool rtl88eu_phy_bb_config(struct adapter *adapt)
 {
 	int rtstatus =3D true;
 	struct hal_data_8188e	*hal_data =3D GET_HAL_DATA(adapt);
diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c b/drivers/st=
aging/rtl8188eu/hal/HalHWImg8188E_MAC.c
index ccca6a496b2b..7d22dd1abaed 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_MAC.c
@@ -116,7 +116,7 @@ static u32 array_MAC_REG_8188E[] =3D {
 		0x70B, 0x00000087,
 };
=20
-bool rtl88e_phy_mac_config(struct adapter *adapt)
+bool rtl88eu_phy_mac_config(struct adapter *adapt)
 {
 	u32 i;
 	u32 arraylength;
diff --git a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c b/drivers/sta=
ging/rtl8188eu/hal/HalHWImg8188E_RF.c
index 2648840f9e20..94ee740efd1f 100644
--- a/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
+++ b/drivers/staging/rtl8188eu/hal/HalHWImg8188E_RF.c
@@ -312,7 +312,7 @@ static bool rtl88e_phy_rf6052_config(struct adapter *ad=
apt)
 	return rf6052_conf_para(adapt);
 }
=20
-bool rtl88e_phy_rf_config(struct adapter *adapt)
+bool rtl88eu_phy_rf_config(struct adapter *adapt)
 {
 	return rtl88e_phy_rf6052_config(adapt);
 }
diff --git a/drivers/staging/rtl8188eu/hal/fw.c b/drivers/staging/rtl8188eu=
/hal/fw.c
index 09324ae80e72..17b7f3750547 100644
--- a/drivers/staging/rtl8188eu/hal/fw.c
+++ b/drivers/staging/rtl8188eu/hal/fw.c
@@ -181,7 +181,7 @@ exit:
 	return err;
 }
=20
-int rtl88e_download_fw(struct adapter *adapt)
+int rtl88eu_download_fw(struct adapter *adapt)
 {
 	struct hal_data_8188e *rtlhal =3D GET_HAL_DATA(adapt);
 	struct dvobj_priv *dvobj =3D adapter_to_dvobj(adapt);
diff --git a/drivers/staging/rtl8188eu/hal/usb_halinit.c b/drivers/staging/=
rtl8188eu/hal/usb_halinit.c
index c5559dfa4e92..1f057b32876d 100644
--- a/drivers/staging/rtl8188eu/hal/usb_halinit.c
+++ b/drivers/staging/rtl8188eu/hal/usb_halinit.c
@@ -743,7 +743,7 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 		Adapter->bFWReady =3D false;
 		haldata->fw_ractrl =3D false;
 	} else {
-		status =3D rtl88e_download_fw(Adapter);
+		status =3D rtl88eu_download_fw(Adapter);
=20
 		if (status) {
 			DBG_88E("%s: Download Firmware failed!!\n", __func__);
@@ -758,11 +758,11 @@ static u32 rtl8188eu_hal_init(struct adapter *Adapter)
 	}
 	rtl8188e_InitializeFirmwareVars(Adapter);
=20
-	rtl88e_phy_mac_config(Adapter);
+	rtl88eu_phy_mac_config(Adapter);
=20
-	rtl88e_phy_bb_config(Adapter);
+	rtl88eu_phy_bb_config(Adapter);
=20
-	rtl88e_phy_rf_config(Adapter);
+	rtl88eu_phy_rf_config(Adapter);
=20
 	HAL_INIT_PROFILE_TAG(HAL_INIT_STAGES_EFUSE_PATCH);
 	status =3D rtl8188e_iol_efuse_patch(Adapter);
diff --git a/drivers/staging/rtl8188eu/include/fw.h b/drivers/staging/rtl81=
88eu/include/fw.h
index c7c7e7e5ffac..d5faaff3db59 100644
--- a/drivers/staging/rtl8188eu/include/fw.h
+++ b/drivers/staging/rtl8188eu/include/fw.h
@@ -54,6 +54,6 @@ struct rtl92c_firmware_header {
 	u32 rsvd5;
 };
=20
-int rtl88e_download_fw(struct adapter *adapt);
+int rtl88eu_download_fw(struct adapter *adapt);
=20
 #endif
diff --git a/drivers/staging/rtl8188eu/include/phy.h b/drivers/staging/rtl8=
188eu/include/phy.h
index 676a66c44264..e3efa8fd69a8 100644
--- a/drivers/staging/rtl8188eu/include/phy.h
+++ b/drivers/staging/rtl8188eu/include/phy.h
@@ -1,3 +1,3 @@
-bool rtl88e_phy_mac_config(struct adapter *adapt);
-bool rtl88e_phy_rf_config(struct adapter *adapt);
-bool rtl88e_phy_bb_config(struct adapter *adapt);
+bool rtl88eu_phy_mac_config(struct adapter *adapt);
+bool rtl88eu_phy_rf_config(struct adapter *adapt);
+bool rtl88eu_phy_bb_config(struct adapter *adapt);
--=20
2.1.0.rc1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/lNSwixqVJEekdzDC/LctU2c
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT8TEbAAoJEMDTa8Ir7ZwVsQ0P+wbymZFck97zcP4OafY6bBSK
Rk2jRsuPeyJRjJEfym5Fo05m/eSQix89UeD+8ZFE/5AWjs08gBtpICyff3B0xleR
wvhHq06SPholCxUopZIlsv9qej4DZI2oaiQNTTaEUJN5jYpzKb3IwD0Fna6IsOSb
/1I8qzF1sbMRwbOtFmgMFhk/g9MVx4T2BftKxfwugyOl8bbKI2tYbp5I+FWC4Euw
lLJEIe3w8NmVPPeMQ88S0YTZxnxoXYT2zksO/pZs4YMX+EDhOvIkz7tyWbb/QhHH
A1o4hoYfli1D3QpE1a1jY/cMaeDSbCy96kfsbQ++IWsGqNcXNCeb5JHHK+Alti7m
XX17FOeTQySVCe7FLf11gkAblDEqIS5ZysdYIvoxSmS9JPbPrEUqgoA93iMlS6fy
RrB+OsPby3YhsotjWvPZnSqsmRUyEVfuUPDtmhlyRwTf1hpBPYgA8SU2dPYEXfcL
tMPqocLbSaHclh6Mr0dSpWpVRjSVHp895IeXmQgS6weCYHxj2TfRD5Rc/WNnSlJK
lQg7EFa20UrO0oy0dQTxmAjpe2oe7lTQbaJ1H7mNAUlV6x7VSMSIZkizGTwfC+J1
nJGQS7P6tcaYhYRjvpFcqfsIdtwRsGdSImHKAmvXAPG9NbWTXp2wu/bOLi2rdgn8
0Yab9K/BcRIUoy3MEJgh
=dxg6
-----END PGP SIGNATURE-----

--Sig_/lNSwixqVJEekdzDC/LctU2c--
