Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3FKSv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:51:58 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:35621 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3FKSv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:51:56 -0400
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.5+dev
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Chen Gang <gang.chen@asianux.com>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org
Subject: next-20130607 BUG: Bad page state in process systemd  pfn:127643
From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1370976639_1896P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 11 Jun 2013 14:50:39 -0400
Message-ID: <20589.1370976639@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1370976639_1896P
Content-Type: text/plain; charset=us-ascii

(This may or may not be collateral damage from my previous e-mail
regarding a BUG at lib/idr.c:424)

Saw several of these booting next-20130607 before it even got to
a single-user prompt.  -0603 is OK, so whatever did it is a recent patch.
Several people touched mm/page_alloc.c on 06/07, have CC'ed them.


[   18.302903] BUG: Bad page state in process systemd  pfn:127643
[   18.303005] page:ffffea000409dea8 count:0 mapcount:0 mapping:          (null) index:0xd
[   18.303127] page flags: 0x400000000000004c(referenced|uptodate|active)
[   18.303543] Modules linked in:
[   18.303691] CPU: 1 PID: 1 Comm: systemd Not tainted 3.10.0-rc4-next-20130607 #79
[   18.303810] Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A11 03/12/2013
[   18.303929]  0000000000000000 ffff88012d0cfbe0 ffffffff815ebdd7 ffffea000409dea8
[   18.304306]  ffff88012d0cfbf8 ffffffff810d615e ffffea000409dea8 ffff88012d0cfc38
[   18.304658]  ffffffff810d6248 0000000000000001 400000000000004c ffffea000409dea8
[   18.305012] Call Trace:
[   18.305101]  [<ffffffff815ebdd7>] dump_stack+0x4f/0x9a
[   18.305198]  [<ffffffff810d615e>] bad_page+0xd8/0xf1
[   18.305300]  [<ffffffff810d6248>] free_pages_prepare+0xd1/0x1a9
[   18.305396]  [<ffffffff810d6902>] free_hot_cold_page+0x1f/0x103
[   18.305494]  [<ffffffff810d6a52>] free_hot_cold_page_list+0x6c/0xc1
[   18.305591]  [<ffffffff810dbedb>] release_pages+0x187/0x196
[   18.305689]  [<ffffffff810dc7a9>] __pagevec_release+0x1b/0x25
[   18.305787]  [<ffffffff810dc90e>] pagevec_release+0xe/0x10
[   18.305884]  [<ffffffff810dd05b>] truncate_inode_pages_range+0x19e/0x420
[   18.305982]  [<ffffffff810dd2ea>] truncate_inode_pages+0xd/0xf
[   18.306082]  [<ffffffff81127ae4>] evict+0xf6/0x1a8
[   18.306177]  [<ffffffff811282ef>] iput+0x1bc/0x1c9
[   18.306353]  [<ffffffff8111e9ca>] do_unlinkat+0x137/0x1a6
[   18.306452]  [<ffffffff81077dd6>] ? trace_hardirqs_on_caller+0x17d/0x199
[   18.306554]  [<ffffffff8124291e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   18.306651]  [<ffffffff8111f67d>] SyS_unlinkat+0x1d/0x29
[   18.306746]  [<ffffffff815f9dd2>] system_call_fastpath+0x16/0x1b
[   18.306914] Disabling lock debugging due to kernel taint

Hit a whole stream of these - identical tracebacks for different pfn's.
Almost continuous and in order, but not quite.

