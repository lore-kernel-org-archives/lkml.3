Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757704Ab3G3HL5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:11:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58964 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288Ab3G3HLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:11:54 -0400
Date: Tue, 30 Jul 2013 10:11:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Alan Stern <stern@rowland.harvard.edu>, <kyungmin.park@samsung.com>,
        <balbi@ti.com>, <jg1.han@samsung.com>, <s.nawrocki@samsung.com>,
        <kgene.kim@samsung.com>, <grant.likely@linaro.org>, <tony@atomide.com>,
        <arnd@arndb.de>, <swarren@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, <akpm@linux-foundation.org>,
        <balajitk@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
Message-ID: <20130730071106.GC16441@radagast>
Reply-To: <balbi@ti.com>
References: <20130720220006.GA7977@kroah.com>
 <3839600.WiC1OLF35o@flatron>
 <51EBC0F5.70601@ti.com>
 <9748041.Qq1fWJBg6D@flatron>
 <20130721154653.GG16598@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <20130721154653.GG16598@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 21, 2013 at 08:46:53AM -0700, Greg KH wrote:
> On Sun, Jul 21, 2013 at 01:12:07PM +0200, Tomasz Figa wrote:
> > On Sunday 21 of July 2013 16:37:33 Kishon Vijay Abraham I wrote:
> > > Hi,
> > >=20
> > > On Sunday 21 July 2013 04:01 PM, Tomasz Figa wrote:
> > > > Hi,
> > > >=20
> > > > On Saturday 20 of July 2013 19:59:10 Greg KH wrote:
> > > >> On Sat, Jul 20, 2013 at 10:32:26PM -0400, Alan Stern wrote:
> > > >>> On Sat, 20 Jul 2013, Greg KH wrote:
> > > >>>>>>> That should be passed using platform data.
> > > >>>>>>=20
> > > >>>>>> Ick, don't pass strings around, pass pointers.  If you have
> > > >>>>>> platform
> > > >>>>>> data you can get to, then put the pointer there, don't use a
> > > >>>>>> "name".
> > > >>>>>=20
> > > >>>>> I don't think I understood you here :-s We wont have phy pointer
> > > >>>>> when we create the device for the controller no?(it'll be done =
in
> > > >>>>> board file). Probably I'm missing something.
> > > >>>>=20
> > > >>>> Why will you not have that pointer?  You can't rely on the "name"
> > > >>>> as
> > > >>>> the device id will not match up, so you should be able to rely on
> > > >>>> the pointer being in the structure that the board sets up, right?
> > > >>>>=20
> > > >>>> Don't use names, especially as ids can, and will, change, that is
> > > >>>> going
> > > >>>> to cause big problems.  Use pointers, this is C, we are supposed=
 to
> > > >>>> be
> > > >>>> doing that :)
> > > >>>=20
> > > >>> Kishon, I think what Greg means is this:  The name you are using
> > > >>> must
> > > >>> be stored somewhere in a data structure constructed by the board
> > > >>> file,
> > > >>> right?  Or at least, associated with some data structure somehow.
> > > >>> Otherwise the platform code wouldn't know which PHY hardware
> > > >>> corresponded to a particular name.
> > > >>>=20
> > > >>> Greg's suggestion is that you store the address of that data
> > > >>> structure
> > > >>> in the platform data instead of storing the name string.  Have the
> > > >>> consumer pass the data structure's address when it calls phy_crea=
te,
> > > >>> instead of passing the name.  Then you don't have to worry about =
two
> > > >>> PHYs accidentally ending up with the same name or any other simil=
ar
> > > >>> problems.
> > > >>=20
> > > >> Close, but the issue is that whatever returns from phy_create()
> > > >> should
> > > >> then be used, no need to call any "find" functions, as you can just
> > > >> use
> > > >> the pointer that phy_create() returns.  Much like all other class =
api
> > > >> functions in the kernel work.
> > > >=20
> > > > I think there is a confusion here about who registers the PHYs.
> > > >=20
> > > > All platform code does is registering a platform/i2c/whatever devic=
e,
> > > > which causes a driver (located in drivers/phy/) to be instantiated.
> > > > Such drivers call phy_create(), usually in their probe() callbacks,
> > > > so platform_code has no way (and should have no way, for the sake of
> > > > layering) to get what phy_create() returns.
>=20
> Why not put pointers in the platform data structure that can hold these
> pointers?  I thought that is why we created those structures in the
> first place.  If not, what are they there for?

