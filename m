Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542AbaDQHIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 03:08:44 -0400
Received: from ozlabs.org ([103.22.144.67]:36167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992AbaDQHIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 03:08:42 -0400
Date: Thu, 17 Apr 2014 17:08:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140417170831.53f065b7aa4ff04d30a79469@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Apr_2014_17_08_31_+1000_kLwOaZ_GSUro=Bsm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Apr_2014_17_08_31_+1000_kLwOaZ_GSUro=Bsm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from mm/shmem.c:61:0:
include/linux/swapops.h: In function 'is_swap_pte':
include/linux/swapops.h:57:2: error: implicit declaration of function 'pte_=
present_nonuma' [-Werror=3Dimplicit-function-declaration]

And a couple more similar.

Caused by commit 851fe3337768 ("x86: define _PAGE_NUMA by reusing
software bits on the PMD and PTE levels").

I have reverted this commit (and 7cb1c1eb682e "x86: define _PAGE_NUMA by
reusing software bits on the PMD and PTE levels -fix") for today and
wonder how many other architectures would be broken by this?  Everything
else with CONFIG_MMU set?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_Apr_2014_17_08_31_+1000_kLwOaZ_GSUro=Bsm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTT331AAoJEMDTa8Ir7ZwVWKQP/0XlBJGgcvC7oB1FCzfRpFvK
UrZJ1QzdGqhTh7hYZV5MXSAt4NOA6cl1GoW4MmBBpUzcDbW+V5dLfvb5z6si5mlb
D2NVEk47Yuitxmm690uDO0THfeLDBfv47bg+BFx6c1Hk2ZuBVS6KlnP/z3C32qq2
suxM65vdUP7QBp9SshxK+M25vR2ZxcvJuDRupUUWDjuA41hF6YYHB9GQ0nvA5lYL
KT1eaXXtrBFwl2n3Dc+CGOpLMZP615nAtfHWmFWFxaJ+lxj8QxHyO8STTJxhLGFE
C9ncbinBJ9esp0vcglDqwcsFs+cr8Uw25XcqTUnUDu1cIoGtdPHj35bVVL1BMISs
KbtC57pCQ5EFCmf/xBly4qTZU1MrsJV1vPmZ48Y/xk5hUuDiZJCub6xrymftSAg2
FBopoG26n8b17Gr/5ytLU61KOF3NQVtZQv2d+Hj9yVv91CjUxRpCeHJuedk2wTCk
hsMfB9KxvwzVcQaBwf+9sTfoKQBxI2ySYkvUcglMbH7uaFEHu6WRjdv97Sc/qYam
VC0+e978XumpNKJh2LIxKh0YhutfTBdB4YprRFNvCJrqXJsH8rG7ZPn+9uxa+tAG
PDGgVrk0Y6THviHbk8PtATmiCt0iiGqEhxASSKjFwbPvSHQGvHzXXbvyIx45HLdS
wF9iPTb9jujCz/xcB/JI
=O3O/
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Apr_2014_17_08_31_+1000_kLwOaZ_GSUro=Bsm--
