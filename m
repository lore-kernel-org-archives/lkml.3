Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab3CNKxh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:53:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54258 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757178Ab3CNKxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:53:34 -0400
Date: Thu, 14 Mar 2013 12:53:20 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <balbi@ti.com>, <rob.herring@calxeda.com>, <kgene.kim@samsung.com>,
        <thomas.abraham@linaro.org>, <dianders@chromium.org>
Subject: Re: [PATCH 2/2] usb: dwc3: exynos: use clk_prepare_enable and
 clk_disable_unprepare
Message-ID: <20130314105320.GH32369@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1363257898-17504-1-git-send-email-gautam.vivek@samsung.com>
 <1363257898-17504-3-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lXr1rPCNTf1w0X8"
Content-Disposition: inline
In-Reply-To: <1363257898-17504-3-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6lXr1rPCNTf1w0X8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 14, 2013 at 04:14:58PM +0530, Vivek Gautam wrote:
> Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
> calls as required by common clock framework.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> CC: Felipe Balbi <balbi@ti.com>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exyno=
s.c
> index 66ca9ac..b03f609 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -129,7 +129,7 @@ static int dwc3_exynos_probe(struct platform_device *=
pdev)
>  	exynos->dev	=3D dev;
>  	exynos->clk	=3D clk;
> =20
> -	clk_enable(exynos->clk);
> +	clk_prepare_enable(exynos->clk);

eventually we need to pass this clock handling to dwc3/core.c. Just make
sure it's optional since not all platforms need it.

I guess the best way would be to handle clocks via
->runtime_suspend()/->runtime_resume() ??

--=20
balbi

--6lXr1rPCNTf1w0X8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQawgAAoJEIaOsuA1yqRERc8P/jGz7Czv57nw66tpzFV18XaX
ckMJpC8gcdZYnSKxejFs6sPYkXrYgQajq9FqfAxRGIoYL1ki1DhdJRPCCKsTNBQq
d42dsESXIFaX+F04SlZRQaDoxYnuNtNz76v9szcJyPiy1uyZgQiJq5h2BpTDWRzZ
bQJqNKbCnZ3tsk1mJ3l81xmtJ9EpZ3jua+IWX04cARU/u7SaAFmL//eRZgmnx9Jz
VEdudP/T37xhqeR1R1Q9D/OT8wWxpKtMNcvI9UC6EWBpqq/TuYGR22uc2TLW3Jpz
Z4LYfdHn8rbvyS6Nz1fVQppm4XrZxCmm4rqS7g4GG5aaFqA5JcD9TZ57UYQTW+o2
GN8rr74dSmVn8fPhiiOmuT7rX3/93YsdMtSKg+nJUasDL7Cp7TVSAQnG5r+mMccO
11z+4RgttYNf8be3TUtXznZooGy88sZrZLc1flPcalsLps7xQ7SiQhDbMwQyFDvI
J55FnStR4pa/tpaprr5sufFH65ul6bRRU49PyElvyq9r5ZaxlIt6YzqNOfrIRX0t
S1+yX16jUxD918AlSmhKodFA6Vga6AN27RNHCXO1VZ8zXI51bZJvkYxebkwv5+Ip
xf8pOCXm7j/BgCYEFz9iKAP0LNz5aVkpAGSLeboKjD7YZesv5AgE9CF21qnwqeVL
x+Ttdo4qCETDN75/g+8v
=6rTS
-----END PGP SIGNATURE-----

--6lXr1rPCNTf1w0X8--
