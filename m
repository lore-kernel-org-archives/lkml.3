Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3FXDyk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 23:54:40 -0400
Received: from ozlabs.org ([203.10.76.45]:52855 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407Ab3FXDyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 23:54:37 -0400
Date: Mon, 24 Jun 2013 13:54:26 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>, Alexander Graf <agraf@suse.de>,
        linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>,
        "kvm@vger.kernel.org mailing list" <kvm@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 3/4] KVM: PPC: Add support for IOMMU in-kernel handling
Message-ID: <20130624035426.GE25265@voom.fritz.box>
References: <E63966E3-336F-4CB8-96EC-24D2C1644E62@suse.de>
 <1371653443.21896.291.camel@pasglop>
 <1371656989.22659.98.camel@ul30vt.home>
 <51C28BEA.8050501@ozlabs.ru>
 <20130620052822.GB3140@voom.redhat.com>
 <1371714449.3944.14.camel@pasglop>
 <51C2C1CC.9000003@ozlabs.ru>
 <1371740113.32709.22.camel@ul30vt.home>
 <20130622120304.GB25265@voom.fritz.box>
 <1371943693.3944.104.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xA/XKXTdy9G3iaIz"
Content-Disposition: inline
In-Reply-To: <1371943693.3944.104.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xA/XKXTdy9G3iaIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 23, 2013 at 09:28:13AM +1000, Benjamin Herrenschmidt wrote:
> On Sat, 2013-06-22 at 22:03 +1000, David Gibson wrote:
> > I think the interface should not take the group fd, but the container
> > fd.  Holding a reference to *that* would keep the necessary things
> > around.  But more to the point, it's the right thing semantically:
> >=20
> > The container is essentially the handle on a host iommu address space,
> > and so that's what should be bound by the KVM call to a particular
> > guest iommu address space.  e.g. it would make no sense to bind two
> > different groups to different guest iommu address spaces, if they were
> > in the same container - the guest thinks they are different spaces,
> > but if they're in the same container they must be the same space.
>=20
> Interestingly, how are we going to extend that when/if we implement
> DDW ?
>=20
> DDW means an API by which the guest can request the creation of
> additional iommus for a given device (typically, in addition to the
> default smallish 32-bit one using 4k pages, the guest can request
> a larger window in 64-bit space using a larger page size).

So, would a PAPR gest requesting this expect the new window to have
a new liobn, or an existing liobn?

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--xA/XKXTdy9G3iaIz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHHwvIACgkQaILKxv3ab8ZVOQCdFa0KpJIGERzTedt0JRVzHMad
+a4An30IO7PRSBaVjZgA2Is1VyepZ6V2
=wviw
-----END PGP SIGNATURE-----

--xA/XKXTdy9G3iaIz--
