Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3GCNP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 09:15:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57296 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3GCNP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 09:15:57 -0400
Date: Wed, 3 Jul 2013 16:15:13 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>, <tony@atomide.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 4/6] USB: ehci-omap: Suspend the controller during
 bus suspend
Message-ID: <20130703131513.GH15056@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <51D28DB9.704@ti.com>
 <Pine.LNX.4.44L0.1307021302430.1086-100000@iolanthe.rowland.org>
 <20130703125719.GD15056@arwen.pp.htv.fi>
 <51D421BC.9050600@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GBDnBH7+ZvLx8QD4"
Content-Disposition: inline
In-Reply-To: <51D421BC.9050600@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GBDnBH7+ZvLx8QD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2013 at 04:06:04PM +0300, Roger Quadros wrote:
> On 07/03/2013 03:57 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Tue, Jul 02, 2013 at 01:17:58PM -0400, Alan Stern wrote:
> >> A PCI-based EHCI controller has two power sources: the core well (which
> >> is turned off during suspend) and the auxiliary well (which remains
> >> powered).  That's how remote wakeup works; it uses the auxiliary well.
> >=20
> > This, kinda, matches what OMAP tries to do with pad wakeup. Just that
> > pad wakeup sits outside of the device itself. Perhaps we could look into
> > how PCI handles the aux well and take some inspiration from there.
> >=20
> > Any pointers under drivers/pci/ would be great :-)
> >=20
> From what I understood, auxiliary well is just a power source, and it kee=
ps
> the EHCI controller powered even during suspend.
>=20
> If that is true then it is different from our situation as we power down =
the
> EHCI controller completely.

right but our "auxiliary well" keeps PRCM powered which can wake EHCI up
;-)

What I'm saying is that from ehci-omap's perspective, there's very
little difference, specially since we route the wakeup through the same
IRQ line anyway. Perhaps we could take some inspiration from the PCI
land to make our hwmod/omap_device a little easier from driver
perspective.

Or maybe it doesn't make sense ;-)

--=20
balbi

--GBDnBH7+ZvLx8QD4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1CPhAAoJEIaOsuA1yqREXcUP/iz2iFfynbPWw5sT13z9TmVW
7AxHIe+AUaQKEVm4Ga9hSwH8SA/aatCBj2mGTU5jYtZt9dCOqknazXmZt0374i9H
ZN9e421SGZLvNECeLnAqEXJhrGTUiGSpcaos34d1WHrS6UFQt9dQTKoNJa2M7I3p
iw86nQ7wxKkY7i2smIpk3i8Ultr8ZJBJMyXdtGUgWPVQUBHV6ROouWhT5puD4UQm
nQShMBRug/6tUp+H2pibTfc4eHCbeCkpSqm+mRziP2aAA/W/bPqQzZUFHfXMtxeR
4+Sbb1qh1oNLTK2xL4QRDo69mH+jT9N86rLYgBMjA4lxgzfZMFrmuvZ19cnIPvbZ
E1tMlmKBuw+ZD1HTAi2kOxegUP77eZe40idi4x5BhTZSCryp5mfzFF4cJzq9Aohd
uNYiBXU8gFwfNdJOck93MdjhCtpaL2kbyO9VuYhRDPN2rtfmtQ7YkgPk+c7MipPE
GV/ask6WESRk+DyGwSJnRYfae6s6wJsUfj6x/Mjq0lxzzh3tSORV3iWNV8+c0xT2
ShNQnupQgGJ4AMtgALCu60SLDxere8vNhfXciWbk+X9nM5+p1e7FT4HDZPCLswpO
qVtwYl3VDGZRugfXAvQtHDls32tTcj6e+YiGFKUpSqg7eVJHDFYRZ1K9l0t/QpT8
xN5VkpxsLDz6znd7ne/G
=Jirn
-----END PGP SIGNATURE-----

--GBDnBH7+ZvLx8QD4--
