Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaIZIe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:34:59 -0400
Received: from ozlabs.org ([103.22.144.67]:55835 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067AbaIZIe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:34:57 -0400
Date: Fri, 26 Sep 2014 18:34:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>, Christoph Hellwig <hch@lst.de>,
        Xiong <wenxiong@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the scsi tree
Message-ID: <20140926183450.7474b448@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/joMs45Ou72vs73aQ97zfpqG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/joMs45Ou72vs73aQ97zfpqG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the scsi tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/scsi/ipr.c: In function 'ipr_handle_log_data':
drivers/scsi/ipr.c:2468:15: error: 'IPR_IOASC_HW_CMD_FAILED' undeclared (fi=
rst use in this function)
  if (ioasc =3D=3D IPR_IOASC_HW_CMD_FAILED &&
               ^

Caused by commit 3185ea63907c ("ipr: don't log error messages when
applications issues illegal requests").  Someone typoed that name in
ipr.h ...

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/joMs45Ou72vs73aQ97zfpqG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJSUvAAoJEMDTa8Ir7ZwV9wUQAJd8wlrNB1LxEtx59qmVMM17
fpqAD7ORJhVlThmWtHIX9flrWBUntVFr5kPvoLdk7iupKMm8a3cDhYqO2Wxl53gE
wlf/OJt4HEnMinAf5QD/2s54ZTy3oMWpmai2+XYg1XXQTfVmCUqU96hr7giyJ644
OUwKGHOTFxMAuxo8l+kssb0BNIa9lXx/trC+z6F8th4wWGwvyvCpOomg3tNipzfj
FxBYjlaie0JSy6aBXiQaNY7iy6dImWqvna/xPqoi7JBaslBmNDwqiDlj2ISvRG2n
/dIbVK5dNiDEYPYX5YAtuf2dqk0gjDSHARtptrJ1K1Y8Ei4mh5Oda5+lE7NKIu3f
cZLCPVFSsNpL91RPWLxBNTlrhEWcLQ/AdFQn0N9h3P9RDRwT92ucNjKZOMzylP7z
X73V01wG/OTtKBs7gN+Gspj2ApnaALiW8bYA0qdG6TIdSaYBez+uJ5B6bj1O8HBg
hIxfPht6UWU/8K5xNu32PGYozfg0bqRwuYd2zqkFnd1Wylw3U8ZvtJIDHZ6pSpfS
Cq3EFXRPtttn2rwCj5PZyBfu64peqfqRBaDZbJ7bw9HFUioEkhUbIOlBOvDFKgJi
j2KftFhOQmiJnhkhqD+DRSS4n4sqHxNlznKIcITx0IJpU3Sx5O3B83InlFniZuV0
kwg+MQkHsKNYpRXqMQBQ
=eYHy
-----END PGP SIGNATURE-----

--Sig_/joMs45Ou72vs73aQ97zfpqG--
