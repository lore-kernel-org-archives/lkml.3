Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3HMIGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:06:49 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37344 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3HMIGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:06:44 -0400
Date: Tue, 13 Aug 2013 10:06:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/9] PCI: mvebu: remove subsys_initcall
Message-ID: <20130813080639.GD9316@ulmo>
References: <1376333215-12885-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376333215-12885-4-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130813091959.784b44f0@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gE7i1rD7pdK0Ng3j"
Content-Disposition: inline
In-Reply-To: <20130813091959.784b44f0@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gE7i1rD7pdK0Ng3j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 09:19:59AM +0200, Thomas Petazzoni wrote:
> Dear Sebastian Hesselbarth,
>=20
> On Mon, 12 Aug 2013 20:46:49 +0200, Sebastian Hesselbarth wrote:
> > This removes the subsys_initcall from the driver and converts it to
> > a normal platform_driver. Also, drvdata is set and a remove functions
> > is added to disable the clock and free resources.
> >=20
> > Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>=20
> I'm OK with this, just a comment below.
>=20
> > +static int mvebu_pcie_remove(struct platform_device *pdev)
> > +{
> > +	struct mvebu_pcie *pcie =3D platform_get_drvdata(pdev);
> > +	struct mvebu_pcie_port *port =3D &pcie->ports[0];
> > +	int i;
> > +
> > +	for (i =3D 0; i < pcie->nports; i++, port++) {
> > +		clk_disable_unprepare(port->clk);
> > +		kfree(port->name);
> > +	}
> > +
> > +	return 0;
> > +}
>=20
> I believe the ->remove() part is quite useless. The driver is a 'bool'
> in Kconfig, so it cannot be compiled as a module, and I'm not sure
> there a way to remove the platform device that corresponds to the PCIe
> controller.

There is. You can write the device's name to the driver's unbind file in
sysfs. What I ended up doing for Tegra was not to provide a .remove() at
all and set the struct device_driver's .suppress_bind_attrs to true.

Those two things combined should make it impossible to unbind the device
=66rom the driver.

> And even if there was, then it would still not work because as far as I
> know, the ARM PCI core doesn't provide functions to 'unregister' PCI
> controllers, so it would keep pointers to functions located in the
> driver, which would cause nasty things when unloading the module.

I did some initial work to support driver unbinding (in order to support
module unloading) on Tegra and things look pretty promising. The ARM PCI
code would need something like pci_common_exit() to make sure there are
no leaks.

Unfortunately I can't seem to find that branch anymore, so I will have
to reconstruct it from memory...

That said, I agree with Thomas that it's not useful (and potentially
even dangerous) to add the .remove() at this point in time.

Thierry

--gE7i1rD7pdK0Ng3j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCekPAAoJEN0jrNd/PrOhKLcP+wY6A6YFFnV2ZOaegG/2kvsw
uxqFlhn4FqAnsM2fmbHJpDoem8gowF+aonwuAKw7oAnmE+tKiIQeAsiGhrMIRx+p
L08j7HxQc0LGwBZQpqGQFeskruD7HzTr+ye26pqwhzHNUX68mL3skaUzI6lRvleb
PzuiG0vaUnCFFBukIJu7VHXmvy8esghIaxUWW4BWNGiJF5tgjjku3OLswJujVkbT
aLJFLXAUreXPr9O7XfSuBUgYQKsD/OklII7tsA53QJ9+twsaQMlMt20VwnKw/vO/
wWmXTMwC64Ff7g69XJgTpdFlnhHxQeukUZF4rleS5JpssKl7b2HRQNN99xTOAyPo
wnnefn0bOHO2mxKANkjJmzXCfGrfsRJWGHxNopd4fk4aPXh9+dpOMOrsa+8trrm3
ivobxxYvW8yCdKtsc1oMAI1iWblyd2xStFEYjE7cyAMwOplwdgvgLU096OUHd4S+
dCmrPbLokq1Uo72kQZYhzdEId79Y/Vlk5FFcJR9wLw945aA5Qj2+BmK+tAMW+YlH
Qt4KaCl3nw7luq1VtcdPlM09CBiuCmAch6YZ9fUn8WB6veDxApPgMT56VD2xUbvG
Z2ADUVBGfnkkKZeXTne/DUFxstsozA1yldJEBhG3sfIhFHH0imP3ZaP5ffy69IFt
Unkb1fGPx8IzPrtJlfmt
=BioH
-----END PGP SIGNATURE-----

--gE7i1rD7pdK0Ng3j--
