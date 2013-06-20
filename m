Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935771Ab3FTDkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:40:43 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47978 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935661Ab3FTDkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:40:42 -0400
Date: Thu, 20 Jun 2013 13:40:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the wireless-next tree with the net
 tree
Message-Id: <20130620134032.8b7ae39298881c936338e7fb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Jun_2013_13_40_32_+1000_mlNf_MqL2LnsAacT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Jun_2013_13_40_32_+1000_mlNf_MqL2LnsAacT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/wireless/nl80211.c between commit 3a5a423bb958 ("nl80211: fix attrbuf
access race by allocating a separate one") from the net tree and commit
940d0ac9dbe3 ("cfg80211: fix rtnl leak in wiphy dump error cases") from
the wireless-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/wireless/nl80211.c
index 51d660e,e402819..0000000
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@@ -1550,7 -1542,7 +1547,8 @@@ static int nl80211_dump_wiphy(struct sk
 =20
  			netdev =3D dev_get_by_index(sock_net(skb->sk), ifidx);
  			if (!netdev) {
+ 				rtnl_unlock();
 +				kfree(tb);
  				return -ENODEV;
  			}
  			if (netdev->ieee80211_ptr) {

--Signature=_Thu__20_Jun_2013_13_40_32_+1000_mlNf_MqL2LnsAacT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRwnm0AAoJEECxmPOUX5FErdIP/1nP/6tNSyWKkCocOvWVhQU3
HOuggcNQ1IGShvfr8VJmmOHDodzl0UzoKUh+oedL+f8ENoDiIjC+YVYDPbhEu0OR
DTsHZdWpITu3PW83MEgk8HgT+j848Tf5QQP0Ti9QrBJTzJOykzNjbm/ZtYj6L03U
t/dlwaxNR9LI3r/uTpWSS8pWzIyyb5WgVgGFDqq/jl9KASk+FXqCBBUbO7BkiBLm
zrH7/R/MIfZP76ExprTj2OGLYc/NF8DNpPA8V9YVs2u/v5OBySzESvgaeZN6S2EF
xxD4KagFH20Ws7tOm/z/x7z3V/SIEMx+jvYxHypJ9RHYGhWp1MxlS5k/MV1A0/n6
zmk1w92JjqblZ+i1h9uxLrRxSaHMAEr2x4zB66boK1T+bMkZQliewDv8CjMWP6RB
iErlAt4gis4S4ZUJXQazox2ELG8oP1obL+6XUNaYtpRN4neLNhuciEBVqtvOgWWV
ZxSSFNMdgmCimAzDYavjtI9D7tD40dbH8EclhDcAKyT+lNgOvjgTZPORsCHVesBB
8xgJgA7mAfvEptD/mbNO3LJEEcpKGwiwF6q2h17XNNP0DCRleXnbYFslXyyB0/HL
Jg+k1ZlHa/vigABoS5OTXbhpk5eB3IY6iPDAuVl8KjWzi0hhTXxgx54n/S9m/dlr
Lg5b6kmHDqBpL7DLdp4l
=wGgO
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Jun_2013_13_40_32_+1000_mlNf_MqL2LnsAacT--
