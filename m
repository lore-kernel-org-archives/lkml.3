Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab3HUEUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:20:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42005 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab3HUEUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:20:40 -0400
Date: Wed, 21 Aug 2013 14:20:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the trivial tree with the wireless tree
Message-Id: <20130821142036.e7d5e9fec3c2e1e96363a9c7@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Aug_2013_14_20_36_+1000__8VmOlH=pLdYeOWG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Aug_2013_14_20_36_+1000__8VmOlH=pLdYeOWG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/wireless/iwlwifi/mvm/time-event.c between commit 057397943eee
("iwlwifi: mvm: disconnect if time event scheduling fails") from the
wireless tree and commit 0b1587b18bfe ("treewide: Fix typo in printk")
from the trivial tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/mvm/time-event.c
index c17b74c,39b3ffb..0000000
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@@ -198,12 -180,19 +198,12 @@@ static void iwl_mvm_te_handle_notif(str
  		 * By now, we should have finished association
  		 * and know the dtim period.
  		 */
 -		if (te_data->vif->type =3D=3D NL80211_IFTYPE_STATION &&
 -		    (!te_data->vif->bss_conf.assoc ||
 -		     !te_data->vif->bss_conf.dtim_period)) {
 -			IWL_ERR(mvm,
 -				"No association and the time event is over already...\n");
 -			ieee80211_connection_loss(te_data->vif);
 -		}
 -
 +		iwl_mvm_te_check_disconnect(mvm, te_data->vif,
- 			"No assocation and the time event is over already...");
++			"No association and the time event is over already...");
  		iwl_mvm_te_clear_data(mvm, te_data);
 -	} else if (le32_to_cpu(notif->action) & TE_NOTIF_HOST_EVENT_START) {
 +	} else if (le32_to_cpu(notif->action) & TE_V2_NOTIF_HOST_EVENT_START) {
  		te_data->running =3D true;
 -		te_data->end_jiffies =3D jiffies +
 -			TU_TO_JIFFIES(te_data->duration);
 +		te_data->end_jiffies =3D TU_TO_EXP_TIME(te_data->duration);
 =20
  		if (te_data->vif->type =3D=3D NL80211_IFTYPE_P2P_DEVICE) {
  			set_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);

--Signature=_Wed__21_Aug_2013_14_20_36_+1000__8VmOlH=pLdYeOWG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSFEAUAAoJEECxmPOUX5FEQugQAKLhJ5ay2TMzI3+OmFPQzATM
Y0UfEV2gZ/mBmJesdh3dv+0oPfii87UcJouU6D83VnO1AUcgM+S81IspJ0rAdRIC
xuUDRFsDXtJBiHq6k0iXUJz7iXiuhXv+sdru+LZwvlXLP+gFuTghWDeIhpxJ1w2/
1jMHcrIkTkZbWl4w1A49BGW8NAkpduzYp3zsyVs1p0Rc1SMVJnEdc3OtxwZ7HFL2
/P/G8lyub4ijs0UtAbhi3f6lrHDww9Z8PG8jwamQ0xvUi10x7lTh+oI69FZMY9zw
vjJPCJYQgkh2ZRily5G55FGCYd3ZvNb0OYxCkjE/fnjkQHG9Qy9yTkCkwaxpZM6O
blvPLHNYIbgBeryZp52fd+OrKP8mku2JQp/wlZj21XZf1kXAVdPY5AbsljNA2q0G
7lZFupk6t96J0zpVVT7iiGjHg78MfOEeqICjqCYZpG65cJ/K3iz/zwK+2jCwqWK5
qZziqpzBd51HAKpNWxJoBhgxt8dSMWC378p4HcZCV3bqvrRhimMJfRRhrFzUDSsj
Aa7wvE+eHxamHg2RkBDEsRYpS+dIhhl/fLH+MrqUdRLTOHrH+TTOs4XyVcvzFE2E
m0miUKBFGZyTtJ31KcTDtkDdqII3bnykf1aPR5OZmu56oLxmz8rsfSPvaskaH/2O
M55c2j61FpXptBiK1Cw7
=U9MF
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Aug_2013_14_20_36_+1000__8VmOlH=pLdYeOWG--
