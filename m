Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaAGGLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 01:11:06 -0500
Received: from ozlabs.org ([203.10.76.45]:59456 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaAGGLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 01:11:04 -0500
Date: Tue, 7 Jan 2014 17:00:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lans Zhang <jia.zhang@windriver.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: linux-next: manual merge of the akpm-current tree with the tip tree
Message-Id: <20140107170041.3a0b3ada016d250b1f9f0572@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Jan_2014_17_00_41_+1100_JMhaqLsdVJWhU4p8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jan_2014_17_00_41_+1100_JMhaqLsdVJWhU4p8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
arch/x86/mm/numa.c between commit f3d815cb854b ("x86/mm/numa: Fix 32-bit
kernel NUMA boot") from the tip tree and commit 1459be89954e ("x86: get
pg_data_t's memory from other node") from the akpm-current tree.

These appear to be two very similar solutions, I fixed it up (see below -
I (arbitrarily) chose to keep the actual allocation from the tip tree, but
the messages from the akpm-current tree) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/mm/numa.c
index c85da7bb6b60,f26b16f0d3e0..000000000000
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@@ -211,11 -211,12 +211,12 @@@ static void __init setup_node_data(int=20
  	 */
  	nd_pa =3D memblock_alloc_nid(nd_size, SMP_CACHE_BYTES, nid);
  	if (!nd_pa) {
+ 		pr_warn("Cannot find %zu bytes in node %d, so try other nodes",
+ 			nd_size, nid);
 -		nd_pa =3D memblock_alloc_nid(nd_size, SMP_CACHE_BYTES,
 -					   MAX_NUMNODES);
 +		nd_pa =3D __memblock_alloc_base(nd_size, SMP_CACHE_BYTES,
 +					      MEMBLOCK_ALLOC_ACCESSIBLE);
  		if (!nd_pa) {
- 			pr_err("Cannot find %zu bytes in node %d\n",
- 			       nd_size, nid);
+ 			pr_err("Cannot find %zu bytes in any node\n", nd_size);
  			return;
  		}
  	}

--Signature=_Tue__7_Jan_2014_17_00_41_+1100_JMhaqLsdVJWhU4p8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSy5gNAAoJEMDTa8Ir7ZwV8ocP/j64fesEWSJLml18z8IhXY2j
+WUApqxJYISDiH9s26NvjY0zp1CC+5BxbFHHOGg22rE+OwJmO5uQavrG1cNK7KkO
EoXDgljoRJXnLO9svlNnNuKg+MvxHQkgWUdFE9ncyiP5e2724NvoglwCfSNsbaVF
fKyQ73lUAMLGo6dtYeePMrjZd/ZjlH0SqP+MsupZ+EJ8qUPBGWOrH+EMckG9+4k3
c2loLK/fhOcf0Wn4yqYE/rr1TEa0oT7P45F6sbor2QXd2Z7PBqoCwywAOQT5y0JH
R8+V9m0IaDRJbd//srK2rk2yo8ycidr8Qlz9xmXRA2NyhaXvdCuv+uXdcGUi4I0h
dZgXr4ppI3wVpkbL8NyskyMMH0/nROIzXmpYjB94buQFN9IJHhwTXi6UkpgDOoDk
SRoqau/D42Pq2dZu7YTzZbMde78Axg+5Q65BGya7eEGAzeIwnYjUR9KbcFVb0+Ww
j2nkYSkbVESO8W23Cp/x1KD/kwPRqP4UJ8TS+049O9QR8h82dAQ4MS+Gwb7jGZaN
/h87t32Af6miaD3bSjS5TazMyGkL9QLgqBA3ZH6t2x+CGpxLjgxGKKJ2gddaTgac
agRJoU8DUnSGnsUy2Rmtdo37fd8MrcTEj+1cbrjROzplwAaVhKR4r351O2Gt1l2f
XfCAVeSW0Lb87kGpMiP8
=ZjRD
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jan_2014_17_00_41_+1100_JMhaqLsdVJWhU4p8--
