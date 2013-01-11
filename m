Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab3AKEfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:35:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63631 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3AKEfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:35:06 -0500
Date: Fri, 11 Jan 2013 05:34:37 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 12/14] ARM: tegra: tec: Add PCIe support
Message-ID: <20130111043437.GF28094@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-13-git-send-email-thierry.reding@avionic-design.de>
 <50EF5B46.8010806@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rMWmSaSbD7nr+du9"
Content-Disposition: inline
In-Reply-To: <50EF5B46.8010806@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:A5+W3kpVegZlxSWPfiegsoZGSZMjVnH9syNx6Zlq/V8
 iX7wcM6NMAv0PtTHz3IyOu+P8GXyVoD1i5aTPzDU9zXhE7yQiq
 2hmpNMtyMCvr5puM/xQUOFlwBpMy3yY11zHfapf6NqqJWPz/oh
 ZwelzJGdkXNn45FtReJg8VogbzNt7CHLu7PffJ8iL4MZvTUU5t
 jWczQ+IFDNqpcTWVjghoAnBq2gonxBm+xi5zsWaiPS56/Iw/6s
 V4+HRgJT/OJ6+Brn5z3HJdPyitgLSFVlJfxciZipuuVdzE9QBm
 HMnPLqTliQzV5rlOVJ7yjlnatYoxoyfo/2IZkhqQIyp8FpEeMg
 ddAdD8DAxM8Pdes/iYGLnQjpM9ziiR+YATkpjSiFGt+/3HH5Do
 X+AHQOB9YqYCRTNO5Iwm9q7gDQyZjyXnDpoJZMU3aaEeOP6T97
 1guDy
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rMWmSaSbD7nr+du9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 05:22:30PM -0700, Stephen Warren wrote:
> On 01/09/2013 01:43 PM, Thierry Reding wrote:
> > Enable the first PCIe root port which is connected to an FPGA on the
> > Tamonten Evaluation Carrier and add device nodes for each of the PCI
> > endpoints available in the standard configuration.
>=20
> > diff --git a/arch/arm/boot/dts/tegra20-tec.dts b/arch/arm/boot/dts/tegr=
a20-tec.dts
>=20
> > +	pcie-controller {
> > +		vdd-supply =3D <&pci_vdd_reg>;
> > +		pex-clk-supply =3D <&pci_clk_reg>;
> > +		status =3D "okay";
>=20
> Sorry this is also really picky. I'd prefer properties that exist in
> /include/d files and are overidden here to appear first, followed by new
> properties. In other words, move the status property to be first. I
> believe/hope all the other (Tegra) .dts files follow this convention.

Okay, I'll fix that.

> > +		pci@1,0 {
> > +			bus-range =3D <0x01 0x0a>;
> > +			status =3D "okay";
> > +
> > +			pci@0,0 {
> > +				reg =3D <0x010000 0 0 0 0>;
>=20
> Hmm. The unit address in that node name doesn't match the address in the
> reg property, although I suppose there's nothing we can do about it
> since those formats are both defined by the standard PCI binding?

That's the standard encoding for unit addresses for PCI devices. The
first cell in the reg property encodes bus/device/function (amongst
other things) and the node name is supposed to be pci@<dev>,<fn>.

> What do the numbers "0,0" represent here; device/function? Is the same
> true for the "0,0" in the child nodes?

Yes, exactly.

> > +				bus-range =3D <0x02 0x0a>;
> > +
> > +				compatible =3D "plda,pcie";
>=20
> Are there DT binding documents for all these devices; plda,pcie,
> ad,pcie, ad,pcie-test, etc.?

No. To be honest I don't quite know how to handle this. For the PLDA
things aren't so bad since it has a proper PCI ID, but the other cores
don't since they are custom IP or taken from opencores.org and made
available via PCIe. We're still in the process of obtaining our own PCI
vendor ID so that these can be properly assigned.

Also, as you have guessed, most of these are not required. I just wanted
to include them here for completeness (and maybe reference in case
somebody else, myself included, needs a working example to base other
work on).

> > +				pci@4,0 {
> > +					reg =3D <0x022000 0 0 0 0>;
> > +					bus-range =3D <0x07 0x07>;
> > +
> > +					compatible =3D "ad,pcie";
> > +					device_type =3D "pci";
> > +
> > +					#address-cells =3D <3>;
> > +					#size-cells =3D <2>;
> > +
> > +					pci@0,0 {
> > +						compatible =3D "opencores,uart";
> > +						reg =3D <0x070000 0 0 0 0>;
> > +					};
> > +				};
>=20
> Do you need to include a node for the UART; I can see you need to for
> the SPI/I2C controllers so you can instantiate the appropriate devices
> on non-probe-able buses, but I think you can just let regular PCI device
> probing find the UART, Ethernet MAC, etc., can't you?

Yes, that's correct. Only SPI and I2C actually require these nodes. I'm
not sure if the PCI binding requires all nodes to be present or not.
Other examples I've seen (e.g. arch/x86/platform/ce4100/falconfalls.dts)
contain nodes for everything, most of which don't seem to be necessary
for things to work.

One other thing that I've seen is the usage of the more standard pci*
values for the compatible property. None of them are very descriptive
which is why I used a vendor,device type of value instead.

Going over the PCI binding again, however, it looks like there's no
requirement to make the node name pci@dev,fn and pci can be anything.
Making it uart@0,0 and then adjusting the compatible value to be as the
binding requires could be an option. In that case I suppose even the
bindings documentation shouldn't be necessary.

That doesn't cover the nodes where non-standard properties are needed
(I2C and SPI), which do need binding documents. I wouldn't know how to
name them, though. I'm not sure going with the current convention would
be any good since it'll be hard to find the right document if you have
to look it up by matching vendor and device IDs or PCI class.

Thierry

--rMWmSaSbD7nr+du9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ75ZdAAoJEN0jrNd/PrOhqLwP/jlhfvEttlemxr+BN6dQq33Q
pnmmTFXKC8nV+Igo9yTlUWOxvIdz/9kLvgC3YdqT8VLJbZvPKAXDp/RyJ6tYn4LV
VckkcH1ssxUjeYnyff5i+8x0pjP4XwS0EKubZPXYgl934SWZr0h6N8yzQFJ8zX3W
vydrJj0iHgzmQEsnjZ7WG6WhwclAFz6e5bUe2Ra5R6yCPqIpKD9ceLp7gcVpFYt9
BFrg60uBZp5wq0/zyPmwrylugQZZBrSdhwAiMcIpEygLpRyOw27L/5vxfzAQ4kd5
8MB9PEKRTTsFkiFf/xuDdCJ3ppVdxZ0/aEyVwucH/D42cAb7SbzHkk8LHDE7auDX
i42yG9GEYjzZkVQ+cIG45zz8Ke6VZzwMVzunuvWLUqyDAR9dIk+5G+S2V+yhq4yv
hJ+QIfwmcu0SZbCLpHpq9UiqDaGPRB907jyq1NdMJMTHz4rrUagesPNzZJH2ApRc
P9HDWubUjYI/4CLOsTpNShoJAMWq6p9vyQmzQoepubAEcdV7Kx0H7kZJdpM+x3Kp
ty7r5sM9wdU+Eogn4jB2HUXBmr4Z5napV+ZlD2siGtq4N2yScw1a7K+QzEsKsM2s
A+36wmjuOy3zzwvBd+XrCgivF1gU7qgG2B+BkQtHjRORqtDT4WpAAPyCMyURkjFH
hRYo3V/CcibTyNeadZh5
=rtWB
-----END PGP SIGNATURE-----

--rMWmSaSbD7nr+du9--
