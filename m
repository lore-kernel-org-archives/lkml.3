Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaKOX6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 18:58:23 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:53663 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbaKOX6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 18:58:21 -0500
Date: Sat, 15 Nov 2014 14:47:23 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/33] thermal: exynos: convert the driver to use
 per-SoC type operations
Message-ID: <20141115184720.GA5722@developer>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello Bartlomiej,


On Thu, Nov 13, 2014 at 04:00:55PM +0100, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>=20
> This patch series replaces the hardware registers abstractions in
> the Exynos thermal driver by the usage of per-SoC type operations.

Good! I think the driver is a bit confusing because it has two ways of
checking features: soc based and feature flag based. Thus, removing one
is a good step.

> Such solution provides simpler, easier to understand code and

Well, that is arguable. IMO, the feature based solution is naturally
easier to understand as while reading the code, you think about the
feature not about chip / IP/ SoC versions. Besides, having soc based
approach spreads many if's in your code base.

Anyways, so far no one working in the Exynos code base has nacked your
proposal. Apart from that, the issue I had with it, as I mentioned, was
the fact that it currently has two ways of representing / checking
features. That is for sure the major issue.

> allows removal of ~250 LOCs (~11% of the whole source code) from
> the driver.  Some other driver improvements are now also possible
> thanks to these changes but are scheduled at later time (like
> consolidating code for clearing IRQs using INTCLEAR register).
>=20

I am not sure I get your point here. I understand you are basing new
changes in the code on top of this series, but I don't see how this
refactoring could enable other feature implementions.


> The patchset should not cause any functionality changes.  This
> means that unless there are some bugs in the patches itself there
> should be no behavior changes for the driver (this also includes
> lack of changes in the way hardware is accessed by the driver).
>=20
> All testing was done on (Exynos4412 SoC based) ODROID U3 board
> (some additional patches are needed to make the Exynos thermal
> driver work on this hardware).

Is it possible to spread testing here? I would like to have coverage for
all supported chip versions. The reasoning is because the driver
supports more than Exynos4412, and the amount of changes are
considerably big.

One thing I can do is to start testing in linux-next on this code. Thus,
I can merge it in my -next branch (which includes my -linus and -fixes
branches). But so far, it would not be queued.

My proposal is that these changes will be sent only for the 3.19 merge
window though. For 3.18 -rc's I believe it is too late. However,
to get it into 3.19, I request you to provide the testing in all
supported chips, as I mentioned. Do you think it is doable before Linus
opens 3.19 merge window?


>=20
> Depends on:
> - 'next' branch of linux-soc-thermal.git kernel tree from Eduardo
>=20

Thanks for attending my request.

> Changes since v1 (https://lkml.org/lkml/2014/9/18/305):
> - rebased on top of the current linux-soc-thermal kernel
>=20
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
>  drivers/thermal/samsung/exynos_tmu.c            | 692 ++++++++++++++++--=
------
>  drivers/thermal/samsung/exynos_tmu.h            | 123 +----
>  drivers/thermal/samsung/exynos_tmu_data.c       | 239 +-------
>  drivers/thermal/samsung/exynos_tmu_data.h       | 159 ------
>  5 files changed, 485 insertions(+), 729 deletions(-)
>  delete mode 100644 drivers/thermal/samsung/exynos_tmu_data.h
>=20
> --=20
> 1.8.2.3
>=20

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZ5+sAAoJEMLUO4d9pOJWMYAH/0l9vwYy997jjJh6gEZmy7dZ
rQKJCWmsjdL13LRD/k0GiF/lep90UZg/9/SFaPMcN/0nZQgs75ZuFEFdL02Z77Yy
J00F+rBzUMZBEe5ymsUOf07fObSydI2PZTlZT6xpcftchJespogZkSQVpzJoa0lM
M2VvVQiIx3hNWMI4k/45opY1LnjnkGeQrXBZooxZ82l7NjjBZ3znbyPwvlmQZVSP
8vLacm2fNZseGEp3YEpQREkNVckNBpiPXG8abrjE5BqKTaorPg2e94+pm4yzQbVa
LwJJYFh8ZgBL/NEgmT0g0hgsXNJzPbGYm6aIpnkbTAimr13XGMvQHBG0am0HsyM=
=0qD+
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
