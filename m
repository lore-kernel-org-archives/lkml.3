Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab3FRIzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 04:55:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51371 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3FRIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 04:54:56 -0400
Date: Tue, 18 Jun 2013 11:51:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Marek <mmarek@suse.cz>
CC: <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>, Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <jirislaby@gmail.com>,
        <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        <linux-usb@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        <linux-geode@lists.infradead.org>, <linux-fbdev@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>, <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] build some drivers only when compile-testing
Message-ID: <20130618085154.GN5461@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1369214326-6558-1-git-send-email-jslaby@suse.cz>
 <20130523022327.GB6159@kroah.com>
 <519D8876.9050405@suse.com>
 <51BF6BFF.7050705@suse.cz>
 <51BFE754.5080301@suse.cz>
 <20130618081858.GD5461@arwen.pp.htv.fi>
 <51C01948.9060708@suse.cz>
 <20130618083425.GI5461@arwen.pp.htv.fi>
 <51C01E04.2050908@suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="prC3/KjdfqNV7evK"
Content-Disposition: inline
In-Reply-To: <51C01E04.2050908@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--prC3/KjdfqNV7evK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 18, 2013 at 10:44:52AM +0200, Michal Marek wrote:
> > On Tue, Jun 18, 2013 at 10:24:40AM +0200, Jiri Slaby wrote:
> >>>>> Sam Ravnborg (the kconfig ex-maintainer) once wrote that
> >>>>> he doesn't want to extend the kconfig language for this
> >>>>> purpose (which I support). That a config option is fine and
> >>>>> sufficient in this case [1]. Except he called the config
> >>>>> option "SHOW_ALL_DRIVERS". Adding the current maintainer to
> >>>>> CCs ;).
> >>>>=20
> >>>> I agree with Sam. 'depends on XY || COMPILE_TEST' is quite=20
> >>>> self-explanatory. And even if it's not, you can look up the
> >>>> help text for COMPILE_TEST. With "archdepends on" or
> >>>> "available on", you need to know what to look for to override
> >>>> the dependency.
> >>>=20
> >>> you will still end up with:
> >>>=20
> >>> depends on (ARCH_OMAP || ARCH_EXYNOS || ARCH_DAVINCI ||
> >>> ARCH_PPC || ...)
> >>>=20
> >>> And every now and again that particular line will be updated
> >>> to add another arch dependency.
> >>=20
> >> But that is perfectly fine *when* the driver is supported on
> >> those archs only.
> >>=20
> >> And come on, how much often will this "every now and again"
> >> happen? We don't have that much cases where a driver is augmented
> >> to work on another arch or platform. It either works on all of
> >> them =3D> doesn't need COMPILE_TEST, or work on one or two arches
> >> at most.
> >=20
> > MUSB alone has 8 different arch choices. Before, it used to be that
> > core driver was dependendent on all of them, so whenever someone
> > wanted to build MUSB for another arch, they had to introdude their
> > glue code and modify the dependency of the core driver.
>=20
> But that you have complex dependencies in some drivers is mostly
> orthogonal to the two choices of syntax, isn't it?
>=20
> depends on ARCH1 || ARCH2 || .... || ARCH8 || COMPILE_TEST
>=20
> vs.
>=20
> archdepends on ARCH1 || ARCH2 || .... || ARCH8

right, but my argument is that I rather not have either. Depend on PCI
if you us PCI, depend on EXTCON if you use extcon, but no driver should
have an ARCH dependency. Specially since it lets people include mach/*
and asm/* headers because "it doesn't break compilation for anyone".

--=20
balbi

--prC3/KjdfqNV7evK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwB+qAAoJEIaOsuA1yqREx3QQALabOoSQQJZR0TRQhm9mGOm2
5M7w9aX+cWRhRdAa1fww6WUDaZWPmwIbmpmax6oSKbzteu/f2o1HUtKlu2rKWaZ7
kQ4wzaFBvgR94qM3JJk69I5QLRrJPoDxIetwUbcQfY3N994m8cUUU1Oqe4PWqwGm
C1qTPAtfRKI3BNQrleA1/TNtSZqGFK+09/iUKvdR2rZ3W5FHZJ1zlM+uDYlYIY5F
uAuC7nXxjOqig//VHIE8mdr5tBa3mRhsEEjcDmeHyKpYtEzJvA0FYPKsufQzP/yX
oF7xJhQTPBampyX5sRNPnAC2jqrQ0tE70iJkGw2kla8fSC61WNjq5Jpi93afD2Zf
RXJOpdEAtwI/zJ3BOCl1+oZEclHe/kS1EC2ru71fjq+Q1kvzUtt8GvZrETXx8W9i
X6D27lJydBMxqHEcEoXKHPdagOIefgBlEQcJb7dYBXqCILehGHKNoCHoUMb+QYAm
aQpJfJNAB2Iha3yOcaokxCW5SQhlsBMbBqSE/rCzSaYpPymf0R5gzD5V8liWdJAs
8PZ9Sq3Dz/NKYaR+zeBb9eIrzSPY7MIxzqb0aZ2ZWFvlEzG7w3D7b6CdMX1e4NPz
ErfPWQflXIlS9aFlXMFSWCq2Z51fnofW5xiO8AO4skuMYHYkMD9sbb/CjcDLFQOH
JClOM06BvYJYCJUlqAlQ
=fpvV
-----END PGP SIGNATURE-----

--prC3/KjdfqNV7evK--
