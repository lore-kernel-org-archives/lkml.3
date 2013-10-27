Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3J0Vwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:52:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59348 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754498Ab3J0Vwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:52:46 -0400
Message-ID: <1382910759.2994.48.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 4/8] drm: Pass pointers to virt_to_page()
From: Ben Hutchings <ben@decadent.org.uk>
To: David Airlie <airlied@linux.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Date: Sun, 27 Oct 2013 21:52:39 +0000
In-Reply-To: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uD6OnAWtuDAyjHHlbp4O"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uD6OnAWtuDAyjHHlbp4O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/drm_pci.c | 4 ++--
 drivers/gpu/drm/drm_vm.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index 1f96cee..4c47954 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -80,7 +80,7 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, =
size_t size, size_t ali
 	/* Reserve */
 	for (addr =3D (unsigned long)dmah->vaddr, sz =3D size;
 	     sz > 0; addr +=3D PAGE_SIZE, sz -=3D PAGE_SIZE) {
-		SetPageReserved(virt_to_page(addr));
+		SetPageReserved(virt_to_page((void *)addr));
 	}
=20
 	return dmah;
@@ -103,7 +103,7 @@ void __drm_pci_free(struct drm_device * dev, drm_dma_ha=
ndle_t * dmah)
 		/* Unreserve */
 		for (addr =3D (unsigned long)dmah->vaddr, sz =3D dmah->size;
 		     sz > 0; addr +=3D PAGE_SIZE, sz -=3D PAGE_SIZE) {
-			ClearPageReserved(virt_to_page(addr));
+			ClearPageReserved(virt_to_page((void *)addr));
 		}
 		dma_free_coherent(&dev->pdev->dev, dmah->size, dmah->vaddr,
 				  dmah->busaddr);
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 8ef6503..93e95d7 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -301,7 +301,7 @@ static int drm_do_vm_dma_fault(struct vm_area_struct *v=
ma, struct vm_fault *vmf)
=20
 	offset =3D (unsigned long)vmf->virtual_address - vma->vm_start;	/* vm_[pg=
]off[set] should be 0 */
 	page_nr =3D offset >> PAGE_SHIFT; /* page_nr could just be vmf->pgoff */
-	page =3D virt_to_page(dma->pagelist[page_nr]);
+	page =3D virt_to_page((void *)dma->pagelist[page_nr]);
=20
 	get_page(page);
 	vmf->page =3D page;


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-uD6OnAWtuDAyjHHlbp4O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2LJ+e/yOyVhhEJAQpE4w/8CLjEhWV6G99Fflqr7jXuZr4Lj/Ryfu3z
K6qQ4smx03vg2nXSwM9ur3/GjdeycWbD+lUwAql4lJDhRY26uMciH8S3IwGCUoB3
kVREQ8Udk3TZAJb0PRvfrFQSRsHAL6mWxRZhQRwAMfEe2poKJg+4UeYcVV3Bv6gL
rfLK0cQRvDNw6nOudHcI+yKM7LBgFhXi5/gMY0zq5DHC7t55fQABFPVgwN3L2494
h/Snq5qr/knUvojQFWSe93NXBavFYRBGselxqHcqeSBkcjgvZdUKbYq1PC56K4o0
fdXh2l3Jeb8o0pOGjSCiwT2xHv3WgrHDMEjZ0wNNeH6ABxuSCoksUAnsKUMjPIk9
Tlpy1M7Up4YpRDyCHzSl7eo3W1HOBwVd5zHG+f4qEaj8PRjrVD89DedAHwFYGrwX
3OY8r6u/RF0rrmK6IVDStwwcNHiAlf15BZjBhyGiIPxeJRstHXG5EOyac7a6lOi6
zvXEn7MSosu1jJbLxKUHvX6zzZbXqxJamh2HT+vA202x7Feulots/m0dZx5E7Ugp
b3Q8rUGQZvxt3vs/L65gowxtbOb4jOCPsYj7LdeCUTYWm8elH5Io7L/aYTOy3zvO
g6ZOPG5nIXGagX8a42LWqnp/UKujxIEmdMGNheaahH1IwhqW7zwOHqP38FSe7Yu+
FJqImZTqqtU=
=e/Px
-----END PGP SIGNATURE-----

--=-uD6OnAWtuDAyjHHlbp4O--
