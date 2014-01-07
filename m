Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaAGEmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 23:42:32 -0500
Received: from ozlabs.org ([203.10.76.45]:33972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbaAGEma (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 23:42:30 -0500
Date: Tue, 7 Jan 2014 15:42:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Wei Liu <liuw@liuw.name>
Subject: linux-next: manual merge of the xen-tip tree with the arm-current
 tree
Message-Id: <20140107154222.b2c0c8081441671f32d78bc1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Jan_2014_15_42_22_+1100_o1XXANa77vLhDjqz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jan_2014_15_42_22_+1100_o1XXANa77vLhDjqz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xen-tip tree got a conflict in
arch/arm/include/asm/xen/page.h between commit 0a5ccc86507f ("ARM:
7933/1: rename ioremap_cached to ioremap_cache") from the  tree and
commit 02bcf053e9c5 ("asm/xen/page.h: remove redundant semicolon") from
the xen-tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/include/asm/xen/page.h
index 3759cacdd7f8,709c4b4d2f1d..000000000000
--- a/arch/arm/include/asm/xen/page.h
+++ b/arch/arm/include/asm/xen/page.h
@@@ -117,6 -117,7 +117,7 @@@ static inline bool set_phys_to_machine(
  	return __set_phys_to_machine(pfn, mfn);
  }
 =20
- #define xen_remap(cookie, size) ioremap_cache((cookie), (size));
 -#define xen_remap(cookie, size) ioremap_cached((cookie), (size))
++#define xen_remap(cookie, size) ioremap_cache((cookie), (size))
+ #define xen_unmap(cookie) iounmap((cookie))
 =20
  #endif /* _ASM_ARM_XEN_PAGE_H */

--Signature=_Tue__7_Jan_2014_15_42_22_+1100_o1XXANa77vLhDjqz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSy4WzAAoJEMDTa8Ir7ZwVUnUP/0EHDRFLLab9spxf8kCH6AIN
a5Bpk3xpkVU/8Yx2so9pVA9lmo9NfizhCvrJ+eX+P0rOSt7wGag3Bu/9U3R9znrX
AwFr9b1awuSFP9qXGqDqmGKY4Cf8fwZC3YPa5keQ4DJoyxCCZ8e8fjWTgDMaA5xD
AK3Dfy+eYwRDdhvAnGj9MUxzLMGeuqGF9YCdtSCtiWtz343kJDzRJmEGoimnAyYU
GSG9za3HYkl3ElBNF1Vjkklfph5vnn0zuMd3hLsRBufRlAsUuM95WguJwAvxMrbW
hP66ONsbLMihIGlRo0si5gmTsWiquk1Yhb3X9uHcDq662I8iwW4JW8+oXyNAYlKd
V/BmzAoK2vp/8vVyCOqp4gN6NHbhy9dL9K8WQZOOgUegPq3YxQOAjXCb7OCoYxFo
1E/XoeAqu+dXVTKbsnLdeVRCEmfh/yPj22mSpfrN16RvJFSUjQbXWzK1vhGOuQK6
4Jajbz5mBhrs+gDYCMRORvxaCE1/TK+k4nMt4ON8W9hVU6TeFPv9YKAfPqPLqlp2
GaSjwsXzSoBe3TIObtPG34uYf2ec2J7LRu0YLddZ8s3s+HyoClxygmL4ELtmZtUu
2bEA0t3jTOR98KrNd1u2KYFMT8pxs0KoheHq8X2Y8hK07Ety3J4OpIZ+p5x22xwi
5axr1xKdt7hLTkDB4Xg9
=udXo
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jan_2014_15_42_22_+1100_o1XXANa77vLhDjqz--
