Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab3AVIuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:50:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57507 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753209Ab3AVIuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:50:23 -0500
Date: Tue, 22 Jan 2013 10:50:04 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kukjin Kim <kgene.kim@samsung.com>
CC: "'Vivek Gautam'" <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <thomas.abraham@linaro.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <sylvester.nawrocki@gmail.com>,
        <dianders@chromium.org>, <jg1.han@samsung.com>, <p.paneri@samsung.com>,
        <cpgs@samsung.com>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v6 0/4] Adding usb2.0 host-phy support for exynos5250
Message-ID: <20130122085004.GD16143@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1357916550-11421-1-git-send-email-gautam.vivek@samsung.com>
 <053c01cdf860$9e98df20$dbca9d60$@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fXStkuK2IQBfcDe+"
Content-Disposition: inline
In-Reply-To: <053c01cdf860$9e98df20$dbca9d60$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fXStkuK2IQBfcDe+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI,

On Mon, Jan 21, 2013 at 09:23:28PM -0800, Kukjin Kim wrote:
> Vivek Gautam wrote:
> >=20
> > Changes from v5:
> >  - Rebased on top of latest patches:
> >         usb: phy: samsung: Introducing usb phy driver for hsotg (v9)
> >         usb: phy: samsung: Add support to set pmu isolation (v6)
> >    As a result adding hostphy enable mask and hostphy register offsets
> >    to driver data in order to access the HOSTPHY CONTROL register.
> >=20
> >  - Adding member 'otg' to struct samsung-usbphy so that its consumers
> >    can call otg->set_host so as to make 'phy' aware of the consumer typ=
e:
> > 	HOST/DEVICE
> >=20
> >  - Adding 'otg' to 'struct s5p_ehci_hcd' and 'struct exynos_ohci_hcd'
> >    which keeps track of 'otg' of the controllers' phy. This then sets
> >    the host.
> >=20
> >  - Moved samsung_usbphy_set_type() calls from ehci-s5p and ohci-exynos
> >    to phy driver itself where based on phy_type it is called.
> >=20
> >  - Added separate macro definition for USB20PHY_CFG register to select
> >    between host/device type usb link.
> >=20
> >  - Removing unnecessary argument 'phy_type' from
> > samsung_usbphy_set_type()
> >    and samsung_usbphy_cfg_sel().
> >=20
> >  - Addressed few nits:
> > 	-- added macro for 'KHZ'
> > 	-- removing useless 'if' from samsung_usbphy_cfg_sel()
> > 	-- keeping the place of clk_get intact and requesting driver
> > 	   data before that.
> >=20
> > Vivek Gautam (4):
> >   ARM: EXYNOS: Update & move usb-phy types to generic include layer
> >   usb: phy: samsung: Add host phy support to samsung-phy driver
> >   USB: ehci-s5p: Add phy driver support
> >   USB: ohci-exynos: Add phy driver support
> >=20
> >  .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +-
> >  drivers/usb/host/ehci-s5p.c                        |   81 +++-
> >  drivers/usb/host/ohci-exynos.c                     |   85 +++-
> >  drivers/usb/phy/Kconfig                            |    2 +-
> >  drivers/usb/phy/samsung-usbphy.c                   |  512
> ++++++++++++++++++--
> >  include/linux/usb/samsung_usb_phy.h                |   16 +
> >  6 files changed, 635 insertions(+), 73 deletions(-)
> >  create mode 100644 include/linux/usb/samsung_usb_phy.h
> >=20
> > --
> > 1.7.6.5
>=20
> Looks good to me,
>=20
> Felipe and Greg, I don't know who should take this series anyway, feel fr=
ee
> to add  my ack:
>=20
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

I will take care of it. But I need Alan's Acked-by for EHCI and OHCI
parts.

--=20
balbi

--fXStkuK2IQBfcDe+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/lK7AAoJEIaOsuA1yqREY+cQAKG7OfsZ9AuSFPy95plICRni
zh2KSmmr17QaLjW74ifH826RsR0fe9Htt+GiqVEcONNV/9WaNRWm4EP6ZFWCY+/5
CNya6MySxQeSpbajzeLx8ziiUmPmAIN4kSUFq43Oimj8+s6qJn/pgx99wjfIlAEs
3j2KpbDVnjooxHDXLtPNg7poJOkpE1LSGy61hdqA6huT1UlmOuD06q1kBtjFbkc6
88wJrvZZXDDdULfy7KsNEUnXASHpiCkpH87a2Xn4wGEa4qqPOUqRGCbzO+s0hNRV
0i8FTrhg0WwcCbozoFS+XzbTlBPQxD7HWn/9J5kbRpHw45F6qGlEFXE0dNWfQJYW
esPJ49qs+gNjPDgriI+0lvEN7jB/d9JWWGaWmT2+2ksZvVLThBQFEg/r2lND8HPc
O21DVdUfkke5tu4c9+NHVLy8ZeVT/lEHQBi7dewdWoPm8X3c68jWVNAIZCnP13XF
zihiXlED3X/161ivnR0aU6SrvDzJZtaSghK3KhCCZRy5lTC2vdvJ6kJqTSgrcom5
20Uh3CV61m6tFqtDqoTrvzdw6FeZhNzBbOC4TlGFMK5nATSTRmXL7MWWaBl3WwHf
3DpjOXmasvpktlfjDF6+y884OseQciNcqgf/pgaPraiH1slnlGVNZFjkzAY9Ray0
Wz6DVMrXCE5zSigYNwBG
=0HyY
-----END PGP SIGNATURE-----

--fXStkuK2IQBfcDe+--
