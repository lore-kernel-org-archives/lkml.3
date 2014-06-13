Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaFMQYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:24:09 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36906 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753635AbaFMQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:24:07 -0400
Date: Fri, 13 Jun 2014 11:23:23 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        Paul Walmsley <paul@pwsan.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Message-ID: <20140613162323.GH8319@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-2-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XbHSybK3LHOYQtWI"
Content-Disposition: inline
In-Reply-To: <1402676147-3711-2-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XbHSybK3LHOYQtWI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 13, 2014 at 11:15:46AM -0500, Felipe Balbi wrote:
> From: Sathya Prakash M R <sathyap@ti.com>
>=20
> Add DSS hwmod data for AM43xx.
>=20
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Rajendra Nayak <rnayak@ti.com>
> Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>=20
> Note that this patch was originally send on May 9th [1], changes were req=
uested
> and a new version was sent on May 19th [2], then on May 27th [3] Tomi pin=
ged
> maintainer again and go no response.
>=20
> Without this patch, we cannot get display working on any AM437x devices.
>=20
> [1] http://marc.info/?l=3Dlinux-arm-kernel&m=3D139963677925227&w=3D2
> [2] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140049799425512&w=3D2
> [3] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140117232826754&w=3D2
>=20
>  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++++++=
++++++
>  arch/arm/mach-omap2/prcm43xx.h             |  1 +
>  2 files changed, 99 insertions(+)
>=20
> diff --git a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c b/arch/arm/mach-o=
map2/omap_hwmod_43xx_data.c
> index 5c2cc80..d2a7b6d 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_43xx_data.c
> @@ -19,6 +19,8 @@
>  #include "omap_hwmod.h"
>  #include "omap_hwmod_33xx_43xx_common_data.h"
>  #include "prcm43xx.h"
> +#include "omap_hwmod_common_data.h"
> +
> =20
>  /* IP blocks */
>  static struct omap_hwmod am43xx_l4_hs_hwmod =3D {
> @@ -415,6 +417,70 @@ static struct omap_hwmod am43xx_qspi_hwmod =3D {
>  	},
>  };
> =20
> +/* Display sub system - DSS */
> +
> +struct omap_dss_dispc_dev_attr am43xx_dss_dispc_dev_attr =3D {
> +	.manager_count		=3D 1,
> +	.has_framedonetv_irq	=3D 0
> +};
> +
> +
> +static struct omap_hwmod_class_sysconfig am43xx_dispc_sysc =3D {
> +	.rev_offs	=3D 0x0000,
> +	.sysc_offs	=3D 0x0010,
> +	.syss_offs	=3D 0x0014,
> +	.sysc_flags	=3D (SYSC_HAS_SIDLEMODE | SYSC_HAS_MIDLEMODE),
> +	.idlemodes	=3D (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
> +	.sysc_fields	=3D &omap_hwmod_sysc_type1,
> +};
> +
> +static struct omap_hwmod_class am43xx_dispc_hwmod_class =3D {
> +	.name	=3D "dispc",
> +	.sysc	=3D &am43xx_dispc_sysc,
> +};
> +
> +static struct omap_hwmod am43xx_dss_core_hwmod =3D {
> +	.name		=3D "dss_core",
> +	.class		=3D &omap2_dss_hwmod_class,
> +	.clkdm_name	=3D "dss_clkdm",
> +	.main_clk	=3D "disp_clk",
> +	.prcm =3D {
> +		.omap4 =3D {
> +			.clkctrl_offs =3D AM43XX_CM_PER_DSS_CLKCTRL_OFFSET,
> +			.modulemode   =3D MODULEMODE_SWCTRL,
> +		},
> +	},
> +};
> +
> +/* display controller -dispc*/
> +
> +static struct omap_hwmod am43xx_dss_dispc_hwmod =3D {
> +	.name		=3D "dss_dispc",
> +	.class		=3D &am43xx_dispc_hwmod_class,
> +	.clkdm_name	=3D "dss_clkdm",
> +	.main_clk	=3D "disp_clk",
> +	.prcm =3D {
> +		.omap4 =3D {
> +			.clkctrl_offs =3D AM43XX_CM_PER_DSS_CLKCTRL_OFFSET,
> +		},
> +	},
> +	.dev_attr	=3D &am43xx_dss_dispc_dev_attr,
> +};
> +
> +/*RFBI*/
> +
> +static struct omap_hwmod am43xx_dss_rfbi_hwmod =3D {
> +	.name		=3D "dss_rfbi",
> +	.class		=3D &omap2_rfbi_hwmod_class,
> +	.clkdm_name	=3D "dss_clkdm",
> +	.main_clk	=3D "disp_clk",
> +	.prcm =3D {
> +		.omap4 =3D {
> +			.clkctrl_offs =3D AM43XX_CM_PER_DSS_CLKCTRL_OFFSET,
> +		},
> +	},
> +};
> +
>  /* Interfaces */
>  static struct omap_hwmod_ocp_if am43xx_l3_main__l4_hs =3D {
>  	.master		=3D &am33xx_l3_main_hwmod,
> @@ -654,6 +720,34 @@ static struct omap_hwmod_ocp_if am43xx_l3_s__qspi =
=3D {
>  	.user           =3D OCP_USER_MPU | OCP_USER_SDMA,
>  };
> =20
> +static struct omap_hwmod_ocp_if am43xx_dss__l3_main =3D {
> +	.master		=3D &am43xx_dss_core_hwmod,
> +	.slave		=3D &am33xx_l3_main_hwmod,
> +	.clk		=3D "l3_gclk",
> +	.user		=3D OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if am43xx_l4_ls__dss =3D {
> +	.master		=3D &am33xx_l4_ls_hwmod,
> +	.slave		=3D &am43xx_dss_core_hwmod,
> +	.clk		=3D "l4ls_gclk",
> +	.user		=3D OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_dispc =3D {
> +	.master		=3D &am33xx_l4_ls_hwmod,
> +	.slave		=3D &am43xx_dss_dispc_hwmod,
> +	.clk		=3D "l4ls_gclk",
> +	.user		=3D OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
> +static struct omap_hwmod_ocp_if am43xx_l4_ls__dss_rfbi =3D {
> +	.master		=3D &am33xx_l4_ls_hwmod,
> +	.slave		=3D &am43xx_dss_rfbi_hwmod,
> +	.clk		=3D "l4ls_gclk",
> +	.user		=3D OCP_USER_MPU | OCP_USER_SDMA,
> +};
> +
>  static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_ifs[] __initdata =3D {
>  	&am33xx_l4_wkup__synctimer,
>  	&am43xx_l4_ls__timer8,
> @@ -748,6 +842,10 @@ static struct omap_hwmod_ocp_if *am43xx_hwmod_ocp_if=
s[] __initdata =3D {
>  	&am43xx_l4_ls__ocp2scp1,
>  	&am43xx_l3_s__usbotgss0,
>  	&am43xx_l3_s__usbotgss1,
> +	&am43xx_dss__l3_main,
> +	&am43xx_l4_ls__dss,
> +	&am43xx_l4_ls__dss_dispc,
> +	&am43xx_l4_ls__dss_rfbi,
>  	NULL,
>  };
> =20
> diff --git a/arch/arm/mach-omap2/prcm43xx.h b/arch/arm/mach-omap2/prcm43x=
x.h
> index 7785be9..ad7b3e9 100644
> --- a/arch/arm/mach-omap2/prcm43xx.h
> +++ b/arch/arm/mach-omap2/prcm43xx.h
> @@ -142,5 +142,6 @@
>  #define AM43XX_CM_PER_USBPHYOCP2SCP0_CLKCTRL_OFFSET	0x05B8
>  #define AM43XX_CM_PER_USB_OTG_SS1_CLKCTRL_OFFSET        0x0268
>  #define AM43XX_CM_PER_USBPHYOCP2SCP1_CLKCTRL_OFFSET	0x05C0
> +#define AM43XX_CM_PER_DSS_CLKCTRL_OFFSET		0x0a20
> =20
>  #endif
> --=20
> 2.0.0.rc1
>=20

--=20
balbi

--XbHSybK3LHOYQtWI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTmyV7AAoJEIaOsuA1yqREehwP/2vBRXSXhkVIlInOHoQGJHvL
bWg3r4ToFvcFkpU3e9sL8L8kwiQ4w2Mjru5e2D3TcRnxrtQeuNg8xepU6Pla7j7P
tRuCcwRu9A7WvAaDtUnXX1UEQQWcJReyplRcTGIBuCkbKc5fklZtUlCZVKm9mhfg
t5nbge/eAUGGAUnZq1fpxMPeRj7NkLH+A4MOPuU2YtFfIvpAbgxXelNheIUPbaVL
FOe6J861URZtThfMEG3Ke9aawAR2fapRdBvQwzk4u+GEeu37c7OUY3aIwUMZAnjE
kjP1oL6LLdCmLa2uPDeambKn2LRAYFit35mADfGn/VRinI+JvQdEvqUVUCZKNrb2
D5Egn55hfk7n9FFKv93QfnACeojlnDG39f799uSAlkReHsejQnhxnV0ALl83Q7HJ
C8Qp8xVXbzoo8xPrCj0XxiyAwDWHB+ozk0DYKa4+tdoHCAySULlabc0ncAxDvC/1
qFcZvVp/KVs3R+7Hranl7Wm/g6Nr5HeNrUi19X4krfhn5jPYXanew4a390alAv2Z
BqlAfGEl8FFWHBMZwL5+tp9/1B4HIiqCGyecDn5BsNoaXLzgFyKQ0gy7mB4u/DEA
ciGbmTlXjD1DIS5tlQCR2NVJEwcBZ2gRtEOc2mgIrAiemsLKAbARGS5BeaGx+c7f
Cfft+oJ0EMq6F0UH3AJW
=GMFX
-----END PGP SIGNATURE-----

--XbHSybK3LHOYQtWI--
