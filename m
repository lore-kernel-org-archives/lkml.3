Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbaHZGfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:35:11 -0400
Received: from ozlabs.org ([103.22.144.67]:50920 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754384AbaHZGfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:35:10 -0400
Date: Tue, 26 Aug 2014 16:35:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140826163502.33a837fc@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hB8BQbDSsyc2nlAvML6icyi"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hB8BQbDSsyc2nlAvML6icyi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

./usr/include/linux/prctl.h:132: found __[us]{8,16,32,64} type without #inc=
lude <linux/types.h>
In file included from /usr/include/x86_64-linux-gnu/sys/prctl.h:23:0,
                 from Documentation/prctl/disable-tsc-test.c:14:
./usr/include/linux/prctl.h:132:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:133:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:134:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:135:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:136:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:137:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:138:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:139:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:140:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:141:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:142:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:143:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:144:2: error: unknown type name '__u32'
./usr/include/linux/prctl.h:145:2: error: unknown type name '__u32'
In file included from /usr/include/x86_64-linux-gnu/sys/prctl.h:23:0,
                 from Documentation/prctl/disable-tsc-ctxt-sw-stress-test.c=
:19:
./usr/include/linux/prctl.h:132:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:133:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:134:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:135:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:136:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:137:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:138:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:139:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:140:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:141:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:142:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:143:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:144:2: error: unknown type name '__u32'
./usr/include/linux/prctl.h:145:2: error: unknown type name '__u32'
make[3]: *** [Documentation/prctl/disable-tsc-test] Error 1
make[3]: *** [Documentation/prctl/disable-tsc-ctxt-sw-stress-test] Error 1
In file included from /usr/include/x86_64-linux-gnu/sys/prctl.h:23:0,
                 from Documentation/prctl/disable-tsc-on-off-stress-test.c:=
19:
./usr/include/linux/prctl.h:132:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:133:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:134:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:135:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:136:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:137:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:138:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:139:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:140:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:141:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:142:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:143:2: error: unknown type name '__u64'
./usr/include/linux/prctl.h:144:2: error: unknown type name '__u32'
./usr/include/linux/prctl.h:145:2: error: unknown type name '__u32'
make[3]: *** [Documentation/prctl/disable-tsc-on-off-stress-test] Error 1
make[2]: *** [Documentation/prctl] Error 2

Caused by commit 802d335c0f7f ("prctl: PR_SET_MM -- introduce
PR_SET_MM_MAP operation").

I have reverted that commit (and commit c2e04b241d40
("prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v3-fix") that
follows it) for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Sig_/hB8BQbDSsyc2nlAvML6icyi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/CqbAAoJEMDTa8Ir7ZwV5QkP/1JZjUlUwe8PtRlOpLvYbk8e
B+mvt8UbjaXPJSgFM9gEzLAVhXPLlei4HquSCEEbHp3scXPVBQTRE9ZDbgNgnJ6P
U+Xc3wekv76IPSalu1Wyl9mObzNi4IXFC40ahuJPafFI5pvZnTtHOG2A/KaHtJBJ
zWs9YLlwuEIhmvs+GKTHOhq9uSsACMgYe3RBoQ5yfKc5zlsWHywmzkzhx+Vi8im2
lqYgfyWFrmq/YnOzqBtUBsJPOswpEfOy/+gX1DgTr3IwfUZyQVk1LKKZlnExTnKo
8xvfd/0k/aspIFaxnVLjX9Kq74yqsgBC+cUzfuxzRFyy5VKkAf9v3N9qllBvCV8T
jTKNP/41o7PdKyPGfYz7LRHNv5IHETXecqkaKiXK7hlMtodajSu3v/2dtwex89/R
3Z86O6/Q5NmQfwyiEMpqwFmL2Gp4ej+viIruz7DiQZRWC3hYwCmxC+pICcNyfoNw
o1u+3Eae0GwD3hahCPJmHu7BYbhsHSYdGF/8TOgurAqxWkbZ/5mkJWBFPh48j81a
uG7/GW8bcPHC1ruo94bHYpGmQLSrPdDb4KZ5aWHZk6VIXAwqhP79+mav3oopV/MQ
Sg4SnWr6XN/xCYanPYjSx2Aom9VEMTACzxQ65ROwZpP6xHZrdDyO7zbn/xCsoNn/
n/7jV0GlNje3QUpYpTia
=lk8d
-----END PGP SIGNATURE-----

--Sig_/hB8BQbDSsyc2nlAvML6icyi--
