Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3C0Eni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 00:43:38 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44659 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab3C0Enh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 00:43:37 -0400
Date: Wed, 27 Mar 2013 15:43:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20130327154323.ae6826a4627560fc7ed8491e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Mar_2013_15_43_23_+1100_lZ4p.6ogAuldbld3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Mar_2013_15_43_23_+1100_lZ4p.6ogAuldbld3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/mm/numa.c: In function 'setup_node_to_cpumask_map':
arch/powerpc/mm/numa.c:72:2: error: expected ';' before 'for'
arch/powerpc/mm/numa.c:65:15: error: unused variable 'node' [-Werror=3Dunus=
ed-variable]

Caused by commit de9a59a3ebd4 ("powerpc/mm/numa: use setup_nr_node_ids()
instead of opencoding").

I added this fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 27 Mar 2013 15:39:56 +1100
Subject: [PATCH] powerpc/mm/numa: use setup_nr_node_ids() fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/mm/numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 7574ae3..b8020dc 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -66,7 +66,7 @@ static void __init setup_node_to_cpumask_map(void)
=20
 	/* setup nr_node_ids if not done yet */
 	if (nr_node_ids =3D=3D MAX_NUMNODES)
-		setup_nr_node_ids()
+		setup_nr_node_ids();
=20
 	/* allocate the map */
 	for (node =3D 0; node < nr_node_ids; node++)
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__27_Mar_2013_15_43_23_+1100_lZ4p.6ogAuldbld3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRUnjrAAoJEECxmPOUX5FEgNwQAI0RsVO7kqbNh5dDS44gogxK
OGABd3HnuBDKL6mhkN/Xb0KUzOjaKl0BK8aInAhQceuwoAV663Y/NPIArFXHIHHy
x/KTH97Zofpu26MUrW+MrWmM+fnhd6qfbWrycSoSXHLftD2fl/W+wxBkv7ljn4yq
jUO0rax2Hn92ZmLptBTBGjC5sEvRmLhlt++lU4b+Gh+x+0l/mMyId4CZZecSsL2z
uf5t7Xl5NaRFI6VqtoUY2XDSgW6oZXVqPyRMRjDBqtH4TgLHQdLsjEUpBkPf442B
2x8JNLSRZUFc60acXbMRquUfoNBlSdl8q/BcCIaA+ex/YuenIi7/VOdf5MKkzNoU
MmFrCd60/crNzXvTpbtLnWNHeHt5hWr9xgBG2dhtkcAs4+rUEs2L2FU7egNoQVf7
v/v8rRExzsKKn0pgeTitssP4YiaLOKXSwfk9cr6oAeFvk/SP04+Sd9NcjjNnJqfO
neVQBmAoQC27Yw7iZGr1JutnxJlymAh7nkWvyG3e4s2Vfr0wPfosummxMyR4sN8e
1NZ8o9K1TW51eIoEfmCHmvPfO8RfJaVlJ6d9SjC2KBQIzooZNrI7scIK57TQu4Xd
giQz0aOZfmMNHC/0nGxX7VOHXr5pTGZf5O/G+G8ieppbNu6Dzce1fxHWFZDXeFQc
GfZPEW8WaGhr03S8T1Te
=RzFV
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Mar_2013_15_43_23_+1100_lZ4p.6ogAuldbld3--
