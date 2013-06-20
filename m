Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965485Ab3FTMIP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:08:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55721 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965182Ab3FTMIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:08:14 -0400
Date: Thu, 20 Jun 2013 15:07:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <stern@rowland.harvard.edu>, <tony@atomide.com>, <balbi@ti.com>,
        <ruslan.bilovol@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [RFC PATCH 1/6] mfd: omap-usb-host: move initialization to
 module_init()
Message-ID: <20130620120746.GC9817@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1371650753-11452-1-git-send-email-rogerq@ti.com>
 <1371650753-11452-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
Content-Disposition: inline
In-Reply-To: <1371650753-11452-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--PHCdUe6m4AxPMzOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jun 19, 2013 at 05:05:48PM +0300, Roger Quadros wrote:
> We no longer need to be initialized in any particular order
> so move driver initialization to the standard place i.e. module_init()
>=20
> CC: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |   10 +---------
>  drivers/mfd/omap-usb-tll.c  |    8 +-------
>  2 files changed, 2 insertions(+), 16 deletions(-)
>=20
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 759fae3..6601a49 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -908,15 +908,7 @@ static int __init omap_usbhs_drvinit(void)
>  {
>  	return platform_driver_probe(&usbhs_omap_driver, usbhs_omap_probe);
>  }
> -
> -/*
> - * init before ehci and ohci drivers;
> - * The usbhs core driver should be initialized much before
> - * the omap ehci and ohci probe functions are called.
> - * This usbhs core driver should be initialized after
> - * usb tll driver
> - */
> -fs_initcall_sync(omap_usbhs_drvinit);
> +module_init(omap_usbhs_drvinit);
> =20
>  static void __exit omap_usbhs_drvexit(void)
>  {
> diff --git a/drivers/mfd/omap-usb-tll.c b/drivers/mfd/omap-usb-tll.c
> index e59ac4c..fb7c73e 100644
> --- a/drivers/mfd/omap-usb-tll.c
> +++ b/drivers/mfd/omap-usb-tll.c
> @@ -482,13 +482,7 @@ static int __init omap_usbtll_drvinit(void)
>  {
>  	return platform_driver_register(&usbtll_omap_driver);
>  }
> -
> -/*
> - * init before usbhs core driver;
> - * The usbtll driver should be initialized before
> - * the usbhs core driver probe function is called.
> - */
> -fs_initcall(omap_usbtll_drvinit);
> +module_init(omap_usbtll_drvinit);

since you're doing that, could just move to module_platform_driver.

--=20
balbi

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRwvCSAAoJEIaOsuA1yqREy64P/1nUFzmSnbInb/pLRyfBYJHc
WbhjdFwIdWgsjM09JCtdKWHPIQe127V4XuEH2VqtENPv8oD9WSPX6OGr0lakjGVo
irRnEp45SWNGy+i1CbTdMSRpREAJ00rnbPFnr1NnIHz8Mlc020jrAcsBgkCId2z+
x20+NgG4++Q/urWCy8/iVdVyE151L3sKkJyYvH+eMRi0oAVTT+9ZjXSvDQUfIQYC
s5JSdOk3sqJHpFuLXhxACBZ1w9XMzgV50Ck57YHVHftI9yYDd5hPeOlt3J4yI51P
6MxFQncXupd5s7oOeRbKtTZwgTqmbflpp0nx90PhSt8bWl0YpFMgFF4Biz7yh34N
qjIy1zY1t4kH8ZHZWHaCceHnFNV5f5S+B3SYw5NaMyh5KjcU9oz+dCcHy9NXcr+9
SrCGaSh3+aDUbiRbGccqAuAp3OpZgCUbmSzS/IMVPy3ytE+aWg4XmmJryxp/T6sP
T+RmdXp8D29RMrdqhamvX6svfzNevW7f+ePBDHjHmsmriUDjtNDykK1I+UdagROl
5bt9TIvjxIIBlsoCLpk7+FfOevBZdKDMhvBpfUgpuiBf2alhB425Us/pnt3R6vep
FEJPmIgPwTh4yLmxI7u/IaNbGeinGBXNQZFY7aB2OlprtghlVydL93BtmrcV1iLm
sUBZBDLlCS0O0z3lsrWo
=nFoz
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--
