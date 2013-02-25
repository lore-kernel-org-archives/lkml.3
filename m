Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759546Ab3BYAN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 19:13:27 -0500
Received: from ozlabs.org ([203.10.76.45]:41429 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758404Ab3BYAN0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 19:13:26 -0500
Date: Mon, 25 Feb 2013 11:03:22 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: making IOMMU sysfs nodes API public
Message-ID: <20130225000322.GN30946@truffula.fritz.box>
References: <1360642004-7419-1-git-send-email-aik@ozlabs.ru>
 <1360645643.3248.91.camel@bling.home>
 <511A54DC.9030908@ozlabs.ru>
 <1360689304.3248.154.camel@bling.home>
 <5121C709.80007@ozlabs.ru>
 <1361251440.2801.142.camel@bling.home>
 <20130219073853.GS21067@truffula.fritz.box>
 <1361304711.2801.232.camel@bling.home>
 <20130222000415.GI21011@truffula.fritz.box>
 <1361506273.2801.327.camel@bling.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F7w+4yMapWozG0Ib"
Content-Disposition: inline
In-Reply-To: <1361506273.2801.327.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F7w+4yMapWozG0Ib
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 21, 2013 at 09:11:13PM -0700, Alex Williamson wrote:
> On Fri, 2013-02-22 at 11:04 +1100, David Gibson wrote:
> > On Tue, Feb 19, 2013 at 01:11:51PM -0700, Alex Williamson wrote:
> > > On Tue, 2013-02-19 at 18:38 +1100, David Gibson wrote:
> > > > On Mon, Feb 18, 2013 at 10:24:00PM -0700, Alex Williamson wrote:
> > > > > On Mon, 2013-02-18 at 17:15 +1100, Alexey Kardashevskiy wrote:
> > [snip]
> > > > >  Adding the window size to sysfs seems more readily convenient,
> > > > > but is it so hard for userspace to open the files and call a coup=
le
> > > > > ioctls to get far enough to call IOMMU_GET_INFO?  I'm unconvinced=
 the
> > > > > clutter in sysfs more than just a quick fix.  Thanks,
> > > >=20
> > > > And finally, as Alexey points out, isn't the point here so we know =
how
> > > > much rlimit to give qemu?  Using ioctls we'd need a special tool ju=
st
> > > > to check the dma window sizes, which seems a bit hideous.
> > >=20
> > > Is it more hideous that using iommu groups to report a vfio imposed
> > > restriction?  Are a couple open files and a handful of ioctls worse t=
han
> > > code to parse directory entries and the future maintenance of an
> > > unrestricted grab bag of sysfs entries?
> >=20
> > The fact that the memory is locked is a vfio restriction, but the
> > actual dma window size is, genuinely, a property of the group.
>=20
> A group is an association of devices based on isolation and visibility.
> The dma window happens to be associated with a group on your platform,
> but that's not always the case.

It's certainly an iommu driver specific group property, but a group
property nonetheless.

>  This is why I was hoping something in
> sysfs already reported the dma window so that we could point to it
> rather than creating an interface where it doesn't really belong.

Alas, no.  There's been no reason to expose PEs previously.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--F7w+4yMapWozG0Ib
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEqqkoACgkQaILKxv3ab8ZERwCfZCL8DaFxn+x9wNLHs84DEfJD
QFEAnj7UA8EAxAfDs00nGBzEMj7Ehj9T
=4K+c
-----END PGP SIGNATURE-----

--F7w+4yMapWozG0Ib--
