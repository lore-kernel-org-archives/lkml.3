Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3BAIve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 03:51:34 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:45416 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab3BAIv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 03:51:28 -0500
Date: Fri, 1 Feb 2013 10:50:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: <balbi@ti.com>, kishon <kishon@ti.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt
 node.
Message-ID: <20130201085053.GG8060@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
 <510A56BF.3040804@ti.com>
 <CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
 <20130131152527.GE4064@arwen.pp.htv.fi>
 <CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
 <20130131153836.GF4064@arwen.pp.htv.fi>
 <510B50DA.6010201@ti.com>
 <CAFp+6iF2HMmiMVR4YyEG7bmpCZ4KdwBT7q2Jy-P1SMVtoVBn6g@mail.gmail.com>
 <CAFp+6iGZU29nt4yBjkyeeS+s_D1=AamgGTOsJq1xo_5z2O-sDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHbokkKX1kTiQeDC"
Content-Disposition: inline
In-Reply-To: <CAFp+6iGZU29nt4yBjkyeeS+s_D1=AamgGTOsJq1xo_5z2O-sDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xHbokkKX1kTiQeDC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 01, 2013 at 11:54:01AM +0530, Vivek Gautam wrote:
> Hi Balbi,
>=20
>=20
> On Fri, Feb 1, 2013 at 11:52 AM, Vivek Gautam <gautamvivek1987@gmail.com>=
 wrote:
> > Hi Kishon,
> >
> >
> > On Fri, Feb 1, 2013 at 10:51 AM, kishon <kishon@ti.com> wrote:
> >> Hi,
> >>
> >>
> >> On Thursday 31 January 2013 09:08 PM, Felipe Balbi wrote:
> >>>
> >>> On Thu, Jan 31, 2013 at 09:00:37PM +0530, Vivek Gautam wrote:
> >>>>
> >>>> Hi Felipe,
> >>>>
> >>>>
> >>>> On Thu, Jan 31, 2013 at 8:55 PM, Felipe Balbi <balbi@ti.com> wrote:
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>> On Thu, Jan 31, 2013 at 08:53:27PM +0530, Vivek Gautam wrote:
> >>>>>>>>
> >>>>>>>> Moreover, SoCs having multiple dwc3 controllers will have multip=
le
> >>>>>>>> PHYs, which eventually be added using usb_add_phy_dev(), and not
> >>>>>>>> using usb_add_phy(). So each dwc3 controller won't be able to
> >>>>>>>> get PHYs by simply calling devm_usb_get_phy() also.
> >>>>>>>
> >>>>>>>
> >>>>>>> No. We have added usb_get_phy_dev() for that purpose in the case =
of
> >>>>>>> non-dt.
> >>>>>>> I think, instead you can have a patch to use devm_usb_get_phy_dev=
()
> >>>>>>> here and
> >>>>>>> in exynos platform specific code use usb_bind_phy() to bind the p=
hy
> >>>>>>> and
> >>>>>>> controller till you change it to dt.
> >>>>>>>
> >>>>>>
> >>>>>> We have dt support for dwc3-exynos, in such case we should go ahead
> >>>>>> with
> >>>>>> of_platform_populate(), right ?
> >>>>>> But if when i use of_platform_populate() i will not be able to set
> >>>>>> dma_mask to dwc3->dev. :-(
> >>
> >>
> >> You can do something like this
> >>
> >> static u64 dwc3_exynos_dma_mask =3D DMA_BIT_MASK(32);
> >>
> >> static int dwc3_exynos_set_dmamask(struct device *dev, void *c)
> >> {
> >>         dev->dma_mask =3D &dwc3_exynos_dma_mask;
> >>
> >>         return 0;
> >> }
> >>
> >> And in your probe after of_platform_populate, you can add
> >>
> >> device_for_each_child(&pdev->dev, NULL, dwc3_exynos_set_dmamask);
> >>
> >> Here pdev is the platform device of dwc3-exynos. By this way all the
> >> children of dwc3-exynos will have dma_mask set to the required value.
> >>
> >
> > Nice idea, thanks :-)
> > hmm.. so i can patch this now, and get things working ;-)
> >
>=20
> If this is fine with you shall i go ahead and post a patch for the same ?=
 ;-)

should be fine, but we can wait a bit to see if DeviceTree folks reply,
your patch will only go on v3.10 anyway.

cheers

--=20
balbi

--xHbokkKX1kTiQeDC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRC4HtAAoJEIaOsuA1yqRE93QP+gKvRYC+g4evMbmz3jxgxtug
RWPlL5K3sKlPK9Frc4SM9cXIdJCodmD1NiI8whuTII5ancFlil8k9baro3CtoPSp
PkziXIucCzx0Zt2TH2T8EOKVZhZ2g+KpFDfqJLsuK8/N+qnbh65ETcOLuI9WzaAB
E+uwUkhgF/IYQB2n+waNGOojXWD0Uq8H6q0esnPQyPkChvzDfv00EohtD0/TMQMn
SV7xV5QYh6VRuzELwtRpzmfskdA2c+ndt+7EdxSq5CVzLdWzNBttJqNshFOsYDJt
0T3+gGtHwNvFYfmTAQZSlkxOzdit8IgZTC7isz26PA+QOZ/jDrmQUA+GsffwSN4F
vIS6XhPY3yc9lFFPyJj57vU+5qJUveU7RdkX4J/yhmgmS1zFr1Kn1kGTGDeQ7kd6
AXqTFYvO4qpRyTBGYonAHHM9gTtDn+/VZkxTWK+WhXBBHP0jctpTKX+XTg6QRTpM
w3jd9bXdObbhaIrY5UV5CRFA82JyPw2U1NsvJR7I4x3v0VhVKWbOWkZxM8EewBSt
9bSNbYfMPNDf1EDNSLL8nNliIMZZ+S995M31nez5ZO4HW5GkLRxBGHoWdvSCjMhf
N6lUVbr52NewoHK3IzahvCQi7GJ3a4aRt6OlQnz/mkIuWbYE5jHazaJjlF4vkmt4
KqzJLb8PZTkqz41nhv4j
=Iymc
-----END PGP SIGNATURE-----

--xHbokkKX1kTiQeDC--
