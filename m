Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3HPHRE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 03:17:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50855 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab3HPHQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 03:16:59 -0400
Date: Fri, 16 Aug 2013 17:16:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>
Subject: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-Id: <20130816171652.18da175d7d411677beab7fde@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Aug_2013_17_16_52_+1000_g2.ZLZoMnZ5Edm7Z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Aug_2013_17_16_52_+1000_g2.ZLZoMnZ5Edm7Z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

arch/arm/kernel/built-in.o: In function `parse_tag_ramdisk':
io.c:(.init.text+0xc4c): undefined reference to `rd_size'

Caused by commit bf27a0131289 ("drivers/block/brd.c: make 'rd_size'
static") from the akpm-current tree.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__16_Aug_2013_17_16_52_+1000_g2.ZLZoMnZ5Edm7Z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSDdHkAAoJEECxmPOUX5FEqr4P/3l913zog4gYrJC3MdjYTknC
IoHTmK1krW9CN+ZF989PQm/8q42UxjfJ4IjerlH7PJxGFyiPBJaawSWixHbQDidF
/x8DqqQzo57DJ1fMj6e1Cp/MZ4J/g8OBXBibKKfAABPEqnXSBDyLoa3TRNUyHjNY
49zOCWhBoDWxtYrGgwJXCFjKRbUxjheFL3Kbx+EbSbQan0u213SxHW8QPcvgP4RE
s1NP1+2QaAyKddY4+ZW1NKdowkhS7dCRsegkb54mn6M7+3bD3VXtE5wt8lJFUgdV
LV00zWZrIrsyxj/xc2I2NWZNWgZox2/SC2ZJ8Ruu8cbHlaANNIuMsAeX/S58H1ar
aWnclsFyAaA24KTp65RT7vU9fEwnE2xDvPe+o+m+/E/847cMuGaviRbhWfycIXdo
S+v56/XWzxSWY6i5hsuDb8wsQS1j3wwKUM2QZX0NMV6+ddIWxJmi7CDtGwbm1osB
lsuVLxiJhVqn64LIOPKBfRUopYKTOa8anp/l+WCf43UHSjB4XvQhhmCtv0uADYJC
veGDdrsGoeARwVHhj9RbE6KTzd0/0CRa2W029NVHAUH0VaII2TKB1JeT0PfLi24R
PRUbec8I05AdKajxia1I7fSryibFMlf6vy7UuFiRmx1YUNSHer3nd0rty9gM+b6h
yn7h0dL8uBk+Ddik/Ff7
=JaLs
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Aug_2013_17_16_52_+1000_g2.ZLZoMnZ5Edm7Z--
