Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaCCIkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 03:40:05 -0500
Received: from ozlabs.org ([203.10.76.45]:34848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbaCCIkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 03:40:03 -0500
Date: Mon, 3 Mar 2014 19:39:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: linux-next: build failure after merge of the final tree (char-misc
 tree related)
Message-Id: <20140303193955.e3d4240943d940a2b8d19fee@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_19_39_55_+1100_3zBTpFcpJW3Etnkd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_19_39_55_+1100_3zBTpFcpJW3Etnkd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

drivers/mcb/mcb-pci.c: At top level:
drivers/mcb/mcb-pci.c:110:1: warning: data definition has no type or storag=
e class [enabled by default]
drivers/mcb/mcb-pci.c:110:1: error: type defaults to 'int' in declaration o=
f 'module_pci_driver' [-Werror=3Dimplicit-int]
drivers/mcb/mcb-pci.c:110:1: warning: parameter names (without types) in fu=
nction declaration [enabled by default]
drivers/mcb/mcb-pci.c:103:26: warning: 'mcb_pci_driver' defined but not use=
d [-Wunused-variable]

Caused by commit b71bb8639891 ("mcb: Add PCI carrier for MEN Chameleon
Bus") from the char-misc tree.  module_pci_driver is defined in
linux/pci.h only if CONFIG_PCI is defined (which is not true for this
build).

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Mar_2014_19_39_55_+1100_3zBTpFcpJW3Etnkd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFD/gAAoJEMDTa8Ir7ZwVQWoP/RrCq8JJ9/Tz9F+iSS6hI+E4
AYfRdmbncwDoWtdxjnpKtG8UaWqZRsHFWyH2hGpTWKPEU5ypNqioZhF4EKKYReO3
qlykYQPhSaD46fbCkwvSPgNetLNp9fb3LV25qIyI1GCr6FTI8WeSczLHhzOr3JLL
Q47rDI6KAJfTfT3Fs16O++uED4P6bdmL8fuLpxSGMVQOXFI52rxUJcgsuk4DM/lT
4hGB8pK3HdIZiLFDTmMRwfU14IVny37U3ayEXa+sjKI7mmeOxa4UKyOpQieSX+LX
D1RKlmcgHtezSumvSVTxr0Yb0N2rLLfV8/UpmY6wDKARv5V06OCtvWPkvq1Ji5Qe
4CSTaxsFZWnqI+fie8igSEQKIeEd/jEi+/RPeFMJO4ydxW5/taISmnC+qgKZwQP6
cxqUoNFZFNd208udkNzZB76AHEsWl0hV03b5bogFP9EiRVbp12ezcNZ2hB7zARjN
btIeZ+tcW/Z9DdbSWXcuEcRdUCklwzDj7gG0GD9akDPyGWKHMofZ7YdYUC9RbbEC
uxf7kddvm1VKwEpq8Gc2rxe/94dw5UkFyxRLoDLyr/9fotSRVCV10x2WLoIbsw4N
9fr5foa3YR8hPtlzH+Zz4+txHzkPqvV6aPWcUy6k+hYmFG3xHuyTeMBgedlYVGOY
ILzqDwevDVWhU+BWbW/r
=WV/4
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_19_39_55_+1100_3zBTpFcpJW3Etnkd--
