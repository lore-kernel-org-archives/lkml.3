Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3J0VwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:52:20 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59345 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754695Ab3J0VwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:52:19 -0400
Message-ID: <1382910737.2994.47.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 3/8] drm: Do not include page offset in argument to
 virt_to_page()
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Date: Sun, 27 Oct 2013 21:52:17 +0000
In-Reply-To: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-jamBaWaOqAKWqV666+D/"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jamBaWaOqAKWqV666+D/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

By definition, the page offset will not affect the result.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_vm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index b5c5af7..8ef6503 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -301,7 +301,7 @@ static int drm_do_vm_dma_fault(struct vm_area_struct *v=
ma, struct vm_fault *vmf)
=20
 	offset =3D (unsigned long)vmf->virtual_address - vma->vm_start;	/* vm_[pg=
]off[set] should be 0 */
 	page_nr =3D offset >> PAGE_SHIFT; /* page_nr could just be vmf->pgoff */
-	page =3D virt_to_page((dma->pagelist[page_nr] + (offset & (~PAGE_MASK))))=
;
+	page =3D virt_to_page(dma->pagelist[page_nr]);
=20
 	get_page(page);
 	vmf->page =3D page;


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-jamBaWaOqAKWqV666+D/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2LEee/yOyVhhEJAQq7xBAAno2SXJMQ2mHAWSemw+s9J233I7lphPuu
fXKyJRXgutVkBp+MnUjLILAI8wxuwzUZitSUzdxO0UfRWlXodkR1I0VZnWoNayP3
nqtaqlwwFA8IxdiXLEAjcmYfnhEeFvytgZKKMsRloc7t5oT0pSUDkeRtkkO1TbDP
mbfIpjNtJ2NIOWB/5Gaz8J4UmIn/EknMYMTPxqA20y48Xpk1uEMteFB5SBS5R0tH
iES3OC/6gT4Lz/LVerc5YO4il17liajhpu+THEmdAlAAEl9shSkhMbKq1MwsC2zZ
xA+UCkE4bYk28BdZRO+cBzUB/RUiwwhihxKDXvqgveScL5m/XhFzXuzIYAOPkfKx
0iScldfjFn3WDRLLYix3VOdMxKPSz3OGGTZJU6drtlMFOdGxKNCGrz1tVnmU5mKT
9bEyyfiwF+qry5NT5gaDFBByz6JfCkRnqSQ8lPiagO89129hdgy4aXHYV4S6iYQM
vt3AV2aNhZVq7eOtOMwZJnLruFgECydG7VnSlBj7mN7fXOVV2jSc5DcmDQOmYKqZ
3wT58VMUjED/HY3kUz1Im6aBV13gR2QjO5rb2IkHFvD5jdn6Fzzxf2hOFCcItEZQ
smZ/HV++gOaiXmM1mQY0MkM4hyMykhDbTXWJNK3pahCrFDoE6oUpSIr1NzmIgZc3
Wgmk646EcZ8=
=B5p5
-----END PGP SIGNATURE-----

--=-jamBaWaOqAKWqV666+D/--
