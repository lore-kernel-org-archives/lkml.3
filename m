Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3KRDBk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 22:01:40 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58629 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3KRDB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 22:01:26 -0500
Date: Mon, 18 Nov 2013 14:01:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20131118140114.f7d4c4aadb5a033d1de53518@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Nov_2013_14_01_14_+1100_PABJ42lacCKvz514"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Nov_2013_14_01_14_+1100_PABJ42lacCKvz514
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

In file included from arch/sparc/include/asm/tlbflush_64.h:4:0,
                 from arch/sparc/include/asm/tlbflush.h:4,
                 from arch/sparc/include/asm/pgtable_64.h:961,
                 from arch/sparc/include/asm/pgtable.h:4,
                 from arch/sparc/mm/tsb.c:10:
include/linux/mm.h: In function 'pgtable_init':
include/linux/mm.h:1391:2: error: implicit declaration of function 'pgtable=
_cache_init' [-Werror=3Dimplicit-function-declaration]
In file included from arch/sparc/include/asm/pgtable.h:4:0,
                 from arch/sparc/mm/tsb.c:10:
arch/sparc/include/asm/pgtable_64.h: At top level:
arch/sparc/include/asm/pgtable_64.h:978:13: error: conflicting types for 'p=
gtable_cache_init' [-Werror]
include/linux/mm.h:1391:2: note: previous implicit declaration of 'pgtable_=
cache_init' was here

Caused by commit ea1e7ed33708 ("mm: create a separate slab for page->ptl
allocation") from Linus' tree.  I have not seen that patch in linux-next
before today :-(

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Nov_2013_14_01_14_+1100_PABJ42lacCKvz514
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSiYL+AAoJEMDTa8Ir7ZwVJuwP/RzMnVZ7CmXl9jF+c3az+Xon
Y589YVdwD2iKSGV3bVDU74f6mdf9aAEGjHUGTdlgHTz/DId1x/ZdofVR0DhZwNBS
dlOxRwPqx2DbOoS6TgIcFyo77HElSk/XFXgbzssYNtINVUbREady36MQt8cCJdLm
aCXg0AU+gsci5kdsNXUusWeQVm2Dev9MV9sCtP2iu3yvZRdExqEqboQQfciDkId9
P3Ubq+tugzu7kDhSb6lt58I9XE5rgCoHRNQenkRzZqWCErvWGFGFEBh4CDyR39iU
Ye+lCamCbu5vz4zu09kRqOFArtKAVNFWVnCpWtUokB16CHwza5rsjFh8YcB0CDCZ
n3d0V8xGVgE2l9IhslJrH7FAmr6x3gGSdrB+322XRNOgE7oSTRQ3F9IOzH+xHBJv
3GQCmUPCDRNV85YcURWbBHHLb/B5BUdcBIkqEYkE616oHyDv2m3QnMmkQWZKxpUs
4eYPRmTrypVir02YHfMVcdIvyDeS4YjshuS/MK9gNUPjcQBE0UDbX++slztOHWMJ
E1kIQ/Z+JZq6KMwj0Rp8Ow3aUMwbpehkr0hCRZhtSWdX2gUdfsJc1sUBfqCq9eKr
7N/iF47xpRo5M63ydy0ssLXx7SWHAF7LVCCJj+h4An/uEzoPqVeK2q1rV0vZMEZ+
hHwBFQByo4vQ50ZuAExy
=SRF8
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Nov_2013_14_01_14_+1100_PABJ42lacCKvz514--
