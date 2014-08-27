Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964855AbaH0T2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:28:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:59903 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935548AbaH0T2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:28:40 -0400
Date: Wed, 27 Aug 2014 14:28:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Felipe Balbi <balbi@ti.com>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: dwc3: exynos: remove usb_phy_generic support
Message-ID: <20140827192825.GJ6347@saruman.home>
Reply-To: <balbi@ti.com>
References: <2141307.zYQLjP6V6U@amdc1032>
 <CAFp+6iF10hSNzkVWwF2QkDLRkhKQ_STN8N8vH2eatM4qjjt7MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gBdJBemW82xJqIAr"
Content-Disposition: inline
In-Reply-To: <CAFp+6iF10hSNzkVWwF2QkDLRkhKQ_STN8N8vH2eatM4qjjt7MQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gBdJBemW82xJqIAr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Aug 27, 2014 at 11:42:25PM +0530, Vivek Gautam wrote:
> On Wed, Aug 27, 2014 at 1:22 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > dwc3 driver is using the new Exynos5 SoC series USB DRD PHY driver
> > (PHY_EXYNOS5_USBDRD which selects GENERIC_PHY) as can be seen by
> > looking at the following commits:
> >
> >   7a4cf0fde054 ("ARM: dts: Update DWC3 usb controller to use new
> >   phy driver for exynos5250")
> >
> >   f070267b5fc1 ("ARM: dts: Enable support for DWC3 controller for
> >   exynos5420")
> >
> > Thus remove unused usb_phy_generic support from dwc3 Exynos glue
> > layer.
> >
> > [ The code that is being removed is harmful in the context of
> >   multi_v7_defconfig and enabling "EHCI support for Samsung
> >   S5P/EXYNOS SoC Series" (USB_EHCI_EXYNOS) + "OHCI support for
> >   Samsung S5P/EXYNOS SoC Series" (USB_OHCI_EXYNOS) because "EHCI
> >   support for OMAP3 and later chips" (USB_EHCI_HCD_OMAP) selects
> >   "NOP USB Transceiver Driver" (NOP_USB_XCEIV).  NOP USB driver
> >   attaches itself to usb_phy_generic platform devices created by
> >   dwc3 Exynos glue layer and later causes Exynos EHCI driver to
> >   fail probe and Exynos OHCI driver to hang on probe (as observed
> >   on Exynos5250 Arndale board). ]
>=20
> The issue with EHCI and OHCI on exynos platforms is that until now
> they also request
> usb-phy and only later if they don't find one, they go ahead and get a
> 'phy' generic.
>=20
> Fortunately we missed this issue with exynos_defconfig, and as you rightly
> mentioned with multi_v7_defconfig, the NOP_USB_XCEIV gets enabled and
> EHCI and OHCI exynos get no-op usb-phy, which actually blocks EHCI/OHCI f=
rom
> initializing the real PHYs.

right, when I added PHY support to dwc3 I expected people to remote NOP
transceivers from their glue layers after they had proper PHY drivers
available.

> This issue is resolved with patches:
> [PATCH v2 1/2] usb: host: ehci-exynos: Remove unnecessary usb-phy support
> [PATCH v2 2/2] usb: host: ohci-exynos: Remove unnecessary usb-phy support
> wherein we are completely removing the usb-phy support from ehci/ohci-exy=
nos.
> So with these patches we should not see the issue mentioned by you.
>=20
> Now for the DWC3 part, the usb-phy part was added to use register two
> separate no-op-xceivers of USB2_PHY type and USB3_PHY type,
> so that platforms with no separate PHY can still be able to use dwc3.

correct.

--=20
balbi

--gBdJBemW82xJqIAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/jFZAAoJEIaOsuA1yqRE5fEP/RKzYqbF5AaTr9JeUjDCfBrR
IHgV4wPDMfBdajroYZVM+dvEzePFwrEDcaATI+jnXnO6op0tgdmfklthhyopxfnH
5P7I0BnHiPlBVnAOaXJGchqmvr5OokabRy0rdXLbD0tacVCOXvBPPOjG5Qqjz9VR
Im0CG05N35exacMcld8nl/iRZ35pjxucMeopBpB6pYkA5shQ28OdeRAFe8iXjNC8
/IQDSPvgxn2s8ILq+xiSx9JWKjDICrwFsIThA92D+AG9SkVGokbnMCeNhfPRuEch
GywfhLOikQlIlB5KJ8v3IiVMEaW6TEPbgd+aKJpCpsrERvJqtxVPaas4yPSAE2f0
UHw48HVW+ngQ66acBcfbYiUJcfyp3u82S8Zq+0bvXK0tyXOuQ9cSSPcQN7uljw0N
8STUExqYuwMf5mBTTfdAvHULr6lPHwMLAk0kB9W1OD0e34Ss+Mf+BN26ezWXx/dL
q3zmfNRDMdr1o4tOo4tKQC2D3EEzef/QFmAKYJEm9EGPhw5Ftj2gbBfC2c3nA06A
vsyyu1ExfaqOWhT2/5ZLrm3EvZMm2kSQT5k+6DLcnFWX1zb3Z5J597O4BuoAy/Kf
y4As3GsuNwVI2oMlzob0780DUoCFpnVmuLtFrK56MTjC6k0ZPIdWI/45OdMIyC5o
mIcxFCFU2z4vFI3hqJg2
=/rUU
-----END PGP SIGNATURE-----

--gBdJBemW82xJqIAr--
