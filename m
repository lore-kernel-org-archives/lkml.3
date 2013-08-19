Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385Ab3HSUQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:16:31 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:64974 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3HSUQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:16:28 -0400
Date: Mon, 19 Aug 2013 22:16:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Russell King <linux@arm.linux.org.uk>, Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: Re: [RFC 3/3] PCI: tegra: Support driver unbinding
Message-ID: <20130819201623.GD5191@mithrandir>
References: <1376392346-14127-1-git-send-email-treding@nvidia.com>
 <1376392346-14127-4-git-send-email-treding@nvidia.com>
 <520BFA0C.5070001@wwwdotorg.org>
 <20130815103452.GA13740@ulmo>
 <520CF211.6060003@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sXc4Kmr5FA7axrvy"
Content-Disposition: inline
In-Reply-To: <520CF211.6060003@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sXc4Kmr5FA7axrvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2013 at 09:21:53AM -0600, Stephen Warren wrote:
> On 08/15/2013 04:34 AM, Thierry Reding wrote:
> > On Wed, Aug 14, 2013 at 03:43:40PM -0600, Stephen Warren wrote:
> >> On 08/13/2013 05:12 AM, Thierry Reding wrote:
> >>> Implement the platform driver's .remove() callback to free all
> >>> resources allocated during driver setup and call
> >>> pci_common_exit() to cleanup ARM specific datastructures. Unmap
> >>> the fixed PCI I/O mapping by calling the new pci_iounmap_io()
> >>> function in the new .teardown() callback.
> >>>=20
> >>> Finally, no longer set the .suppress_bind_attrs field to true
> >>> to allow the driver to unbind from a device.
> >>=20
> >>> +static int tegra_pcie_remove(struct platform_device *pdev) +{=20
> >>> +	struct tegra_pcie *pcie =3D platform_get_drvdata(pdev); +
> >>> struct tegra_pcie_bus *bus, *tmp; +	int err; + +
> >>> pci_common_exit(&pcie->sys); + +	list_for_each_entry_safe(bus,
> >>> tmp, &pcie->busses, list) { +		vunmap(bus->area->addr); +
> >>> kfree(bus); +	} + +	if (IS_ENABLED(CONFIG_PCI_MSI)) { +		err =3D
> >>> tegra_pcie_disable_msi(pcie); +		if (err < 0) +			return err; +
> >>> }
> >>=20
> >> Wouldn't it make sense to do that as early as possible in the
> >> function, to make sure that no MSI accidentally fires after some
> >> of the cleanup has already happened?
> >=20
> > I don't think that's strictly necessary in this case. After the
> > call to pci_common_exit() there are no PCI devices left, there's
> > not even a bus left. All MSI users should have cleaned up after
> > themselves.
> >=20
> > Given that I thought it more useful to mirror the setup done in
> > .probe() to make it clearer what's being undone (and potentially
> > what's missing).
>=20
> That makes sense SW-wise, but what about mis-behaving HW that triggers
> an MSI even when it's been told not to? I assume that
> tegra_pcie_disable_msi() unrequests the IRQ, hence solves that
> problem, if done early enough.

To be honest, I'm not sure about the side-effects that this will have.
tegra_pcie_disable_msi() does quite a bit more than just masking the
interrupts. It also completely removes the IRQ domain that provides the
MSI interrupts. While I haven't tried it yet I can imagine that it will
cause crashes at a later point when drivers want to disable MSI on a
device and the IRQ domain having vanished from underneath.

Thierry

--sXc4Kmr5FA7axrvy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSEn0XAAoJEN0jrNd/PrOhEaMQAINyaMv3aopPIBEAx3AOT3ej
uzzRA0Rd0XdNazWYbeMNsAc+4EAVyLxn2urcwBHeAnWFMvrM5AUzZyWa/Tps16eV
FCKq0zqMxdzJrSS3L+110wC3Rpo18zIWmOINJuJi0lg5WOPXZ6rNp0oQCZAM+vOh
MKG5RrWXRy+UDhYQExa+ng3V/mzliRxBag1QWoYTH6z9SCXLu8mUix4j+ZszyAJL
R35fhg3Pb/KDb+YOOM1dVpclqlInBoK25P7Z4g0B13SUM2pAT0qYVwxaupnm03o4
moaFafOET7ZiJZkeLwKWmlzrc22uEuxDY89DyPJrktLbv2OGAepuU1PumIMXFnY/
25BHAEHbI0v3vCFtPlpAQD2EM6wKJyk+htnGGrmvgEeE+3C6RMAWdxiu3bndC0sW
NsYA4vpF4cHzYKvXnNT5+JVX70XP8S67geOdDjrD3wGW15q+n5GRpHVeqGJi3xF5
TGjGXs672+h17SCpstXwAtm8Arn39ESTObIbSJo78aX4lo+UDaVOIkd9J8F8YS4Q
KCIbQfAakor0vrhXCtZnFnaBGmEYLZ5lMj6CwB1ihSrFWMouTu5/Mkj/T7FiDPJ0
oW01l8jhQI0srjc2ZgyM6xQTqrrlvWDI+V1AY9KdIUq5O5q4vn+Rh1PpgNBSv7QS
Y6qL9MjeKQ+5GUcFZkwh
=Wbys
-----END PGP SIGNATURE-----

--sXc4Kmr5FA7axrvy--
