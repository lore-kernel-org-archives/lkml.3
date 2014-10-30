Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbaJ3Con (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 22:44:43 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:50427 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbaJ3Col (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 22:44:41 -0400
Date: Wed, 29 Oct 2014 22:44:29 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] thermal: exynos: convert the driver to use per-SoC
 type operations
Message-ID: <20141030024426.GA29689@developer>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Bartlomiej,

On Thu, Sep 18, 2014 at 05:27:17PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>=20
> This patch series replaces the hardware registers abstractions in
> the Exynos thermal driver by the usage of per-SoC type operations.
> Such solution provides simpler, easier to understand code and
> allows removal of ~250 LOCs (~11% of the whole source code) from
> the driver.  Some other driver improvements are now also possible
> thanks to these changes but are scheduled at later time (like
> consolidating code for clearing IRQs using INTCLEAR register).
>=20
> The patchset should not cause any functionality changes.  This
> means that unless there are some bugs in the patches itself there
> should be no behavior changes for the driver (this also includes
> lack of changes in the way hardware is accessed by the driver).
>=20
> All testing was done on (Exynos4412 SoC based) ODROID U3 board
> (some additional patches are needed to make the Exynos thermal
> driver work on this hardware).
>=20
> Depends on:
> - 'next' branch of linux-soc-thermal.git kernel tree from Eduardo
> - [PATCH] thermal: exynos: use correct offset for TMU_CONTROL
>   register on Exynos5260
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg36529=
=2Ehtml)
>=20

Could you please refresh this series?

I checked until patch 09, but patch 10 fails to apply:
patching file drivers/thermal/samsung/exynos_tmu.c
Hunk #1 succeeded at 414 (offset 15 lines).
patching file drivers/thermal/samsung/exynos_tmu.h
Hunk #1 succeeded at 92 with fuzz 2 (offset -4 lines).
Hunk #2 succeeded at 117 (offset -8 lines).
patching file drivers/thermal/samsung/exynos_tmu_data.c
Hunk #1 FAILED at 422.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/thermal/samsung/exynos_tmu_data.c.rej

I also have in my local tree the dependency patch you mention above.

Cheers,

> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
>=20
>=20
> Bartlomiej Zolnierkiewicz (33):
>   thermal: exynos: remove needless triminfo_data abstraction
>   thermal: exynos: remove needless tmu_status abstraction
>   thermal: exynos: remove needless threshold_temp abstraction
>   thermal: exynos: remove needless triminfo_ctrl abstraction
>   thermal: exynos: remove needless test_mux_addr_shift abstraction
>   thermal: exynos: remove needless therm_trip_[mode,mask]_shift
>     abstractions
>   thermal: exynos: remove needless therm_trip_en_shift abstraction
>   thermal: exynos: remove needless emul_temp_shift abstraction
>   thermal: exynos: remove needless emul_time_shift abstraction
>   thermal: exynos: replace tmu_irqstatus check by Exynos5440 one
>   thermal: exynos: replace tmu_pmin check by Exynos5440 one
>   thermal: exynos: simplify HW_TRIP level setting
>   thermal: exynos: replace threshold_falling check by Exynos SoC type
>     one
>   thermal: exynos: remove TMU_SUPPORT_READY_STATUS flag
>   thermal: exynos: remove TMU_SUPPORT_TRIM_RELOAD flag
>   thermal: exynos: add sanitize_temp_error() helper
>   thermal: exynos: add get_th_reg() helper
>   thermal: exynos: add ->tmu_initialize method
>   thermal: exynos: add get_con_reg() helper
>   thermal: exynos: add ->tmu_control method
>   thermal: exynos: add ->tmu_read method
>   thermal: exynos: add get_emul_con_reg() helper
>   thermal: exynos: add ->tmu_set_emulation method
>   thermal: exynos: add ->tmu_clear_irqs method
>   thermal: exynos: remove TMU_SUPPORT_FALLING_TRIP flag
>   thermal: exynos: remove TMU_SUPPORT_EMUL_TIME flag
>   thermal: exynos: remove TMU_SUPPORT_EMULATION flag
>   thermal: exynos: remove TMU_SUPPORT_ADDRESS_MULTIPLE flag
>   thermal: exynos: remove TMU_SUPPORT_MULTI_INST flag
>   thermal: exynos: remove test_mux pdata field
>   thermal: exynos: remove SoC type ifdefs
>   thermal: exynos: remove __EXYNOS5420_TMU_DATA macro
>   thermal: exynos: remove exynos_tmu_data.h include
>=20
>  drivers/thermal/samsung/exynos_thermal_common.h |   1 -
>  drivers/thermal/samsung/exynos_tmu.c            | 706 +++++++++++++++++-=
------
>  drivers/thermal/samsung/exynos_tmu.h            | 131 +----
>  drivers/thermal/samsung/exynos_tmu_data.c       | 260 +--------
>  drivers/thermal/samsung/exynos_tmu_data.h       | 174 ------
>  5 files changed, 509 insertions(+), 763 deletions(-)
>  delete mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>=20
> --=20
> 1.8.2.3
>=20

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUaYCAAoJEMLUO4d9pOJWan4H/2YDAd8+bVQmCWRmwXupVsgV
uGCnV8TPa0lNxHWj49Kt4eWPKmDdn6v7/0aIAUGiAcUpwEd1+KOC+Lb/46GT5Tmn
mnBS8F5XARBZZmtQvW3eX9i4xoOYEtfCl35Whuud1rdcsJQbRs8eEgJE9Lq/5k15
tMvmElmZcJJBufQbJ2aBDoEFAFyajjIm3jzvk4WVuDgJ+0vaGvgdv+f86jui3HMg
hYArjxrKzxX9Vmc9IREPj0qnSkGBUWVwncppD/PfM4ZMsc4R9zukZr2wcUZaPfvN
rmrOLLJvSrVbmxjyfNkne7LmaOR4LJwZy9drRTCDiATpK5+hskI6srI+RB9pjMU=
=gdVE
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
