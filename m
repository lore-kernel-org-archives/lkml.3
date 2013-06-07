Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab3FGC4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 22:56:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43607 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3FGC4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 22:56:23 -0400
Date: Fri, 7 Jun 2013 12:56:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20130607125612.4016cd4ee44614642dc5dd31@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__7_Jun_2013_12_56_12_+1000_x9z=mz4V7LFJETS="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__7_Jun_2013_12_56_12_+1000_x9z=mz4V7LFJETS=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
drivers/net/wireless/ath/ath9k/Kconfig between commit 8bb7f167a12a
("ath9k: Use minstrel rate control by default") from the wireless tree
and commit cf657a2bc50d ("ath9k: Remove MAC_DEBUG") from the
wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/ath/ath9k/Kconfig
index 3c2cbc9,ec33c80..0000000
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@@ -84,25 -84,13 +84,17 @@@ config ATH9K_DFS_CERTIFIE
  	  developed. At this point enabling this option won't do anything
  	  except increase code size.
 =20
- config ATH9K_MAC_DEBUG
- 	bool "Atheros MAC statistics"
- 	depends on ATH9K_DEBUGFS
- 	default y
- 	---help---
- 	  This option enables collection of statistics for Rx/Tx status
- 	  data and some other MAC related statistics
-=20
 -config ATH9K_RATE_CONTROL
 +config ATH9K_LEGACY_RATE_CONTROL
  	bool "Atheros ath9k rate control"
  	depends on ATH9K
 -	default y
 +	default n
  	---help---
  	  Say Y, if you want to use the ath9k specific rate control
 -	  module instead of minstrel_ht.
 +	  module instead of minstrel_ht. Be warned that there are various
 +	  issues with the ath9k RC and minstrel is a more robust algorithm.
 +	  Note that even if this option is selected, "ath9k_rate_control"
 +	  has to be passed to mac80211 using the module parameter,
 +	  ieee80211_default_rc_algo.
 =20
  config ATH9K_HTC
         tristate "Atheros HTC based wireless cards support"

--Signature=_Fri__7_Jun_2013_12_56_12_+1000_x9z=mz4V7LFJETS=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsUvRAAoJEECxmPOUX5FE478P/AtUSDmjASrTBX12lwWhVlWP
YZiVjWbs/TqRMcMXUUV0KVm4NsMT13xSr7RUUhtQUkjRx1ajRBqHSH0DLnirWr1K
B6D919fm2kC/OccJgQ4F/1aWfawT4scLDgGwL2fuTWWFjXc1GYNTcIImtQXynp1p
/hjdXGbacrQYXkaOQAFO+tVQFzaqhzVSF/89Nj+7dgg+LIb+yusiGwUc77Uxpfhe
Zuil143l2UmTrDPB28sCBCWjIRYeqSXcc8jVdHDnpmC3ngYxRZ6BwWPJ+c3B+Tve
ZCOfuTeYPCCq0YSXCNSHFznG8NcVNDottk9Vm7uVWQla3eGifG6/jE2/ZxoPnp+q
+xCbkTDxs8Lm6YXgxeeF+Ddj4r+wActi2nps7y7T2Zye7+FwIJ1xvLMFh1D3Gmwp
7moHvfhcrpHvcIg56nk+nw2xmFTO6d38FkCx0efv/f3EQ/iSnXPDEqe3x1BBMnat
GZQSPXCFUYnix0askqF7QlTPjBowOJa+U8LLp3aY0ercRKBHpPsgrjhEBwpYjXyb
6OOxmiodkGJOEfExX9bFoAmalcg2upGycntSYj7EpVAnegW8SXyOudobybx9S/uU
2SuAji8XBPniuGyYzH+RPicWh++ge1cOTsQHvcmd689L0Ajd6nFWuEjqpKSPvTGY
K0OeBf53XBj9W3u9hq8y
=38Ec
-----END PGP SIGNATURE-----

--Signature=_Fri__7_Jun_2013_12_56_12_+1000_x9z=mz4V7LFJETS=--
