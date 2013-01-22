Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3AVJaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 04:30:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:33512 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab3AVJaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 04:30:05 -0500
Date: Tue, 22 Jan 2013 11:29:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <p.paneri@samsung.com>,
        <cpgs@samsung.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250
Message-ID: <20130122092947.GJ16143@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
 <053c01cdf860$9e98df20$dbca9d60$@samsung.com>
 <20130122085004.GD16143@arwen.pp.htv.fi>
 <CAFp+6iEoCF91HiDbixqsKX5XS_UQrN=+2O7puPqN1MvjY_eHBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YPJ8CVbwFUtL7OFW"
Content-Disposition: inline
In-Reply-To: <CAFp+6iEoCF91HiDbixqsKX5XS_UQrN=+2O7puPqN1MvjY_eHBg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--YPJ8CVbwFUtL7OFW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 22, 2013 at 02:45:26PM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Tue, Jan 22, 2013 at 2:20 PM, Felipe Balbi <balbi@ti.com> wrote:
> > HI,
> >
> > On Mon, Jan 21, 2013 at 09:23:28PM -0800, Kukjin Kim wrote:
> >> Vivek Gautam wrote:
> >> >
> >> > Changes from v5:
> >> >  - Rebased on top of latest patches:
> >> >         usb: phy: samsung: Introducing usb phy driver for hsotg (v9)
> >> >         usb: phy: samsung: Add support to set pmu isolation (v6)
> >> >    As a result adding hostphy enable mask and hostphy register offse=
ts
> >> >    to driver data in order to access the HOSTPHY CONTROL register.
> >> >
> >> >  - Adding member 'otg' to struct samsung-usbphy so that its consumers
> >> >    can call otg->set_host so as to make 'phy' aware of the consumer =
type:
> >> >     HOST/DEVICE
> >> >
> >> >  - Adding 'otg' to 'struct s5p_ehci_hcd' and 'struct exynos_ohci_hcd'
> >> >    which keeps track of 'otg' of the controllers' phy. This then sets
> >> >    the host.
> >> >
> >> >  - Moved samsung_usbphy_set_type() calls from ehci-s5p and ohci-exyn=
os
> >> >    to phy driver itself where based on phy_type it is called.
> >> >
> >> >  - Added separate macro definition for USB20PHY_CFG register to sele=
ct
> >> >    between host/device type usb link.
> >> >
> >> >  - Removing unnecessary argument 'phy_type' from
> >> > samsung_usbphy_set_type()
> >> >    and samsung_usbphy_cfg_sel().
> >> >
> >> >  - Addressed few nits:
> >> >     -- added macro for 'KHZ'
> >> >     -- removing useless 'if' from samsung_usbphy_cfg_sel()
> >> >     -- keeping the place of clk_get intact and requesting driver
> >> >        data before that.
> >> >
> >> > Vivek Gautam (4):
> >> >   ARM: EXYNOS: Update & move usb-phy types to generic include layer
> >> >   usb: phy: samsung: Add host phy support to samsung-phy driver
> >> >   USB: ehci-s5p: Add phy driver support
> >> >   USB: ohci-exynos: Add phy driver support
> >> >
> >> >  .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
> >> >  drivers/usb/host/ehci-s5p.c                        |   81 +++-
> >> >  drivers/usb/host/ohci-exynos.c                     |   85 +++-
> >> >  drivers/usb/phy/Kconfig                            |    2 +-
> >> >  drivers/usb/phy/samsung-usbphy.c                   |  512
> >> ++++++++++++++++++--
> >> >  include/linux/usb/samsung_usb_phy.h                |   16 +
> >> >  6 files changed, 635 insertions(+), 73 deletions(-)
> >> >  create mode 100644 include/linux/usb/samsung_usb_phy.h
> >> >
> >> > --
> >> > 1.7.6.5
> >>
> >> Looks good to me,
> >>
> >> Felipe and Greg, I don't know who should take this series anyway, feel=
 free
> >> to add  my ack:
> >>
> >> Acked-by: Kukjin Kim <kgene.kim@samsung.com>
> >
> > I will take care of it. But I need Alan's Acked-by for EHCI and OHCI
> > parts.
> >
>=20
> We got Alan's ACK for:
> USB: ehci-s5p: Add phy driver support
> USB: ohci-exynos: Add phy driver support

Ok, then as soon as I get back to the office (in a few hours), I'll
start queueing those.

cheers

--=20
balbi

--YPJ8CVbwFUtL7OFW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/lwKAAoJEIaOsuA1yqREnUUP/1mT5q753JR1MKoRNJhvQEeF
Dmqhc3evS4lpTtyL6UIkDMe2sJ/vBdsJKk1fUDYXQRa8fMnTo/INbDIqpJ7SNOkb
cKvvg7TFq0HUSdOm6nqFjdEIKwsuUgvgV3+QLqgldF85OsLwRz8eFcnhkwOFxoab
wBmF5PLeilMKqv/SeCAG5qMi4XgD3VTxeHPMwbAnDaXdZb/MnPtfUVRsijC+MZs+
48OFcQS9OXxwGypwxr0/LiseB/9f3TQaDEOEsvFJTFKBPgRtu2jvj9924/2O/Dy9
ub5Nop+Mew988TZrJ/4sYcvVA1vL4P770pzvgjE/GZbzGUwL+wCAg3rHPlODM3+B
RhzdynnaHdNt99/3ac58ztevHY4UywSbTwUYzGq3sUNpUTckE9FH4056JwwN/qj1
SRtzxBTv7gaXr4fnUlH3o/s4EJikBfwaIzMjqlPtfONLvq0y4fQUJBi9KDh3RBd7
Ghd4BaJnYpJeLHocThjDBHVeuqaOx5C0+LSB3aQxPgLxqIWTtAFbFAlsBGUTPHM9
GgME5eUVqLl7dfKO1wmoHmEWaygqoYPNGhktrt3axdDHlGTcjCqRU7V/CZ5AIDdJ
g6mT49y9nQvgNSoMi4ah+9dYiYXkYoaTz8EVbknir5F5pWo+zPKU9EYLk/H4++sh
LpRDK4EYzhAdiOtSsuUd
=lBTS
-----END PGP SIGNATURE-----

--YPJ8CVbwFUtL7OFW--
