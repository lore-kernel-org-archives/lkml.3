Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058AbaLNXSV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 18:18:21 -0500
Received: from ozlabs.org ([103.22.144.67]:45451 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaLNXSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 18:18:09 -0500
Date: Mon, 15 Dec 2014 10:17:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@lst.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB driver patches for 3.19-rc1
Message-ID: <20141215101754.31e2ae56@canb.auug.org.au>
In-Reply-To: <CA+55aFx4V9urJ=_Ai0-zuQmQvzpz-t250bgDZBEDhWUbfe3oBQ@mail.gmail.com>
References: <20141214223523.GA3802@kroah.com>
	<CA+55aFx4V9urJ=_Ai0-zuQmQvzpz-t250bgDZBEDhWUbfe3oBQ@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Ss5UMrkMWuR2zZKS6IXdLbS"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ss5UMrkMWuR2zZKS6IXdLbS
Content-Type: multipart/mixed; boundary="MP_/b3TjX=+Y9T8858GCZXolPPT"

--MP_/b3TjX=+Y9T8858GCZXolPPT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Linus,

On Sun, 14 Dec 2014 15:06:07 -0800 Linus Torvalds <torvalds@linux-foundatio=
n.org> wrote:
>
> On Sun, Dec 14, 2014 at 2:35 PM, Greg KH <gregkh@linuxfoundation.org> wro=
te:
> >
> > Hans de Goede (1):
> >       uas: Make uas work with blk-mq
>=20
> So I got some fairly trivial conflicts on this one (conflicting with
> the scsi cleanups mainly by Christoph Hellwig.
>=20
> I resolved the conflict easily, and it all *looks* fine, but quite
> frankly, I'd be a lot happier about it if somebody who has the
> hardware were to actually test the end result.   The whole interaction
> with ".use_blk_tags" etc should be verified by somebody who knows the
> code.
>=20
> Hans? Christoph?

Attached is the message I sent about this on Nov 24 to which I received
no response and so assumed it was ok ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--MP_/b3TjX=+Y9T8858GCZXolPPT
Content-Type: message/rfc822
Content-Transfer-Encoding: binary
Content-Disposition: inline

AF: 
NF: 0
PS: 10
SRH: 1
SFN: 
DSR: 
MID: 
CFG: 
PT: 0
S: sfr@canb.auug.org.au
RQ: 
SSV: ozlabs.org
NSV: 
SSH: 
R: <James.Bottomley@HansenPartnership.com>,<linux-next@vger.kernel.org>,<linux-kernel@vger.kernel.org>,<hdegoede@redhat.com>,<greg@kroah.com>,<hch@lst.de>
MAID: 2
X-Claws-Privacy-System: pgpmime
X-Claws-Sign: 1
SCF: #imap/ozlabs.org/Sent
X-Claws-Auto-Wrapping: 0
X-Claws-Auto-Indent: 0
X-Claws-End-Special-Headers: 1
Date: Fri, 14 Nov 2014 18:00:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH
 <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Hans de Goede
 <hdegoede@redhat.com>, Christoph Hellwig <hch@lst.de>
Subject: linux-next: manual merge of the scsi tree with the usb tree
Message-ID: <20141114180054.77fbbc7b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/RLU61p/c5uqQ3RrTNO04.PU"; protocol="application/pgp-signature"

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

--MP_/b3TjX=+Y9T8858GCZXolPPT--

--Sig_/Ss5UMrkMWuR2zZKS6IXdLbS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjhqrAAoJEMDTa8Ir7ZwVJeIQAIMbGYhVPTCWoXQE+nv7vVru
juQRvBAFjuzn6++y84KzdYLr5u8B4r6YDjjt4rfd0TqTeVnmGhgA+DDdgxWpQO50
vBJBaogbXWaDMujuMA2l8/XnzKlVgDYpvKwAyAdu8IZCwIShNFUUW1OzAlnb9GPY
k237TlnQH57mSPR9HKdw8TUvN+jM6Npw8BVAqv7dtVc6l9qhIg8VT6DIvbUPgWNk
mg5nyowOgrP3sq+e71BaTp91+3ZF29GrR60HDZZNo8lYA6PCgQvtRBSAqrNQci+B
7yF6nqLnfaHGGjBuVLBALcV9z5DABXUkfdQ5hjE7ewUr/loJZa3KLCm83MRs7YMH
UVPTWW8JEKMPYUZnGJ3hyxXneUMnBUzBq5KLJOE8p7gLbnLyYuf8G+ylh8d65PO6
Lwm7z/di/jm6sA1/T1T5YIcN9lqjobNHxJKSGOtsguyKYKwLfk+MC3uehR4jEXNw
MHmBbXChOXYfn3/sm/aYLbKwVP94d/2WG4PamuQljXF+4tGrbQGj1AQ0FiVXv5V7
9AWc+OtbCuek42WI+BsWebN+JCwfKA+1YVKAVHrhvxtUp2khz9HK3Tf5+E9Dp1za
keZn1jElRXg/2tUlIINyjNMWONNelN+3Ug8lLwqYPX9jEkQYn1bLJJUVexvrWbfD
HRqDlJVknAS9AhEuQkvf
=PR1c
-----END PGP SIGNATURE-----

--Sig_/Ss5UMrkMWuR2zZKS6IXdLbS--
