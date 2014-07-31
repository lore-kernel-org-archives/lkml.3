Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391AbaGaKZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 06:25:32 -0400
Received: from ozlabs.org ([103.22.144.67]:60642 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbaGaKZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 06:25:31 -0400
Date: Thu, 31 Jul 2014 20:25:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140731202523.59762097@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/PJAlGZcD9Hre3M/I1KCPx24"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PJAlGZcD9Hre3M/I1KCPx24
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm multi_v7=
_defconfig)
failed like this:

In file included from kernel/kexec.c:14:0:
kernel/kexec.c: In function 'crash_save_vmcoreinfo_init':
kernel/kexec.c:1623:20: error: 'free_huge_page' undeclared (first use in th=
is function)
  VMCOREINFO_SYMBOL(free_huge_page);
                    ^

Caused by commit "kexec-export-free_huge_page-to-vmcoreinfo".

I applied the patch "kexec-export-free_huge_page-to-vmcoreinfo-fix"
from Michal Hocko <mhocko@suse.cz>.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/PJAlGZcD9Hre3M/I1KCPx24
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT2hmYAAoJEMDTa8Ir7ZwV0MYP/ilOMpMruDK5WiEpgTEuorIs
zzbZoUvKCJ9VXMoobG2z9Ig1ByW+sZUKNliPhCaPIXacyCmwZlVEnaZEwSi6E21o
1LMntFlv3881JkwHgesNYZkUyzc0DxVTp8BzVsJfa9JqRAZJMKt8aW46d4pbBXhv
jGkvT9z1mU4mLIK9jHrb0fc6tl/60lQEAZPFYX/xZcIi7b8E96ADUd6lklZzwODW
0YmAKH+lnHd+ySzMce1bTZ4LCR/InT5zw3VLb+zO7E8W253jN+mVpxGa1LHVUToz
GmrsyK8RFzWN3wmcjoHsL+alcHzp3Cjw+MOTdQaoyo2sQVzug+KKi+Ulep4GBDAn
yN66oBZDL3u33ANI7w545UCfh4pv/OkbiJpSctmdxR2hkGX2bk8RQHidOMuuoEyo
bHRnzLkdJnoq7i5S+rekYjeGqDGj/q0xn4NjuhEZLpKMHOyLOqEe000qj1u2JbdF
4Cj1r6DDr76NQpzD3eJhgikFswAcZy8jTwPkr4nAsDiUnLnsXwOJxQl5INP/tBR5
QPdKvM/Gsav+N2rKKpr0WHY/c/C6tgFU/6I1FwMfjNqwR31OIhU7VKAozrd3+lbL
Xtdqj7EerSGMWE2uscLW4gBgSsdUaJbeM4bqTiCTkP7+7W4Sg/1bIzgcQJSIYeIC
tYB6o653kA2Qpb0+E18f
=X8ks
-----END PGP SIGNATURE-----

--Sig_/PJAlGZcD9Hre3M/I1KCPx24--
