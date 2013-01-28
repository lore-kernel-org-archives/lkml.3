Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab3A1LqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:46:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43254 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425Ab3A1LqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:46:19 -0500
Date: Mon, 28 Jan 2013 13:45:54 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <sarah.a.sharp@linux.intel.com>, <kgene.kim@samsung.com>,
        <dianders@chromium.org>, <sylvester.nawrocki@gmail.com>,
        <tomasz.figa@gmail.com>
Subject: Re: [PATCH 2/4] USB: dwc3: Adjust runtime pm the dwc3 driver to
 allow runtime suspend
Message-ID: <20130128114554.GE28698@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
 <1359373348-18320-3-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <1359373348-18320-3-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 28, 2013 at 05:12:26PM +0530, Vivek Gautam wrote:
> The current code in the dwc3 probe effectively disables runtime pm
> from ever working because it calls a get() that was never put() until
> device removal.  Change the runtime pm code to match the standard
> formula and allow runtime pm to function.
>=20
> Note that this doesn't enable full runtime pm on the DWC3 device in
> that the port isn't put into a lower power mode when not used.
> However it does allow users of dwc3 (like dwc3-exynos) to do some
> amount of runtime power management.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/usb/dwc3/core.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index 3a4004a..59c2494 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -453,6 +453,7 @@ static int dwc3_probe(struct platform_device *pdev)
>  	if (of_get_property(node, "tx-fifo-resize", NULL))
>  		dwc->needs_fifo_resize =3D true;
> =20
> +	pm_runtime_set_active(dev);

this usage of pm_runtime_set_active() actually makes me a bit scared. At
least OMAP starts with the device switched off, so this will probably
break OMAP at least. OTOH, calling ->runtime_resume() during probe()
might not make that much sense after all, but the way OMAP is
implemented, we won't get clocks turned on if this ->runtime_resume()
method isn't called.

/me starts to wonder whether OMAP implementation is flakey and what
should be done here...

--=20
balbi

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRBmTyAAoJEIaOsuA1yqRETWgP/jxSlC79Ixe8iutKZJz30TAL
2vgyLWQULrbXJLM/itQR/j9162uvZSxej9ykvWTH6saafi6uIE7gcJQR6KcHhPHZ
JlboJoTp/XlOqdgIFA5BmyIO7UWkHaJRg/wiAGsPqRQlxDsCa1yGsHSJXrdufRTn
B1C9c48mQcwVzULxpHrY2sIrMaDGsokjJn/dofbIPb9xsIsxe8/hwR/XF47ykWML
7lULnaDH8YHyRbDzQs1BpO2CCsk/GoafjYGkLCXECXY8gNPJmdXnWJr65G909EcQ
oqBQ5mk6szk7FvYDIYC1IwvRBLDO+NOVLsDW4luZewy32sEJECkh9SJtORoF9dmh
lA76Gv8D0rb5ugTaA+JlcT+5OErIkm3mDhhPqBgVl2G4PPFwVsAgy12P8KouW4YJ
XLxiJVis9+uLLrK5JT8xXbQmwnFHAzDbdq2PrGS4pyoyvF/I2bxTly55iOzVR7jO
LZn/CPMsg+ZFKUdIyGM46VBXvvrzOrMEe0cRV+b44W/GqSeTC5e/Kv5AzqjzR9v9
UCQlYtg5rtHGhZesEGcwheAMKtmhOXH9byDSJ1MJWpKqUTUHwHkShn0w0Tdy77yr
yIZsbuqxe7EXs9WJxZX2u+DlGrpLGKN8VMPNbSm8KlhuFGSA1A3tIbixmzrR9fzB
7bMIWyJUpdVkaXMFgpaj
=6cTd
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
