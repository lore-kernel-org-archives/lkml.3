Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaCYR2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:28:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47478 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423AbaCYR2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:28:51 -0400
Message-ID: <1395768502.28354.7.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 3.4] iwlwifi: Complete backport of "iwlwifi: always copy
 first 16 bytes of commands"
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Jianguo Wu <wujianguo@huawei.com>,
        Andres Bertens <abertensu@yahoo.com>,
        Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Date: Tue, 25 Mar 2014 17:28:22 +0000
In-Reply-To: <1395716117.2832.86.camel@deadeye.wl.decadent.org.uk>
References: <20140308010611.468206150@linuxfoundation.org>
	 <20140322165145.GA12870@kroah.com>
	 <1395509887.2770.72.camel@deadeye.wl.decadent.org.uk>
	 <1553572.xqrhDm938v@tux200s>
	 <1395716117.2832.86.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Tg4AyvHBvrFHftrTGalP"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Tg4AyvHBvrFHftrTGalP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Linux 3.4.83 included an incomplete backport of commit
8a964f44e01ad3bbc208c3e80d931ba91b9ea786 ('iwlwifi: always copy first
16 bytes of commands') which causes a regression for this driver.
This is the missing piece.

Reported-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Jianguo Wu <wujianguo@huawei.com>
Tested-by: Andreas Sturmlechner <andreas.sturmlechner@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -825,14 +825,15 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, =
struct iwl_host_cmd *cmd)
 	trace_idx =3D 1;
 #endif
=20
+	/* map the remaining (adjusted) nocopy/dup fragments */
 	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
-		if (!cmd->len[i])
+		if (!cmdlen[i])
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr =3D dma_map_single(trans->dev,
-					   (void *)cmd->data[i],
-					   cmd->len[i], DMA_BIDIRECTIONAL);
+					   (void *)cmddata[i],
+					   cmdlen[i], DMA_BIDIRECTIONAL);
 		if (dma_mapping_error(trans->dev, phys_addr)) {
 			iwlagn_unmap_tfd(trans, out_meta,
 					 &txq->tfds[q->write_ptr],

--=20
Ben Hutchings
Make three consecutive correct guesses and you will be considered an expert=
.

--=-Tg4AyvHBvrFHftrTGalP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIUAwUAUzG8tue/yOyVhhEJAQqdgA/0DJjI0Pjnp0tvkAretUbfGF+EYz2wzQU6
Gkyfy3oROnNk5T9ng9m5R6+cl3kvLyvCcHV1w3R0OGoGveExI2vj0cFgwmj37088
l0y2z1Q2DBZzBH/v0jE/kf3KxNSyuveOPFuYE45egGV1BOO2BCWWAcnVFSCIu/mu
2L5hw1woLBbwEtnWVoDNJd8iVmF9V+amjgPnbizwZUPu1ickmGVz2QWkVxNe5WK7
yvhwTGl+WJ52L0yNyALovdL98jogEUGCd9VcsXDPIn5KfLx70udSRR3P79xdMPK6
HrzlrLsxbrvdSZd07KPSn14ZK4P1jfDWXo6cEJoc4WwaotkdRnjAGsZ7aJ/KqUwk
9bXqliJRD9mAXVhd9yGrLnU+JcBhFj+mGm6MsFlV56tkzaBqg10gxnQy3jowziSB
NztdMgclcc9S5xJqkp8OlbnhmuUoeS6c6PO5InK/udW26lCd3VAJ2P9XDkjLyKgc
i/CkJHULd96Vjvgt6RvtiLs1tjWvaSLV+z8mmI3DpaOmmu9VBlKUDCwsAoUvp/pX
aNi8LiRt/5Bm2PksVJBlJE/MJY9q6vXHWTcq9uGDBlOrznVx9FQA73wZukp7Hulz
XNHgJe/7v4pHTK0giBSo/dQgCQaZL+VV5cTQluFdKyoBMUsoFPOg4iZb/+kSFbPW
PYbW/e9ufA==
=h6f5
-----END PGP SIGNATURE-----

--=-Tg4AyvHBvrFHftrTGalP--
