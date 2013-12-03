Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752865Ab3LCAUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:20:41 -0500
Received: from ozlabs.org ([203.10.76.45]:57029 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3LCAUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:20:38 -0500
Date: Tue, 3 Dec 2013 11:20:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Chun-Yeow Yeoh" <yeohchunyeow@gmail.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 wireless tree
Message-Id: <20131203112032.b6c5faa3e40442b66770df91@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__3_Dec_2013_11_20_32_+1100_aDNjMGSUBBBzxLm."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__3_Dec_2013_11_20_32_+1100_aDNjMGSUBBBzxLm.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/mac80211/util.c between commit 3f718fd8401d ("mac80211: fix the mesh
channel switch support") from the wireless tree and commit ca91dc97b8a0
("mac80211: use put_unaligned_le16 for precedence value in mesh") from
the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/util.c
index 9f9b9bd3fd44,06265d7f8cc3..000000000000
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@@ -2457,9 -2481,13 +2479,8 @@@ int ieee80211_send_action_csa(struct ie
  			  WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT : 0x00;
  		put_unaligned_le16(WLAN_REASON_MESH_CHAN, pos); /* Reason Cd */
  		pos +=3D 2;
- 		pre_value =3D cpu_to_le16(ifmsh->pre_value);
- 		memcpy(pos, &pre_value, 2);		/* Precedence Value */
 -		if (!ifmsh->pre_value)
 -			ifmsh->pre_value =3D 1;
 -		else
 -			ifmsh->pre_value++;
+ 		put_unaligned_le16(ifmsh->pre_value, pos);/* Precedence Value */
  		pos +=3D 2;
 -		ifmsh->chsw_init =3D true;
  	}
 =20
  	ieee80211_tx_skb(sdata, skb);

--Signature=_Tue__3_Dec_2013_11_20_32_+1100_aDNjMGSUBBBzxLm.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSnSPUAAoJEMDTa8Ir7ZwVvUAP/2vx4eg658g6PD+xV9OqSkH/
FjHpeix1q/38ZBhXFb2R+NbKptQswC9r9ObaL3Bk9+nz/SLlX/P8keXjR3wUpS4u
Dx/LzQcjfwUutBVhDzsxv3VQzmhQJ4fWpwqlKo+O2Vox1zJegqFz5JCzH98I1gtS
YiU7yX0vDgQl4+qYZqk4/ncvX3bTGwOFlhlOWiNwtS6UVifyVD0l/EWEJ9mIKdUE
TMQ/Dbhqg3NiZw4Tu3eEXnvhvT4/amAkWFdlIDgqD25RkfFzGvVWL5zaA5VoyEZu
yGXL3F2VN/6UDX6l8vixtSVIOChUQRbvw1D/nBJYPrbzHJgL4A3TacvTxtyMVe4x
3gaObx1yV6dpvvKIUtEtq/tYL3Vbg9lJ4yx4739F2NoX9ZitFOmlc3oZfskUjfzz
Ii44oXox9HbawG3Rpc75ATpYohy1a+8YfZ7eBLC//JSTWknUM2ZVjyeQtXPHD9mI
+0bz/i4xlpRK3N7yu6FyEMNTLXPVGmkxWzf47ALi6q5IumOOytFF3ewSxIkMwaJG
mFNZBLEVxPaP+PT8FvBxnrkwlwvM28QQxdEk0LrKCO3fyxov++x4DaiX2XTZY/jR
ywcqXIb4xND9dI46hEqcgpMtcfTYz/RnwOQTyO3oRwX94YLmeYPPeuTKIsASaFG8
9lR3isdl+RqIZcTwIPLB
=xT7P
-----END PGP SIGNATURE-----

--Signature=_Tue__3_Dec_2013_11_20_32_+1100_aDNjMGSUBBBzxLm.--
