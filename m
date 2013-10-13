Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab3JMKH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 06:07:57 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:34843 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab3JMKHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 06:07:55 -0400
Message-ID: <525A70EF.8000503@gmail.com>
Date: Sun, 13 Oct 2013 18:07:43 +0800
From: Lennox Wu <lennox.wu@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>
Subject: Re: [PATCH 25/34] score: handle pgtable_page_ctor() fail
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com> <1381428359-14843-26-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1381428359-14843-26-git-send-email-kirill.shutemov@linux.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="er0PeqXieLTmsBfs7UNSVDVx4wcWwM5RK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--er0PeqXieLTmsBfs7UNSVDVx4wcWwM5RK
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: quoted-printable

Thanks.

Acked-by: Lennox Wu <lennox.wu@gmail.com>

=A9=F3 2013/10/11 =A4W=A4=C8 02:05, Kirill A. Shutemov =B4=A3=A8=EC:
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Chen Liqin <liqin.chen@sunplusct.com>
> Cc: Lennox Wu <lennox.wu@gmail.com>
> ---
>  arch/score/include/asm/pgalloc.h | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/arch/score/include/asm/pgalloc.h b/arch/score/include/asm/=
pgalloc.h
> index 059a61b707..2a861ffbd5 100644
> --- a/arch/score/include/asm/pgalloc.h
> +++ b/arch/score/include/asm/pgalloc.h
> @@ -54,9 +54,12 @@ static inline struct page *pte_alloc_one(struct mm_s=
truct *mm,
>  	struct page *pte;
> =20
>  	pte =3D alloc_pages(GFP_KERNEL | __GFP_REPEAT, PTE_ORDER);
> -	if (pte) {
> -		clear_highpage(pte);
> -		pgtable_page_ctor(pte);
> +	if (!pte)
> +		return NULL;
> +	clear_highpage(pte);
> +	if (!pgtable_page_ctor(pte)) {
> +		__free_page(pte);
> +		return NULL;
>  	}
>  	return pte;
>  }



--er0PeqXieLTmsBfs7UNSVDVx4wcWwM5RK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEVAwUBUlpw8hIBnItolwGVAQL/sQf/QneZCl4KA0apRznG3MOEsettXq6ekB7+
y0qtw81SJ/fUEVu9kPCzQByOYwRdgAoiSObTUKoFzzUQkCuHSm7AmZF1YUE2v7ne
E2pMXv/haP0sNj8ZBMCYTZa/6TcC5sVsY1Rxwo0yB+BqxXcRh1pg37SIm/6Clf5i
7iHWkGNo5o+egq6bc7MJ9XtxejIahi202BnPZdGWeVUH8amxplDcmvd0WNpkArRd
ds/39+NASiAJzP6WvNM5vBdKJccoEnkm7PJw13x5CbRs8COXexxZTQDoOPuBhZem
P1Bloy85A0/k2S2nQc4Ql2jRnTZLaQIKUUEed2Wy5FuW3VOz2cBivg==
=w5X6
-----END PGP SIGNATURE-----

--er0PeqXieLTmsBfs7UNSVDVx4wcWwM5RK--
