Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3AWBQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:16:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39385 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab3AWBQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:16:38 -0500
Date: Wed, 23 Jan 2013 12:16:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: linux-next: manual merge of the wireless-next tree with Linus' tree
Message-Id: <20130123121635.f9d10701019ad76297799d68@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Jan_2013_12_16_35_+1100_+1fL357lOc2gJVL3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jan_2013_12_16_35_+1100_+1fL357lOc2gJVL3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/iwlwifi/dvm/tx.c between commit f590dcec9445
("iwlwifi: fix the reclaimed packet tracking upon flush queue") from
Linus' tree and commit 1c3fea82d6eb ("iwlwifi: improve the reports in TX
path") from the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/dvm/tx.c
index 31534f7,b0aad71..0000000
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@@ -1218,14 -1205,8 +1210,15 @@@ int iwlagn_rx_reply_tx(struct iwl_priv=20
  			freed++;
  		}
 =20
 +		if (tid !=3D IWL_TID_NON_QOS) {
 +			priv->tid_data[sta_id][tid].next_reclaimed =3D
 +				next_reclaimed;
 +			IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
 +					   next_reclaimed);
 +		}
 +
- 		WARN_ON(!is_agg && freed !=3D 1);
+ 		if (!is_agg && freed !=3D 1)
+ 			IWL_ERR(priv, "Q: %d, freed %d\n", txq_id, freed);
 =20
  		/*
  		 * An offchannel frame can be send only on the AUX queue, where

--Signature=_Wed__23_Jan_2013_12_16_35_+1100_+1fL357lOc2gJVL3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ/znzAAoJEECxmPOUX5FEwOwQAJLfCw863dydL2VMmPtE3qpc
HgB6So2t3Bhbu2ThyWC8+wa0MEn6uEmQL7OA0PerX1d90bjYgUL+ZBrdEAHEtpLm
tyYTwdi7Ymzu3cYxc3rss5W2I1qU6Hmcu1Te/IPyEPjrdNNARoM/0JFoamxgmNxN
+10LVbQt2XcyQVbdppDMhe6XZoxrXxgEKdu3N8MIEA3niJPmV20eZIGI+JgTf895
r6joQ3cfCAeXMHJ0wR8xa2Q/8ROWBOg89VwyMlhp9m4qgEqxOh2+GBb7STGADMDl
LTtzMjJHXq6eTitmLJc45ji9J7KMQbqaK10Vu0+3fo1uSTnv3sgEZ8yM7grjzSFN
MZYTe/syGn5lNU0kuwtlmimCGdczycnDQ4VeJPADv3byMmmS927XarIEbGpKM/KL
88YYXVHKM6cPlK3UPYk1I43A8gUiXrLeH1UxY9EzZS1ZLLVMmSzZ4cl3mitmwQ+7
ST/CK3ScZtlPkKHd9+ftqilSkPbVYsSN1R2xweGwNf5sBdkpdbxcaCFTBGDWCXqu
/9qCfLNQsGt/IDLoTvrwbR+7YSY26wuoxuHIL9nn/RLU+eoZ8EJlcOaPV2pn2CRq
4IkK/OQ7ygwGJU0gYopCQDa76WU6XTmX36H6jbrZqH5eGEQ0/wwSVJMLz5MmZZ1L
qFqtGNfeMEJV82ymuHXO
=bMFX
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jan_2013_12_16_35_+1100_+1fL357lOc2gJVL3--
