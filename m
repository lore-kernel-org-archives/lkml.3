Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaHDHTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:19:16 -0400
Received: from ozlabs.org ([103.22.144.67]:45218 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbaHDHTO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:19:14 -0400
Date: Mon, 4 Aug 2014 17:19:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weston Andros Adamson <dros@primarydata.com>,
        NeilBrown <neilb@suse.de>
Subject: linux-next: manual merge of the tip tree with the nfs tree
Message-ID: <20140804171906.2c2b4470@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/jo/HQGV9uQXJiyc2xyjFfMl"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jo/HQGV9uQXJiyc2xyjFfMl
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
fs/nfs/pagelist.c between commit e7029206ff43 ("nfs: check
wait_on_bit_lock err in page_group_lock") from the nfs tree and commit
743162013d40 ("sched: Remove proliferation of wait_on_bit() action
functions") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/nfs/pagelist.c
index 9425118e91d7,0be5050638f7..000000000000
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@@ -158,14 -149,8 +152,13 @@@ nfs_page_group_lock(struct nfs_page *re
 =20
  	WARN_ON_ONCE(head !=3D head->wb_head);
 =20
 -	wait_on_bit_lock(&head->wb_flags, PG_HEADLOCK,
 +	do {
 +		ret =3D wait_on_bit_lock(&head->wb_flags, PG_HEADLOCK,
- 			nfs_wait_bit_uninterruptible,
  			TASK_UNINTERRUPTIBLE);
 +	} while (wait && ret !=3D 0);
 +
 +	WARN_ON_ONCE(ret > 0);
 +	return ret;
  }
 =20
  /*

--Sig_/jo/HQGV9uQXJiyc2xyjFfMl
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT3zPvAAoJEMDTa8Ir7ZwVucoP+wWii1fEHNL0NxlIsbH/G46l
CB2/9JoMY0ohjXgDmLHeUttXj1ZclvkRO8NWFpEdEhg0kb46d2e5TN/yhOdFudWv
sNnzlsxbp8n3M/EAZ0WHNNfuZY1kLIP4Vt+dML7BHceiyvj4U7x6A196/qLUa9sq
gKBeTFxZj8ziGkHAGujnP3qXa04L5clZxb4/YfD1uIxAZAQOJme6wjj4i/kC55P6
1GZrVRo1SdZQs5FyYPdQAzCviSWyScPjJA0QwXfidlIEdlYIdfU3QR6CaoCJ3C7A
TbRrQMAJI0faFyhxhlsXJhNW0qnWoXhAqzI2z14r0jZChhUMuSE6k5ASIWR+60dg
Vi13W1Bnw7WRl/vP31p0r7Z8R8DGR218qIxDA6nKUo3SNjR2MGebnW23fqhJP65S
4ukc01nJyY2jCYHi98E7iWUg3RD/iKT8zwOMdFDoshhexRiQ+S1ZqpQzqbtEZ4MM
lc+HEGUXgNeX0mEoVfHaFQ5LM/vEC/uL59Hh/eXvnLS0LE5BChngq/Z1NJOEbbTB
DdViIGhQMdedRXmhFEpPiSR4bnE9EiogEijLCfQtQBOE7ZNJQS7FTNHOfedyRIZk
JogBpJV853ZKKmUPQf7RShUaaoLDR1WVGIOW9svTaSUR2bwRsq+IvVuqHQ2SzvMX
oV1PlW7+FV/TRa0q74bQ
=qYhd
-----END PGP SIGNATURE-----

--Sig_/jo/HQGV9uQXJiyc2xyjFfMl--
