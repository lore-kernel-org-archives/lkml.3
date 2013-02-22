Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3BVBWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:22:42 -0500
Received: from ozlabs.org ([203.10.76.45]:57165 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753970Ab3BVBWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:22:40 -0500
Date: Fri, 22 Feb 2013 11:04:15 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>, Joerg Roedel <joerg.roedel@amd.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: making IOMMU sysfs nodes API public
Message-ID: <20130222000415.GI21011@truffula.fritz.box>
References: <1360628713.3248.8.camel@bling.home>
 <1360642004-7419-1-git-send-email-aik@ozlabs.ru>
 <1360645643.3248.91.camel@bling.home>
 <511A54DC.9030908@ozlabs.ru>
 <1360689304.3248.154.camel@bling.home>
 <5121C709.80007@ozlabs.ru>
 <1361251440.2801.142.camel@bling.home>
 <20130219073853.GS21067@truffula.fritz.box>
 <1361304711.2801.232.camel@bling.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oxV4ZoPwBLqAyY+a"
Content-Disposition: inline
In-Reply-To: <1361304711.2801.232.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oxV4ZoPwBLqAyY+a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 19, 2013 at 01:11:51PM -0700, Alex Williamson wrote:
> On Tue, 2013-02-19 at 18:38 +1100, David Gibson wrote:
> > On Mon, Feb 18, 2013 at 10:24:00PM -0700, Alex Williamson wrote:
> > > On Mon, 2013-02-18 at 17:15 +1100, Alexey Kardashevskiy wrote:
[snip]
> > >  Adding the window size to sysfs seems more readily convenient,
> > > but is it so hard for userspace to open the files and call a couple
> > > ioctls to get far enough to call IOMMU_GET_INFO?  I'm unconvinced the
> > > clutter in sysfs more than just a quick fix.  Thanks,
> >=20
> > And finally, as Alexey points out, isn't the point here so we know how
> > much rlimit to give qemu?  Using ioctls we'd need a special tool just
> > to check the dma window sizes, which seems a bit hideous.
>=20
> Is it more hideous that using iommu groups to report a vfio imposed
> restriction?  Are a couple open files and a handful of ioctls worse than
> code to parse directory entries and the future maintenance of an
> unrestricted grab bag of sysfs entries?

The fact that the memory is locked is a vfio restriction, but the
actual dma window size is, genuinely, a property of the group.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--oxV4ZoPwBLqAyY+a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlEmtf8ACgkQaILKxv3ab8Yx2wCeIZi02eSK4V91QamKoq1R4LQb
jrAAniA1BHfvqKgrn+e+59edyq2MXpSM
=XHeH
-----END PGP SIGNATURE-----

--oxV4ZoPwBLqAyY+a--
