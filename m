Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab3FFHZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 03:25:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59100 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3FFHZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 03:25:43 -0400
Date: Thu, 6 Jun 2013 17:25:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: linux-next: build failure after merge of the final tree (akpm tree
 related)
Message-Id: <20130606172541.fb4748ed039278a39c444bfe@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Jun_2013_17_25_41_+1000_ibg=d8L_6Ber1=8t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Jun_2013_17_25_41_+1000_ibg=d8L_6Ber1=8t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
failed like this:

mm/page_alloc.c: In function 'free_area_init_node':
mm/page_alloc.c:4801:2: error: implicit declaration of function 'get_pfn_ra=
nge_for_nid' [-Werror=3Dimplicit-function-declaration]

Caused by commit 55ce7b776831 ("mm: remove duplicated call to
get_pfn_range_for_nid()").  This build does not have
CONFIG_HAVE_MEMBLOCK_NODE_MAP defined, so that get_pfn_range_for_nid() is
not defined.  It used to be called from within the protection of
CONFIG_HAVE_MEMBLOCK_NODE_MAP.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Jun_2013_17_25_41_+1000_ibg=d8L_6Ber1=8t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRsDl1AAoJEECxmPOUX5FEgOgP/01YOIOkuUmrPLjaY3ckvG0A
2xppRaMNH91QpKXJNuzoO/TbgyNMZMj8ln44npWqYO/tx9gRnOt0pLCDSzAMKLQP
6JgLnRrrTOQFdISxX9ezXjHtskF/Lms+Gc4L8mOrd/N337qIY040Bhq014K+O2hz
0ZFpmyJxpDrq6IQWmsNT4bMldBE6RZSgkMSWePr1xLyCF4CTyV3oT9/dGezslI0s
MxOuGRSj228J/S1wPR9zNj8y4/pndxTlOSJo1a5tMz/2DKDHfl9P2nP3G7oElRO1
F9/caYPdeRXdlUQQRqv2tp5yFRBMxAsn+OQZ6JIMIPhZehOwz7cQEZhcEhnunMaW
VS+KR2Xb7vVMcq+Jfay0ftIeQOo8tQN1A39E9nYqHfkg191mZt2OygaLUcWKDMmt
8anyOg0dclMmkqU7L+aVbKcxDOedR3tQsJv4eiiKm7E50o4CbyE6y6wYQQS+vAnj
cXz+vi4nXQV0NqOAkMFrvMUyHeJc16DrgWrFTIDfBmBZOctkkTMSv2cdZoMeSiZo
KUP29sc3blI9qWBHku2ctPzW8ZXHUIQ+N1JYrfn211M6t9u8exW2HV9k6i47bTIk
CRDZ9mpmC7rk9FeMtZ6aTJ1PwS/zSfTPVYUe207/BZEiVbptlrem6uNLLvCMwGOt
bAaIDK3SXFR4bC/TTXDd
=c2Da
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Jun_2013_17_25_41_+1000_ibg=d8L_6Ber1=8t--
