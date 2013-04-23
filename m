Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab3DWLQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 07:16:20 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37796 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3DWLQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:16:18 -0400
Date: Tue, 23 Apr 2013 14:15:41 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: Vivek Gautam <gautamvivek1987@gmail.com>, <balbi@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <stern@rowland.harvard.edu>, <sarah.a.sharp@linux.intel.com>,
        <rob.herring@calxeda.com>, <kgene.kim@samsung.com>,
        <dianders@chromium.org>, <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130423111541.GY15177@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
 <20130402082342.GF30286@arwen.pp.htv.fi>
 <CAFp+6iFW9-fOCgCfpfQzS9PZyjb9_NahjSxzbrS0AhVeNngyXw@mail.gmail.com>
 <20130402121048.GA9488@arwen.pp.htv.fi>
 <CAFp+6iEqHOc6G+4UpUGneQ43FGf11DOH_LignFiXJxVJnjry2w@mail.gmail.com>
 <516FDDF3.30507@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="edESjMboOAwUFn6i"
Content-Disposition: inline
In-Reply-To: <516FDDF3.30507@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--edESjMboOAwUFn6i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Apr 18, 2013 at 05:20:11PM +0530, Kishon Vijay Abraham I wrote:
> >>>>>Adding  APIs to handle runtime power management on PHY
> >>>>>devices. PHY consumers may need to wake-up/suspend PHYs
> >>>>>when they work across autosuspend.
> >>>>>
> >>>>>Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >>>>>---
> >>>>>  include/linux/usb/phy.h |  141 +++++++++++++++++++++++++++++++++++=
++++++++++++
> >>>>>  1 files changed, 141 insertions(+), 0 deletions(-)
> >>>>>
> >>>>>diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> >>>>>index 6b5978f..01bf9c1 100644
> >>>>>--- a/include/linux/usb/phy.h
> >>>>>+++ b/include/linux/usb/phy.h
> >>>>>@@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(=
enum usb_phy_type type)
> >>>>>               return "UNKNOWN PHY TYPE";
> >>>>>       }
> >>>>>  }
> >>>>>+
> >>>>>+static inline void usb_phy_autopm_enable(struct usb_phy *x)
> >>>>>+{
> >>>>>+     if (!x || !x->dev) {
> >>>>>+             dev_err(x->dev, "no PHY or attached device available\n=
");
> >>>>>+             return;
> >>>>>+             }
> >>>>
> >>>>wrong indentation, also, I'm not sure we should allow calls with NULL
> >>>>pointers. Perhaps a WARN() so we get API offenders early enough ?
> >>>
> >>>True, bad coding style :-(
> >>>We should be handling dev_err with a NULL pointer.
> >>>Will just keep here:
> >>>if (WARN_ON(!x->dev))
> >>>       return .... ;
> >>
> >>right, but I guess:
> >>
> >>if (WARN(!x || !x->dev, "Invalid parameters\n"))
> >>         return -EINVAL;
> >>
> >>would be better ??
>=20
> btw, shouldn't it be IS_ERR(x)?

not in this case, since we're trying to catch users passing NULL to as
the phy argument.

--=20
balbi

--edESjMboOAwUFn6i
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdm1dAAoJEIaOsuA1yqREaOYP/ilMFJ7fBdvCqCIMnDWmjeF9
m7aiur+xk0TGPYKaxl9jTgEyA8AISPxwM76XVOB4PGpKu2fQP2ltpVVvOOW2wR4l
oADNYNEYqugkEqBW7tzB8S/VX0cJNy+yTVEFoY/Xlj7DkLFyB7lvMqAx7X+L/8lf
MrxmyQGOniIxg4aBB425nM6yLGH6PJ2heWLDc9a+XfGd8R2zpnVqM9lZOB4H6pzP
A75RSaIuj/RSGWZ6hhIyf/yC+EcH4AJX9SYICKOLDLU8bNhGhsJHt15eNV2tVzHJ
75hszKM8p7ekivIQJr29poT7HQvz7P1+ST6SR5XujB12DAJV6kVJwmZZ6Qx6uqrw
nK8kk1XCi73ZxJh9bycxWmPSkzE2g6EofK6kGilwU6/I03nknSOMTMicK2c+p8dU
Ej2l2rPTPi+KyVzNH60GbRPVa1xoYc9F97dPoiRsDdtzdPvXsKGz5uAexao+8pHl
kAAyCkMqZ3cOCpsVwnfQyWUYMgOEadWcs+6Eksw+gagTLNaHaNuAaFEUMWaMQ2NE
AoHWHTAp29l8cCt+wHHB1u42lxRO2rljr951nM/XvLx4I6OFssUr3ntREZZN5bMA
gFUFTQhwYtvIeQvotMDEjOypoqE9flebOfYdEyk9DyGvdeGH6mN1sLtsBTLHROvT
E+Nn1pRhwk/4P0HvS4mi
=yds5
-----END PGP SIGNATURE-----

--edESjMboOAwUFn6i--
