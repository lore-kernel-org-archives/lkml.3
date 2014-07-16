Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933488AbaGPDx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:53:29 -0400
Received: from ozlabs.org ([103.22.144.67]:58166 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbaGPDx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:53:27 -0400
Date: Wed, 16 Jul 2014 13:53:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hariprasad Shenai <hariprasad@chelsio.com>,
        Steve Wise <swise@opengridcomputing.com>
Subject: linux-next: manual merge of the infiniband tree with the net-next
 tree
Message-ID: <20140716135320.4011c6c8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/vgw9m8+VmK4jRFpS8g.bNdB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/vgw9m8+VmK4jRFpS8g.bNdB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the infiniband tree got a conflict in
drivers/infiniband/hw/cxgb4/device.c between commit 7730b4c7e32c
("cxgb4/iw_cxgb4: work request logging feature") from the net-next tree
and commit 6b54d54dea82 ("RDMA/cxgb4: Initialize the device status
page") from the infiniband tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/infiniband/hw/cxgb4/device.c
index df1f1b52c7ec,7db82b24302b..000000000000
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@@ -843,16 -696,7 +843,17 @@@ static int c4iw_rdev_open(struct c4iw_r
  		pr_err(MOD "error allocating status page\n");
  		goto err4;
  	}
 +	if (c4iw_wr_log) {
 +		rdev->wr_log =3D kzalloc((1 << c4iw_wr_log_size_order) *
 +				       sizeof(*rdev->wr_log), GFP_KERNEL);
 +		if (rdev->wr_log) {
 +			rdev->wr_log_size =3D 1 << c4iw_wr_log_size_order;
 +			atomic_set(&rdev->wr_log_idx, 0);
 +		} else {
 +			pr_err(MOD "error allocating wr_log. Logging disabled\n");
 +		}
 +	}
+ 	rdev->status_page->db_off =3D 0;
  	return 0;
  err4:
  	c4iw_rqtpool_destroy(rdev);

--Sig_/vgw9m8+VmK4jRFpS8g.bNdB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxfc0AAoJEMDTa8Ir7ZwVFzMP/izJ3B4E7kKLRfXjJn+3HGjF
wnWQpY+8zzHXeiT1Y/8AZSC5c1Dxy2FAPE9WrLHOX+2l43tz3py/pGG8zbyIaXqb
uIr6SSkoAJ0zoWYma891tIrVVzABvwgYBhPbKgt/kxLFh9IlexIrSbS/+OuYmRs5
5kOyBJa7Wn2IwjH2WqcxFiquZtvohIWtD5Yu43VBBbQnPmfn3ywDK/VZuTtAIv3r
TPXzb4BrWOcxJxN8hMHKyKB1/qBNp5Fl2EzB6fWKKY9lfogCpYUuVzH3PINei1yW
Wd295ZaqfrlEiCPjqIJ3BTdpfecft4lcdPJBcOPcYK24BTCdIexT91jiGBlo75lb
sL3Qnyj3MbYf51fM2RAj0GX+beE2l6XhxgKb3RyqIvHkcGHE+EHeX9NFmBUfdr3z
1vvXe5eCgRB5Gk4qjgUDeTkULd97niAABmESUAHRLbwpnsM2fxFCyQvnIDGGJYJo
5p5xRnWCU55VjdR8aZQyXLNZFS7WlzRiQfO5AotqJGdQzjn5WZbfFMNmtOYgR2tY
NJCeQaBfEga2IoQM9cWNjzVs2uY6utpGzVn6JQRMXVHyr0k5fQmMhZgW2h09lXVz
SepUmmAQNW3FpMoR5p4QN0a1i3X60JCig0KcEv3jE186XdAdEhzKPAzE/ay4hem+
WYgpBOi+UG7qkp9K6yZW
=HbYj
-----END PGP SIGNATURE-----

--Sig_/vgw9m8+VmK4jRFpS8g.bNdB--