heh, IMO we shouldn't pass pointers of any kind through platform_data,
we want to pass data :-)

Allowing to pass pointers through that, is one of the reasons which got
us in such a big mess in ARM land, well it was much easier for a
board-file/driver writer to pass a function pointer then to create a
generic framework :-)

> > > > IMHO we need a lookup method for PHYs, just like for clocks,
> > > > regulators, PWMs or even i2c busses because there are complex cases
> > > > when passing just a name using platform data will not work. I would
> > > > second what Stephen said [1] and define a structure doing things in=
 a
> > > > DT-like way.
> > > >=20
> > > > Example;
> > > >=20
> > > > [platform code]
> > > >=20
> > > > static const struct phy_lookup my_phy_lookup[] =3D {
> > > >=20
> > > > 	PHY_LOOKUP("s3c-hsotg.0", "otg", "samsung-usbphy.1", "phy.2"),
> > >=20
> > > The only problem here is that if *PLATFORM_DEVID_AUTO* is used while
> > > creating the device, the ids in the device name would change and
> > > PHY_LOOKUP wont be useful.
> >=20
> > I don't think this is a problem. All the existing lookup methods alread=
y=20
> > use ID to identify devices (see regulators, clkdev, PWMs, i2c, ...). Yo=
u=20
> > can simply add a requirement that the ID must be assigned manually,=20
> > without using PLATFORM_DEVID_AUTO to use PHY lookup.
>=20
> And I'm saying that this idea, of using a specific name and id, is
> frought with fragility and will break in the future in various ways when
> devices get added to systems, making these strings constantly have to be
> kept up to date with different board configurations.
>=20
> People, NEVER, hardcode something like an id.  The fact that this
> happens today with the clock code, doesn't make it right, it makes the
> clock code wrong.  Others have already said that this is wrong there as
> well, as systems change and dynamic ids get used more and more.
>=20
> Let's not repeat the same mistakes of the past just because we refuse to
> learn from them...
>=20
> So again, the "find a phy by a string" functions should be removed, the
> device id should be automatically created by the phy core just to make
> things unique in sysfs, and no driver code should _ever_ be reliant on
> the number that is being created, and the pointer to the phy structure
> should be used everywhere instead.
>=20
> With those types of changes, I will consider merging this subsystem, but
> without them, sorry, I will not.

I'll agree with Greg here, the very fact that we see people trying to
add a requirement of *NOT* using PLATFORM_DEVID_AUTO already points to a
big problem in the framework.

The fact is that if we don't allow PLATFORM_DEVID_AUTO we will end up
adding similar infrastructure to the driver themselves to make sure we
don't end up with duplicate names in sysfs in case we have multiple
instances of the same IP in the SoC (or several of the same PCIe card).
I really don't want to go back to that.

--=20
balbi

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR92cJAAoJEIaOsuA1yqRE0ugP/2Nn6KnDxcBCsTxnEc+tLsEu
qY26sZZlwsPRX/zcDTYePFWKgo0OUUptbfgBj22cCrRtSRi5X3vTFC4+ZsKoXGGq
NjSaAfgRD8Axh0EKLslTtPm+E5t8hVcaGfYA/wZzCKbGIMxvD0n1ncR48+oOG41z
Zfglv2e19KMP/tBdSYDOgw6JbUQuGuk+4ovthn2vMHjbQHffoLYmphh+evu5BYsE
KRCvbtHCMFA7xdsKW6wnZ8kwLsK5jZXLQcM3H1++eezXBhdwsHPUmsVH+81PRdZk
hPt8QlM1mcZyfzMuZKGnYTobrC69wlzW1x1YFvKjFLnduZzyMjQnSwunYbKG7bhq
jceUghC2LPA3H6PVGWvmlePwHCB1OW1Pk8yaYlwBUiDBJ7WbDvkJ+SOkISinAdB5
9NzCSSwBfuebrsoNVj+osoegdvUyZpYuEbMu/we5vps5/h85Wh5KaU437eF++kBA
eWIkQAwtvvhXcEVcWTbJ3jttOX26k7YHAU7PZ/JT62xKB3JG3/mGr/CjRTlwL4C/
R26PhaBB3+WdZI+ZtuMILW/repNw4uXE1VLMklDD0uF6qs8y8oO8TUAnpOEXrUiG
hEh+8Rz/LhCiIi4GOkCNht3m3aA0WFT27n3+UjYu8c32Kzh4wLFB4dstufAJ3Qcx
gPysm9AJ4/XDXQkSS1p/
=cE11
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
