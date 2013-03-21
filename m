Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab3CUFdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 01:33:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53926 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3CUFdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 01:33:39 -0400
Date: Thu, 21 Mar 2013 16:33:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, Tkhai Kirill <tkhai@yandex.ru>,
        David Miller <davem@davemloft.net>
Subject: linux-next: manual merge of the akpm tree with the sparc-next tree
Message-Id: <20130321163328.2c6dccabad6a8dc8fe4b0e24@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Mar_2013_16_33_28_+1100_rrdZM4x_uqqUxoGx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Mar_2013_16_33_28_+1100_rrdZM4x_uqqUxoGx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/sparc/mm/init_64.c between commit ce835e513a93 ("sparc64: Do not
change num_physpages during initmem freeing") from the sparc-next tree
and commit "mm/SPARC: use common help functions to free reserved pages"
from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/sparc/mm/init_64.c
index 076068f,3f559d1..0000000
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@@ -2119,14 -2117,10 +2117,8 @@@ void free_initmem(void
  			((unsigned long) KERNBASE));
  		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
 =20
--		if (do_free) {
- 			p =3D virt_to_page(page);
-=20
- 			ClearPageReserved(p);
- 			init_page_count(p);
- 			__free_page(p);
- 			totalram_pages++;
- 		}
++		if (do_free)
+ 			free_reserved_page(virt_to_page(page));
 -			num_physpages++;
 -		}
  	}
  }
 =20

--Signature=_Thu__21_Mar_2013_16_33_28_+1100_rrdZM4x_uqqUxoGx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRSpuoAAoJEECxmPOUX5FES/YP/0TBzzgUOnY/VC4NCojwdP3+
G8Bye+OTqTdRWx9pQaV0+bCHSxAfDwDmpBKYcBQufNjG+iN+UBn9f21mQw1Mo+QA
QqRQ6huxcSjk1+xBFMZNMJDtEM536efbquKO5gMCkItUlBRNvYRhFn1c4upMWo8a
c5S0NjGLycFuZq79PRQF6HeMHkkgInseN0ax6OxNSPFgLL/FDaSA/LrCBLTHOXCP
I7DiSi15rZsw9XsyP40vBNKvuCX2VnX4PJtOxutZRuuwbOXzyAfjrpuYkvPYf2tH
SAPgPZhoktOaftYCzTH3+TUMjS0q7tvdyzCM+KHRZw/WRtMPUlcuT1CaxW3fEVg2
chvfpWm735zKIHxbjX+hHfuKfs4Ju2pyNPb1tk5A07KGdeanlMDoBRFUXE/iM5B8
T6qzR6fc6WBWOnC9Q0JHxafHPOZsJJymyW/ZRXSNlB5VQ3tHHfsQWoQnjtEA8/IP
T2g4DUBlO9XUg1QACyut8AHAfJI4Vn5doH2yb0WwGXnzhCjU0f0Bvzkz/6PJJ5HD
f5SHC+IzjgfQjA+nECeTv5qh+YwQLFSrN8qeOIkLT+ueQiQM/r9dYxafxdXa6GPH
ohUDlJXa67EcExpj2BZRLF9rPTOG3sDyF/K31uVc5QZeMvLDE9QGsOzcDSg5bTfP
5PloALjKVmcPLU+e5yOh
=K4jw
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Mar_2013_16_33_28_+1100_rrdZM4x_uqqUxoGx--
