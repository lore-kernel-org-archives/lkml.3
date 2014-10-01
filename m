Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaJADOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 23:14:33 -0400
Received: from ozlabs.org ([103.22.144.67]:53449 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbaJADOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 23:14:32 -0400
Date: Wed, 1 Oct 2014 13:14:21 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: linux-next: manual merge of the vfio tree with the pci tree
Message-ID: <20141001131421.64cab8d7@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/R6xja8/XDl+3OX_S3xS3fFJ"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/R6xja8/XDl+3OX_S3xS3fFJ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Alex,

Today's linux-next merge of the vfio tree got a conflict in
drivers/pci/msi.c between commits a160fe94cb53 ("PCI/MSI: Remove unused
get_cached_msi_msg()") and 18ef822c59f6 ("PCI/MSI: Rename
__get_cached_msi_msg() to get_cached_msi_msg()") from the pci tree and
commit 3b307ffe3faa ("PCI: Export MSI message relevant functions") from
the vfio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).  And then I added this merge fix patch (I should probably
also have added an include of linux/irq.h):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 1 Oct 2014 13:09:58 +1000
Subject: [PATCH] vfio: update for get_cached_msi_msg API change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/vfio/pci/vfio_pci_intrs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_=
intrs.c
index 553212f037c3..a068bb0d69e5 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -559,7 +559,7 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_d=
evice *vdev,
 	if (msix) {
 		struct msi_msg msg;
=20
-		get_cached_msi_msg(irq, &msg);
+		get_cached_msi_msg(irq_get_msi_desc(irq), &msg);
 		write_msi_msg(irq, &msg);
 	}
=20
--=20
2.1.1


Someone needs to remember to send this fix to Linus when these 2 trees
are merged into his tree ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/pci/msi.c
index d077749df25b,e468d65eb238..000000000000
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@@ -288,6 -305,14 +288,7 @@@ void get_cached_msi_msg(struct msi_des
 =20
  	*msg =3D entry->msg;
  }
 -
 -void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
 -{
 -	struct msi_desc *entry =3D irq_get_msi_desc(irq);
 -
 -	__get_cached_msi_msg(entry, msg);
 -}
+ EXPORT_SYMBOL_GPL(get_cached_msi_msg);
 =20
  void __write_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
  {

--Sig_/R6xja8/XDl+3OX_S3xS3fFJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUK3GVAAoJEMDTa8Ir7ZwV7b8QAI9ZgnIv/X9KNo8RGn5CONJu
qWMAuGbfXtXdXM8QymrtjELB9Qx5+Hk7sgUg2aOEIeN/r/AB4/2Mb762pzyiWybD
1igGzwgTGZjNwT3s7hycj8wGFRdcsvI1dfzkYvIdpx1vhG5N9po7Nm05mFln1AeM
MSTvCOdEiEnYAVPa020xgLZuaQgijv5F69H7iJHrn38x9DWU8RguKvCs7l7J0KmO
MgM86Ut8qEWsBPuMoEklTIX3NYmH5hsaG2fK/flu7Yd7NIiO6j7unoDWOqnL/NH6
LM8taEJ0rZecfL+M0zpWQb07roITTfaSyZbX0nIsJL9KOXPSA69u89u+TUYVcOmb
a+rF836xmltOYQkJY7lIz2iL3VnGBVB+yOTdDa9vfFBM1zrjBZ5J902yKiemRkkz
miFCN4Y6PusJe/behoQWMID508NnPaG8e3eONe8rWQ4wi/7+ZZzO/lW+KNo4ivZE
a3rC8aFWFGW66b6uPdMeL99QNapwHdRJJWcMth6vZe2i/BtwFvytrOw1oUYSD2hn
UZrd7I2Tmyi5Hy2RupYs5J3NGKhtevEgIT4P9BRQ6CLtNcf3laC0zJxhWKFtZFrv
FcSVUOD+hIx+rx/NbNkoj8MTCXOnmRjps0KTQPcSwbDAg4Jz/YvS/IjtNYLM6yqp
8uqYnjLjbEa+z2jNrR0C
=6koS
-----END PGP SIGNATURE-----

--Sig_/R6xja8/XDl+3OX_S3xS3fFJ--
