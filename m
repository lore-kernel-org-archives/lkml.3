Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676AbaJOPEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 11:04:34 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50137 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaJOPEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 11:04:33 -0400
Date: Wed, 15 Oct 2014 10:04:20 -0500
From: Felipe Balbi <balbi@ti.com>
To: Dave Jones <davej@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <aubrey.li@linux.intel.com>
Subject: Re: x86: Make Atom PMC driver configurable.
Message-ID: <20141015150420.GE11511@saruman>
Reply-To: <balbi@ti.com>
References: <20141015144603.GA19944@redhat.com>
 <20141015145245.GB11511@saruman>
 <20141015145924.GA21199@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+JUInw4efm7IfTNU"
Content-Disposition: inline
In-Reply-To: <20141015145924.GA21199@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+JUInw4efm7IfTNU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2014 at 10:59:24AM -0400, Dave Jones wrote:
> On Wed, Oct 15, 2014 at 09:52:45AM -0500, Felipe Balbi wrote:
>  > Hi,
>  >=20
>  > On Wed, Oct 15, 2014 at 10:46:03AM -0400, Dave Jones wrote:
>  > > The Atom PMC driver is always built-in, regardless of whether
>  > > the kernel being built is going to be run on an Atom (or even Intel)=
 CPU.
>  > >=20
>  > > Signed-off-by: Dave Jones <davej@redhat.com>
>  > >=20
>  > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>  > > index f2327e88e07c..04280177c1e2 100644
>  > > --- a/arch/x86/Kconfig
>  > > +++ b/arch/x86/Kconfig
>  > > @@ -2485,7 +2485,7 @@ config X86_DMA_REMAP
>  > >  	depends on STA2X11
>  > > =20
>  > >  config PMC_ATOM
>  > > -	def_bool y
>  > > +	tristate "Intel Atom SOC power management controller driver"
>  >=20
>  > looks like you should still have this as default y just to make sure y=
ou
>  > a simple defconfig still enables this as it did before.
> =20
> I could, but why should this be default y ? There's no real
> justification to inflict this on everyone, given atom is at best
> a niche area of x86.

well, because it already was a bool ? There might be distros out there
who would mysteriously loose PMC support after upgrade the kernel
without realizing that PMC_ATOM isn't a default y anymore.

Frankly though, no strong feelings. I won't be the one having to tell
users to change their .config ;-)

--=20
balbi

--+JUInw4efm7IfTNU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUPoz0AAoJEIaOsuA1yqRES2MP/i8a5p9TUG7lqq+9Ggclb9vD
n3y9MwlgpP+m0xOe7SE9N5O9fSbt9oL6Nk0+tmwqWpdIHClxETSvdWfJ0aX9Vghs
cwFmmfLCXbR56v0x6QV4bH3JhbDs4hFa1HwUDU7N8U0ZAy8tlfOfIWe9qVvUAQ7v
XeFZKypYuGKwcGD2WmTR7pg6YfcsV/ZLpyE8UAzye34JkFqYIkyhXLiP1VJDmyV2
GiguaMo7VIEcP4UFPk14qMv60MwSK0hbBBzvYH9yyrivhkoKqFwGnOARyivlpk/c
tH+XNbPHIHvVWBvp8s9OH/AYfoZj17aks73HPdpq9VKRn7JRlMmkHqXojXjAkCDI
PG3k+/aVEsz0djlNUIfVbwhuVzK+/UQ8fQd6FF4GqiQF3wL6jFRqssw0bg53aIrt
TDlMDDcPcr4LPI4kpMGEMKo7Nlh0KUqDxKOXfbarYunbR35pOPFhvo/fuw1x9paa
4TNu1gAHqz2iQ8mUFnVGdYOMydI53vTcgqH5pIc2mnYyR8sr7ukC5bNXy+L2VURI
nSVyj2ucrIpziIK57l63P5xEzBCjvMmcgMLZ5u8PKrh0rHBx0P6qSZWY+bTff5+o
9bXxVvHKAPrlLCqpeqAvK0evzvlwxZA9ws7urxtFeIw0RoldyngfQ4Zc4KDu9UA1
4SQBnaIyvKVcNdJK0JrL
=+3+p
-----END PGP SIGNATURE-----

--+JUInw4efm7IfTNU--
