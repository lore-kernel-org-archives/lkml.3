Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab3A1N0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 08:26:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57714 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3A1N0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:26:23 -0500
Date: Mon, 28 Jan 2013 15:25:59 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <sarah.a.sharp@linux.intel.com>,
        <kgene.kim@samsung.com>, <dianders@chromium.org>,
        <sylvester.nawrocki@gmail.com>, <tomasz.figa@gmail.com>
Subject: Re: [PATCH 4/4] usb: phy: samsung: Enable runtime power management
 on samsung-usb3
Message-ID: <20130128132558.GP28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-5-git-send-email-gautam.vivek@samsung.com>
 <20130128120909.GG28698@arwen.pp.htv.fi>
 <CAFp+6iHjzSKyya-t6dtsVQdOuhBTsCgWu+NFnDXFeRWwnBt-Jw@mail.gmail.com>
 <20130128130703.GO28698@arwen.pp.htv.fi>
 <CAFp+6iHSvJdsT-Bdq2nPWo8L+LFigdrx9=2XEind9H8XC9BCFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1BKOZKwX7DAU5odC"
Content-Disposition: inline
In-Reply-To: <CAFp+6iHSvJdsT-Bdq2nPWo8L+LFigdrx9=2XEind9H8XC9BCFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1BKOZKwX7DAU5odC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 06:54:42PM +0530, Vivek Gautam wrote:
> Hi Felipe,
>=20
>=20
> On Mon, Jan 28, 2013 at 6:37 PM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Mon, Jan 28, 2013 at 06:34:15PM +0530, Vivek Gautam wrote:
> >> >> @@ -65,7 +67,22 @@ static u32 samsung_usb3_phy_set_refclk(struct sa=
msung_usbphy *sphy)
> >> >>       return reg;
> >> >>  }
> >> >>
> >> >> -static int samsung_exynos5_usb3_phy_enable(struct samsung_usbphy *=
sphy)
> >> >> +/*
> >> >> + * Sets the phy clk as ref_pad_clk (XusbXTI) which is clock from e=
xternal PLL.
> >> >> + */
> >> >> +static u32 samsung_usb3_phy_set_refclk_ext(void)
> >> >> +{
> >> >> +     u32 reg;
> >> >> +
> >> >> +     reg =3D PHYCLKRST_REFCLKSEL_PAD_REFCLK |
> >> >> +             PHYCLKRST_FSEL_PAD_100MHZ |
> >> >> +             PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF;
> >> >> +
> >> >> +     return reg;
> >> >> +}
> >> >
> >> > I wonder if you really need this small function (likewise for
> >> > set_refclk_int()). They don't do much, so you could just inline them=
 on
> >> > the only caller.
> >> >
> >>
> >> Created this just to keep symmetry, ;-)
> >> will move this in the caller only.
> >
> > you can have a patch before this series moving the refclk_int() to the
> > caller, then you will have symmetry ;-)
> >
>=20
> refclk_int() was rather slightly a big chunk :-(
> as available in below patch as samsung_usb3_phy_set_refclk() :
> [PATCH v4 2/2] usb: phy: samsung: Add PHY support for USB 3.0 controller
> http://www.mail-archive.com/linux-usb@vger.kernel.org/msg13796.html
>=20
> Will try to figure best possible way and amend.

oh, right... In that case, keep the way it is. Ignore my comment ;-)

--=20
balbi

--1BKOZKwX7DAU5odC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBnxmAAoJEIaOsuA1yqREbSoP/0iKcZf2KXv3I+7jn6fbQ+UL
GOHO7IuFbpGAfhJctpivIgVVNPonhJKEze0mTT5AqdVSlgmy5bgilvl9H7K/bgtQ
XORLLZVR9wISGNGraZ95dMGjFHAwNUyu5jPejBwKB6KjaFHPT+LR3eCO1SrH1SGq
LTroBuc29w6y9SVhI4E6K9kVg09w8LPuT9sYQSGfIUwfgKwCBuqTqivWQy8GNUFg
FvrXiWgzu+BMcsUDLRnuFuAsvnjHD9EULnN6PuY+jqwFa9XVgtN1AELktT+V85d6
L9Zfln9Njy9pPfLXus/8O8xyuZQk9yl8GhRUyIiXaYAq4cxBKzI0ctIcZVojx/Le
MdbQHXBcCt2vJQWSOraajZ5xtOOBdbGHm9ZqUfOzkKWkOXcvc3TldGhzs2xv0dp+
3BFhuuTXM7u2UJpBFlmD0cK+6Dlmg0VgCiPOFr2t6aAQLvN8kdjscAzlGdMsb3Wf
EB1wjKa72sYQb2tGZAcfYr6kmt+9xXRnVIQYp8Rv6ugJbzduC8BmjlL56+0WvNpS
Q13jXU1Ot3ZanVrpLW4KKQVyUhultt3/eVkrJg+LnKx3P7m9q8yQahr1pGsjj4ci
F75DRAQHvkWlx2NXPZrkxkIBSmA2vbZzCgAf7lgQS40Ytdu3w2H0BMRx7Gx38Pe9
7BJBn2EBBe2FJ7v4ZNUE
=S2WK
-----END PGP SIGNATURE-----

--1BKOZKwX7DAU5odC--
