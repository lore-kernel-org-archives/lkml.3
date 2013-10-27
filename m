Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab3J0Vr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:47:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59326 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754236Ab3J0VrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:47:25 -0400
Message-ID: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 0/8] Fix minor address type errors
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com
Date: Sun, 27 Oct 2013 21:47:17 +0000
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aenbMtIN47UiBrAVHmxj"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aenbMtIN47UiBrAVHmxj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Various bits of code are mixing making assumptions about the size of
dma_addr_t or resource_size_t, or mixing up pointer and integer types.

All these fixes are based on compiler warnings and so far as I can see
the bugs are practically harmless.

Ben.

Ben Hutchings (8):
  IB/cxgb4: Fix formatting of physical address
  farsync: Fix confusion about DMA address and buffer offset types
  drm: Do not include page offset in argument to virt_to_page()
  drm: Pass pointers to virt_to_page()
  [SCSI] tgt: Pass pointers to virt_to_page(), not integers
  uio: Pass pointers to virt_to_page(), not integers
  rds: Pass pointers to virt_to_page(), not integers
  [SCSI] pmcraid: Pass pointers to access_ok(), not integers

 drivers/gpu/drm/drm_pci.c            |  4 ++--
 drivers/gpu/drm/drm_vm.c             |  2 +-
 drivers/infiniband/hw/cxgb4/device.c |  4 ++--
 drivers/net/wan/farsync.c            | 19 +++++++------------
 drivers/scsi/pmcraid.c               |  3 ++-
 drivers/scsi/scsi_tgt_if.c           |  2 +-
 drivers/uio/uio.c                    |  6 ++++--
 net/rds/message.c                    |  2 +-
 8 files changed, 20 insertions(+), 22 deletions(-)


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-aenbMtIN47UiBrAVHmxj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2J5ee/yOyVhhEJAQqGvA/9GzMeGBFRDv9lMX/TsSlwFqMeODg9ZXbI
MMWTYKi+h5aiKrniDjtSKb7ilx0nVNnR8BEFCQcZBr4DOd+97kMEbxrZZTBKE1F6
Nhy419nEivQcWzmVAw4q6uqQ+ozfVz5XX/bqOUvdYZtSBLkw3py6DyCnWnLHsr8Y
QQqF9bDaa8cJWeN59moFUduSKDUHSHSgJFMNF6j1oB0n3BdaVzuqVmwNCwLG/AXk
Zly1V6lvKj1QPzgDO3P3RDEVrOaOx6GKfuoVqj5gbqNAw1nXlnqg5myRYC7FqNnN
EKta5bUHgkwpS867jaIMalnjVXIDgf0p2TgfgsxCgTdF6F4hirL6DZaLjIHxK7OO
Hr22hkX64W/CppwP5653sjO2xuPwcqiVlHZdVRhhYckRldRaEaB63mwkIdRsRolW
i8OrbYGZvUTXJ2gcCgxoYNMXYAO+EFAK4YVEM4vc7CSzi018Zz0TEapi+4abNdWp
ckUzC8+P5uk1fBTGziOdH+derBwDo6GS9qscdIrXCbkA4zKMn+JaKynTmncFNtGn
0uKVD/TW3ds2+tUlbuwlikWrLk7rTU+8186+K0q3xcaArPt3uLnlqSsrq6Th1r9D
zsbWvsZAvs7yWsa+sUOla25T++Z2/o+k6IQYKNmhAWVqWVJuAF0OZ1YK5yu0NWq0
9/1fnbEoDMw=
=ZTmh
-----END PGP SIGNATURE-----

--=-aenbMtIN47UiBrAVHmxj--
