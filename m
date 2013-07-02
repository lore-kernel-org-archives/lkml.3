Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3GBP2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:28:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48134 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775Ab3GBP2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:28:14 -0400
Date: Tue, 2 Jul 2013 18:26:57 +0300
From: Felipe Balbi <balbi@ti.com>
To: Luciano Coelho <coelho@ti.com>
CC: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>,
        <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/9] wlcore: use irq_flags in pdata instead of hiding
 it behind a quirk
Message-ID: <20130702152657.GE7013@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372776948-24840-1-git-send-email-coelho@ti.com>
 <1372776948-24840-3-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HnQK338I3UIa/qiP"
Content-Disposition: inline
In-Reply-To: <1372776948-24840-3-git-send-email-coelho@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HnQK338I3UIa/qiP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 02, 2013 at 05:55:41PM +0300, Luciano Coelho wrote:
> The platform_quirk element in the platform data was used to change the
> way the IRQ is triggered.  When set, the EDGE_IRQ quirk would change
> the irqflags used and treat edge trigger differently from the rest.
>=20
> Instead of hiding this irq flag setting behind the quirk, export the
> whole irq_flags element and let the board file define what to use.
> This will be more meaningful than driver-specific quirks when we
> switch to DT.
>=20
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>
> ---
>  arch/arm/mach-davinci/board-da850-evm.c      |    2 +-
>  arch/arm/mach-omap2/board-4430sdp.c          |    1 +
>  arch/arm/mach-omap2/board-omap3evm.c         |    1 +
>  arch/arm/mach-omap2/board-omap4panda.c       |    1 +
>  arch/arm/mach-omap2/board-zoom-peripherals.c |    1 +
>  drivers/net/wireless/ti/wlcore/debugfs.c     |    2 +-
>  drivers/net/wireless/ti/wlcore/main.c        |   13 +++----------
>  drivers/net/wireless/ti/wlcore/wlcore.h      |    5 ++---
>  include/linux/wl12xx.h                       |    5 +----
>  9 files changed, 12 insertions(+), 19 deletions(-)
>=20
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davi=
nci/board-da850-evm.c
> index 8a24b6c..d2a2a98 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -1377,8 +1377,8 @@ static const short da850_wl12xx_pins[] __initconst =
=3D {
> =20
>  static struct wl12xx_platform_data da850_wl12xx_wlan_data __initdata =3D=
 {
>  	.irq			=3D -1,
> +	.irq_flags		=3D IRQF_TRIGGER_RISING,
>  	.board_ref_clock	=3D WL12XX_REFCLOCK_38,
> -	.platform_quirks	=3D WL12XX_PLATFORM_QUIRK_EDGE_IRQ,
>  };
> =20
>  static __init int da850_wl12xx_init(void)
> diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/bo=
ard-4430sdp.c
> index 56a9a4f..c2334aa 100644
> --- a/arch/arm/mach-omap2/board-4430sdp.c
> +++ b/arch/arm/mach-omap2/board-4430sdp.c
> @@ -693,6 +693,7 @@ static void __init omap4_sdp4430_wifi_mux_init(void)
>  }
> =20
>  static struct wl12xx_platform_data omap4_sdp4430_wlan_data __initdata =
=3D {
> +	.irq_flags =3D IRQF_TRIGGER_HIGH | IRQF_ONESHOT,

couldn't you just call irq_set_irq_type() from the board-file itself ?
Then on your driver you can just pass IRQF_ONESHOT (to make sure heh) to
your request_threaded_irq_handler()

--=20
balbi

--HnQK338I3UIa/qiP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR0vFBAAoJEIaOsuA1yqRECwQP/2IQS04PpctSEMcrjcDpUu92
tSnO/JSi9PxeftIE/brxPLI0x0fvzeR6t7W8mAo9aki1rIEfIgNdVPXBaaQmM7Ng
jqzQ/66sp3f6ukuQGKmtfsIRTbORHRa2O232MfTAjULr4By1pSwB3SFg3qbg1Jd4
csAc99AajYy54HAQA7ZrI4u0XO802rqa5MJMwa1QXrTVwhwPCMYQaJxToDg9FzLG
3pnI2ImTgN2oKx93il+lcbL2v9eDoGruZ1l/iIdKlljLPkvbM1baDqc0hNuAtVUP
ty27MDze9BhO2ZO5S4l/Oui/XlPtXt6tpebB5QaqtUFcUWEzkoQ9nwEqBkDzrfZA
zB7h2g0R5GxaFJBVz/px8A8gCkXPS0fpAkstMCMHI59r/fk27GROmvuoLFE3oD9v
aMUnqjqtRWr9ZLaxFO8i+Vq6gxI8LLIOxoWg3eTlRyo/eUorTp6qccAY/4nb49Ii
Dp2T465o+MWWZS6E4OlbJh9R7uGhCY/Yrd6iOezfr4gQoaNttaSMIwElivZSJySd
M3WHbHlpczxmzBEy94yvh+vb5DE2dmNwDcOu2aXU9A/+SBVoAy+7bwhM9RgwamMC
nZ/cbOLf2zhfunCGXqNZy6ukqiS7SW9keaTiurx1rejg0Nkrckm2pfbphqqOIc6I
ZKIynSdelkum1AQUfEEO
=Tmqu
-----END PGP SIGNATURE-----

--HnQK338I3UIa/qiP--
