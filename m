Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbbA0EDm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 23:03:42 -0500
Received: from ozlabs.org ([103.22.144.67]:54852 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757926AbbA0EDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 23:03:39 -0500
Date: Tue, 27 Jan 2015 15:03:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shaohua Li <shli@fb.com>, Dan Williams <dan.j.williams@intel.com>,
        Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-ID: <20150127150332.64d614da@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XQJwcs.KCeg6e3Ull1r8MF3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XQJwcs.KCeg6e3Ull1r8MF3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/ata/libata-core.c between commit 72dd299d5039 ("libata: allow
sata_sil24 to opt-out of tag ordered submission") from Linus' tree and
commit 98bd4be1ba95 ("libata: move sas ata tag allocation to
libata-scsi.c") from the block tree.

I fixed it up (I used the version from the block tree and then added
the following patch) and can carry the fix as necessary (no action is
required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 27 Jan 2015 14:59:51 +1100
Subject: [PATCH] libata: fix for move of sas tag allocation code

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/ata/libata-scsi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index fd9be1756f0d..055e75d2176e 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -4240,7 +4240,10 @@ int ata_sas_allocate_tag(struct ata_port *ap)
 	unsigned int i, tag;
=20
 	for (i =3D 0, tag =3D ap->sas_last_tag + 1; i < max_queue; i++, tag++) {
-		tag =3D tag < max_queue ? tag : 0;
+		if (ap->flags & ATA_FLAG_LOWTAG)
+			tag =3D i;
+		else
+			tag =3D tag < max_queue ? tag : 0;
=20
 		/* the last tag is reserved for internal command. */
 		if (tag =3D=3D ATA_TAG_INTERNAL)
--=20
2.1.4

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XQJwcs.KCeg6e3Ull1r8MF3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxw4ZAAoJEMDTa8Ir7ZwVYjgQAIldHKHuOcmjxId42fG1E59j
iLpNP5ie2niIoaUrlpKQ7xaiAxQc18etOSkt6m8L8UowSCiYW4/h6d0qvhmNX+sW
5ZtSmM4D4dRtWBuoLGpn1bD8VhGv8+5vuYVJ5n1BFVYQZpc2T8jyD58QzQAMPYfq
u0A/JK2GQWxWCG4DbQygO6kSGGLAEktL7s39p8YOZXBeTFElj5G4/8x/dFfEYfZw
qnIqSKyHMLA8xrn/T+31k9IyfuBe6xWkttppFHdmG3oehtvY8yNe2SRUw7byLVWi
P61K9/T3ag9sIhzQW6nQKJcQUWwAZ3tLzKMXlnREqlIP/KK5+LIrqAjFk5JGgkRz
zUNZuVNZbUM8PkTGvLsrNk7MRUFFUoimSmLef3PmvOxI6TbNXkIr5iFcgvwrH8SR
UDZ4ju4XMxsz2iOP7BWsg4mKOndaPB+RIKSWzfcmkhYVSOH+MpspxruFRd8QEMt9
zuNS2y39baszQC4Sy4QpKfGM1PxI4Uh7iZqfXMLmfokVDVMBKOsYWYdqHsl/1Ihz
9rK7zocWCkqwgEgg+FtuOzuxwRniqiqPdqcicCqDQPz085V8aedOkIe5raYY12P3
8FFr7evg11Fw2xNK7tGIQ/hlu/oz76y0RGtrQnsa/VZddfnjHvkReJMcvl4scm8a
jaDdEGYiOdpUAqOp6vEi
=MMMN
-----END PGP SIGNATURE-----

--Sig_/XQJwcs.KCeg6e3Ull1r8MF3--
