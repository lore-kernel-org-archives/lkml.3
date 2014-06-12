Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbaFLDhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:37:19 -0400
Received: from ozlabs.org ([103.22.144.67]:54789 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752751AbaFLDhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:37:17 -0400
Date: Thu, 12 Jun 2014 13:37:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the virtio tree with Linus' tree
Message-ID: <20140612133702.58473968@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/VdeWwv33SraHT5b2Nmpwe8A"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/VdeWwv33SraHT5b2Nmpwe8A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the virtio tree got a conflict in
drivers/scsi/virtio_scsi.c between commit b54197c43db8 ("virtio_scsi:
use cmd_size") from Linus' tree and commit c77fba9ab058 ("virtio_scsi:
don't call virtqueue_add_sgs(... GFP_NOIO) holding spinlock") from the
virtio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/virtio_scsi.c
index d4727b339474,e2a68aece3da..000000000000
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@@ -484,10 -529,13 +483,9 @@@ static int virtscsi_queuecommand(struc
  	memcpy(cmd->req.cmd.cdb, sc->cmnd, sc->cmd_len);
 =20
  	if (virtscsi_kick_cmd(req_vq, cmd,
- 			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
- 			      GFP_ATOMIC) !=3D 0)
 -			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd) =3D=3D 0)
 -		ret =3D 0;
 -	else
 -		mempool_free(cmd, virtscsi_cmd_pool);
 -
 -out:
 -	return ret;
++			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd) !=3D 0)
 +		return SCSI_MLQUEUE_HOST_BUSY;
 +	return 0;
  }
 =20
  static int virtscsi_queuecommand_single(struct Scsi_Host *sh,

--Sig_/VdeWwv33SraHT5b2Nmpwe8A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTmSBlAAoJEMDTa8Ir7ZwVK+AP/RQTgdjYD/OwuMekjpQFS+Zl
K9B8E/6qxWdbnTf8nHFf9aYGrlMAKUjGH4ml+f/Ew4i3CCip7U9djL828ld6dL0J
bAUo6RW1AWormdkLTdtVln1qXpp1pxGNKezMkWyG0YTW3PFPVy+nFkXihruNQA5u
U5t/129smpfoFExHC5wi1gfodPIXC9jS/Th18MzmHYoR8Zpv1lS9kYkzT/neZ54R
g7zMODAEh4vpMBpYr2eyxYHf00S+FUP0bgmAd58s0crBxPF2gmav5cV6TcJ4Wm/+
/7n7PsF7FiNTyH0pgY+Qobfh1n40/Tsvhs+6B/NCPVuo1GHJODLXZRPTGWeyU9JK
546pdPzxmznGm1sXjL/H0L8/5qI0aG8XHCPGCK7VmZUkVVQ9hkqInKd732jFhX+4
7w9YVm/PGwnsFCXNaXkTJTDmJ1xLpCvxmTSIqSZ7jd487RRlG3gks48LS3VQ78nF
zJK1SieDq3XQft4mOxIhYbRaKBNk3D1n/xOw4U/YNspzoK8CVQwutOGzYCNp0KV/
hhvTXMjRA7kOv5gatnDIcvWtIBx+bacool7m7BDzZTe16YwLNLpHiMGJcfMEfFx7
TyYb3TyxlcwiTDYsh7l3i+fazhXwym/WQ6LDjiovfoiIe5gIiElbnklgV7eZ9BYL
CJiSsgGd4fdSDWpa33DJ
=Od6E
-----END PGP SIGNATURE-----

--Sig_/VdeWwv33SraHT5b2Nmpwe8A--
