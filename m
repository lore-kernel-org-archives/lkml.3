Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbaEWJMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 05:12:10 -0400
Received: from ozlabs.org ([103.22.144.67]:60155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaEWJMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 05:12:06 -0400
Date: Fri, 23 May 2014 19:11:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the target-updates tree
Message-ID: <20140523191159.6a064678@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/HRLxfAu0877iVtX2bl=vUzF"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/HRLxfAu0877iVtX2bl=vUzF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

After merging the target-updates tree, today's linux-next build
(powerpc ppc64_defconfig) failed like this:


drivers/scsi/virtio_scsi.c: In function 'virtio_scsi_init_hdr_pi':
drivers/scsi/virtio_scsi.c:491:48: error: dereferencing pointer to incomple=
te type
   cmd_pi->pi_bytesout =3D blk_rq_sectors(rq) * bi->tuple_size;
                                                ^
drivers/scsi/virtio_scsi.c:493:47: error: dereferencing pointer to incomple=
te type
   cmd_pi->pi_bytesin =3D blk_rq_sectors(rq) * bi->tuple_size;
                                               ^

Caused by commit 4baaa7d589e2 ("virtio-scsi: Enable DIF/DIX modes in
SCSI host LLD").  A missing include of linux/blkdev.h.  See Rule 1 in
Documentation/SubmitChecklist.

I have used the target-updates tree from next-20140522 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/HRLxfAu0877iVtX2bl=vUzF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfxDkAAoJEMDTa8Ir7ZwVzLwQAIz7x0Sut3JLLgFBRJU4X8ol
qdVUnnmHfrgKZniUtijqEByqQSZv6nEen4A3nYD273MyqhBeoOsN8oRW5sBD1CTh
W3eiPn2IjVMIbOPGH8z9eUkRpW2TQzL6fkW6CS/lsS4rc/NU71j4Ed2sY5WsjXbo
Td1CUJqW6Gj9l9gY4S0IyeuCfHQRL/kcbEPxL3lcrENYbOUrWcK648Y/QyU2oaRq
BdMrbBZA2QvKmJetxcDwGa59CONRqUuAQRvYeHuyTwUn3XmNaxme0g6AByclnePk
GIECwZ7uKTVqiqmQ6htZy/IAzmKg+ZzlHoFa/MZfKRb50w54tHDQ6hJ7jNV/+q8S
JqZu8NtYxpVnCbFVuJV2if5X9EyMyj4+waY0MxIoO0pD3cYn2wuDYirOGjf3Jfce
ZFob6SxjET7TNf48PkSNUQaRdAsmVz6YEXlO94kHZHL5/R2kmCOl6RznkJjKBPhv
dlq4WU4nMXYx8D6h/a5RKI4vOJRz9K0DSfEvXjkBVj/LO+9IEmpPg3WlklWigu6I
8T3SX1n6e5d8Z0YmjLcORjJIbTGmI2UoOAp6lJEVVLIWRiTpwMjWIIZvs2nfHV00
TqHwRlTHNaog5axUStTfZIKehoYAwZ4mxuYJNT323y323zURzrltUAbUfcHd970x
xYlvtsXgjfvCDikNHoj9
=9eCB
-----END PGP SIGNATURE-----

--Sig_/HRLxfAu0877iVtX2bl=vUzF--
