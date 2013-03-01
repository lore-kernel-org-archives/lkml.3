Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab3CAGlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 01:41:52 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50805 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAGlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 01:41:50 -0500
Date: Fri, 1 Mar 2013 08:41:29 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Felipe Balbi <balbi@ti.com>,
        kishon <kishon@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <devicetree-discuss@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt
 node.
Message-ID: <20130301064129.GF3120@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
 <510A56BF.3040804@ti.com>
 <CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
 <20130131152527.GE4064@arwen.pp.htv.fi>
 <CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
 <20130131153836.GF4064@arwen.pp.htv.fi>
 <CAFp+6iGTqZY=+crcYyu9o5uEP9Nv2=haSqB+nCuqA2_iUand6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="924gEkU1VlJlwnwX"
Content-Disposition: inline
In-Reply-To: <CAFp+6iGTqZY=+crcYyu9o5uEP9Nv2=haSqB+nCuqA2_iUand6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--924gEkU1VlJlwnwX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Feb 28, 2013 at 08:09:33PM +0530, Vivek Gautam wrote:
> On Thu, Jan 31, 2013 at 9:08 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Jan 31, 2013 at 09:00:37PM +0530, Vivek Gautam wrote:
> >> Hi Felipe,
> >>
> >>
> >> On Thu, Jan 31, 2013 at 8:55 PM, Felipe Balbi <balbi@ti.com> wrote:
> >> > Hi,
> >> >
> >> > On Thu, Jan 31, 2013 at 08:53:27PM +0530, Vivek Gautam wrote:
> >> >> >> Moreover, SoCs having multiple dwc3 controllers will have multip=
le
> >> >> >> PHYs, which eventually be added using usb_add_phy_dev(), and not
> >> >> >> using usb_add_phy(). So each dwc3 controller won't be able to
> >> >> >> get PHYs by simply calling devm_usb_get_phy() also.
> >> >> >
> >> >> > No. We have added usb_get_phy_dev() for that purpose in the case =
of non-dt.
> >> >> > I think, instead you can have a patch to use devm_usb_get_phy_dev=
() here and
> >> >> > in exynos platform specific code use usb_bind_phy() to bind the p=
hy and
> >> >> > controller till you change it to dt.
> >> >> >
> >> >>
> >> >> We have dt support for dwc3-exynos, in such case we should go ahead=
 with
> >> >> of_platform_populate(), right ?
> >> >> But if when i use of_platform_populate() i will not be able to set
> >> >> dma_mask to dwc3->dev. :-(
> >> >
> >> > do you have a special need for dma_mask because OF already sets it.
> >> >
> >> If i am not wrong of_platform_device_create_pdata() will set
> >> "dev->dev.coherent_dma_mask =3D DMA_BIT_MASK(32)"
> >> and not dma_mask.
> >> I fact we had some discussion sometime back when we needed the same
> >> for dwc3-exynos in the thread:
> >> [PATCH v2 1/2] USB: dwc3-exynos: Add support for device tree
> >>
> >> But couldn't get final node on it.
> >> So suggestions here please. :-)
> >
> > hmm.. you're right there. Grant, Rob ? Any hints ?
> >
>=20
> Any suggestions on this ?

anyone ?

--=20
balbi

--924gEkU1VlJlwnwX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRME2ZAAoJEIaOsuA1yqREwBEQAKJl3/2/4qkkHZwyV+aUYAxX
goGdCgTswl8ZS7cO7te6OxLLsOJIu9Mh+MjAoKoT3R1xjZ2dSI0OCa6snNAbvx7O
GR/HyoGXAbHDJVYxSyzc1OL6aXTUVN97TE1/JlpDgdhEknxksaar1O0X572O57sB
KznO2E36Jc4Pp73I+GkwReYYho92SPkna/5YyNTpnydx/jLka4bF8hm3Z7LcwQo4
02IMlIP6yHjaAsVsGYvEV57KGM0a1ozFTgJ2ZGH/0x/FNIOqVCXorHFTJojHuTGZ
kkQDa0JmCdF6wpOMbRizIuRK5GmOfMiqkMsVDfmuoHGZdwMzKD1v34B1n49yi768
cUM1qd935m3cozRm18GAL6BgXmEUzh3xbUapdC/pwv0Jy2HsL6GoIb29HwZ97h0e
qJlyC9bxBiOpI0KZYbheSGsw7vRTsXy+edp0XI4LYH9bsoDZumjEV1qbNOMcGWfH
SwZbxvanMqVdMLTL+XNKeTvogyjg29LNk8uyET9fCJkuqEbyxzOZ2lbiiYcbC65o
hIfWhxF8X9RscxlFOqQjAS/u4dt7K40nu3CDLMUElGvXTG8yB/oTnunOD1giLzSh
6ReORjGDgb7eofnrorj7obQUWdqE+Kf1kkvnyPyppBeDZk50BmpxoBCK5KAnFHVD
lBLPkWR2uFIXNFCFEwOf
=EfNa
-----END PGP SIGNATURE-----

--924gEkU1VlJlwnwX--
