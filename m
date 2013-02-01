Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3BAJoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 04:44:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:56407 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab3BAJoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 04:44:03 -0500
Date: Fri, 1 Feb 2013 11:43:27 +0200
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
Message-ID: <20130201094326.GK8060@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <510A56BF.3040804@ti.com>
 <CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
 <20130131152527.GE4064@arwen.pp.htv.fi>
 <CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
 <20130131153836.GF4064@arwen.pp.htv.fi>
 <510B50DA.6010201@ti.com>
 <CAFp+6iF2HMmiMVR4YyEG7bmpCZ4KdwBT7q2Jy-P1SMVtoVBn6g@mail.gmail.com>
 <CAFp+6iGZU29nt4yBjkyeeS+s_D1=AamgGTOsJq1xo_5z2O-sDg@mail.gmail.com>
 <20130201085053.GG8060@arwen.pp.htv.fi>
 <CAFp+6iFBL8LOh=dw=mvHaUHjKvmLr0of83dmC6wf4zHog8xubw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yQDbd2FCF2Yhw41T"
Content-Disposition: inline
In-Reply-To: <CAFp+6iFBL8LOh=dw=mvHaUHjKvmLr0of83dmC6wf4zHog8xubw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--yQDbd2FCF2Yhw41T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 01, 2013 at 02:23:28PM +0530, Vivek Gautam wrote:
> >> >>>>> On Thu, Jan 31, 2013 at 08:53:27PM +0530, Vivek Gautam wrote:
> >> >>>>>>>>
> >> >>>>>>>> Moreover, SoCs having multiple dwc3 controllers will have mul=
tiple
> >> >>>>>>>> PHYs, which eventually be added using usb_add_phy_dev(), and =
not
> >> >>>>>>>> using usb_add_phy(). So each dwc3 controller won't be able to
> >> >>>>>>>> get PHYs by simply calling devm_usb_get_phy() also.
> >> >>>>>>>
> >> >>>>>>>
> >> >>>>>>> No. We have added usb_get_phy_dev() for that purpose in the ca=
se of
> >> >>>>>>> non-dt.
> >> >>>>>>> I think, instead you can have a patch to use devm_usb_get_phy_=
dev()
> >> >>>>>>> here and
> >> >>>>>>> in exynos platform specific code use usb_bind_phy() to bind th=
e phy
> >> >>>>>>> and
> >> >>>>>>> controller till you change it to dt.
> >> >>>>>>>
> >> >>>>>>
> >> >>>>>> We have dt support for dwc3-exynos, in such case we should go a=
head
> >> >>>>>> with
> >> >>>>>> of_platform_populate(), right ?
> >> >>>>>> But if when i use of_platform_populate() i will not be able to =
set
> >> >>>>>> dma_mask to dwc3->dev. :-(
> >> >>
> >> >>
> >> >> You can do something like this
> >> >>
> >> >> static u64 dwc3_exynos_dma_mask =3D DMA_BIT_MASK(32);
> >> >>
> >> >> static int dwc3_exynos_set_dmamask(struct device *dev, void *c)
> >> >> {
> >> >>         dev->dma_mask =3D &dwc3_exynos_dma_mask;
> >> >>
> >> >>         return 0;
> >> >> }
> >> >>
> >> >> And in your probe after of_platform_populate, you can add
> >> >>
> >> >> device_for_each_child(&pdev->dev, NULL, dwc3_exynos_set_dmamask);
> >> >>
> >> >> Here pdev is the platform device of dwc3-exynos. By this way all the
> >> >> children of dwc3-exynos will have dma_mask set to the required valu=
e.
> >> >>
> >> >
> >> > Nice idea, thanks :-)
> >> > hmm.. so i can patch this now, and get things working ;-)
> >> >
> >>
> >> If this is fine with you shall i go ahead and post a patch for the sam=
e ? ;-)
> >
> > should be fine, but we can wait a bit to see if DeviceTree folks reply,
> > your patch will only go on v3.10 anyway.
> >
>=20
> Yeah, sure. No problem at all.
> For the time being i will continue to use this change for my other
> development work too. :-)

Sure, makes sense ;-)

--=20
balbi

--yQDbd2FCF2Yhw41T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRC44+AAoJEIaOsuA1yqRE9k4P/Rt3DdOUHTa0eTsJxbqvMD3r
Ksg4aa8fb3gcrp5kM0m1+pDWLHVTQaWqjDZtl1C2k9iBkv+LMhmmVbI2s9cWuQ/l
VG93Y2hHNDJqI0d1sWHoNVc+TTw0BugPgk1cbXydYKKQqJ7lmCluK99NyuvwnamB
LvT4ioe7Ku6eKn/VWntpwvD+squnSnTa+o1ss2juJyDAbqfO/ZiNjkgrOBj3L9Xv
y+SYLz60ghS9pgavULC55jQGEhd0ATzPiV7hORqrMcvoaD0DujRol7z1DfHILbWW
ATyikvCF7+znFt1BMiGpcsvjXrP13YEuhSpT4eg9/BOfI0Wx2lzExoFqDZd7AU3i
apA97D681z1wOhqNdKKKbvvS/B+dVzwsvgw/+NSU1pqARqLqN69lqni6RDZvjjAo
+slII1EjLyp3z1d4rzUXbjxm0WpnsGPoeCOk5Fvfki4Kzbmyo3X46K12lWyoXfcl
FwzPaQJPc9+gmqjUg2hKIjyeXkkkIO8Kw90tI45pQbeabeurq2HXAXlD3zNA0HyY
SJ67/Ov9Q1Ha6bC/VvpgQzNsw7l1dzT17VGqAzkAG2PjM/bE6Dxz/qSofUAuYBnl
YdyEsrj++PjfEv4fC+UbgQIFJkfpvMCTgQ7gVd+MFsQW4A2RkAFOlA5+wnxwlBSc
6/8elnnoWyMQNDTGaXVs
=1AQM
-----END PGP SIGNATURE-----

--yQDbd2FCF2Yhw41T--
