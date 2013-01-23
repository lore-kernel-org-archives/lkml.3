Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3AWBMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:12:50 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39133 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3AWBMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:12:47 -0500
Date: Wed, 23 Jan 2013 12:12:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felix Fietkau <nbd@openwrt.org>
Subject: linux-next: manual merge of the wireless-next tree with the net
 tree
Message-Id: <20130123121238.bc4ba1fe89c20d41fb5752ae@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_12_12_38_+1100_o5k/Wft/fQITXmpD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_12_12_38_+1100_o5k/Wft/fQITXmpD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/ath/ath9k/main.c between commit 4b883f021b9c
("ath9k: fix rx flush handling") from the net tree and commit
1381559ba48a ("ath9k: clean up processing of pending tx frames on reset")
from the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/ath/ath9k/main.c
index dd91f8f,3e5082c..0000000
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@@ -182,7 -182,7 +182,7 @@@ static void ath_restart_work(struct ath
  	ath_start_ani(sc);
  }
 =20
- static bool ath_prepare_reset(struct ath_softc *sc, bool retry_tx)
 -static bool ath_prepare_reset(struct ath_softc *sc, bool flush)
++static bool ath_prepare_reset(struct ath_softc *sc)
  {
  	struct ath_hw *ah =3D sc->sc_ah;
  	bool ret =3D true;
@@@ -196,12 -196,20 +196,12 @@@
  	ath9k_debug_samp_bb_mac(sc);
  	ath9k_hw_disable_interrupts(ah);
 =20
- 	if (!ath_stoprecv(sc))
+ 	if (!ath_drain_all_txq(sc))
  		ret =3D false;
 =20
- 	if (!ath_drain_all_txq(sc, retry_tx))
+ 	if (!ath_stoprecv(sc))
  		ret =3D false;
 =20
 -	if (!flush) {
 -		if (ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 -			ath_rx_tasklet(sc, 1, true);
 -		ath_rx_tasklet(sc, 1, false);
 -	} else {
 -		ath_flushrecv(sc);
 -	}
 -
  	return ret;
  }
 =20
@@@ -271,7 -278,8 +270,7 @@@ static int ath_reset_internal(struct at
  		hchan =3D ah->curchan;
  	}
 =20
- 	if (!ath_prepare_reset(sc, retry_tx))
 -	if (!ath_prepare_reset(sc, flush))
++	if (!ath_prepare_reset(sc))
  		fastcc =3D false;
 =20
  	ath_dbg(common, CONFIG, "Reset to %u MHz, HT40: %d fastcc: %d\n",
@@@ -797,7 -801,7 +794,7 @@@ static void ath9k_stop(struct ieee80211
  		ath9k_hw_cfg_gpio_input(ah, ah->led_pin);
  	}
 =20
- 	ath_prepare_reset(sc, false);
 -	ath_prepare_reset(sc, true);
++	ath_prepare_reset(sc);
 =20
  	if (sc->rx.frag) {
  		dev_kfree_skb_any(sc->rx.frag);

--Signature=_Wed__23_Jan_2013_12_12_38_+1100_o5k/Wft/fQITXmpD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/zkGAAoJEECxmPOUX5FEEOgP/1xYZwc0w8GaMmP8egZa40xL
PFU/rleOa6TcQfpHXwpfksl4GwSLlOqE3pPnY+cOj/4Oi97uMOd4CWykSrj/yVNd
25HSjaJWDjLCGlkBlB+LCK6bmyzqRNKEMBmr0m08nHLmEw3gWt7q7zScCxDHCihh
iWhDuKPPSznIj9o4wkIAueSsBmJyoRR8xjUNmqlrNzidxKUBBHJ0f+0heoryicog
vdRtPhBdPa7yjBJaszBNGqfF0hd65joAMk7izlg3jv0AUzihpvTCfMU7EuPEvgXL
3pzLQsx5FgbuCp3vXwi3F9nn9Ilqx9vHSfu6spLvCF2Vjo6v6A7sVmtLSoAsSLSw
WUJDr5wOfkS9dtmi4YzyrDh28Tq+gzQX8onZSaPSD+IQi/88Vz0+j7WHCdkoIMEo
NSvIDfnsY9cutgqRvksmAAkdj4S7yiQt1NNVgJXsxruOLF2IOE15LKw97bRcB0Xr
vhYoYyT+Pwgt95vli/EhQZqplS2bVSP4GPMTbVpLBBRmuCrN9dh4aiSuYabuNdBh
dhP8nsOeP5tgC7nLn6EvNiXRF4NdDApwv7y2VXfhz9awwfuxFIElmoyrIp+o2BJ0
WqbAr8FoZdLOIZ4/RSL4NJRFDsYNy43tcq9spe/kHd/FADV2S4PWDDxnPkQkt9+g
8rb3UAY+R/fB59j70cp4
=f/8l
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_12_12_38_+1100_o5k/Wft/fQITXmpD--
