Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbaIZHA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:00:28 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:35469 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaIZHA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:00:27 -0400
Date: Fri, 26 Sep 2014 09:00:23 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>, Liviu Dudau <Liviu.Dudau@arm.com>
Subject: Re: linux-next: manual merge of the pci tree with the asm-generic
 tree
Message-ID: <20140926070022.GA31002@ulmo>
References: <20140926132902.603fb9f8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20140926132902.603fb9f8@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 26, 2014 at 01:29:02PM +1000, Stephen Rothwell wrote:
> Hi Bjorn,
>=20
> Today's linux-next merge of the pci tree got a conflict in
> include/asm-generic/io.h between commit 4005bfe0aa45
> ("asm-generic/io.h: Implement generic {read,write}s*()") from the
> asm-generic tree and commit 3aad9c969c09 ("asm-generic/io.h: Fix
> ioport_map() for !CONFIG_GENERIC_IOMAP") from the pci tree.
>=20
> I fixed it up (the only difference is that the latter castes the result
> to void __iomem * - see below) and can carry the fix as necessary (no
> action is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc include/asm-generic/io.h
> index 3e976be3bdd4,2e2161b0c795..000000000000
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@@ -756,16 -329,11 +756,16 @@@ static inline void iounmap(void __iome
>  =20
>   #ifdef CONFIG_HAS_IOPORT_MAP
>   #ifndef CONFIG_GENERIC_IOMAP
>  +#ifndef ioport_map
>  +#define ioport_map ioport_map
>   static inline void __iomem *ioport_map(unsigned long port, unsigned int=
 nr)
>   {
> - 	return PCI_IOBASE + (port & IO_SPACE_LIMIT);
> + 	return (void __iomem *)(PCI_IOBASE + (port & IO_SPACE_LIMIT));

I don't think that cast is necessary. All instances of PCI_IOBASE are
already defined to be void __iomem *.

Or at least they were until a few days ago. Commit f3dfddf7bd85 (ARM:
Define PCI_IOBASE as the base of virtual PCI IO space) introduces one
variant for ARM which isn't actually void __iomem *. I think what we
should do is standardize the type of PCI_IOBASE.

So how about we remove commit 3aad9c969c09 (asm-generic/io.h: Fix
ioport_map() for !CONFIG_GENERIC_IOMAP) and move the cast to void
__iomem * to Liviu's definition of PCI_IOBASE for ARM?

Thierry

--liOOAslEiF7prFVr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJQ8GAAoJEN0jrNd/PrOhgp0P/iQfL2lRP/iNpYWCp2t2RP05
1UO2XizDoFE6IBJva2t4pSHLDXkEXP8b6nF09hu82Jv7sT1ppHJ0IGLGs+xNMt0T
kODdqDhUEeRcSztcQ0CzsigFktwgJswPxZhtk8HV4/iitsF6YFUBaJumRA7pNXqG
T/sJdXmu2THvR6WOnOJH3at53Hy8mkuxlSYAm988fK7Hq7voF3nzVtrhuU8vxwku
Ie3Kbu6XHvpdhKEpoWFhDiZZsJ0pyLDfqmfgRJf97mqVGIuvnZVFQ9fU4FFz7VTZ
l89s3Cbydl7r9HmW4uKHa0MadS5blKO1xtNfofgmhmzrVQcCZPBgS7TKmuypTqlV
SyAvE5tyQw5g2Pnz2CQHio9liajnnUDPIcyZJ7fKiZKc/c60b9JvC0GYy0oPUVeC
S9rtDUH6gBWm6hTQRqQrbEInH/gWfc4O1XUzAT79YMRszWkTbPeAMxFqCJujAq0m
79OIvYY+urSK0XFtzLDCrBYiGBbrx+EE7Une0Udk6pkqzGZZK7AMlt9DbDnazgb5
IXq1AJ0F4UCPmWTkoECAORWhZjLtrqrjJWNGzuzNuTQvx9vCH4pNq4Y1z89GWnx2
uuAhpmnCUxH8J7jzXPiB5E1DXqRmU+OS31UCNpNV5HK36laC8RWZXkGGNjU8wTb3
RX8C0n5ETYVd28ELDGxh
=DXqC
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
