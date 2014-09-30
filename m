Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaI3Cyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 22:54:32 -0400
Received: from ozlabs.org ([103.22.144.67]:56468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976AbaI3Cya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 22:54:30 -0400
Date: Tue, 30 Sep 2014 12:54:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20140930125422.6ddbf80b@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eT79GzT/TgVSx6199mZ8E7S"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eT79GzT/TgVSx6199mZ8E7S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
net/netfilter/nfnetlink.c between commit cbb8125eb40b ("netfilter:
nfnetlink: deliver netlink errors on batch completion") from the net
tree and commit fc04733a1a71 ("netfilter: nfnetlink: use original
skbuff when committing/aborting") from the net-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/netfilter/nfnetlink.c
index f37f0716a9fc,f77d3f7f22b5..000000000000
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@@ -380,8 -333,7 +380,8 @@@ replay
  			 * original skb.
  			 */
  			if (err =3D=3D -EAGAIN) {
 +				nfnl_err_reset(&err_list);
- 				ss->abort(skb);
+ 				ss->abort(oskb);
  				nfnl_unlock(subsys_id);
  				kfree_skb(nskb);
  				goto replay;
@@@ -418,11 -357,10 +418,11 @@@ ack
  	}
  done:
  	if (success && done)
- 		ss->commit(skb);
+ 		ss->commit(oskb);
  	else
- 		ss->abort(skb);
+ 		ss->abort(oskb);
 =20
 +	nfnl_err_deliver(&err_list, oskb);
  	nfnl_unlock(subsys_id);
  	kfree_skb(nskb);
  }

--Sig_/eT79GzT/TgVSx6199mZ8E7S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUKhtjAAoJEMDTa8Ir7ZwV+CkQAILYTG8lLQ8HikQ81tGrX88E
4CGq8Dal9U8HylPktqBacLYFLsp3P+6bcFVmgeWb8NwlSyPL7GEtaFhH01JuxenV
mtLZ/Z88qiZWuvvp6sgfGhWGZBer0xmtBzwoYs3jgWNxsP73y+jQmPi6quXb9qfM
+TjaQuI04d3z55/620/ZFxidIyUi2r87wNctT4ohZA/ifXseObghenNuURF0ZE0A
RV53Ix/BOrLB9jUy6jdL+xdlTO87k1HbjIL8xtXtAt18dmtvVxWMro8BUux04mlz
bnCJTkDPFtO/zcqAWjBOdHIwrV/rnQkD4uapwlT5gK7eClMN8F7o0aSzP6vA2P1B
u9SeoI4p8WWas6EGP2CoMOHyGgIFOKCduZ5xHBymcyXvEcZuTrjv+ag6DhylgLF3
utyFK/b9QndCWkMzNXEAaR+OKx0/vjq1N+XASn/iEhmgn5T09tb2hNaNi610+3lk
1pX9pIwccV++7y1kiUuNxPKW3sx34VWB+Xa80ZvyUCBavbppJe9ATKo8BnJoYxVS
ThPdw6x66l86+rcDple5bomk3uK3KqBNjGoabRKeiA+RxRSOVXXe6uO+f6sdj6OU
yHbUxFmNThfdbfcUo7Vpjbi8pqbhxHFsYURQcHFsRRdHwBvhyIsbgCzqq6jbdqU7
sJDw3a3lnGD1Lg2ICmmW
=YAuz
-----END PGP SIGNATURE-----

--Sig_/eT79GzT/TgVSx6199mZ8E7S--
