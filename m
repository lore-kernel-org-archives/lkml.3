Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364Ab3DBIdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 04:33:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60044 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761346Ab3DBIdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 04:33:47 -0400
Date: Tue, 2 Apr 2013 11:33:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>,
        <stern@rowland.harvard.edu>, <sarah.a.sharp@linux.intel.com>,
        <rob.herring@calxeda.com>, <kgene.kim@samsung.com>, <kishon@ti.com>,
        <dianders@chromium.org>, <t.figa@samsung.com>, <p.paneri@samsung.com>
Subject: Re: [PATCH v3 05/11] usb: dwc3: exynos: Enable runtime power
 management
Message-ID: <20130402083326.GI30286@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1364824448-14732-1-git-send-email-gautam.vivek@samsung.com>
 <1364824448-14732-6-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5GLnnZ8mDMEwH4V"
Content-Disposition: inline
In-Reply-To: <1364824448-14732-6-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--e5GLnnZ8mDMEwH4V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 01, 2013 at 07:24:04PM +0530, Vivek Gautam wrote:
> Enabling runtime power management on dwc3-exynos
> letting dwc3 controller to be autosuspended on exynos
> platform when not in use.
>=20
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/usb/dwc3/dwc3-exynos.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exyno=
s.c
> index 1ea7bd8..1ae81a0 100644
> --- a/drivers/usb/dwc3/dwc3-exynos.c
> +++ b/drivers/usb/dwc3/dwc3-exynos.c
> @@ -19,6 +19,7 @@
>  #include <linux/platform_data/dwc3-exynos.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/clk.h>
> +#include <linux/pm_runtime.h>
>  #include <linux/usb/otg.h>
>  #include <linux/usb/nop-usb-xceiv.h>
>  #include <linux/of.h>
> @@ -138,6 +139,11 @@ static int dwc3_exynos_probe(struct platform_device =
*pdev)
>  	exynos->dev	=3D dev;
>  	exynos->clk	=3D clk;
> =20
> +	pm_runtime_set_active(dev);
> +	pm_runtime_enable(dev);
> +	pm_runtime_get_sync(dev);
> +	pm_runtime_forbid(dev);

don't you want to use autosuspend() to avoid consecutive suspend/resume
calls when controller is under use ?

--=20
balbi

--e5GLnnZ8mDMEwH4V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWpfWAAoJEIaOsuA1yqRE/ecP/jaogkFFALSZKOGLPHt3+pj1
mmiYf2UDYTBfjg7IPBOh8IR5aebLk2TqaytzxCE0Uf3N9hkmsi4i53ucHHqebPRD
fK7EwPnzPq0IzuF70OUtPAOcBZ9Y6RGe1lhogLOK8b1ivWRNqm2jOOmYLhmHBbEf
pnhvrFCHlf5tXRyuXWOXiFMpPF5ivDQyylM9yBja+FWOGaCMLoUXNi5KL+j/E3S6
NKtRiWmiTLdOxiSjnPyQ0PcniB0K87dzLSg8Edcj0mu+jrNyhCLOeKuaLyGsDXkN
LgS1FJK56+qpHLCpDa/yfWEBxV93vlP+alLhTul1ipNQhOviIy94AQb6wGb3LKRW
T6BIZTp7G0BzrjJDGXwm4LLBACUeT+4B7D8JK7uLizqmaXF8kE8lKF+VctoYhFte
qixZpUIluzm9f1Mv320+8wHSU9PiJZ6rXmBBUvPWkrwH0b6UQIWMD6LHKyHdcBr5
aIUt81j/skbqtNcC7MTqY75ekzcMwvW91QvwUKvNc+A1IxTsAFi4MbdgeifEbbGx
GS6z0RJYthyW8hT6o2BcXnM/FstLvV4dO6qu3yYnjG13wLlpsks6dNG2seEEqLtr
L3J++e7oSzMzC067tj8FHwnyM/7JyFFTehcHPKyJ7PTFdLvSf5MxR97vIVlxCMtH
ijKV+uMjgK1Y8F95NPtW
=iuwz
-----END PGP SIGNATURE-----

--e5GLnnZ8mDMEwH4V--