[   18.302903] BUG: Bad page state in process systemd  pfn:127643
[   18.307011] BUG: Bad page state in process systemd  pfn:127642
[   18.310766] BUG: Bad page state in process systemd  pfn:127641
[   18.319703] BUG: Bad page state in process systemd  pfn:127640
[   18.323423] BUG: Bad page state in process systemd  pfn:12763f
[   18.327138] BUG: Bad page state in process systemd  pfn:12763e
[   18.330855] BUG: Bad page state in process systemd  pfn:12763d
[   18.334574] BUG: Bad page state in process systemd  pfn:12763c
[   18.338279] BUG: Bad page state in process systemd  pfn:12763b
[   18.347197] BUG: Bad page state in process systemd  pfn:12763a
[   18.350913] BUG: Bad page state in process systemd  pfn:127639
[   18.354635] BUG: Bad page state in process systemd  pfn:127638
[   18.358346] BUG: Bad page state in process systemd  pfn:127637
[   18.362058] BUG: Bad page state in process systemd  pfn:127636
[   18.370971] BUG: Bad page state in process systemd  pfn:127651
[   18.374690] BUG: Bad page state in process systemd  pfn:127650
[   18.378400] BUG: Bad page state in process systemd  pfn:12764f
[   18.382101] BUG: Bad page state in process systemd  pfn:12764e
[   18.385811] BUG: Bad page state in process systemd  pfn:12764d
[   18.394732] BUG: Bad page state in process systemd  pfn:12764c
[   18.398433] BUG: Bad page state in process systemd  pfn:12764b
[   18.402173] BUG: Bad page state in process systemd  pfn:12764a
[   18.405885] BUG: Bad page state in process systemd  pfn:127649
[   18.409601] BUG: Bad page state in process systemd  pfn:127648
[   18.413318] BUG: Bad page state in process systemd  pfn:127647
[   18.422216] BUG: Bad page state in process systemd  pfn:127646
[   18.425928] BUG: Bad page state in process systemd  pfn:127645
[   18.429633] BUG: Bad page state in process systemd  pfn:127644
[   18.433343] BUG: Bad page state in process systemd  pfn:12765f
[   18.437049] BUG: Bad page state in process systemd  pfn:12765e
[   18.445974] BUG: Bad page state in process systemd  pfn:12765d
[   18.449701] BUG: Bad page state in process systemd  pfn:12765c
[   18.453405] BUG: Bad page state in process systemd  pfn:12765b
[   18.457123] BUG: Bad page state in process systemd  pfn:12765a
[   18.460827] BUG: Bad page state in process systemd  pfn:127659
[   18.464549] BUG: Bad page state in process systemd  pfn:127658
[   18.473475] BUG: Bad page state in process systemd  pfn:127657
[   18.477187] BUG: Bad page state in process systemd  pfn:127656
[   18.480893] BUG: Bad page state in process systemd  pfn:127655
[   18.484608] BUG: Bad page state in process systemd  pfn:127654
[   18.488326] BUG: Bad page state in process systemd  pfn:127653
[   18.497245] BUG: Bad page state in process systemd  pfn:127652
[   18.500956] BUG: Bad page state in process systemd  pfn:12766d
[   18.504687] BUG: Bad page state in process systemd  pfn:12766c
[   18.508412] BUG: Bad page state in process systemd  pfn:12766b
[   18.512127] BUG: Bad page state in process systemd  pfn:12766a
[   18.515842] BUG: Bad page state in process systemd  pfn:127669
[   18.524752] BUG: Bad page state in process systemd  pfn:127668
[   18.528467] BUG: Bad page state in process systemd  pfn:127667
[   18.532194] BUG: Bad page state in process systemd  pfn:127666
[   18.535923] BUG: Bad page state in process systemd  pfn:127665
[   18.539625] BUG: Bad page state in process systemd  pfn:127664
[   18.548532] BUG: Bad page state in process systemd  pfn:127663
[   18.552245] BUG: Bad page state in process systemd  pfn:127662
[   18.555960] BUG: Bad page state in process systemd  pfn:127661
[   18.559672] BUG: Bad page state in process systemd  pfn:127660
[   18.563383] BUG: Bad page state in process systemd  pfn:12767b
[   18.567155] BUG: Bad page state in process systemd  pfn:12767a
[   18.576067] BUG: Bad page state in process systemd  pfn:127679
[   18.579776] BUG: Bad page state in process systemd  pfn:127678



--==_Exmh_1370976639_1896P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUbdxfwdmEQWDXROgAQJnPg//TddAjF6MLO7jndY0H81M/GWfGbl4zlTr
pMITk2u5uigumZ3cbhQAEaB54fuHk1298KOR4iDnyTPhhyXiOUj2qWEbuagLT7sL
++aTpBajSkmBaMjBIlU7ogr1de9TnfissqLECmzGlYJ2LCEeec6z4K61/A71UnZ8
8UnMLAAhtmq8VYi5vzaQ5x7i6tzEJmbqw/QqKsVRNw14ZiScCH4II63LK/Wlu81j
PW6D+WU/HkgWBDAGJHWqFp0zsgpnZRiUF3EnEm+vpt/vIqUA8/LW3jvuegQEthin
OMp3gdtvI5dkSwTtAQN1f9sIzNHKg5Ujdc+l7ryQe9tJbb7gk5WgVzBhKtOmy7FI
OGdGZF66ZZsd1QlwmJHUneGfuzJ/nw1mNImd/CxctGPYmZKID0dR/083Wn97sxEy
KqXn2EBDHGbvXp3xdlLG4Eu6SgUACQ4Qb3tvUhpDHsWXkUhUcHfnt6q9lAsbu+YA
HaWG11r6FAPEJzUsxUzYu0jG9C3QdXV/iDfBir463vjRQdz8UCDf5S4FyGns0Q5a
KDDMYREAo9Y4TmLwgBTnQN3/GAEtaDWqvvImfaZsmgZBmAWAbPrBNzSD8V+S3p/S
hN3fS+9HXVIJRPpJoxsbjiolOSPsraq6kSEwYyWo5Yf0yrcVWBarHLTh6g6nBA/d
N2EWGXN7pIs=
=fR8e
-----END PGP SIGNATURE-----

--==_Exmh_1370976639_1896P--
