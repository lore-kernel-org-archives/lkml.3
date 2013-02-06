Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3BFGqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 01:46:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:59076 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab3BFGqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 01:46:05 -0500
Date: Wed, 6 Feb 2013 17:45:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>, Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: linux-next: manual merge of the akpm tree with the nfsd tree
Message-Id: <20130206174549.0518f5f76815eebe52a689ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__6_Feb_2013_17_45_49_+1100_hp3NBGjHolREs9ZA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_Feb_2013_17_45_49_+1100_hp3NBGjHolREs9ZA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
fs/nfsd/nfscache.c between commit 2c6b691c05bf ("nfsd: when updating an
entry with RC_NOCACHE, just free it") from the nfsd tree and commit
"hlist: drop the node parameter from iterators" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfsd/nfscache.c
index d16a5d6,30c27eb..0000000
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@@ -254,9 -165,11 +253,9 @@@ nfsd_cache_search(struct svc_rqst *rqst
  				proc =3D rqstp->rq_proc;
 =20
  	rh =3D &cache_hash[request_hash(xid)];
- 	hlist_for_each_entry(rp, hn, rh, c_hash) {
+ 	hlist_for_each_entry(rp, rh, c_hash) {
 -		if (rp->c_state !=3D RC_UNUSED &&
 -		    xid =3D=3D rp->c_xid && proc =3D=3D rp->c_proc &&
 +		if (xid =3D=3D rp->c_xid && proc =3D=3D rp->c_proc &&
  		    proto =3D=3D rp->c_prot && vers =3D=3D rp->c_vers &&
 -		    !nfsd_cache_entry_expired(rp) &&
  		    rpc_cmp_addr(svc_addr(rqstp), (struct sockaddr *)&rp->c_addr) &&
  		    rpc_get_port(svc_addr(rqstp)) =3D=3D rpc_get_port((struct sockaddr =
*)&rp->c_addr))
  			return rp;

--Signature=_Wed__6_Feb_2013_17_45_49_+1100_hp3NBGjHolREs9ZA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJREfwdAAoJEECxmPOUX5FE2sYP/3rA5KaAeDIsVJH8nAJHkOmh
E9f/fGKQp7HZgGtg+yJDRzSyQaKQa0PIFGA4QXPmBDvJKfpPONk97pweov6NUlDS
v6fFu0BI3AKJBCn+hCn2azrbnumCAV/0H9lG6aIHl17fx39HzaIVjzgGdC/oBCyW
HPSCJ7ee1QYT4ECgnaeJpXs45kuBZD6YUjTAvU5U1+j28ofy9rUeMNAcOZxcRoWC
qLfooaLBdB2DdvuB8CigOpq8Jfu3jSYeed64QctG/wENV9KkdSlj1744syP0fC8Y
cHuKTqlNb7meaImmAAF+hpFZ9HzblqE+UZPPQB9AKC4mqVEOYfJ7mnxIP3y5tRJQ
mz0nOln7hUTu6qAvH44hT5Tzw2BOEXdTG0yCUw5VZOZHcIrdblo7M2DYnG+/6ikz
SfbBnms59htCpuq4YuBZlAC5B7kWGsb2D/vtAe4ZZNOTYPXs63LLF3iDCZ96dZMK
X26aAMg5yZIQpsao0GhJDsKmzBYEZIyZK0ShNytpnP2bQvAz8jko0apA/QYHS+9d
LTpJPXKT2f6dHGWwwvO0rZBq4Tlm16IFJ24K+SZRJR03jrOtVnRZaMTzWiP3aPgM
xM38drEwEU7TddnEtAeqhnFyMMmDLB5xx5ytH/upGNSVfZOYkoaLlTqtZBdiMBy2
JMuDuAKCwylm4ZINn69N
=a87Z
-----END PGP SIGNATURE-----

--Signature=_Wed__6_Feb_2013_17_45_49_+1100_hp3NBGjHolREs9ZA--
