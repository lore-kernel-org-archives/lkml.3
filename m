Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbaIZD3M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 23:29:12 -0400
Received: from ozlabs.org ([103.22.144.67]:55688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbaIZD3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 23:29:10 -0400
Date: Fri, 26 Sep 2014 13:29:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: linux-next: manual merge of the pci tree with the asm-generic tree
Message-ID: <20140926132902.603fb9f8@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ow5xe+EKyE8fo+vUZAtbux3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ow5xe+EKyE8fo+vUZAtbux3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bjorn,

Today's linux-next merge of the pci tree got a conflict in
include/asm-generic/io.h between commit 4005bfe0aa45
("asm-generic/io.h: Implement generic {read,write}s*()") from the
asm-generic tree and commit 3aad9c969c09 ("asm-generic/io.h: Fix
ioport_map() for !CONFIG_GENERIC_IOMAP") from the pci tree.

I fixed it up (the only difference is that the latter castes the result
to void __iomem * - see below) and can carry the fix as necessary (no
action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/asm-generic/io.h
index 3e976be3bdd4,2e2161b0c795..000000000000
--- a/include/asm-generic/io.h
+++ b/include/asm-generic/io.h
@@@ -756,16 -329,11 +756,16 @@@ static inline void iounmap(void __iome
 =20
  #ifdef CONFIG_HAS_IOPORT_MAP
  #ifndef CONFIG_GENERIC_IOMAP
 +#ifndef ioport_map
 +#define ioport_map ioport_map
  static inline void __iomem *ioport_map(unsigned long port, unsigned int n=
r)
  {
- 	return PCI_IOBASE + (port & IO_SPACE_LIMIT);
+ 	return (void __iomem *)(PCI_IOBASE + (port & IO_SPACE_LIMIT));
  }
 +#endif
 =20
 +#ifndef ioport_unmap
 +#define ioport_unmap ioport_unmap
  static inline void ioport_unmap(void __iomem *p)
  {
  }

--Sig_/ow5xe+EKyE8fo+vUZAtbux3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJN2DAAoJEMDTa8Ir7ZwV9vgP/3BnKrDma9zJlMeUR3Celdgw
6nO4CvZeQhM9GktOJA4gXGcIj0aq1x1fYNoEOcNO5BBzoNPqw6/4Btj845tarBWX
624IBKQNdvIc4kYWlsHso/ylMS1ItpTZnnvmstamhmfFlgterDYBBosA/DYC+v8I
UK0vA0HFA2CdbNF6B1FNHF6VkZdUgiZq/eb4VhIb+ANlF08VY2N73f/x2gLjxiAy
qe/9NUzzkXtWcr+HKvFXlwsaz+VE6W60dyTnUADnqcO6YdClSQAg9Lovuohp2Ocv
DiESfCt2DAfrX3Csdx7VbPKdGhd7aQCMOcz8ry8a4mOGgqDL/FAf0oyuDrTcJ6jQ
ECfWb6H/ZMjrycKDDZrHVcJQgUVC4oajY9s+iNS6uTGc3s87xSCZfTRiM6XBVC3p
EKl5fC8p/7RmABlE2gz3HBJ2jDNwwvQbrN73upRi549d6SD4jWSNNBGY9yvTj1AF
Ct0LWN2/ibf2kSKeMHIeRCLpX16u0YcYzpHHu0XwXVtYNb+Y/934j5fkN3pkv9vF
HZ9eME6WFkCVWQF7x9ooNH5VICu5JUiQJAdkoC3fnWQnW2B5qaWNxF1weSKpIazd
amYW4LP+T97P/SHZBEQC/QdZBxzohRQsbPz+IEGA/n+6AeLqte6w83oJFxjRjxHg
gtnLhI47NHphAcRkEgLw
=HTA/
-----END PGP SIGNATURE-----

--Sig_/ow5xe+EKyE8fo+vUZAtbux3--
