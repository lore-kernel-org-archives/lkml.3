Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaKQLkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:40:43 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46009 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104AbaKQLkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:40:41 -0500
Date: Mon, 17 Nov 2014 12:40:35 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thermal:cpu cooling:tegra: Provide deferred probing
 for tegra driver
Message-ID: <20141117114034.GE25699@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SWTRyWv/ijrBap1m"
Content-Disposition: inline
In-Reply-To: <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SWTRyWv/ijrBap1m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 06:02:42PM +0100, Lukasz Majewski wrote:
> When CPU freq is used as a thermal zone cooling device, one needs to wait
> until cpufreq subsystem is properly initialized.
>=20
> This code is similar to the one already available in imx_thermal.c file.
>=20
> Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
> ---
>  drivers/thermal/tegra_soctherm.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/drivers/thermal/tegra_soctherm.c b/drivers/thermal/tegra_soc=
therm.c
> index 70f7e9e..9c5aaa4 100644
> --- a/drivers/thermal/tegra_soctherm.c
> +++ b/drivers/thermal/tegra_soctherm.c
> @@ -26,6 +26,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/reset.h>
>  #include <linux/thermal.h>
> +#include <linux/cpufreq.h>
> =20
>  #include <soc/tegra/fuse.h>
> =20
> @@ -346,6 +347,12 @@ static int tegra_soctherm_probe(struct platform_devi=
ce *pdev)
> =20
>  	const struct tegra_tsensor *tsensors =3D t124_tsensors;
> =20
> +#ifdef CONFIG_CPU_THERMAL
> +	if (!cpufreq_get_current_driver()) {
> +		dev_dbg(&pdev->dev, "no cpufreq driver!");

Shouldn't this rather be dev_err() or dev_warn() to give at least some
clue as to the cause?

Thierry

--SWTRyWv/ijrBap1m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUad6yAAoJEN0jrNd/PrOhJA8P/0ENnloNjC6BTahtRDY/neyO
Pp8jazZYQ6i1FeBqGXD6sa8ccsRzzLI0K5MuI+oaKnYyw8w3qJtUtIRs4p3lyvV0
dyCuyx5Twn8UrJHZj76q6Zv1NHUiulCyqZOxqjljNjuGtptfWBUDxjhtWNINIqFq
G4Uyr0dBIF485xi03UApagiQ5dQFeIFNjqkB6e56s29ztzf3NmHcjkjMs8pjLtef
cgOoQSDGqdE1ZqFezo0JFu6KRMUkVBUbwZyuWNM4n/2hlpRNNonsmPg8nnjYv6LC
MjP3H7cFZUC1sQDymj5as5zdBmqRpgxLlQS9Vsw+PDHCKgowKzQRTVFHPLEsZJpY
4IFKI+QvErAMJqNPC8O680WFBttzfZY5EekxsVIyE/Wse330/Lf+833wNflsLE9W
t1bSeLKxnKgYpVoDXq0/viEuChdah6eZNa+zw5q/KpvitV3rYSyFjgkwfFWm29Fi
CeYHJ7glR4TymHDFfOM7E8FuleHOzMwYN9iSO0lBzurqprSHlA+VMOlvrx6lMeDe
EVXcq/SqMPnLo47Zjk3CLvg5+Sowd47Gk075yLgyYzocWiJ1yPP8Zq24IjsI7rUT
Yv+UHj4q7+AlCefYkEmb7ftoSzgvXY8VsRomrBxlciErwme5/6OPP77wm/CODu18
P3OvVXHJVVe5aZl2OTCG
=XUiC
-----END PGP SIGNATURE-----

--SWTRyWv/ijrBap1m--
