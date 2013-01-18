Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab3ARKKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:10:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:54938 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab3ARKJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:09:59 -0500
Date: Fri, 18 Jan 2013 11:09:50 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Murray <andrew.murray@arm.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 10/14] PCI: tegra: Move PCIe driver to drivers/pci/host
Message-ID: <20130118100950.GA7596@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-11-git-send-email-thierry.reding@avionic-design.de>
 <20130118095620.GA7552@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20130118095620.GA7552@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:7/VGGGIo/zcyLox8ZOB6jJCJ/XiJ+M8gwc/gSKDK7kz
 hODEiyZMvo9RBLZuI9hLcsv/5luSxw/RuuHYkktkVwEP63OuON
 VrPctz1cjI1mt/CvsrslSfVWKCP30Owp35U0nY34aLxJ7eNqQI
 qOnogfH/2+z949RYuyx3SyK6NV9EE423bwWuSBgyo/n/g0MoMC
 TmeQiw5DO2t0ZaQLQy6MNF+zuqEKlBkgjzlZnisQH6b2f1NtCu
 biZKJRNvQ+0dKFBTXHhBpy4PlKCXm4sPEDCGLSh+c3A9zhPIZh
 WLEYYscXAUWvoaPTgbyUq48fCSymg30HYIM3erluSW0rnWlgeB
 xWymTTLUQFa6kcdlbh1g2QTxjGCYKIR20RQSVmuIBqItdgkXMi
 XQnquGANuYJ76T+kJI+vB5bkU1+J2WggPg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 18, 2013 at 09:56:20AM +0000, Andrew Murray wrote:
> On Wed, Jan 09, 2013 at 08:43:10PM +0000, Thierry Reding wrote:
> > Move the PCIe driver from arch/arm/mach-tegra into the drivers/pci/host
> > directory. The motivation is to collect various host controller drivers
> > in the same location in order to facilitate refactoring.
> >=20
> > The Tegra PCIe driver has been largely rewritten, both in order to turn
> > it into a proper platform driver and to add MSI (based on code by
> > Krishna Kishore <kthota@nvidia.com>) as well as device tree support.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> [snip]
>=20
> > +static int tegra_pcie_enable(struct tegra_pcie *pcie)
> > +{
> > +       struct hw_pci hw;
> > +
> > +       memset(&hw, 0, sizeof(hw));
> > +
> > +       hw.nr_controllers =3D 1;
> > +       hw.private_data =3D (void **)&pcie;
> > +       hw.setup =3D tegra_pcie_setup;
> > +       hw.scan =3D tegra_pcie_scan_bus;
> > +       hw.map_irq =3D tegra_pcie_map_irq;
> > +
> > +       pci_common_init(&hw);
> > +
> > +       return 0;
> > +}
>=20
> [snip]
>=20
> > +static int tegra_pcie_probe(struct platform_device *pdev)
> > +{
> > +       struct device_node *port;
> > +       struct tegra_pcie *pcie;
> > +       int err;
> > +
> > +       pcie =3D devm_kzalloc(&pdev->dev, sizeof(*pcie), GFP_KERNEL);
> > +       if (!pcie)
> > +               return -ENOMEM;
> > +
> > +       INIT_LIST_HEAD(&pcie->ports);
> > +       pcie->dev =3D &pdev->dev;
> > +
> > +       err =3D tegra_pcie_parse_dt(pcie);
> > +       if (err < 0)
> > +               return err;
> > +
> > +       pcibios_min_mem =3D 0;
> > +
> > +       err =3D tegra_pcie_get_resources(pcie);
> > +       if (err < 0) {
> > +               dev_err(&pdev->dev, "failed to request resources: %d\n"=
, err);
> > +               return err;
> > +       }
> > +
> > +       err =3D tegra_pcie_enable_controller(pcie);
> > +       if (err)
> > +               goto put_resources;
> > +
> > +       /* probe root ports */
> > +       for_each_child_of_node(pdev->dev.of_node, port) {
> > +               if (!of_device_is_available(port))
> > +                       continue;
> > +
> > +               err =3D tegra_pcie_add_port(pcie, port);
> > +               if (err < 0) {
> > +                       dev_err(&pdev->dev, "failed to add port %s: %d\=
n",
> > +                               port->name, err);
> > +               }
> > +       }
> > +
> > +       /* setup the AFI address translations */
> > +       tegra_pcie_setup_translations(pcie);
> > +
> > +       if (IS_ENABLED(CONFIG_PCI_MSI)) {
> > +               err =3D tegra_pcie_enable_msi(pcie);
> > +               if (err < 0) {
> > +                       dev_err(&pdev->dev,
> > +                               "failed to enable MSI support: %d\n",
> > +                               err);
> > +                       goto put_resources;
> > +               }
> > +       }
> > +
> > +       err =3D tegra_pcie_enable(pcie);
> > +       if (err < 0) {
> > +               dev_err(&pdev->dev, "failed to enable PCIe ports: %d\n"=
, err);
> > +               goto disable_msi;
> > +       }
> > +
> > +       platform_set_drvdata(pdev, pcie);
> > +       return 0;
> > +
> > +disable_msi:
> > +       if (IS_ENABLED(CONFIG_PCI_MSI))
> > +               tegra_pcie_disable_msi(pcie);
> > +put_resources:
> > +       tegra_pcie_put_resources(pcie);
> > +       return err;
> > +}
> > +
>=20
> [snip]
>=20
> > +
> > +static const struct of_device_id tegra_pcie_of_match[] =3D {
> > +       { .compatible =3D "nvidia,tegra20-pcie", },
> > +       { },
> > +};
> > +
> > +static struct platform_driver tegra_pcie_driver =3D {
> > +       .driver =3D {
> > +               .name =3D "tegra-pcie",
> > +               .owner =3D THIS_MODULE,
> > +               .of_match_table =3D tegra_pcie_of_match,
> > +       },
> > +       .probe =3D tegra_pcie_probe,
> > +       .remove =3D tegra_pcie_remove,
> > +};
> > +module_platform_driver(tegra_pcie_driver);
>=20
> If you have multiple 'nvidia,tegra20-pcie's in your DT then you will end =
up
> with multiple calls to tegra_pcie_probe/tegra_pcie_enable/pci_common_init.
>=20
> However pci_common_init/pcibios_init_hw assumes it will only ever be call=
ed
> once, and will thus result in trying to create multiple busses with the s=
ame
> bus number. (The first root bus it creates is always zero provided you ha=
ven't
> implemented hw->scan).

