Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3BSF2d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 00:28:33 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42531 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3BSF2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 00:28:31 -0500
Date: Tue, 19 Feb 2013 16:28:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the akpm tree with the wireless-next
 tree
Message-Id: <20130219162822.dcf6f5bf65252d2b25420051@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Feb_2013_16_28_22_+1100_v4onkqf7zX7Qj8dD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Feb_2013_16_28_22_+1100_v4onkqf7zX7Qj8dD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
net/mac80211/mesh_pathtbl.c between commit bf7cd94dcc71 ("mac80211: clean
up mesh code") from the wireless-next tree and commit "hlist: drop the
node parameter from iterators" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/mesh_pathtbl.c
index 6b3c4e1,ddf48f6..0000000
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@@ -455,27 -448,30 +452,27 @@@ err_rcu
   * @tbl: table which holds our list of known gates
   * @mpath: gate mpath
   *
 - * Returns: 0 on success
 - *
   * Locking: must be called inside rcu_read_lock() section
   */
 -static int mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
 +static void mesh_gate_del(struct mesh_table *tbl, struct mesh_path *mpath)
  {
  	struct mpath_node *gate;
- 	struct hlist_node *p, *q;
+ 	struct hlist_node *q;
 =20
- 	hlist_for_each_entry_safe(gate, p, q, tbl->known_gates, list) {
 -	hlist_for_each_entry_safe(gate, q, tbl->known_gates, list)
 -		if (gate->mpath =3D=3D mpath) {
 -			spin_lock_bh(&tbl->gates_lock);
 -			hlist_del_rcu(&gate->list);
 -			kfree_rcu(gate, rcu);
 -			spin_unlock_bh(&tbl->gates_lock);
 -			mpath->sdata->u.mesh.num_gates--;
 -			mpath->is_gate =3D false;
 -			mpath_dbg(mpath->sdata,
 -				  "Mesh path: Deleted gate: %pM. %d known gates\n",
 -				  mpath->dst, mpath->sdata->u.mesh.num_gates);
 -			break;
 -		}
 -
 -	return 0;
++	hlist_for_each_entry_safe(gate, q, tbl->known_gates, list) {
 +		if (gate->mpath !=3D mpath)
 +			continue;
 +		spin_lock_bh(&tbl->gates_lock);
 +		hlist_del_rcu(&gate->list);
 +		kfree_rcu(gate, rcu);
 +		spin_unlock_bh(&tbl->gates_lock);
 +		mpath->sdata->u.mesh.num_gates--;
 +		mpath->is_gate =3D false;
 +		mpath_dbg(mpath->sdata,
 +			  "Mesh path: Deleted gate: %pM. %d known gates\n",
 +			  mpath->dst, mpath->sdata->u.mesh.num_gates);
 +		break;
 +	}
  }
 =20
  /**

--Signature=_Tue__19_Feb_2013_16_28_22_+1100_v4onkqf7zX7Qj8dD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIw12AAoJEECxmPOUX5FE4xsP/ip3D6rxwTa7NhdFjUX9G5G7
xucSMomzkAOd4tYQuYa5ecL5Tjj7AkNLgofYKp5B7n9mlzX2F85aUd4TE2WMt7sE
DRnp9oBZG+TmitS/L+JlOykgdxg2AO45jwwz/vU+jztbKOLwMbCsHy24RpBkiqWm
FV630aS7x4GWxm+S9kmEX2Yhp0tBxHM3ySwj6jSaAXsIRC2vEtBygHR6AsfO8+Tv
72HHUoSD7INxWAZRxn8qJM8qs3H8oW5l5X265SrGoubUWcoU8E2qCRm3iOl3mhd+
ryAgr3Yot1Lv9IvWaWmBkj4ad3NC2+oK3LUB6mKvQi+68cdYlDFjUsV96kjBMw/m
ixup+dTk+AS6PlwRgJyUFlR/5j+wBddoe0w4no++bWEn1riWSwB/SgToki/ISaDO
NVAnrpDXSTSHaeUyReKEekkf86xCq/UdNg/r7ePbzRfIh36bjtl6WR4D2PylZvYC
UP8wX5rZbxFLrLygDNHMpTb7DuzE4Oer6gIE1KuhnpIEUEH52zvgNnWiD3Yg1p7c
lmtzvPz8/XwLb6+RhSTx4DA4dgaL0BohQuX8Svt5jAPm7MGmfnFeXOxJpkb1p9M1
CJe9YyxL/zqojfdqHTHdGHNq+IXsD3KserBP7aEqCyHBTW4hGT3D9kjaIGjticuv
HiDDyTYAuIppL4EKLGGO
=D7j9
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Feb_2013_16_28_22_+1100_v4onkqf7zX7Qj8dD--
