Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbaDPXya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 19:54:30 -0400
Received: from ozlabs.org ([103.22.144.67]:59461 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaDPXy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 19:54:28 -0400
Date: Thu, 17 Apr 2014 09:54:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-Id: <20140417095419.de828de2cd490711d5e4de7a@canb.auug.org.au>
In-Reply-To: <20140416192135.GY7292@suse.de>
References: <20140416151956.b3388ef9c11c6c58b535186f@canb.auug.org.au>
	<20140416192135.GY7292@suse.de>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Apr_2014_09_54_19_+1000_Wb10tmYVmPyEkMVR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Apr_2014_09_54_19_+1000_Wb10tmYVmPyEkMVR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mel, Andrew,

On Wed, 16 Apr 2014 20:21:35 +0100 Mel Gorman <mgorman@suse.de> wrote:
>
> On Wed, Apr 16, 2014 at 03:19:56PM +1000, Stephen Rothwell wrote:
> >=20
> > After merging the akpm-current tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> >=20
> > In file included from mm/vmscan.c:50:0:
> > include/linux/swapops.h: In function 'is_swap_pte':
> > include/linux/swapops.h:57:2: error: implicit declaration of function '=
pte_present_nonuma' [-Werror=3Dimplicit-function-declaration]
> >   return !pte_none(pte) && !pte_present_nonuma(pte) && !pte_file(pte);
> >   ^
> >=20
> > Caused by commit 851fe3337768 ("x86: define _PAGE_NUMA by reusing
> > software bits on the PMD and PTE levels").  This build does not have
> > CONFIG_NUMA_BALANCING set.
> >=20
> > I have reverted that commit for today.
>=20
> Thanks Stephen. A patch that should address the problem is on its way to
> Andrew.

I grabbed it out of mmots and added it to linux-next for today (in case a
new mmotm does not appear in time).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__17_Apr_2014_09_54_19_+1000_Wb10tmYVmPyEkMVR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTTxgwAAoJEMDTa8Ir7ZwVuZQP/Rd0Kl3z0eS1Im48eAWbUKH5
fu8vwbiIoMKRVHrb1hjKV4WmlD3EjhqmygxcouNbEc6XMvI7OMZBpJbvkm5TidG3
nt23CcBqpfgbqtgTkCOXQQ3hJc5fvurmyPOWT/pTEKYjCfrzq0dutyjRx52QECGP
l5Ggu5sE4rNOe++a+era/sFGUKp3FWQWvaKRVH5Dd1XwzvyECTiwyfhd7dUJHKCY
3+b8HhTaeRxR/COmhwUZPAMdlZz2oR7aGFCY571lGnfMOE4BsxMDnzLa6JFJ1azR
62u61WWZ9shgXwCOG8T95GH76O34UNi0oIfBH3Y/9OL2qA5yyyy/CxncWqp9+bfP
z+J6HwLb85ED5FeIgSxOHmuP0jy4tDEjbhy7JVL+0AeUfU6nn+1iWMYduskVqWev
FLWgJxujEIGnmdO353jdYTIikSqtuDsTO1Ug79r8ZOesuAsoo4a5L5SM7xHIVehB
D752NJW54G6yPvddrvXTApFXRe+UiDZGZ4Aka11G955LMtW+dRuteLGfH1E7lbfB
5fTks19vB9QGpnKLsRCcGoDFdDZ4N8QqbrT9s2XF4f+ecNLijyJvoq77LqlBM8WC
sj36EArJVTyzdn6HmXrDJFedAxGzcenTkMvc9AzZyrEQ8a6RKR6nSGdXM6VkwYti
JWd91SnUK3ICJ66wMbZn
=AC6r
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Apr_2014_09_54_19_+1000_Wb10tmYVmPyEkMVR--
