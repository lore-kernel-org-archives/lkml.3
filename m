Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751182AbaFJEM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 00:12:27 -0400
Received: from ozlabs.org ([103.22.144.67]:48816 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbaFJEM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 00:12:26 -0400
Date: Tue, 10 Jun 2014 14:12:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the vhost tree
Message-ID: <20140610141217.50d98cd6@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.hS.3A+/XSbx.Xakvqxg/.E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.hS.3A+/XSbx.Xakvqxg/.E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michael,

After merging the vhost tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/vhost/scsi.c: In function 'vhost_scsi_handle_vq':
drivers/vhost/scsi.c:1043:14: error: 'struct vhost_dev' has no member named=
 'acked_features'
   if (vs->dev.acked_features & VIRTIO_SCSI_F_T10_PI) {
              ^

Commit 95e7c4341b8e ("vhost/scsi: Enable T10 PI IOV -> SGL memory
mapping") from the target-updates tree interacting with commit
10350a292160 ("vhost: move acked_features to VQs") from the vhost tree.

I applied the following patch which seems right, but may not be.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 10 Jun 2014 14:08:21 +1000
Subject: [PATCH] vhost/scsi: fixup for acked_features move

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/vhost/scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 78ff1f64d759..6d7dd85365fe 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1040,7 +1040,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vh=
ost_virtqueue *vq)
 			break;
 		}
=20
-		if (vs->dev.acked_features & VIRTIO_SCSI_F_T10_PI) {
+		if (vhost_has_feature(vq, VIRTIO_SCSI_F_T10_PI)) {
 			req =3D &v_req_pi;
 			lunp =3D &v_req_pi.lun[0];
 			target =3D &v_req_pi.lun[1];
--=20
2.0.0

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.hS.3A+/XSbx.Xakvqxg/.E
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTloWmAAoJEMDTa8Ir7ZwVLc4P/igiMC6kuh5J/9PkwkPeZDG8
h9zpH/ZaYcCaM9+Jnj6VMvfde5muAUd03BWSowjfsorc7Lfz7ByX1SReiESNyNvp
Rg6cjVFR/LkJ9UFEReKxMb+BPNa49Cf5oVA/4rxPUf6FRFBl/jgz1zNMCZwDhQuZ
Q4OeqDIWs9HqjuUhfwded0dR/86OsYez5EIO7o7BnIx49crG47fMild639P6ERGj
pFeVFWLeH+iLFf+DPUstpSx2CmTF0DyUM0Tn2lD5Zkqvd1QJbRZ7Cju2MzErOpZe
cEWNbuAHci6Lj7G1NNPM86VKsXOVxjcyW9MCbOwI4H48fs+tTF2C1nYXW9imeEiB
mEp96t8Y1LLEp5oRFcQTrxngkNxZvQCcTyUAtfYGbM9E3cGA9IgCsi7ArOO2N62p
9KrU2S1Sl0OEJZZ1CkBT85RLjrj/Hk8lDdWlRYPGjLBhysQ1nI0qxqTUvIcFCi0k
Ph9DYYwbWhy0IR7Fy4/SWB64/J7Ab4SRd/vSvjAogic5UEJ+iTluWZgZUObhxgeY
YSV1SIxmLcVBCmP5dIK4TavghsepLj4rzdHLecluSJdJhcVOJQ1stzq/hAclgjxy
WGsRzEA+61NfEzsxauahH0zWZYPxkDMO6+biASEOeKSEcr2mkphb6LzrYJF53bzj
2vLpQoD4qozM0GwLOVnu
=mwWR
-----END PGP SIGNATURE-----

--Sig_/.hS.3A+/XSbx.Xakvqxg/.E--
