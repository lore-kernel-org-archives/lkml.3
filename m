Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826AbaKYDgz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 22:36:55 -0500
Received: from ozlabs.org ([103.22.144.67]:57272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaKYDgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 22:36:54 -0500
Date: Tue, 25 Nov 2014 14:36:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luciano Coelho <luciano.coelho@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Arik Nemtsov <arik@wizery.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-ID: <20141125143646.4d945674@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/td_R+A_=UcaelopoFguwgDw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/td_R+A_=UcaelopoFguwgDw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-fw.h between commit 5ac6c72e5944
("iwlwifi: mvm: check TLV flag before trying to use hotspot firmware
commands") from the wireless tree and commit 77c5d7eff790 ("iwlwifi:
mvm: add TDLS channel switch FW APIs") from the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-fw.h
index 649fdae77383,a94d244459d7..000000000000
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@@ -155,7 -157,7 +157,8 @@@ enum iwl_ucode_tlv_api=20
   * @IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT: supports Quiet Period reques=
ts
   * @IWL_UCODE_TLV_CAPA_DQA_SUPPORT: supports dynamic queue allocation (DQ=
A),
   *	which also implies support for the scheduler configuration command
+  * @IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH: supports TDLS channel switchi=
ng
 + * @IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT: supports Hot Spot Command
   */
  enum iwl_ucode_tlv_capa {
  	IWL_UCODE_TLV_CAPA_D0I3_SUPPORT			=3D BIT(0),
@@@ -164,7 -168,7 +169,8 @@@
  	IWL_UCODE_TLV_CAPA_WFA_TPC_REP_IE_SUPPORT	=3D BIT(10),
  	IWL_UCODE_TLV_CAPA_QUIET_PERIOD_SUPPORT		=3D BIT(11),
  	IWL_UCODE_TLV_CAPA_DQA_SUPPORT			=3D BIT(12),
+ 	IWL_UCODE_TLV_CAPA_TDLS_CHANNEL_SWITCH		=3D BIT(13),
 +	IWL_UCODE_TLV_CAPA_HOTSPOT_SUPPORT		=3D BIT(18),
  };
 =20
  /* The default calibrate table size if not specified by firmware file */

--Sig_/td_R+A_=UcaelopoFguwgDw
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUc/lTAAoJEMDTa8Ir7ZwVx1EP/2Ogx03Li1tXkIyiVWa41ygs
qsHM86Vnz5uA68b3YshrlSCcRgx1Mu+TxFP2ip9Yt2GN2oLN0clA+avSMzmOk60f
Usb82NrFm/+GUA+YQEHpiRyvflf6xZZH0q1/+J5cgvVJ/n+tnrnnil1gE4UofwK5
O1bXjI4AvyeOd1gfkvzowxkOBlAx/Oh7p27SkSe/aslBcvlFnYdyT6T8SAUBFga+
27W2CHFcKXmi/Y5A9i91STfOWqL2VGhuWRqEwQiaDU0ySBlkcD35q3imbuv4ZB4j
nHymTcqDQh02f9hnfdOO0QUIaOEaJ1dGv0NwRnxUnFwHMmJ+QaV9fm5DfLeD2kGC
v4Ea1TGANrhHf0G7uBWq1mL0BmHRxoiGtIYUQ/cGHIlYyYcOLS0OTVfIGD283FIN
y2+LJxwzf2F761cXZFPvlj1db8fvIo9SnkJfRcRezCM7QxENfU7fwq2PLxgwkn66
oClsaHxv/3C2JTNYix8PbFrPWjgvOn94onxs61MmnBy2htusP+vvxMihDMwmwQ2w
ByY6hBB3+lZGl7MMGikdel9daTGYv7ArEWAuiHwSeC4j7BYOdQpq1LzQcyJOtja7
5ceajZqch4YLvXeaWsjgww0m7qa+2fXLEn6SHnRyY6FbgWsErN1hGISwBTlOCTdB
GR2HeDvARUlmECsEryYS
=KtMB
-----END PGP SIGNATURE-----

--Sig_/td_R+A_=UcaelopoFguwgDw--
