Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3J0Vxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:53:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59354 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754807Ab3J0Vxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:53:42 -0400
Message-ID: <1382910820.2994.50.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 6/8] uio: Pass pointers to virt_to_page(), not integers
From: Ben Hutchings <ben@decadent.org.uk>
To: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sun, 27 Oct 2013 21:53:40 +0000
In-Reply-To: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nSzYhhPDl2AsKtk24Q3z"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nSzYhhPDl2AsKtk24Q3z
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/uio/uio.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 11d4e0a..ef30ec9 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -601,6 +601,7 @@ static int uio_vma_fault(struct vm_area_struct *vma, st=
ruct vm_fault *vmf)
 	struct uio_device *idev =3D vma->vm_private_data;
 	struct page *page;
 	unsigned long offset;
+	void *addr;
=20
 	int mi =3D uio_find_mem_index(vma);
 	if (mi < 0)
@@ -612,10 +613,11 @@ static int uio_vma_fault(struct vm_area_struct *vma, =
struct vm_fault *vmf)
 	 */
 	offset =3D (vmf->pgoff - mi) << PAGE_SHIFT;
=20
+	addr =3D (void *)(unsigned long)idev->info->mem[mi].addr + offset;
 	if (idev->info->mem[mi].memtype =3D=3D UIO_MEM_LOGICAL)
-		page =3D virt_to_page(idev->info->mem[mi].addr + offset);
+		page =3D virt_to_page(addr);
 	else
-		page =3D vmalloc_to_page((void *)(unsigned long)idev->info->mem[mi].addr=
 + offset);
+		page =3D vmalloc_to_page(addr);
 	get_page(page);
 	vmf->page =3D page;
 	return 0;


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-nSzYhhPDl2AsKtk24Q3z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2LZOe/yOyVhhEJAQrkeBAAmHpiYT7oljGqKBjsGuKHkhDjzfaEgkne
r5EZufy3WkFmH8I5fciqTlMi+GYSGtYxbIj48WvwNtdt24HyliMYVtVK2dXfZxXg
IOaHTghR5IItK99pzsQNo7PqyeaL2R3u3plbnxIr1QxMOg3Zfpoy+AIkqqTvOdZ+
AAVTKUSFRja77UQp7TzfHOFbBAaCaroBKtbZw/Rt56YTuUCXPdNHMjQ3qe1kLIoI
6/n5nTuN8j+xHj3NtEksidV9WCnmGj7AsO2a9zFfi5sT6n+qOw/uM2TSMK4KKP3K
+OY5oPznN0Z49QV6yg5l5E+pN9lcRFzqMEKM975oBhp3g7mPgdfSIN8W+ym9M69D
4axs+TXgBqQuAK1CavrAR0DP64i+iLzxzba/rqF3FPF6A+qaZW05x657Ea4PT4uW
vS8hgqOu2y/WaoMFRPz96oLo2ayDrM31A896BLz3piC63K7dF706B4c7o8x70ILs
EJNMo/F8LuyfotZrQEtbTsj3qYwKVZa1mRD/XACnWwxUQRoIhqke7/J0x7ki3WyV
NVxnAv9VhIgPukgCOb2T9WWOVzNo5gkfO64xjCGCVBpFDQkIoaGqka/UvCafQ1zh
rykXh2ifhjjuZBUGauAZs5BjZMeB+4jmPf1J5Sp+oS36BLOTNONtLkaEO2hOytjc
G2C0uXVIbjE=
=IGlL
-----END PGP SIGNATURE-----

--=-nSzYhhPDl2AsKtk24Q3z--
