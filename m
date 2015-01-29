Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854AbbA2H3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:29:04 -0500
Received: from ozlabs.org ([103.22.144.67]:47475 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521AbbA2H3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:29:03 -0500
Date: Thu, 29 Jan 2015 18:28:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: linux-next: manual merge of the akpm-current tree with the xen-tip
 tree
Message-ID: <20150129182855.58f0cf82@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Xp=KsYPkgH.R_e7otOCxb2E"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Xp=KsYPkgH.R_e7otOCxb2E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
include/linux/mm.h between commit 667a0a06c99d ("mm: provide a
find_special_page vma operation") from the xen-tip tree and commit
cfd00f5aa195 ("mm: drop vm_ops->remap_pages and
generic_file_remap_pages() stub") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/mm.h
index 9269af7349fe,b5e28731a293..000000000000
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@@ -287,17 -284,6 +284,14 @@@ struct vm_operations_struct=20
  	struct mempolicy *(*get_policy)(struct vm_area_struct *vma,
  					unsigned long addr);
  #endif
- 	/* called by sys_remap_file_pages() to populate non-linear mapping */
- 	int (*remap_pages)(struct vm_area_struct *vma, unsigned long addr,
- 			   unsigned long size, pgoff_t pgoff);
 +
 +	/*
 +	 * Called by vm_normal_page() for special PTEs to find the
 +	 * page for @addr.  This is useful if the default behavior
 +	 * (using pte_page()) would not find the correct page.
 +	 */
 +	struct page *(*find_special_page)(struct vm_area_struct *vma,
 +					  unsigned long addr);
  };
 =20
  struct mmu_gather;

--Sig_/Xp=KsYPkgH.R_e7otOCxb2E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyeE8AAoJEMDTa8Ir7ZwVpjkQAIRMfYiVQQumAbbBBA5q6nJE
BLMif5shURtsjLtt+JTn7rvLWEzCoTlLzKRocTG9h19oEj3IFrLD84tthB9LP1RQ
H0IFLdFX5IZzCNU4nWiuhOPNv4zEGWkCnYJeY8MvCn7omEbJc6H+BnFfjr6ztnkJ
IPPsL2YnU6HghUAfzxk20ZhqyVcny7lgPqgyzhGGh2wexsy8CjDbnAoYfYP7S7rq
Dzj6aEJ+B+RNMqVz/JMgxgx7JbmykwBpM3MJ1+DOUsd1f7SwCbsWz7PsY8+ctpib
xYlfE3WkVObwH6WOSOn5UV6+anwLDh/zuFwA2lZwP/2usexfBmwqsh8MqXFEKhTB
LTYnRMezO60XhfYtpy7GtHMMKELVwLfBYL1LAPPySkdMkRSUDGjAk50w4opdtzUT
3/opEFZ5uJFEdbnfmd6JogYj8/KwWgJNioaZZXisSGiemPRnzVzKQDkGImxx8dm9
7eFdfnZ/OiD8FzZKzmjA1v5mMb3Y68vVEGq58zjvgx4pi2sOQY5+4fhCurQsCGwk
L1uisHshbC2Nur81BRjmFyW+Fy88waGPf2ve8Udj/TXMo5O6uGqLEh+oUHrpYfkK
zrJ5eA31tcLwTADh7lihrDKbzGSIGIZGxAAr0AZuwn6/6Jh4Etr9vSeggmtY2Rag
xMac42c95udxVVKoRMlb
=Qf9W
-----END PGP SIGNATURE-----

--Sig_/Xp=KsYPkgH.R_e7otOCxb2E--
