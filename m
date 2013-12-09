Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab3LIB0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:26:19 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:59323 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759563Ab3LIB0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:26:16 -0500
Date: Mon, 9 Dec 2013 01:26:15 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: bcousson@baylibre.com, Roger Quadros <rogerq@ti.com>
cc: tony@atomide.com, tomi.valkeinen@ti.com, balbi@ti.com, sr@denx.de,
        David.Laight@ACULAB.COM, michael@amarulasolutions.com,
        bigeasy@linutronix.de, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: OMAP4+: hwmod data: Don't prevent RESET of USB
 Host module
In-Reply-To: <1386080748-17005-2-git-send-email-rogerq@ti.com>
Message-ID: <alpine.DEB.2.02.1312090125170.32309@utopia.booyaka.com>
References: <1386080748-17005-1-git-send-email-rogerq@ti.com> <1386080748-17005-2-git-send-email-rogerq@ti.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="843723315-993088861-1386552375=:32309"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--843723315-993088861-1386552375=:32309
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Beno=EEt,

On Tue, 3 Dec 2013, Roger Quadros wrote:

> Without this, the USB devices are sometimes not detected on OMAP4 Panda
> with u-boot v2013.10.
>=20
> Unlike what the comment states, errata i660 does not state that we
> can't RESET the USB host module. Instead it states that RESET is the
> only way to recover from a deadlock situation.
>=20
> RESET ensures that the module is in a known good state irrespective
> of what bootloader does with the module, so it must be done at boot.
>=20
> Reported-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Acked-by: Paul Walmsley <paul@pwsan.com>

Will you pick this up for the -rc series, or do you want me or Tony to? =20
Roger writes that this one's pretty important.


- Paul


> ---
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 12 ++----------
>  arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 13 +++----------
>  2 files changed, 5 insertions(+), 20 deletions(-)
>=20
> diff --git a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c b/arch/arm/mach-o=
map2/omap_hwmod_44xx_data.c
> index 1e5b12c..3318cae9 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_44xx_data.c
> @@ -2937,7 +2937,7 @@ static struct omap_hwmod_class_sysconfig omap44xx_u=
sb_host_hs_sysc =3D {
>  =09.sysc_offs=09=3D 0x0010,
>  =09.syss_offs=09=3D 0x0014,
>  =09.sysc_flags=09=3D (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE |
> -=09=09=09   SYSC_HAS_SOFTRESET),
> +=09=09=09   SYSC_HAS_SOFTRESET | SYSC_HAS_RESET_STATUS),
>  =09.idlemodes=09=3D (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>  =09=09=09   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
>  =09=09=09   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
> @@ -3001,15 +3001,7 @@ static struct omap_hwmod omap44xx_usb_host_hs_hwmo=
d =3D {
>  =09 * hence HWMOD_SWSUP_MSTANDBY
>  =09 */
> =20
> -=09/*
> -=09 * During system boot; If the hwmod framework resets the module
> -=09 * the module will have smart idle settings; which can lead to deadlo=
ck
> -=09 * (above Errata Id:i660); so, dont reset the module during boot;
> -=09 * Use HWMOD_INIT_NO_RESET.
> -=09 */
> -
> -=09.flags=09=09=3D HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
> -=09=09=09  HWMOD_INIT_NO_RESET,
> +=09.flags=09=09=3D HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>  };
> =20
>  /*
> diff --git a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c b/arch/arm/mach-o=
map2/omap_hwmod_54xx_data.c
> index 9e08d69..e297d62 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_54xx_data.c
> @@ -1544,7 +1544,8 @@ static struct omap_hwmod_class_sysconfig omap54xx_u=
sb_host_hs_sysc =3D {
>  =09.rev_offs=09=3D 0x0000,
>  =09.sysc_offs=09=3D 0x0010,
>  =09.sysc_flags=09=3D (SYSC_HAS_MIDLEMODE | SYSC_HAS_RESET_STATUS |
> -=09=09=09   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET),
> +=09=09=09   SYSC_HAS_SIDLEMODE | SYSC_HAS_SOFTRESET |
> +=09=09=09   SYSC_HAS_RESET_STATUS),
>  =09.idlemodes=09=3D (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>  =09=09=09   SIDLE_SMART_WKUP | MSTANDBY_FORCE | MSTANDBY_NO |
>  =09=09=09   MSTANDBY_SMART | MSTANDBY_SMART_WKUP),
> @@ -1598,15 +1599,7 @@ static struct omap_hwmod omap54xx_usb_host_hs_hwmo=
d =3D {
>  =09 * hence HWMOD_SWSUP_MSTANDBY
>  =09 */
> =20
> -=09/*
> -=09 * During system boot; If the hwmod framework resets the module
> -=09 * the module will have smart idle settings; which can lead to deadlo=
ck
> -=09 * (above Errata Id:i660); so, dont reset the module during boot;
> -=09 * Use HWMOD_INIT_NO_RESET.
> -=09 */
> -
> -=09.flags=09=09=3D HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY |
> -=09=09=09  HWMOD_INIT_NO_RESET,
> +=09.flags=09=09=3D HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>  =09.main_clk=09=3D "l3init_60m_fclk",
>  =09.prcm =3D {
>  =09=09.omap4 =3D {
> --=20
> 1.8.3.2
>=20


- Paul
--843723315-993088861-1386552375=:32309--
