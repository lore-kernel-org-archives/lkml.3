Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab3I0ICk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:02:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46723 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3I0ICd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:02:33 -0400
Date: Fri, 27 Sep 2013 18:02:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tang Chen <tangchen@cn.fujitsu.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20130927180219.f15e4e7fa60ee7ffb929abef@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__27_Sep_2013_18_02_19_+1000_PpK5qOhWuX93smtp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_Sep_2013_18_02_19_+1000_PpK5qOhWuX93smtp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/mm/init.c: In function 'memory_map_bottom_up':
arch/x86/mm/init.c:512:18: error: 'STEP_SIZE_SHIFT' undeclared (first use i=
n this function)
    step_size <<=3D STEP_SIZE_SHIFT;
                  ^

Caused by commit 21376f622b03 ("x86/mem-hotplug: support initializing
page tables in bottom-up mode") interacting with commit 6979287a7df6
("x86/mm: Add 'step_size' comments to init_mem_mapping()") from the tip
tree.

I added the following merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 27 Sep 2013 17:58:55 +1000
Subject: [PATCH] x86/mem-hotplug: fix for bad merge

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/mm/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index cb77179..58bb4e9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -509,7 +509,7 @@ static void __init memory_map_bottom_up(unsigned long m=
ap_start,
 		start =3D next;
=20
 		if (new_mapped_ram_size > mapped_ram_size)
-			step_size <<=3D STEP_SIZE_SHIFT;
+			step_size =3D get_new_step_size(step_size);
 		mapped_ram_size +=3D new_mapped_ram_size;
 	}
 }
--=20
1.8.4.rc3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__27_Sep_2013_18_02_19_+1000_PpK5qOhWuX93smtp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSRTuPAAoJEMDTa8Ir7ZwVZCoP/R10JDMXWwSOifoFh0jXVgQk
hsANilCSb5Y0qV3aLaZR+WRW/fKipK0J919bqZtwZ5hIUdd6pJLtQdHGVvS6aFPF
10g0dRwEGvCl2WLClEj8/omcf/bN0N5Mi4aL+XJAuqM8D16PVAetu1OR1yzzKHiA
SfbuwGE+2uuMciLtoRcvXUOl4vzwFcVRWMg/8+amPA3HUCg8EbOFzdKNXduw3Zi2
avzN5Y/OmvWsO0jVpg8JZSs9AM/0YbyLbY+Tkue1CvVbkyuEX8HW2dUeSuQLLEw8
GwvR4mrlq6XQZ2tnjyi7oWpY4YGQhMT5L6ZXryKMQ+IG1fPEm6iv1Mi+6SnaJdFi
/4ea7ayG224Pktq8RXTu62OF4ddP9SexQzLa3/JVEIctD7gAPwGQFuUQkbDaiuvg
FYGnv4CGXM8mMgz7xfdwp28sZ5RvhNJvMVJNFt6X3jXnyvGAjTW2g7UbW1AKQZrf
0plCAnxMerDQV5zDQ7jIfBPxpX5qQ4GwW3y8EvMy1337o4nc6a3IU8dXgWd0NmP2
WPxCgiUTqOJ5jKZI+msDO0n48svx/U2frZlD+XGIjeZQj4XvQyHhaeA4xIy9Q6HP
gAh1iZKygJVvmSHDj2TvFDFCo0nkga41SRXeWhcEXMDEI4YyKabIeGBNbULMTmFI
pI9hUrOv9XUzrU195mXJ
=5U1N
-----END PGP SIGNATURE-----

--Signature=_Fri__27_Sep_2013_18_02_19_+1000_PpK5qOhWuX93smtp--
