Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3D2Ii3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:38:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52729 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab3D2Ii2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:38:28 -0400
Date: Mon, 29 Apr 2013 18:38:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhao Hongjiang <zhaohongjiang@huawei.com>,
        Linus <torvalds@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>
Subject: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130429183823.fac55917339ff7b84a03c262@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Apr_2013_18_38_23_+1000_mMeZxy7mzoIfYt5x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Apr_2013_18_38_23_+1000_mMeZxy7mzoIfYt5x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in fs/aio.c
between commit 91d80a84bbc8 ("aio: fix possible invalid memory access
when DEBUG is enabled") from Linus' tree and commit "aio: dprintk() ->
pr_debug()" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/aio.c
index 670cb8b,1574cb2..0000000
--- a/fs/aio.c
+++ b/fs/aio.c
@@@ -802,9 -794,8 +794,8 @@@ static int aio_read_evt(struct kioctx *
  	spin_unlock(&info->ring_lock);
 =20
  out:
- 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
- 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 -	kunmap_atomic(ring);
+ 	pr_debug("%d  h%u t%u\n", ret, ring->head, ring->tail);
 +	kunmap_atomic(ring);
  	return ret;
  }
 =20

--Signature=_Mon__29_Apr_2013_18_38_23_+1000_mMeZxy7mzoIfYt5x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRfjF/AAoJEECxmPOUX5FEeusP/0Jet/0dX3QD9LgH7aAEatEW
MxuU29A+FeSGB0VOYa8/TQiXW8LB9zI3wz8V8BeDEzk2n3j/lxn5gmwsYn2I9mXR
KV57LbCgP+SbPGWH8pMXb9ZJriJPNI489uCGMIwiGpedRVhJyPQL//gExvy/k5cT
LioBuhMDsMFlpPvwLMslE3fLcG+fHLG2k6SYjMdHRH2WD/eSNhIsxHWHgEx0uSOb
2bchdNdHReyn43OblCAzymap0UgnUL0zMIwrooPCgz3d8FzfwOwwslOxBzfi5DAr
tjuTh1pToOZfTUh5uMGjtW2+PefGL6ke7BpJIrPJRZ7mIxhCizt1xfFx8ClXZmHp
XCvsV1BhYqL3JGc4TkwVQj30GUIVEAmFRxXLIg+2PLStXRXq4Fk4rgfZ1CTp9Awq
XNG5HLCdty1Dx+Mzac3Vfg/AU/d6UjP/1ObbeKPbs+viTJt7jQGarvbbXD9qPma/
SixfxlDQ7zeLu/pbOhLl8WOGn/H/xOetLJ6qB6TrCQAgGcxbffhMP1O72u0Z4/PP
B/FxEYD2Mnqp/AmIRS37W0pOoSNGEslibsigxcu4Q2UoW5CrdI7scugGSWwPYTtT
8VgrFH1vfvRMJac4qoRwf5l3GGeC56gKGUBufjdNbtshTgRHyGJO0vkW1u8VMnOt
ED9AsTUSOzPX1QXUKGId
=Z8X8
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Apr_2013_18_38_23_+1000_mMeZxy7mzoIfYt5x--
