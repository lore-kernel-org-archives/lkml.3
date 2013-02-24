Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316Ab3BXWsr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 17:48:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46028 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758955Ab3BXWsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 17:48:41 -0500
Date: Mon, 25 Feb 2013 09:48:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: manual merge of the metag tree with Linus' tree
Message-Id: <20130225094830.e45f7b56cddcc839841d6619@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Feb_2013_09_48_30_+1100_jAj.Z4HXbliaWA.F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Feb_2013_09_48_30_+1100_jAj.Z4HXbliaWA.F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the metag tree got a conflict in
mm/page_alloc.c between commit 22b751c3d037 ("mm: rename page struct
field helpers") from Linus' tree and commit 373d4d099761 ("taint: add
explicit flag to show whether lock dep is still OK") from the metag tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc mm/page_alloc.c
index e9075fd,4c99cb7..0000000
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@@ -332,8 -319,8 +332,8 @@@ static void bad_page(struct page *page
  	dump_stack();
  out:
  	/* Leave bad fields for debug, except PageBuddy could make trouble */
 -	reset_page_mapcount(page); /* remove PageBuddy */
 +	page_mapcount_reset(page); /* remove PageBuddy */
- 	add_taint(TAINT_BAD_PAGE);
+ 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
  }
 =20
  /*

--Signature=_Mon__25_Feb_2013_09_48_30_+1100_jAj.Z4HXbliaWA.F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRKpi+AAoJEECxmPOUX5FEfWoP/iig+pBC87I9yWFs/1HB71+r
/ntlOCHhtuzwyiejTIDwU2CqTfTc8JbXxbi+79bFXgMn+B+A1OxEyzd3KwJVHCD2
o7XYXLDYCoIOr3jcaNzUE6Mwz0Vk+yQYAJbZuj2TMRQ6gd1Apw6HiKS1ME6NeJHd
c5zckG1pazvnvpPRofuvq49p6xB0GTVqk8AcjJ4+z4VCD87WDaCtglMSbii8KX/G
saDogrQ+gOgbPnfwNIhAnRbN1qzSky2JP6SG2qlHR8VXiD7jawLdaql6dp2AKCoG
g82pn1klm5VUsnGvvSL+Az4UZVPo75ha7KLBudl4CtbQkPLnsxWW+wVL4XfOE7gg
cIazYAs/r2D+cNtzbft9AMY9lGtuPNzkYaKhLJrB2xXk0E+/y+Asy+iYd7fL/dcd
RampnB2GH+hwKcxKSm1vrEDM7YepiHOZnTaPR1Tpixg+pi7rIHVUakYV50kpuaGF
4gyMPRwqH9PQ6uAQNto4hry1KjBQPVI4GfVT6e2Cu26EGNV9de+cuKIJZ90ezJrX
wIO4GWqrBlw+p7VZIV3Vk4Rkjd/7ggUenxhc/hge+z2Y0jSNLlguFMycT3xHuy2N
F8Fjn8j5NI6BV89nLonWEw5onu5b/KSek2ao0dtV4KJCqSQ6Y4h+CU/c+jpI2VAr
Du9CiiAfD5BH4d3hCRiv
=PAzO
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Feb_2013_09_48_30_+1100_jAj.Z4HXbliaWA.F--
