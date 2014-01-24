Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaAXCBe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 21:01:34 -0500
Received: from ozlabs.org ([203.10.76.45]:53447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbaAXCBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 21:01:33 -0500
Date: Fri, 24 Jan 2014 13:01:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the staging tree
Message-Id: <20140124130122.017195b49e852e4e42b77997@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Jan_2014_13_01_22_+1100_+uIWWU+THWTkBhYg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Jan_2014_13_01_22_+1100_+uIWWU+THWTkBhYg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the staging tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_beaconing_fla=
gs':
drivers/staging/rtl8821ae/regd.c:200:20: error: 'IEEE80211_CHAN_NO_IBSS' un=
declared (first use in this function)
      ch->flags &=3D ~IEEE80211_CHAN_NO_IBSS;
                    ^
drivers/staging/rtl8821ae/regd.c:200:20: note: each undeclared identifier i=
s reported only once for each function it appears in
drivers/staging/rtl8821ae/regd.c:204:11: error: 'IEEE80211_CHAN_PASSIVE_SCA=
N' undeclared (first use in this function)
          ~IEEE80211_CHAN_PASSIVE_SCAN;
           ^
drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_active_scan_f=
lags':
drivers/staging/rtl8821ae/regd.c:237:19: error: 'IEEE80211_CHAN_PASSIVE_SCA=
N' undeclared (first use in this function)
   if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
                   ^
drivers/staging/rtl8821ae/regd.c: In function '_rtl_reg_apply_radar_flags':
drivers/staging/rtl8821ae/regd.c:312:8: error: 'IEEE80211_CHAN_NO_IBSS' und=
eclared (first use in this function)
        IEEE80211_CHAN_NO_IBSS |
        ^
drivers/staging/rtl8821ae/regd.c:313:8: error: 'IEEE80211_CHAN_PASSIVE_SCAN=
' undeclared (first use in this function)
        IEEE80211_CHAN_PASSIVE_SCAN;
        ^
drivers/staging/rtl8821ae/regd.c: In function '_rtl_regd_init_wiphy':
drivers/staging/rtl8821ae/regd.c:410:18: error: 'WIPHY_FLAG_CUSTOM_REGULATO=
RY' undeclared (first use in this function)
  wiphy->flags |=3D WIPHY_FLAG_CUSTOM_REGULATORY;
                  ^
drivers/staging/rtl8821ae/regd.c:411:19: error: 'WIPHY_FLAG_STRICT_REGULATO=
RY' undeclared (first use in this function)
  wiphy->flags &=3D ~WIPHY_FLAG_STRICT_REGULATORY;
                   ^
drivers/staging/rtl8821ae/regd.c:412:19: error: 'WIPHY_FLAG_DISABLE_BEACON_=
HINTS' undeclared (first use in this function)
  wiphy->flags &=3D ~WIPHY_FLAG_DISABLE_BEACON_HINTS;
                   ^
drivers/staging/rtl8821ae/base.c: In function '_rtl_init_mac80211':
drivers/staging/rtl8821ae/base.c:372:4: error: 'struct ieee80211_hw' has no=
 member named 'channel_change_time'
  hw->channel_change_time =3D 100;
    ^
drivers/staging/rtl8821ae/base.c: In function 'rtl_beacon_statistic':
drivers/staging/rtl8821ae/base.c:1185:2: error: implicit declaration of fun=
ction 'compare_ether_addr' [-Werror=3Dimplicit-function-declaration]
  if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
  ^
drivers/staging/rtl8821ae/ps.c: In function 'rtl_swlps_beacon':
drivers/staging/rtl8821ae/ps.c:530:2: error: implicit declaration of functi=
on 'compare_ether_addr' [-Werror=3Dimplicit-function-declaration]
  if (compare_ether_addr(hdr->addr3, rtlpriv->mac80211.bssid))
  ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8812ae_dm_txpwr_t=
rack_set_pwr':
drivers/staging/rtl8821ae/rtl8821ae/dm.c:1476:5: warning: array subscript h=
as type 'char' [-Wchar-subscripts]
     rtl_set_bbreg(hw, RA_TXSCALE, 0xFFE00000, rtl8812ae_txscaling_table[fi=
nal_ofdm_swing_index]);
     ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c:1525:5: warning: array subscript h=
as type 'char' [-Wchar-subscripts]
     rtl_set_bbreg(hw, RB_TXSCALE, 0xFFE00000, rtl8812ae_txscaling_table[fi=
nal_ofdm_swing_index]);
     ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_txpwr_t=
rack_set_pwr':
drivers/staging/rtl8821ae/rtl8821ae/dm.c:2113:5: warning: array subscript h=
as type 'char' [-Wchar-subscripts]
     rtl_set_bbreg(hw, RA_TXSCALE, 0xFFE00000, rtl8812ae_txscaling_table[fi=
nal_ofdm_swing_index]);
     ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_check_e=
dca_turbo':
drivers/staging/rtl8821ae/rtl8821ae/dm.c:2656:3: warning: format '%lx' expe=
cts argument of type 'long unsigned int', but argument 2 has type 'u64' [-W=
format=3D]
   RT_TRACE(COMP_TURBO, DBG_LOUD,
   ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c:2658:3: warning: format '%lx' expe=
cts argument of type 'long unsigned int', but argument 2 has type 'u64' [-W=
format=3D]
   RT_TRACE(COMP_TURBO, DBG_LOUD,
   ^
drivers/staging/rtl8821ae/rtl8821ae/trx.c: In function '_rtl8821ae_translat=
e_rx_signal_stuff':
drivers/staging/rtl8821ae/rtl8821ae/trx.c:461:7: error: implicit declaratio=
n of function 'compare_ether_addr' [-Werror=3Dimplicit-function-declaration]
       (!compare_ether_addr(mac->bssid, (fc & IEEE80211_FCTL_TODS) ?
       ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c: In function 'rtl8821ae_dm_clear_t=
xpower_tracking_state':
drivers/staging/rtl8821ae/rtl8821ae/dm.c:487:31: warning: iteration 2u invo=
kes undefined behavior [-Waggressive-loop-optimizations]
   rtldm->bb_swing_idx_ofdm[p] =3D rtldm->default_ofdm_index;
                               ^
drivers/staging/rtl8821ae/rtl8821ae/dm.c:485:2: note: containing loop
  for (p =3D RF90_PATH_A; p < MAX_RF_PATH; ++p) {
  ^

Caused by commit 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI
WIFI driver").  Did you really want to merge a new driver right now, not
wait until after the merge window?

I have disabled that driver for today using this patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 24 Jan 2014 12:57:38 +1100
Subject: [PATCH] Staging: rtl8812ae: disable due to build errors

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/rtl8821ae/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/rtl8821ae/Kconfig b/drivers/staging/rtl8821ae/=
Kconfig
index 2aa5dac2f1df..a432e1aa7405 100644
--- a/drivers/staging/rtl8821ae/Kconfig
+++ b/drivers/staging/rtl8821ae/Kconfig
@@ -2,6 +2,7 @@ config R8821AE
 	tristate "RealTek RTL8821AE Wireless LAN NIC driver"
 	depends on PCI && WLAN
 	depends on m
+	depends on BROKEN
 	select WIRELESS_EXT
 	select WEXT_PRIV
 	select EEPROM_93CX6
--=20
1.8.5.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__24_Jan_2014_13_01_22_+1100_+uIWWU+THWTkBhYg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBCAAGBQJS4cl3AAoJEMDTa8Ir7ZwVuVQP+JIBvwOAurwIPAT717PVOxg8
lS0rMxzCIaKbqVeRlOEjGiWxs+Dp7JCEmKKQueusmFOVOp2Bjk3Siqq1aN0Fy2um
5+H527R+sK7u6Q8HXLzr6EoQz5wujmP5BmndbejtrTNx/rW2ABMTx8Q7vztGa2ml
tPYfgSHkmrjtjYlPPmOlLREeUNRJGLwogRNhzkYUVaWCoqB1JX7sCueYiW7o2YAc
qmXdHVjMBV5xsQa7vth9Us6DEzgojWjOJ80PsbXRXNKugEDH06lMaFkqAaFz+0z5
XNPZXYbcb1OZdN0/7HTR4EwzQfQRpFvm7iK05sugiL8Z35oeI2Eg5PDGDYlriNTA
p/6kNb6nkNs7eFybqsnIF+rDpqJBqkGqxTmSNfecNnK0smT6iPh1J/WmTnfzBQxY
13W4KMzInevIWW6xwMY+2TdKsGiPBRqr2BvOP8JxgrW/t10xznm3jKcsos54rOUn
w44SkpGueqyEOKPMsboorYOJiL7Ibk7olHoUIRLlU8o6gda4wxCfSgQ++IUue0vC
3catDygxlSU1Vl4o30YvTSKV+TG6E+ghx9fafZHMFKCr+32IfjU23RaYnnn1Ra2h
qdKOJ0XNgaua66IElu1tje8o8vuuMLwYgesUE6gYdsZEiOuJC+fTop8+O/kwxJOu
R/0kFFzAKVn+OMSnoHg=
=gtrn
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Jan_2014_13_01_22_+1100_+uIWWU+THWTkBhYg--
