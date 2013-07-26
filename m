Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759673Ab3GZUcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:32:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44506 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465Ab3GZUcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:32:39 -0400
Date: Fri, 26 Jul 2013 23:32:26 +0300
From: Felipe Balbi <balbi@ti.com>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: "balbi@ti.com" <balbi@ti.com>, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: core: modify IO memory resource after
 deferred probe completes
Message-ID: <20130726203226.GC14077@radagast>
Reply-To: <balbi@ti.com>
References: <1374769590-14491-1-git-send-email-iivanov@mm-sol.com>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE112E@US01WEMBX2.internal.synopsys.com>
 <20130725205224.GA12209@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE12C9@US01WEMBX2.internal.synopsys.com>
 <1374821306.1956.34.camel@iivanov-dev.int.mm-sol.com>
 <20130726095347.GA2970@radagast>
 <A2CA0424C0A6F04399FB9E1CD98E030458DE178C@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RIYY1s2vRbPFwWeW"
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DE178C@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RIYY1s2vRbPFwWeW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jul 26, 2013 at 06:44:23PM +0000, Paul Zimmerman wrote:
> > From: Felipe Balbi [mailto:balbi@ti.com]
> > Sent: Friday, July 26, 2013 2:54 AM
> > > > > Also, this is not *modifying* what was passed, just skipping the =
xHCI
> > > > > address space so we don't request_mem_region() an area we won't r=
eally
> > > > > handle and prevent xhci-hcd.ko from probing.
> > > >
> > > > Hmm? platform_get_resource() returns a pointer to an entry in the
> > > > platform_device's resource[] array. And "res->start +=3D" modifies =
the
> > > > entry pointed at. If it didn't, the bug fixed by this patch wouldn't
> > > > have happened.
> > > >
> > > > Are you sure this code will work OK if you build the driver as a mo=
dule,
> > > > modprobe it, rmmod it, and then modprobe it again? Seems like it wo=
n't,
> > > > unless the dev->resource[] array gets reinitialized in between some=
how.
> >=20
> > gotta try that one... Perhaps the correct way would be to copy the
> > resource to a private struct resource and modify that one, leaving
> > pdev->resources untouched.
>=20
> Maybe this is a dumb question, but why can't the driver that is going
> to use the resource after this just "know" that it has to add
> DWC3_GLOBALS_REGS_START to the start address? Are there some versions
> of the core where that is not the case?

that won't work, because dwc3.ko will already have request_mem_region()
the entire region and a subsequent request_mem_region() for xHCI space
only would fail.

> Or, maybe there should be two sets of resources?

maybe we should require two sets of resources, yes... but then there's
no point in having any host initialization whatsoever in dwc3.ko.

--=20
balbi

--RIYY1s2vRbPFwWeW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8tzaAAoJEIaOsuA1yqREOmEP/0DOmVKW2KJvfzWcMoGLOxEU
KlBjiy/tJC9IhMf0r4zdJ+VhIHln2i0MH7vl+pZo2Kw/0ql+OunkysgfuGVRX3h6
nFu2tCosGYik0O4/vqPv8pvTEPoD0hZso7xVOQM0gQVsdXm9weA4fLadL4DWp+6P
MX7nArYl9HyhYh8B3eqHRXC97jdpWmw2LDgRBSw7dm5DDVtSLUw8ZE9h1wTEQQht
cd+tOe1GKT43lzBZhXODZrXXLP4uJ/tiRLcnlk78y4JJYQ58Xj7hdDh+Dgundgfd
EdXNZz8ylFXdemoK9SYCBa+o5rdOKFSOkTohQV5YaO2xpEYVkxMmlerkVZxEg8tI
xkaeyqI9MuUsAwzBLw03HVFwkcUXP+j9Yu6BM/kQMWBDdV0TRn1a/r8GSlXHrynK
FCLgskQnKckQ63pG+Tcow3KWgJqdYH+y3to3ZBXFiItyh7h37FtQYThV1NvsmiIw
uTQ7L8TkgE2x2DUZ+rXUTIm12J0X/BOz1qOVDWo7u6jfVjEFZwQ3GXyIg3P3MXhC
IRzYBaWcbEk7/givxMi8bT2kmM2tHw0GNJlq5vltQ9cUGdv8qoc365ckWtYYnU42
FQyM8jA9BNS5iL9qEfOezzfmVDp/BD0NC17cZ0qRTWoY1c4YQoKTzQXnuHbcOQDJ
bIlCv+MoshBDvKJmyYwX
=LBfX
-----END PGP SIGNATURE-----

--RIYY1s2vRbPFwWeW--
