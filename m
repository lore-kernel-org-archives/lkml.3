Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3H0Hna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 03:43:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37482 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab3H0Hn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 03:43:29 -0400
Date: Tue, 27 Aug 2013 17:43:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Shlomo Pongratz <shlomop@mellanox.com>,
        Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org
Subject: linux-next: manual merge of the scsi tree with the infiniband tree
Message-Id: <20130827174317.10e4f4b7a244f2bf640a9b59@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_17_43_17_+1000_Yr5m4xcjOCaPAzWS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_17_43_17_+1000_Yr5m4xcjOCaPAzWS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
drivers/infiniband/ulp/iser/iser_initiator.c between commit b7f04513090c
("IB/iser: Accept session->cmds_max from user space") from the infiniband
tree and commit 6a06a4b8cff8 ("[SCSI] IB/iser: Add Discovery support")
from the scsi tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/ulp/iser/iser_initiator.c
index bdc38f4,b31fa1d..0000000
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@@ -342,10 -249,15 +343,16 @@@ static int iser_post_rx_bufs(struct isc
  	WARN_ON(iser_conn->ib_conn->post_recv_buf_count !=3D 1);
  	WARN_ON(atomic_read(&iser_conn->ib_conn->post_send_buf_count) !=3D 0);
 =20
- 	iser_dbg("Initially post: %d\n", iser_conn->ib_conn->min_posted_rx);
+ 	if (session->discovery_sess) {
+ 		iser_info("Discovery session, re-using login RX buffer\n");
+ 		return 0;
+ 	} else
+ 		iser_info("Normal session, posting batch of RX %d buffers\n",
 -			  ISER_MIN_POSTED_RX);
++			  iser_conn->ib_conn->min_posted_rx);
+=20
  	/* Initial post receive buffers */
 -	if (iser_post_recvm(iser_conn->ib_conn, ISER_MIN_POSTED_RX))
 +	if (iser_post_recvm(iser_conn->ib_conn,
 +			    iser_conn->ib_conn->min_posted_rx))
  		return -ENOMEM;
 =20
  	return 0;

--Signature=_Tue__27_Aug_2013_17_43_17_+1000_Yr5m4xcjOCaPAzWS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHFiaAAoJEECxmPOUX5FE8wIP/3p66oVR07GoiJ/SOQ6MHjd8
KsDEm88hO7BS8ERBW66QpW0jqSYJzFCzf8KSRA7pJ/ky88iNnpkkHzNZrqSyZdpF
DOFR/FaBYdVm1xRD/TdizviZt5qMRRcdMLPlfXPKLgzWhaMeokz2FfgjOfg66nU3
eDSaaRmg+YlnDWYmBKxRfpOgmocPa7g+dgpB0HdLvf56oHCh0jUyO10gIuC5ik3m
2+MMTnS954z1N4BP8gLdS5nPzTmTbCJbamPnP0QfLF+W4Ao89Ueiu71UvdkyoIwM
yLBDMdGtycqHxMC+PDLgWE5ZGHAeKuykaV818bXgbmf3vZ1VPNu9AayHd6L7ouDh
HMXEys7gOlhTc3Z8HhMqM5sU81fhaWhMKY/7RgpIjDkImaE6jUF0wHwoURFQJADv
Kr5h60bH6h6tm0yEDnyrDO/indnWNBg9RH3KwF7/LqlHhj8lyfnzMjUv0icZ4Svq
HO89hH4zVCCCcExNyRvZIq17RLiTvraBtZ5vX7iVqEKt6XT6wNtFn3WI+AVP9v5Q
JHtSfXE5494immJKeBwwridqqA1O/FjTS0rX9nQITTHFRcbd5Ky7KT2BraLK3rlG
/lRtWgNdmUd289JkjTvrMeEvrFEp5Q91vL/dCAVqli2aUoahDuVUUd+Z4wIJ1kMr
J2WtVevaC0Y75iVojFab
=uio2
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_17_43_17_+1000_Yr5m4xcjOCaPAzWS--
