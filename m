Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbaF0PBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:01:38 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36040 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbaF0PBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:01:33 -0400
Date: Fri, 27 Jun 2014 10:00:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andrew Bresticker <abrestic@chromium.org>
CC: Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        <balbi@ti.com>
Subject: Re: [PATCH v1 4/9] pinctrl: tegra-xusb: Add USB PHY support
Message-ID: <20140627150004.GF8069@saruman.home>
Reply-To: <balbi@ti.com>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
 <1403072180-4944-5-git-send-email-abrestic@chromium.org>
 <53AB493F.3030802@wwwdotorg.org>
 <CAL1qeaHhoqEPu-j+drNiRMyeutz=qqZPxSP8H+v-sgjZSfS5tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qp4W5+cUSnZs0RIF"
Content-Disposition: inline
In-Reply-To: <CAL1qeaHhoqEPu-j+drNiRMyeutz=qqZPxSP8H+v-sgjZSfS5tQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qp4W5+cUSnZs0RIF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 04:30:48PM -0700, Andrew Bresticker wrote:
> >> +static int usb3_phy_power_on(struct phy *phy)
> >> +{
> >> +     struct tegra_xusb_padctl *padctl =3D phy_get_drvdata(phy);
> >> +     int port =3D usb3_phy_to_port(phy);
> >> +     int lane =3D padctl->usb3_ports[port].lane;
> >> +     u32 value, offset;
> >> +
> >> +     value =3D padctl_readl(padctl, XUSB_PADCTL_IOPHY_USB3_PADX_CTL2(=
port));
> >> +     value &=3D ~((XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_MASK <<
> >> +                 XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_WANDER_SHIFT) |
> >> +                (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_MASK <<
> >> +                 XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_RX_EQ_SHIFT) |
> >> +                (XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_MASK <<
> >> +                 XUSB_PADCTL_IOPHY_USB3_PAD_CTL2_CDR_CNTL_SHIFT));
> >
> > Hmm. So there is a lot of "PHY" stuff here after all.
> >
> > However, the PHYs implemented here appear to implement very low-level
> > I/O pad code, whereas the PHYs we have for our USB 2.0 controller are
> > somewhat higher-level; they're more USB-oriented than just IO pad
> > oriented. Do you know which level of abstraction a Linux PHY object is
> > supposed to be? I could never get an answer when I asked before.
>=20
> The only other PHY driver I've worked with (Exynos USB2/3 PHYs) also
> mainly only did low-level pad control stuff, but looking at a couple
> of other USB PHYs (MSM, MV), there appear to be others that have
> higher-level USB stuff in the PHY driver.  Perhaps Kishon or Felipe
> could offer us some guidance?

well, if you're adding a new driver, I'd rather see folks moving over to
the generic phy framework (drivers/phy) because we're trying really hard
to get rid of drivers/usb/phy/. And I think, in your case, it's actually
ok to use pinctrl because you actually are muxing pads to the USB3 PHY,
you just do it lazyly.

my 2 cents

--=20
balbi

--qp4W5+cUSnZs0RIF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrYb0AAoJEIaOsuA1yqRESYgP/ioYc9AcPqPaQF9qHk26g2D5
+C8aIXKab+FhejXsJDUHJCh2Ww5nECcHwK7BtX7r6C5ZMd07wbAP/4jAEXexYoyc
woaPwonAXa1NL58sojIfcH7fYnc3eYY5PuLImRMruLTs7XKK0hs1y2B/en/dHHnx
V9Y2jQ4sVI5WeD0cV1a7xUTMjNnqCIRSnzl8HBNCPBnd4ZtIF4adTVy79kG4KtnK
SDOu7FBhSqSVtcrFbfWv5bBYbbmJvSxzXgAwMvN6voaQ0NRpVHuPb8HvZXZuzDE7
mNvk5Oab0T5u2DYL1ora6OQ/kXluY3cWCufNlfU+56HS6OIs/TIlOHgKGM5juXZe
0hhVqnazgsxa6/Ci7rV//7hxeX8l4tkHwPiM74sJuPVOhe6u45RUVfsMUsB/um23
IUQNRJp7YtQTBkFM4g8e7MPH/Fx9ezSdRst/0nCIu7E6rlYxoT/s9y+nM/x5Upqt
e/bGrx0OM/rWE/uyW0HgcRhwxYGgKgY45Rg9/ooIoUG6oAkDZSmiSX7vVlbgZbhC
ZWhvMeqDTQQan/ToQFrnk+TdjDj9AXa9Q9cVZvAKcXkXkjel3pSuhhfdAYhflbpI
f7HD6HweVEBqfOOxNUjW1Q5YS/JafmKXZi+Uc8udV0IPhbMlo98lXsaEVaCWKWXq
p2yhgFQ6Q9CmQefgXNgL
=kYXQ
-----END PGP SIGNATURE-----

--qp4W5+cUSnZs0RIF--
