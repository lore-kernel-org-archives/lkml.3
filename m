Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864Ab3BMIH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:07:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:55221 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab3BMIH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:07:57 -0500
Date: Wed, 13 Feb 2013 19:07:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: linux-next: manual merge of the akpm tree with the ipsec-next tree
Message-Id: <20130213190753.c45ff38dbf502eec735bd1d5@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Feb_2013_19_07_53_+1100_7wYtvcauQupTK3al"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Feb_2013_19_07_53_+1100_7wYtvcauQupTK3al
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
net/xfrm/xfrm_policy.c between commit 7cb8a93968e3 ("xfrm: Allow
inserting policies with matching mark and different priorities") from the
ipsec-next tree and commit "hlist: drop the node parameter from
iterators" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/xfrm/xfrm_policy.c
index 5b47180,33fe9ee..0000000
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@@ -628,16 -612,17 +627,16 @@@ int xfrm_policy_insert(int dir, struct=20
  	struct xfrm_policy *pol;
  	struct xfrm_policy *delpol;
  	struct hlist_head *chain;
- 	struct hlist_node *entry, *newpos;
+ 	struct hlist_node *newpos;
 -	u32 mark =3D policy->mark.v & policy->mark.m;
 =20
  	write_lock_bh(&xfrm_policy_lock);
  	chain =3D policy_hash_bysel(net, &policy->selector, policy->family, dir);
  	delpol =3D NULL;
  	newpos =3D NULL;
- 	hlist_for_each_entry(pol, entry, chain, bydst) {
+ 	hlist_for_each_entry(pol, chain, bydst) {
  		if (pol->type =3D=3D policy->type &&
  		    !selector_cmp(&pol->selector, &policy->selector) &&
 -		    (mark & pol->mark.m) =3D=3D pol->mark.v &&
 +		    xfrm_policy_mark_match(policy, pol) &&
  		    xfrm_sec_ctx_match(pol->security, policy->security) &&
  		    !WARN_ON(delpol)) {
  			if (excl) {

--Signature=_Wed__13_Feb_2013_19_07_53_+1100_7wYtvcauQupTK3al
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRG0nZAAoJEECxmPOUX5FEF2YQAI5cWO8Uh3ysNs4i9pRjGDF9
sA0jtkNHciZAmUIqwDDk+GZPGoroepd2cc9sj08+gZGcz04UFB4GOT7VW8bvHBHQ
xzXXwlzCx+cvQIglv+CqzOz+4z3jBgyi2DVW9dpP93W8gVaGdXfr+choVXX0OVlJ
WYYh0Tt6UGYVO3N0mHIpSHRJfKo5xIftp+quX/mfoYD+EUTTg6BRulI1XkCo2Fwv
jluQo8HJZbckfkb1zio/DwhvzQi6ojKGa6FuNUxXztmhBBRX3OYUsfkQ2xLBbTOv
3qrM7OL4fjgPxvmKxEB026gRcYlJr51wUW7bFZfnJFf3zOWxDwuvTIzfQy5etdXF
RsTBCfzmctJ7kTdT6eJrDQPp2eHg6xctdJswBISQFMQae4j7HBzkySJYR744xSOc
S7itpTaHjswo+VL+l3MlNC9yTY1fMUxJAh2EnDcpoWS19G5gwhmLxju5mhx0qos4
qUD0ylwmkIjobZEqoLJLNZa0qQVpce12C0P3OOfWgjRXAYrzlYE2vHiL6ZFBuBCV
rWLce0apWUx3+L8yWaFPIVttOe9A42n50H2Xu3ZDbcIWznSAFIzOBzqyR4PdEi3B
YRnlCvbX4Iim3MOs1d1i2zd/EQpnO2jYHinwCXgQupBUsmte5FDlYehXzH8wWNde
Ygr5rZ0DEEGpmpIcIUZ8
=KBat
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Feb_2013_19_07_53_+1100_7wYtvcauQupTK3al--
