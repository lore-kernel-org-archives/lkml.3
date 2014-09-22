Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaIVDcN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:32:13 -0400
Received: from ozlabs.org ([103.22.144.67]:35076 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbaIVDcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:32:12 -0400
Date: Mon, 22 Sep 2014 13:31:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Tkhai <ktkhai@parallels.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the tip tree with the nfs tree
Message-ID: <20140922133156.454481f9@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HWJk7xCnoYb9+7N5y_CCi.Z"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HWJk7xCnoYb9+7N5y_CCi.Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got conflicts in
fs/nfs/blocklayout/blocklayoutdev.c and
fs/nfs/blocklayout/blocklayoutdm.c between commit 871760ce97a9
("pnfs/blocklayout: move all rpc_pipefs related code into a single
file") from the nfs tree and commit f139caf2e897 ("sched, cleanup,
treewide: Remove set_current_state(TASK_RUNNING) after schedule()")
from the tip tree.

I fixed it up (the former move the code in these two files into
fs/nfs/blocklayout/rpc_pipefs.c, so I deleted the 2 files and applied
the following merge fix patch) and can carry the fix as necessary (no
action is required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 22 Sep 2014 13:29:19 +1000
Subject: [PATCH] pnfs: merge fixup for sched cleanup of set_current_state(T=
ASK_RUNNING)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/nfs/blocklayout/rpc_pipefs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/nfs/blocklayout/rpc_pipefs.c b/fs/nfs/blocklayout/rpc_pipef=
s.c
index 8d04bda2bd2e..e966c023b1b7 100644
--- a/fs/nfs/blocklayout/rpc_pipefs.c
+++ b/fs/nfs/blocklayout/rpc_pipefs.c
@@ -92,7 +92,6 @@ bl_resolve_deviceid(struct nfs_server *server, struct pnf=
s_block_volume *b,
=20
 	set_current_state(TASK_UNINTERRUPTIBLE);
 	schedule();
-	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&nn->bl_wq, &wq);
=20
 	if (reply->status !=3D BL_DEVICE_REQUEST_PROC) {
--=20
2.1.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/HWJk7xCnoYb9+7N5y_CCi.Z
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUH5g5AAoJEMDTa8Ir7ZwV1ZYP/jLxnkdNkLjKTR3qA1O1sPG1
eNVBylzFpffeengF2g8XPh5Ngbbx36zWBWRa+dYi4+4e7vPXjCXqAkfPv+RR0sEO
CRzORljgpYnEv5P76Y43tz4gUYrcDLH2mOCqMK3qpQyn48DZiq751DbzKMjS68VZ
TJN7M2rBySZ/Z720pu3nQcgprJNYJ4emlAqlKhz2v7OeWlxbbT5HesPeufWKOcPD
IA01/iQayCDAtS9zpJrXgukpE0URwchDDV4eEQAkK6jcoBOe37P5kTDrliRq5hI+
+CA2dUdNNZbGuuke57VB6T2PL9FQaLL3xcEXiDoG/anztaMlcoDQ7OWsj63/EWt3
m5XiJkdQw4gyqhS3viyPLJeRWYOzBkZVj+q2DIdZybOywfAgoCANYox7WLdlW4Ut
SyOEAjlkRAdkzb27+6jssEOzIQeh0VN1rDQbJJZajv5u4xjyReXOGxhfxmk3h/iJ
xBFfGauOIfJqUUJU1hmbWNvxRSz6cCVWY3wTPh8Bd32lOIhfGmlEMvvzbdvxijgd
KOPJvKw9Qv2RpeJpa+qbaBjojjbrAGnpLuSeRIjLx3Wd8fPxRjVfwF/W8OU5VXIO
gWogxWrlopuwsfbLYKrG97LtPyYo3aoLL2Lwb+Fc5hhDiWpQJ7y+FvcoPPd9MlYG
mDiCx+zkjWPDUMFgkW5x
=Vws5
-----END PGP SIGNATURE-----

--Sig_/HWJk7xCnoYb9+7N5y_CCi.Z--
