Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaKRAdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:33:41 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43330 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753271AbaKRAdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:33:38 -0500
Date: Mon, 17 Nov 2014 18:33:05 -0600
From: Felipe Balbi <balbi@ti.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: <balbi@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH V5 09/12] usb: xhci: Add NVIDIA Tegra xHCI
 host-controller driver
Message-ID: <20141118003305.GB11280@saruman>
Reply-To: <balbi@ti.com>
References: <1416264102-1323-1-git-send-email-abrestic@chromium.org>
 <1416264102-1323-10-git-send-email-abrestic@chromium.org>
 <20141117231240.GB9716@saruman>
 <CAL1qeaG1=g39gsRHPrmCTBFbn3XQmW_2N7rm7uWa=-xOzDiDHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <CAL1qeaG1=g39gsRHPrmCTBFbn3XQmW_2N7rm7uWa=-xOzDiDHQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Nov 17, 2014 at 03:51:29PM -0800, Andrew Bresticker wrote:
> >> +static const struct {
> >> +     const char *name;
> >> +     unsigned int num;
> >> +} tegra_xhci_phy_types[] =3D {
> >> +     {
> >> +             .name =3D "usb3",
> >> +             .num =3D TEGRA_XUSB_USB3_PHYS,
> >> +     }, {
> >> +             .name =3D "utmi",
> >> +             .num =3D TEGRA_XUSB_UTMI_PHYS,
> >> +     }, {
> >> +             .name =3D "hsic",
> >> +             .num =3D TEGRA_XUSB_HSIC_PHYS,
> >> +     },
> >
> > these should be using the generic PHY subsystem (drivers/phy).
>=20
> This driver does use the generic PHY subsystem, see patch 7 in this serie=
s :).

true, I got misled by the fact that you added your phy provider to your
pinctrl. Odd.

> >> +static int tegra_xhci_load_firmware(struct tegra_xhci_hcd *tegra)
> >> +{
> >> +     struct device *dev =3D tegra->dev;
> >> +     struct tegra_xhci_fw_cfgtbl *cfg_tbl;
> >> +     struct tm fw_tm;
> >> +     u32 val, code_tag_blocks, code_size_blocks;
> >> +     u64 fw_base;
> >> +     time_t fw_time;
> >> +     unsigned long timeout;
> >> +
> >> +     if (csb_readl(tegra, XUSB_CSB_MP_ILOAD_BASE_LO) !=3D 0) {
> >> +             dev_info(dev, "Firmware already loaded, Falcon state 0x%=
x\n",
> >> +                      csb_readl(tegra, XUSB_FALC_CPUCTL));
> >> +             return 0;
> >> +     }
> >
> > won't this prevent rmmod && insmod from succeeding ? Maybe not, as you
> > return 0 anyway, but if the firmware side craps out, it might be useful
> > to reload the firmware and reset that block. I wonder if this prevents
> > that.
>=20
> rmmod && insmod does work with the above since, as you mentioned, we
> return successfully if the controller is already running.  Attempting
> to re-load the firmware if the controller is already running won't
> work - it requires a full power-gate/ungate sequence of the
> controller.  Unfortunately, that sequence is rather complicated and I
> haven't had a chance to implement it yet.  it will hopefully be coming
> later, though.

Alright, could you add a comment on the source code stating that ?
Perhaps a REVISIT note or FIXME ?

cheers

--=20
balbi

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUapPBAAoJEIaOsuA1yqREycsP/jumgu3nWi8y6s41zVrOCUIi
Jx1odGzzxRoTszdOckXWoycGoOnZKJBNFqXrcbQJj+xZU73mZrn3lAGfestpdSrG
hkG8UrtxJ8WJ/JqgfV715gY/YpICd4XFSJzQDDb5C0k/QhAkZNaw3+yvgfaBbXmr
bCE9Pc9+keavZ7XrkYrHs6S2RTN2hBpH9+JfO+G7kC8q7x2b1XYzfocT4AIBNAZp
Ak58XBxU2kWgyPAZ4Qmswu6c4llK+P1du1z5UCg0RQdsGMTbM4zaysOUD/HENI/W
oBkVLP9Fn5qjIhsQMWFm8342gYuq824GwYHmC3T4C4MSs4mf9t9JWPgK5iqEYNXo
cHXRbFS+Y4W3pghaKphimlZ43vYS6OEkGJQNLxYsfkBURgHlcSRYfFDuLxqiNulg
qeUT8DV0nN1TxOPYEMnXaLAtLruaK6UfNOvN2J/qbHpbQqJbfRbrLxufI4V2z4wP
OO/cpe4xTgucbtsHRYxysjSAwnuIgpUyEhASxo6qV+OEoy9qkFqtHoF5jD0lV+Us
zejKfghXdMze2BA37gaZjf/Va8CV0A0QoRf3XVs+NEmDF7MpquQrKsqPbnQVxfkK
J8cRkXjwymkaN8Mugk5/xAJXFQjMMet4SZfDKNB2DR2uC4Eq0FBL+W1yyFEhin6a
6UhzmgfG7KwbfuQCw2mH
=KMdC
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
