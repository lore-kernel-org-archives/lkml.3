Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754998Ab3ETAvo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 20:51:44 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:50359 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab3ETAvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 20:51:43 -0400
Date: Mon, 20 May 2013 10:51:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinod Koul <vinod.koul@intel.com>
Subject: linux-next: build failure after merge of the rr-fixes tree
Message-Id: <20130520105133.2bb50dcc4f8cf639f18f1a2c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_May_2013_10_51_33_+1000_NVYx_w=BE0S/dx2B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_May_2013_10_51_33_+1000_NVYx_w=BE0S/dx2B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr-fixes tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/dma/iovlock.c: In function 'dma_pin_iovec_pages':
drivers/dma/iovlock.c:98:21: error: dereferencing pointer to incomplete type
   down_read(&current->mm->mmap_sem);
                     ^
drivers/dma/iovlock.c:101:11: error: dereferencing pointer to incomplete ty=
pe
    current->mm,
           ^
drivers/dma/iovlock.c:108:19: error: dereferencing pointer to incomplete ty=
pe
   up_read(&current->mm->mmap_sem);
                   ^

Caused by commit 11227d242a8c ("Hoist memcpy_fromiovec/memcpy_toiovec
into lib/").  Clearly, net/tcp.h was indirectly including sched.h or
asm/current.h.  Changing inclusions is fraught with problems since people
do not follow Rule 1 (in Documentation/SubmitChecklist) consistently.  :-(

I have used the rr-fixes tree from next-20130515 (since the fix in
rr-fixes in next-20130516/7 conflicts with the better fix now in Linus'
tree) for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_May_2013_10_51_33_+1000_NVYx_w=BE0S/dx2B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRmXOVAAoJEECxmPOUX5FEI8cQAIq5hrbtWR7oiVtoyq0bZ63y
Fc8wzXD0hu9p/TCGSPekoJo0Q45Wu2u68wVGCgFH1HmmvOR21FDrEHVUxuDoBzKo
s0IZaEROKQ8FyE8FICL7GrODo6THsNRetYz1SGNjnRg02/Yhuppdc8xms0NGA4hc
UhVIFBK2oCHZeoMV2k5po7EcwRshH0z5AbVzO53pCimnsDwCve02h9rhaKt075mp
au5lIDhCnjokwtpSjiQwO4sGrJxqZ9Zt0UoUkJG01i02aNcGl2KGwFja+Un8qjwk
LUbaY2u+yUO/Fn/pP2RWLXt53jmyKVa0to+3K0lPp1+/4dzVWSUnVNmG1/ssz5pr
PUGwOXYD9ZuAjp7O4MEv6n+cVUQhhOLf3EOwT/Eh53PyBElpkfku84rxtZ8uMkJ/
5F336qBsi3GFHz2KI51zRuXP2p9b+nECcWB/vz5QjqWwnAaj+5ATuo6kphKVURgj
ND8llVsfkC4aKqifldibr/QCrkPreIBDIOUz4M0u0SlppSnhTu+MJo7r6MQXsmrp
7rd0LvwS9jMcN2vP1CknKNhd1CSlSuEgEl3V+T/mvqUySLXxAmbJWCre6l6oYjBk
bHPKn3caXr3ah+J4PlTTAUYoTNX2QjOd5Xm+xUQ/+VWpedY6Oepf0GNiOeRE9Zgh
Hsqk1Myr2y4JpC0+0I9Q
=pFZf
-----END PGP SIGNATURE-----

--Signature=_Mon__20_May_2013_10_51_33_+1000_NVYx_w=BE0S/dx2B--
