Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbbASHfv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:35:51 -0500
Received: from ozlabs.org ([103.22.144.67]:52314 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbbASHft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:35:49 -0500
Date: Mon, 19 Jan 2015 18:35:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20150119183543.54830c54@canb.auug.org.au>
In-Reply-To: <20150119182853.35f278b5@canb.auug.org.au>
References: <20150119182853.35f278b5@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/2=BAbkKR2DuO41PtdW_8SqC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/2=BAbkKR2DuO41PtdW_8SqC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 19 Jan 2015 18:28:53 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the akpm-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> mm/filemap_xip.c:304:2: error: unknown field 'remap_pages' specified in i=
nitializer
>   .remap_pages =3D generic_file_remap_pages,
>   ^
> mm/filemap_xip.c:304:17: error: 'generic_file_remap_pages' undeclared her=
e (not in a function)
>   .remap_pages =3D generic_file_remap_pages,
>                  ^
>=20
> Caused by commit 76f0255272b6 ("mm: drop vm_ops->remap_pages and
> generic_file_remap_pages() stub").  Looks like one was missed - grep is
> your friend.
>=20
> I have added this patch for today:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 19 Jan 2015 18:16:15 +1100
> Subject: [PATCH] mm: drop vm_ops->remap_pages and generic_file_remap_page=
s() stub fix
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  mm/filemap_xip.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
> index 0d105aeff82f..70c09da1a419 100644
> --- a/mm/filemap_xip.c
> +++ b/mm/filemap_xip.c
> @@ -301,7 +301,6 @@ out:
>  static const struct vm_operations_struct xip_file_vm_ops =3D {
>  	.fault	=3D xip_file_fault,
>  	.page_mkwrite	=3D filemap_page_mkwrite,
> -	.remap_pages =3D generic_file_remap_pages,
>  };
> =20
>  int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
> --=20
> 2.1.4

I then had to fix up the later patch "dax,ext2: replace the XIP page
fault handler with the DAX page fault handler" because the above line
was already removed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/2=BAbkKR2DuO41PtdW_8SqC
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUvLPTAAoJEMDTa8Ir7ZwV2GAP+QHTGwhu4L9U4uOpEo1AUNs4
OO8nxfOFHZ6GWjMAENPRhdYkD1Fx4/yuQzjtuyFiEnNOJKCOetRDYGZIjIjdXZdR
SmzYPXJcqImHRa97AiBBYpioZwGojDkpe5cOaHzi0HNLIjfuvBwc6L3DZjpopktk
fD4rEiz5R+0HXI7sqWKDXvADFU8usZEmKhdSVMKw7nb/DDltN+eckEUkHkFdVY1K
flocVyyZG5BaBaJDxzJwoyaPNY/rw/zYxBx3NXIf8rHb+PbjdY0fLafUuyfZBFs1
VZaFUIRxMsMVikOlQYQUwdcmjdFzt3QqXbNzlH5DitkEXlljcenWKzCVVv/DiD9o
fEQtRxp1yMy6RwUX/FJEaYVor6nliT9MEwHNogc5pz1cZklg7kXpdw1WjEY9jahW
w0Wz4zA/yD0EYsp1xG+dwq+38KRUo8ptZf2tTYdroZcKmilRcx1bTby6E7taC6il
lcb+nNCXNOtsa2/c7oUnvHgB+B4f4TbXptLlvb/uLzc3z3J2g34XLko2taPE5feF
nrFojQblaB1aqNRqcU3TwYn9CQXh/9JqL1OOgXafXEBtwW30AoBYUphUIvfFXIfm
FvoXKbEB0uBJNf9ZMAqNGe1OEQLN2dI7aWNc88L7aaoB8et6yDh72B4OqTZKWUlM
2AEb1w7rWXh8IbdXUvpL
=k2zC
-----END PGP SIGNATURE-----

--Sig_/2=BAbkKR2DuO41PtdW_8SqC--
