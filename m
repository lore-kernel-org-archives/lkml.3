Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937AbaIYHrm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:47:42 -0400
Received: from ozlabs.org ([103.22.144.67]:36650 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbaIYHrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:47:41 -0400
Date: Thu, 25 Sep 2014 17:47:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liviu Dudau <Liviu.Dudau@arm.com>, Peter Feiner <pfeiner@google.com>
Subject: linux-next: manual merge of the akpm-current tree with the pci tree
Message-ID: <20140925174730.302842e6@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fYCfO8lzaTM.Z24wmdhnwWh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fYCfO8lzaTM.Z24wmdhnwWh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
include/asm-generic/pgtable.h between commit b766eafe6828 ("PCI: Add
pci_remap_iospace() to map bus I/O resources") from the pci tree and
commit 4cc2f91f2636 ("mm: softdirty: enable write notifications on VMAs
after VM_SOFTDIRTY cleared") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/asm-generic/pgtable.h
index 977e545a64c3,f6acf1195182..000000000000
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@@ -249,10 -249,18 +249,22 @@@ static inline int pmd_same(pmd_t pmd_a
  #define pgprot_writecombine pgprot_noncached
  #endif
 =20
 +#ifndef pgprot_device
 +#define pgprot_device pgprot_noncached
 +#endif
 +
+ #ifndef pgprot_modify
+ #define pgprot_modify pgprot_modify
+ static inline pgprot_t pgprot_modify(pgprot_t oldprot, pgprot_t newprot)
+ {
+ 	if (pgprot_val(oldprot) =3D=3D pgprot_val(pgprot_noncached(oldprot)))
+ 		newprot =3D pgprot_noncached(newprot);
+ 	if (pgprot_val(oldprot) =3D=3D pgprot_val(pgprot_writecombine(oldprot)))
+ 		newprot =3D pgprot_writecombine(newprot);
+ 	return newprot;
+ }
+ #endif
+=20
  /*
   * When walking page tables, get the address of the next boundary,
   * or the end address of the range if that comes earlier.  Although no

--Sig_/fYCfO8lzaTM.Z24wmdhnwWh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUI8iaAAoJEMDTa8Ir7ZwVAcYP/jxS7kTI7EymZz9NvnNWA1W2
5HKSWWx/ldifffV0JcbGGKkOrP290TfB8Rl/bR5gJKn1nL1v3r5IK8e8OP9NqeQv
aYL8kP8dhGx1UzdZNAi7vJVMwKfXcGkp6+iRxTKP0tMsTu4dnsIcvriky5ToQLrz
dlKIcO1BqkGjaY+TWYaIkK3lQJXII1XR30JlFx6OliMVN+KQgr05IZQ8RFrtWkRR
qZaNIJvp8hS8zPcPxKt+jRUXvbrYIp6TXF562dWXbM4sVTqpdG3n1KmYbVHVvNe4
+kflDaC6sk3qra+uSCjkfAdyJynfInGYSJW3PBn7R0mCFX5aWlfZPMoHIMtqURRT
26exfhZI+9fKJ7UXsK7/3kAoyJEcyFrgGNMSREZP0coer5+NhXvmbaLO628AQGLh
7v0MVJNyCGmssSvFrPQIkixBFEBZg001I/wHM+ACZzNqicKGTa05ZZ9KM5mvBg7V
zBgwV05gVd3wjkD9JwezG7pUK4TwYMB1Dq7rxypi60GiZTdb8BS9O+T7DzP0QuW1
aOwlgPKCiuaFSDj/8JvvXIuf5C5wbhgTJMMJXNPJgCeRB2ZAzNlpBq+3dQxdaF1+
ieMANfLiTWvagrs7yWrxx9H9V8Nw3zbG+JEuq9VAF64EAIxcJylb5OHIX3kYTByv
Wkw5W+GPeVZq69HVKzVD
=D/w7
-----END PGP SIGNATURE-----

--Sig_/fYCfO8lzaTM.Z24wmdhnwWh--
