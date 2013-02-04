Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3BDEPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:15:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:34975 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822Ab3BDEPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:15:08 -0500
Date: Mon, 4 Feb 2013 15:14:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: linux-next: build failure after merge of the xen-two tree
Message-Id: <20130204151456.ea053895a487a19013e4991f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_15_14_56_+1100_6MiWI.E5ZwRPTJcU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_15_14_56_+1100_6MiWI.E5ZwRPTJcU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

After merging the xen-two tree, today's linux-next build (x86_64
allmodconfig) failed like this:

arch/x86/xen/mmu.c: In function 'xen_init_mmu_ops':
arch/x86/xen/mmu.c:2213:10: error: 'struct x86_init_ops' has no member name=
d 'mapping'
arch/x86/xen/mmu.c:2213:39: error: 'xen_mapping_pagetable_reserve' undeclar=
ed (first use in this function)

Caused by commit 8154d7a6b9b9 ("xen/pvh: Implement MMU changes for PVH")
from the xen-two tree interacting with commit 6f80b68e9e51 ("x86, mm,
Xen: Remove mapping_pagetable_reserve()") from the tip tree.  The
automatic merge left the moved version of the above line intact while it
should have been removed (I assume).

I have added the following merge fix patch and can carry the fix as
necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 4 Feb 2013 15:08:33 +1100
Subject: [PATCH] xen: fix bad merge of arch/x86/xen/mmu.c

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/x86/xen/mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 824706a..3228600 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2210,7 +2210,6 @@ void __init xen_init_mmu_ops(void)
 		pv_mmu_ops.flush_tlb_others =3D xen_flush_tlb_others;
 		return;
 	}
-	x86_init.mapping.pagetable_reserve =3D xen_mapping_pagetable_reserve;
 	pv_mmu_ops =3D xen_mmu_ops;
=20
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__4_Feb_2013_15_14_56_+1100_6MiWI.E5ZwRPTJcU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDzXAAAoJEECxmPOUX5FEsqkQAKeja+gLS4+FC3qpSdbAQBnT
Uw2+AnfWQwLPJqXMJP255Oc9qj9LtMpOAd3bgH6a7MDBqQAYcx8s6H4UIFyS5Llx
UDDoJf7LOvX+ilCN5MbvReEeepv58Kb+cIATXn2nm/KgABfdhiyLYp2aDEnt2hF6
JQsjID5jduOOo7lyUJm2uUQhBxGWonhthgY1ILVEvdm0sgOH4IinkrIkiKaoafIC
/B6wOThQXWjW1b/bYSN1NSfNCjzV/uFIoLgKMxahW9p9anmoZbtaTlmPouWECp5i
wzfryw03LsLtsxwbFSWDNwkXHh8mJnypfCTIALW1b5Pk1dUG4ey22Wpr0grP0fN6
A2bjT8npSZYCYrZx+rRqsK7gwPffnCTx116MxpE22BHYIQtRi4GJ8AXfhyAa9Pn/
UkJXarWXJB7mvtwSuOePGAmA2q7iDZmLx8QGVuc+gzzd5xHMSY6W7hCgmXsWWiIJ
YwtlQi9vLVr8y+7larfOY3QoFYliEnrXBuSdEEMFtx/whjUbpQteB3zmvq/cIM6V
qf2EJQaE/1rBQMZBjVlHD9iLajJgPJfP5XNX2m7iKqBUlHRkkbuqZDGxem8u+Dig
4gK1CrfXHZCOLmtd8snSOet+BZc6bO7PuW2RIWS/LUSGtcDx5vycDWTb8mZzOWr/
Ng0JuFIMD6+5NMMsPyJL
=B/sW
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_15_14_56_+1100_6MiWI.E5ZwRPTJcU--
