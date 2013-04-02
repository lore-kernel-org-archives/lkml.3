Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572Ab3DBMLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 08:11:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55451 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759764Ab3DBMLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 08:11:12 -0400
Date: Tue, 2 Apr 2013 15:10:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <sarah.a.sharp@linux.intel.com>, <rob.herring@calxeda.com>,
        <kgene.kim@samsung.com>, <kishon@ti.com>, <dianders@chromium.org>,
        <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 01/11] usb: phy: Add APIs for runtime power management
Message-ID: <20130402121048.GA9488@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-2-git-send-email-gautam.vivek@samsung.com>
 <20130402082342.GF30286@arwen.pp.htv.fi>
 <CAFp+6iFW9-fOCgCfpfQzS9PZyjb9_NahjSxzbrS0AhVeNngyXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <CAFp+6iFW9-fOCgCfpfQzS9PZyjb9_NahjSxzbrS0AhVeNngyXw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 02, 2013 at 04:04:01PM +0530, Vivek Gautam wrote:
> > On Mon, Apr 01, 2013 at 07:24:00PM +0530, Vivek Gautam wrote:
> >> Adding  APIs to handle runtime power management on PHY
> >> devices. PHY consumers may need to wake-up/suspend PHYs
> >> when they work across autosuspend.
> >>
> >> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> >> ---
> >>  include/linux/usb/phy.h |  141 ++++++++++++++++++++++++++++++++++++++=
+++++++++
> >>  1 files changed, 141 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
> >> index 6b5978f..01bf9c1 100644
> >> --- a/include/linux/usb/phy.h
> >> +++ b/include/linux/usb/phy.h
> >> @@ -297,4 +297,145 @@ static inline const char *usb_phy_type_string(en=
um usb_phy_type type)
> >>               return "UNKNOWN PHY TYPE";
> >>       }
> >>  }
> >> +
> >> +static inline void usb_phy_autopm_enable(struct usb_phy *x)
> >> +{
> >> +     if (!x || !x->dev) {
> >> +             dev_err(x->dev, "no PHY or attached device available\n");
> >> +             return;
> >> +             }
> >
> > wrong indentation, also, I'm not sure we should allow calls with NULL
> > pointers. Perhaps a WARN() so we get API offenders early enough ?
>=20
> True, bad coding style :-(
> We should be handling dev_err with a NULL pointer.
> Will just keep here:
> if (WARN_ON(!x->dev))
>       return .... ;

right, but I guess:

if (WARN(!x || !x->dev, "Invalid parameters\n"))
	return -EINVAL;

would be better ??

--=20
balbi

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWsrIAAoJEIaOsuA1yqREQqUQAKVLfkvAYQg/Q9ep74qIhTyL
k+51stxin27zlsaK2Bzeoscd/PzQPhz2wTk3vvkOeMgo94+NL+ILr9ZOUzmMWX2W
P9TRTwO+IaX/FMiRpBp30ybgNosxH8xnF5zWJBBuutiS7gKpoTKqz8iA4GVcmjq1
PQohxxKr8CaM6Pm+aI5N6Op+xt1KnvvNennTwQxfq3ddj8sF5X5lXQ/iIZjwupJC
AzRADhr0IXLu3bVFuUPkeBeienn7q3rp2PcnPbo0X1FGO7YyuI3JSOjyt3AjoqJe
r7UsvXcmobRSoa1XWnvRgwlcZIFlhesT1JaFOzd4FzFbuChzBS15cPYEWphHBABt
Vy+S8iJfAt6FpVZXnQ8DGhWy/MVOo7c7Remyvb2zQQ+J97HoduSlRrGiNyLR100H
PMphFt6O0gMmh1dFXehgVotzkDYFMf/1goGW5KptE+iYO4MJCnJHJpEyJfn8b6e6
Bm716Mu/SZaBQVkdHaDWqXfBESwTLw97m3Y9G4bw7zQpoe7fM55ndS7OA2gDLnSq
1cBG9d8MrjoSD3njKU7ZXr90aNthefHDM/OMI5PnvQc8Sp0I+Q24U4cNXiRAznTY
dMeVGhGRikp3+J7aeTblALYMS8xlVAXsuh0Mpu9kR+UgA8voCF3+J/tN89ENCEIT
Lj5qpcvzP2rwopMNQLUb
=+8UT
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
