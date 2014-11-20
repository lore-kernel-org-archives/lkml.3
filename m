Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbaKTTAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 14:00:32 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:47572 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291AbaKTTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 14:00:30 -0500
Date: Thu, 20 Nov 2014 15:00:27 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] thermal:cpu cooling:ti: Provide deferred probing for
 ti drivers
Message-ID: <20141120190025.GB26794@developer>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-7-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <1415898165-27406-7-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Lukaz,

On Thu, Nov 13, 2014 at 06:02:43PM +0100, Lukasz Majewski wrote:
> When CPU freq is used as a thermal zone cooling device, one needs to wait
> until cpufreq subsystem is properly initialized.
>=20
> This code is similar to the one already available in imx_thermal.c file.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
>  drivers/thermal/ti-soc-thermal/ti-bandgap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/thermal/ti-soc-thermal/ti-bandgap.c b/drivers/therma=
l/ti-soc-thermal/ti-bandgap.c
> index 634b6ce..0ac5ead 100644
> --- a/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> +++ b/drivers/thermal/ti-soc-thermal/ti-bandgap.c
> @@ -40,6 +40,7 @@
>  #include <linux/of_irq.h>
>  #include <linux/of_gpio.h>
>  #include <linux/io.h>
> +#include <linux/cpufreq.h>
> =20
>  #include "ti-bandgap.h"
> =20
> @@ -1196,6 +1197,12 @@ int ti_bandgap_probe(struct platform_device *pdev)
>  	struct ti_bandgap *bgp;
>  	int clk_rate, ret =3D 0, i;
> =20
> +#ifdef CONFIG_CPU_THERMAL
> +	if (!cpufreq_get_current_driver()) {
> +		dev_dbg(&pdev->dev, "no cpufreq driver!");
> +		return -EPROBE_DEFER;
> +	}
> +#endif

This is part of drivers/thermal/ti-soc-thermal/ti-thermal-common.c. So,
no need to duplicate it in here.

>  	bgp =3D ti_bandgap_build(pdev);
>  	if (IS_ERR(bgp)) {
>  		dev_err(&pdev->dev, "failed to fetch platform data\n");
> --=20
> 2.0.0.rc2
>=20

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbjpJAAoJEMLUO4d9pOJWMIYH/iEQsBZN4A/BdVTIzD9IxQZL
myAd1rF7obgvE/34GI9erJKHNZLPy555MttvsAlzjDLc5mDn5dSL3tRTH7+5xLOG
akkOLE5SoRDch8sNHoQnPt5090p60hIg3gz+8TRzcmkmqS3WN+hycZ02hEHCR+oz
m2EWy7eDYvPuZoMw6HFMLkN5p/kqVsli5y3Uk/QSqrcmNI07ReAZTzujT6eVv3FW
tOSGdEXSMH1+FnVjoY1+2qQD19GGroGy4tSG6asa4lj9WsrmigMMcUVy2d2XcJQu
gCx38k8L7OqCBDbYPdaJNok4aRUQtMYcwX48Vm73Lvt6icFKB9b9GLIW36IwH/w=
=SEfc
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
