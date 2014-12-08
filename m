Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaLHL0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 06:26:52 -0500
Received: from ozlabs.org ([103.22.144.67]:36947 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbaLHL0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 06:26:51 -0500
Date: Mon, 8 Dec 2014 22:26:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the access_once tree
Message-ID: <20141208222641.40a64946@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/A=bv69.VVArYVLGKVtsDaBW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/A=bv69.VVArYVLGKVtsDaBW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Christian,

After merging the acess_once tree, today's linux-next build (powerpc
allnoconfig) failed like this:

arch/powerpc/mm/hugetlbpage.c: In function 'find_linux_pte_or_hugepte':
arch/powerpc/mm/hugetlbpage.c:981:3: error: invalid initializer
   pud  =3D ACCESS_ONCE(*pudp);
   ^
arch/powerpc/mm/hugetlbpage.c:993:4: error: invalid initializer
    pmd  =3D ACCESS_ONCE(*pmdp);
    ^

These are preexisting ...

mm/gup.c: In function 'gup_pmd_range':
mm/gup.c:929:3: error: invalid initializer
   pmd_t pmd =3D ACCESS_ONCE(*pmdp);
   ^
mm/gup.c:929:3: error: (near initialization for 'pmd')

This is from commit f30c59e921f1 ("mm: Update generic gup
implementation to handle hugepage directory") from the powerpc-mpe (and
powerpc) tree and so will require a merge fix patch (presumable
s/ACCESS_ONCE/READ_ONCE/).

I am not sure how many architectures you are trying to cover, but
powerpc is one I care about :-)

I have dropped the access_once tree again today, sorry (its too late at
night).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/A=bv69.VVArYVLGKVtsDaBW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUhYr3AAoJEMDTa8Ir7ZwVaIQP/162dexk3to+Y9RDaXMOwrq0
fSzrsad3Vv/mV025ZyXpCRyD6ijYRCrRIHJN7eoql2GsknOQX5yTW6nlJWjIjcUy
6OQx1G3ajRHFBNEkHLzgbG/+A1IiFAJGl9GVHnVl4GEFF+iiv95YeRgoo4hQ3ZaI
XxQNPTcuGeWGny6RJY6h1UyevmcQu3siU3vQ7tMHJ/wna+/M6n+VG+p4UiYcLkEc
tm6WvEA5JefOqv++JX9Emw7a/I8EFbjUuKQIc9g+a5j4jc/IFcLZ2+xQyIFzIm/b
k2l1dtH5gdoGb0RKOoN6NN1/su9osqIN0W0ENNDfqEH7pGfmv/ZKggsu1tr1TzCF
ZECV+Y9YI0oC5SxRPw0HEJfmAKhpZkQ283sWVqzN1BxiY/xmE0avXNhZZPHBQRl8
Uvb8ebHtgds4J270NUD0blE12buMRSYymnN9uQB1dMpK19Bq11S9hf0OVoN4idZo
szXOrQRyyrKeNhRDhNRyieAaBN+PKFl7U2EuZVHq82kFtkbnWzmJILPGbRvdLABH
jbxNNuidTVR5+/O38B/8qXuGsm3y4a6nXfhIkQCvbjEanqkG8qUG8ICxBSU8Zojp
T+CZUWOQ5Wxv++AJ8iHgRFVPhAVi1ENLNv28SKrFk+U031Teor/+dJJC0Sv7kc62
Ho5YS3s3YYMv0XyEkQxf
=m+Ij
-----END PGP SIGNATURE-----

--Sig_/A=bv69.VVArYVLGKVtsDaBW--
