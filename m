Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab3KOFAK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:00:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:52152 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab3KOFAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:00:07 -0500
Date: Fri, 15 Nov 2013 16:00:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: manual merge of the akpm tree with the sparc-next
 tree
Message-Id: <20131115160000.dffe5b8a2db3ca60c5c01e55@canb.auug.org.au>
In-Reply-To: <20131115155733.b05306db95bc04bcb76c83f9@canb.auug.org.au>
References: <20131115155733.b05306db95bc04bcb76c83f9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Nov_2013_16_00_00_+1100_XIhpN2ekheZHgHDY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Nov_2013_16_00_00_+1100_XIhpN2ekheZHgHDY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Forgot to cc Dave]

On Fri, 15 Nov 2013 15:57:33 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Hi Andrew,
>=20
> Today's linux-next merge of the akpm tree got a conflict in
> arch/sparc/mm/init_64.c between commit 37b3a8ff3e08 ("sparc64: Move from
> 4MB to 8MB huge pages") from the sparc-next tree and commit "sparc:
> handle pgtable_page_ctor() fail" from the akpm tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/sparc/mm/init_64.c
> index bd6430ded69f,d6de9353ee11..000000000000
> --- a/arch/sparc/mm/init_64.c
> +++ b/arch/sparc/mm/init_64.c
> @@@ -2563,16 -2511,21 +2563,16 @@@ pte_t *pte_alloc_one_kernel(struct mm_s
>   pgtable_t pte_alloc_one(struct mm_struct *mm,
>   			unsigned long address)
>   {
>  -	struct page *page;
>  -	pte_t *pte;
>  -
>  -	pte =3D get_from_cache(mm);
>  -	if (pte)
>  -		return pte;
>  +	struct page *page =3D alloc_page(GFP_KERNEL | __GFP_NOTRACK |
>  +				       __GFP_REPEAT | __GFP_ZERO);
> - 	pte_t *pte =3D NULL;
>  =20
> - 	if (page) {
> - 		pgtable_page_ctor(page);
> - 		pte =3D (pte_t *) page_address(page);
>  -	page =3D __alloc_for_cache(mm);
> + 	if (!page)
> + 		return NULL;
> + 	if (!pgtable_page_ctor(page)) {
> + 		free_hot_cold_page(page, 0);
> + 		return NULL;
>   	}
> -=20
> - 	return pte;
> + 	return (pte_t *) page_address(page);
>   }
>  =20
>   void pte_free_kernel(struct mm_struct *mm, pte_t *pte)

--Signature=_Fri__15_Nov_2013_16_00_00_+1100_XIhpN2ekheZHgHDY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJShapUAAoJEMDTa8Ir7ZwV4hgP/2gWEStRKpTrb6TSrIsi/80C
yklvNusGO+wTKodck1nQLJxyBKOI3xQcjJrPKMHCl3ZQIXdwMHMzbwcJFjNiz7Px
pWLmCnTy7D29mu8TGkmyp66a+oeBcFAjDpINrA2qEJ1aFoTZhQNLSDVHVCr+6Zlb
n/Dk7DoRXg9UN9U1Lo1V5R1WYxmqXrpPApnhWJLDBti0nTmJBtdZuuggA6bZEauJ
W2EFClr08jpo2w13TtWdNmH8j8bNBUOd5QVKnN6slqI0TzhgRvPEchpE1oaKqlzi
ahkP0NhU2wjS+ploTSq+AdlEdIIZ8dhY0ujxrccnEfS0oP+Cp/O67JEw0zz9+2t6
Ob8Gw1vPm5xP+4xd/+2f4CJjSCwgqVmrUdY63IanOozCZF0PQvVdwMR6HI9u32Kq
8R5pY6ZvA9XtLQs1OnqoUTN0W7LRJUNtnaL2k6EkVDeD4x63k18rND0anDBobWeT
87mwBcxySzfqNgOgYieIJLEpeuxzw8i4Pd3+DWxSlbvsq/QrpV4uY9Pu7/Mg5X7F
nap/tuihILbK2tQiyeqebHyR7v2u53U+QeQB3UNPLrYzmVY39RqfBllD5VW7zqFo
BrYOSl5SWyKB+TNflf/dRBdiTz4wXHhuftosXtUNMg80vV2CPAET16NPYC+QJHZV
kw6gxSJOhvBw+zAaBeQI
=iboD
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Nov_2013_16_00_00_+1100_XIhpN2ekheZHgHDY--
