Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3KRDTv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 22:19:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44315 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3KRDTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 22:19:44 -0500
Date: Mon, 18 Nov 2013 14:19:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20131118141933.7314374b0157183e0613599d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Nov_2013_14_19_33_+1100_bzKOIlSusROffW/K"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Nov_2013_14_19_33_+1100_bzKOIlSusROffW/K
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

arch/sparc/mm/init_64.c: In function 'pte_alloc_one':
arch/sparc/mm/init_64.c:2568:9: error: unused variable 'pte' [-Werror=3Dunu=
sed-variable]

Caused by the merge between commit 37b3a8ff3e08 ("sparc64: Move from 4MB
to 8MB huge pages") and commit 1ae9ae5f7df7 ("sparc: handle
pgtable_page_ctor() fail") (I had the following merge fix in linux-next,
but it didn't seem to propagate upstream - may have forgotten to point it
out :-().

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 18 Nov 2013 14:16:40 +1100
Subject: [PATCH] sparc64: merge fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/mm/init_64.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 6b643790e4fe..5322e530d09c 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -2565,8 +2565,6 @@ pgtable_t pte_alloc_one(struct mm_struct *mm,
 {
 	struct page *page =3D alloc_page(GFP_KERNEL | __GFP_NOTRACK |
 				       __GFP_REPEAT | __GFP_ZERO);
-	pte_t *pte =3D NULL;
-
 	if (!page)
 		return NULL;
 	if (!pgtable_page_ctor(page)) {
--=20
1.8.4.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Nov_2013_14_19_33_+1100_bzKOIlSusROffW/K
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSiYdJAAoJEMDTa8Ir7ZwVP3EP/iEWWcy6I98Aul5e5aUwkrh0
RmsF8jWARtOEG0G7wevEERD28t8IH8t0EUr1cTyYQIw+9HEdAacvt062QB/VVsMW
xgNcnpMrVSR/ajUKsBMVFHKWpNq6Acs/5OWxAw6AaBcG98ii4IwvgC7h47pNf1m9
AhcxJ91Oyc0wKXkL7K/4MlQLVxwR8NpEPjQrHkM7AgTRUDtyDxQSQFxJGsk6NINU
nENv4Pv7KqbNfn0LNR/XzdDHV7loRpL69vSrYS/3u/V/Nwx2mj9qAE/8jq3Xg3Zk
nANX5kCGpfFeGlIiIZgKBjfjemro7FHbMblZvcO1EaTfdNmrexpn4TwmPzTpK9hw
FGwkkMUAapaNq5o4asH5ViDjQ5ljQWqAekegLXiSuiJ6CDsgbhMUv6nA9KhLASo5
0X8UPFY9KSiSU3RtOFOIgpszR4qWhLL+zgK/bEDGFQd6kGjlqWEeJiKfQ6bfxjj4
4ZTJUaKVWLtRY4FcZEM8dxvDiDNugsKTtvURpkRfBYnpnrA3Vg77Ou7wWMrlyfmH
bsFvoBFjRL6eaLRxC1QZaUZM+hAg30umpbVYiIZzEyWpS5qVkRU9yE9WYD7KP4sE
ugdT9gCucOUzciNTnVfgu2RSZE7U+MOZDhRX6/ougNodGBkXg55lPO3vGoqPd/Us
rK8p2I6H1lahaTkzL2cn
=JXcp
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Nov_2013_14_19_33_+1100_bzKOIlSusROffW/K--
