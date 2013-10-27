Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab3J0Vuz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:50:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59340 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754338Ab3J0Vux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:50:53 -0400
Message-ID: <1382910645.2994.45.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Ben Hutchings <ben@decadent.org.uk>
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-rdma@vger.kernel.org
Date: Sun, 27 Oct 2013 21:50:45 +0000
In-Reply-To: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-i6e8HgC6/uJhDTKxHWUS"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i6e8HgC6/uJhDTKxHWUS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Physical addresses may be wider than virtual addresses (e.g. on i386
with PAE) and must not be formatted with %p.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
The resource could also be printed using '%pR' or '%pr', but that makes
a bigger change to the output.

Ben.

 drivers/infiniband/hw/cxgb4/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/c=
xgb4/device.c
index 33d2cc6..4a03385 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -602,10 +602,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
 	     rdev->lldi.vr->qp.size,
 	     rdev->lldi.vr->cq.start,
 	     rdev->lldi.vr->cq.size);
-	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
+	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
 	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
 	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
-	     (void *)(unsigned long)pci_resource_start(rdev->lldi.pdev, 2),
+	     (u64)pci_resource_start(rdev->lldi.pdev, 2),
 	     rdev->lldi.db_reg,
 	     rdev->lldi.gts_reg,
 	     rdev->qpshift, rdev->qpmask,


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-i6e8HgC6/uJhDTKxHWUS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2Ktee/yOyVhhEJAQoZmQ//Ul0hZhPFiii98nH641LDoSmUquR0xPJv
pCWiLD63G3X+SFUuPRi8ydNyqRoGNKLS17w7DxrAr9E7X+52tXldFVUgyOAsY1we
1sVyY2j3gRG00nHaVcIGQZZs/IA+zflCIbfAltT0db20OqroNDUewlLNsayTmzJn
zfIkzdZcIBxbEGN7wdJ560+G24CmM5/6mqvnLNEhx1mzZut+GVk6ri5uP22iC9FI
2YMGz28O7lf37Rm1so7HyiGCF3HnhMNUOgjHvu0eSm2B7x9xIZiJUGQfzbCb0fMQ
3/qjI+wwpsV+V2uTmDueEjfiCJZy6msxZTRiVbUPCqSPSQeGyorVSUQ29uh13c0H
DwnVMcbguPjxxQQha1Jc8COXsxrkhNxWctge5KNpngAapblUeEohg3arc0Ftmf2P
b+5OmTKAuWwtRLz07+T5h+UsV9+TTYY2K4ZrK24gPRKOzY4Wc7bUpta5NaNHOscI
1Zm6UrbFY41DYBkI9/nmm+hFWPy1dlJ3+7CAyEjmshUKuNtG/uRF6sUVvKvRPBUV
h0poUPSSWBRDczfTnyEgVqlCpON+mTSA4CLIBrOhno/oEeLkRHSBxUP29T+2I2Vs
AZn12bgoWx0UYX68FF2zbEnFkJxx2JU+YegPTRl38g6zuq7qrd7Nr8ge3DL/Jfc9
+gxv5+ynjuY=
=mDnF
-----END PGP SIGNATURE-----

--=-i6e8HgC6/uJhDTKxHWUS--