Right, I hadn't noticed. There's currently no hardware that actually has
two PCIe host bridges but I wanted to keep the driver properly prepared
in case this ever happened.

Actually I've reimplemented hw->scan, but it still forwards the bus
number setup by pcibios_init_hw() (sys->busnr) to pci_create_root_bus()
so it will still break. I wonder, though, if a better approach would be
to take this number from the bus-range property in DT instead.

> I have a patch for this if you want to fold it into your series? (I see y=
ou've
> made changes to bios32 for per-controller data).

I would certainly like to take a look at it.

Thierry

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ+R9uAAoJEN0jrNd/PrOh0XoP/39mLPpEs/z9yZX3rN8jyhvD
hk7cjTeFJ9I6Umy9VslOG6u1wwAmetmdniBWBjhRCnVSmZbpJzdPVGse1+DkQOOk
JlbMYAql6JO+M97u4bDleIdNNNbhno9/r/Q6aX6x6q83MNeskNK8uGno9AUVzrEJ
WpWJHYWSUGVsETCYpYA4Dn4u+LCrpIrldqh89N+SqvsL1THR0oFj8e88W+mfpcsW
oK19FsDOsQnDjnglN/XPHUDWzdZjyE/Jb6ZDK0u46b0tcdZafLO7NAVgRC+KBnts
0ydO1ODPNtiqXTI+ZSuNEcVLIKzH7eevvF1BmcL6X6OfOXFsYe48cYQnbhEl1yCS
KE2L0qpc5+/F9rHzNbqr/KzeOue9LsqQ96qi2si/gqtnP79IulruYHiRY4H+yV/S
W/GJBxiqSZ5Ga4fIe5bswKH9PI77ur+G+NPfUukjJO5Ze9N3daAJoHZJ6/rmsbnV
KKsKFqECk4GgMEfG+S8UCv0GOCDNdQQPfL7my33aG4cn4y/ICque2bXcdd3I7+gN
fb4I+FD8lKdsxuRoa03LKZmsK4BiWH/QbzZjB0M89flNgEnqc/e8N+JreXf8H//t
NaTyly/T7k15acmpFy10D+k3W1Y+gLb9MH/F5JtMn0zIRgn+36QIRXBuhx6WVVBR
zAUZIGcAJOk0xpUzRnD+
=E00m
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
