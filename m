Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaKNHBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 02:01:06 -0500
Received: from ozlabs.org ([103.22.144.67]:44892 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbaKNHBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 02:01:03 -0500
Date: Fri, 14 Nov 2014 18:00:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the scsi tree with the usb tree
Message-ID: <20141114180054.77fbbc7b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RLU61p/c5uqQ3RrTNO04.PU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RLU61p/c5uqQ3RrTNO04.PU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the scsi tree got a conflict in
drivers/usb/storage/uas.c between commit e28e2f2f7c42 ("uas: Make uas
work with blk-mq") from the usb tree and commits 125c99bc8b6b ("scsi:
add new scsi-command flag for tagged commands"), abd0c533e377
("scsi: remove ordered_tag host template field") and 2ecb204d07ac
("scsi: always assign block layer tags if enabled") from the scsi tree.

I fixed it up (maybe, please check - see below) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/storage/uas.c
index 004ebc12bc21,33f211b56a42..000000000000
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@@ -806,7 -816,14 +805,7 @@@ static struct scsi_host_template uas_ho
  	.sg_tablesize =3D SG_NONE,
  	.cmd_per_lun =3D 1,	/* until we override it */
  	.skip_settle_delay =3D 1,
- 	.ordered_tag =3D 1,
 -
 -	/*
 -	 * The uas drivers expects tags not to be bigger than the maximum
 -	 * per-device queue depth, which is not true with the blk-mq tag
 -	 * allocator.
 -	 */
 -	.disable_blk_mq =3D true,
+ 	.use_blk_tags =3D 1,
  };
 =20
  #define UNUSUAL_DEV(id_vendor, id_product, bcdDeviceMin, bcdDeviceMax, \

--Sig_/RLU61p/c5uqQ3RrTNO04.PU
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUZaitAAoJEMDTa8Ir7ZwVfhAQAIXnmGYFDuRRNsA1By3WaWpW
coUAbNQd54Avb8EAh0IuPkVNeL1G+wVwZmBP03KWrV9onKvlYJ3UCWD+VFKEuwAX
jJL4GC2nHKRebH4CRVYIa1BFjjJ3wYILVozqIrhmkZ9nwD0VHtx7T6gfOxbXuSvX
DChYNYQ7Kvzh7X64nnAdcZr/zv+RCTeRVfbdHwwxrQ83fTORkLKC6aW1E5oym7gR
dzEHU4yPTYiF3tnbRy8pDrgtnTcEaju7dcNdWYzoCaoJPfk6DhrgW2ez6Do33bju
1Vnv9KkSyhi6/H0s/AD9C/kZOv1LB/yE4GPhfPHR6pnSgrlqKPfkiAQYTA5pfkL2
snMphZtZYRfz6dGCHccTLaIN3N3O5Mnk6N0K7TfPsmvuNUAx060E+H1VPO0skc5s
rX89UgPi1BSG7IJFCjjwVijdfdAKMe4AKUGU7XpM7fWUBI5epHjfyPgHPlZ4enMV
zsZuC9ouudVzTTwYlPjxL4Q/eqbs5A5hpUDAB4dnw2181ledYC3zuT4JXAgJ2AMn
j2N+0QfnUwcw1MVH1cm34VdZ8Ja9uaOTHacCkygi5q/iIQIx7ZwMSDv+L12vxMqb
wlsC5a90tqpYsyn6p757FvICfb3ulg22HFLB1l8FlOCsDdV0GkMcIzFzU5H/+nqa
bk9RYxKVXDid9Fxajx9x
=49dI
-----END PGP SIGNATURE-----

--Sig_/RLU61p/c5uqQ3RrTNO04.PU--
