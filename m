Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971AbaCKMHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:07:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48038 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbaCKMHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:07:45 -0400
Date: Tue, 11 Mar 2014 12:07:31 +0000
From: Mark Brown <broonie@kernel.org>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Zoltan Kiss <zoltan.kiss@citrix.com>, Annie Li <annie.li@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140311120731.d18ae172bfe02469fda4b2a4@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Mar_2014_12_07_31_+0000__lNQNr5yEm/oXOuB"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the net-next tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Mar_2014_12_07_31_+0000__lNQNr5yEm/oXOuB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in drivers/net=
/xen-netback/netback.c between commit 5bd076708664313f ("Xen-netback: Fix i=
ssue caused by using gso_type wrongly") from Linus' tree and commit 3e2234b=
3149f66 ("xen-netback: Handle foreign mapped pages on the guest RX path") f=
rom the net-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/net/xen-netback/netback.c
index 438d0c09b7e6,bc943205a691..000000000000
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@@ -338,6 -348,10 +348,9 @@@ static int xenvif_gop_skb(struct sk_buf
        int head =3D 1;
        int old_meta_prod;
        int gso_type;
 -      int gso_size;
+       struct ubuf_info *ubuf =3D skb_shinfo(skb)->destructor_arg;
+       grant_ref_t foreign_grefs[MAX_SKB_FRAGS];
+       struct xenvif *foreign_vif =3D NULL;
 =20
        old_meta_prod =3D npo->meta_prod;
 =20

--Signature=_Tue__11_Mar_2014_12_07_31_+0000__lNQNr5yEm/oXOuB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHvyDAAoJELSic+t+oim9PucQAJsfjqyQ4MlY2mNs2icLChWW
FcGCPjnndTFvsds+uoYMe//Eb5QVJ4mqv79A/45GCNIV6Q9Bc0GE6YDOl+34SQSn
zeqkiBX1s/OGQn2kmm2hEGMJizWEdCU3z66Gd+0Otnmvl91SY4uJIWpuyKnDZ11v
Z0dGPzSXXiqd3Pzwqlr3JmOm8BETIhY/0dTuTmYTJeQB/Z594go9M1KNMxm2Kvww
NIJ58UWLo9ll1CWVC7AVGMiijn6yFr1rdrzEiKMu+I9Ta8Pql155zGxcD9fScwo2
7rK0aIAgEiKtJ23EwUU0XLDpJC1WFBWAtliAoYQ47+uXxMt0xzz/bCGrte4lJjMo
eA0zhtb8thOKd2RJbFIBcvTHHQrJmJpCXJDCHj6J7mFkAERvtAHtuhK3zcgR0QQK
oGzZamF1nWjYrYNfl7bAI5kF1Q1V/73FYRONpgC+3xAyzwlHUlSKnM2SrgF8hw/s
lJ9uURZUNq4Drovw752I2MqFph82iKUL++SsLKvubcwHWjFObDcMwZAsc8zVM7H7
tPrxHo8uNYD0KRjRik0TG8VJksnOq1Y7s8YHo1afNmE1KRjyC1KaeXlwIzSb267e
8p6hEEUKotn+9UQPI4SHwXefsSu/B6aLYjd+qLK0sAeWHsarAyvD9RQGovNedCL+
kdQicKskYkKZzD/PCb9v
=5hHm
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Mar_2014_12_07_31_+0000__lNQNr5yEm/oXOuB--
