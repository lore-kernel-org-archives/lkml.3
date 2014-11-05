Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbaKECrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 21:47:40 -0500
Received: from ozlabs.org ([103.22.144.67]:59682 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaKECri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:47:38 -0500
Date: Wed, 5 Nov 2014 13:47:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olav Haugan <ohaugan@codeaurora.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the iommu tree
Message-ID: <20141105134731.799a1a3d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Nzz4gyi3FMw/SdAxw8nTwAn"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Nzz4gyi3FMw/SdAxw8nTwAn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Joerg,

After merging the iommu tree, today's linux-next build (powerpc
pc64_defconfig) failed like this:

In file included from arch/powerpc/platforms/powernv/pci.c:33:0:
arch/powerpc/include/asm/iommu.h:140:12: error: conflicting types for 'iomm=
u_map_sg'
 extern int iommu_map_sg(struct device *dev, struct iommu_table *tbl,
            ^
In file included from arch/powerpc/platforms/powernv/pci.c:23:0:
include/linux/iommu.h:311:22: note: previous definition of 'iommu_map_sg' w=
as here
 static inline size_t iommu_map_sg(struct iommu_domain *domain,
                      ^

Caused by commit 315786ebbf4a ("iommu: Add iommu_map_sg() function").
Grep is your friend ...

I have used the iommu tree from next-20141104 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Nzz4gyi3FMw/SdAxw8nTwAn
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWY/HAAoJEMDTa8Ir7ZwVWlUP/2xm4CG2Vu9zK8V79BB9zXH6
GEQk0u4Ow2TrGB+tbDab+tBsESaUpB51mVqq80WLSB05pkk39kviBM7Ra7O6ygOg
28aMo0+GO7Nx4VPwIam8l1/OZqwmrBkNq8UzvIDLmZmeiWQ1ORMbQQDvEHkmGUdT
05nTxaftgj9v7i5ENnGI/q+LCmTuXADPK+A0YYvdw2HRK0Zgc/gZYd8/W5qca4Ya
OZCZq+yPjkE2GKCqPeUCxZscZJliQSZYOx1bUexvPrH0k4mojnZrXmpqJyLTHrVm
ohWYULHVkDyOgLF5cnh6Hqgi7+FqFk3Jfxs9WGs8DF6jV8KlXRO41xgdh75HUDQV
REOZP6S+gtOxk8yV59AxvJfbQ8HWp5bGub8WkRhCyA6AlsSeVinNVNFtwlhtYKpn
FwVWrax0LUU4GEn+sW+KVi613E23yqIxzCAHF9bveeSubyUkT/JHxw1GBy9d4Xkh
NuHfHxe1b6jxeaBzOgBiXkfGJbscW/y6E3qRfA2FESHi51qxsDUw93PET87+OKb4
Xat9ivrIzit/i+HCwo/A1ZPu2eGolZbXD1+/zUjMJQOK5Hm+eQ6eikuFjt00/utu
Ya//qgJDso5xE3LMsbGlaKrDOauM3tjPADwfYyxsXYBJl5MpPCK/LkobOqHE4Ooy
CgKsM/YwY13DToXqSQ9V
=KoTk
-----END PGP SIGNATURE-----

--Sig_/Nzz4gyi3FMw/SdAxw8nTwAn--
