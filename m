Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaJTMrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:47:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20547 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJTMrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:47:41 -0400
X-AuditID: cbfee61a-f79c06d000004e71-8a-5445046b4a5f
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>,
        Lukasz Majewski <l.majewski@samsung.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/33] thermal: exynos: convert the driver to use per-SoC
 type operations
Date: Mon, 20 Oct 2014 14:47:04 +0200
Message-id: <1799007.8fVFUEOU02@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
References: <1411054070-25757-1-git-send-email-b.zolnierkie@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jQd1sFtcQg5vXjC0aroZYzL9yjdXi
	bNMbdos3DzczWlzeNYfN4nPvEUaLGef3MVk8edjH5sDhsXPWXXaPxXteMnn0bVnF6PF5k1wA
	SxSXTUpqTmZZapG+XQJXxqrHS5gKvitUTNn4ir2B8aNUFyMnh4SAicTMJa3sELaYxIV769m6
	GLk4hASmM0oc6F/DCOG0MEl8vzIRrIpNwEpiYvsqRhBbRCBM4uC9vSwgNrPAPUaJvuUGILaw
	QLzEtXu/mUBsFgFViRebJzKD2LwCmhJ7HqwF6xUV8JTYsX0lG4jNCWQ33NoENl9IwEOibctd
	qHpBiR+T70HNl5fYt38qK4StI7G/dRrbBEaBWUjKZiEpm4WkbAEj8ypG0dSC5ILipPRcQ73i
	xNzi0rx0veT83E2M4CB/JrWDcWWDxSFGAQ5GJR7eHWYuIUKsiWXFlbmHGCU4mJVEeF3+A4V4
	UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUw6t4TyFr8mG09
	j/ymtqemO+fKHd926M9TfTe9mkMnvB8v2c5Q1PJ7MstuTsuJHg2F3+/M5nHJ4evK36Z4JbzF
	dqmibVTMpRPLlpv0bm6Q6NxnX8r99Y6T1ged66e7jk/uldjHFPmJ2XhKd7C+FWNj1Jc7yTqL
	Uj5PEg6LF38QmLJb7OndnnR+JZbijERDLeai4kQAvxi+l24CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Eduaro/Amit, any comments on this series?
Could it be merged for v3.19?

[ Currently this series conflicts with "[PATCH] thermal: exynos: fix IRQ
  clearing on TMU initialization" patch so I'm planning to refresh it but
  it would be great to get some feedback first. ]

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Thursday, September 18, 2014 05:27:17 PM Bartlomiej Zolnierkiewicz wrote:
> Hi,
> 
> This patch series replaces the hardware registers abstractions in
> the Exynos thermal driver by the usage of per-SoC type operations.
> Such solution provides simpler, easier to understand code and
> allows removal of ~250 LOCs (~11% of the whole source code) from
> the driver.  Some other driver improvements are now also possible
> thanks to these changes but are scheduled at later time (like
> consolidating code for clearing IRQs using INTCLEAR register).
> 
> The patchset should not cause any functionality changes.  This
> means that unless there are some bugs in the patches itself there
> should be no behavior changes for the driver (this also includes
> lack of changes in the way hardware is accessed by the driver).
> 
> All testing was done on (Exynos4412 SoC based) ODROID U3 board
> (some additional patches are needed to make the Exynos thermal
> driver work on this hardware).
> 
> Depends on:
> - 'next' branch of linux-soc-thermal.git kernel tree from Eduardo
> - [PATCH] thermal: exynos: use correct offset for TMU_CONTROL
>   register on Exynos5260
>   (http://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg36529.html)
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> 
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
> 
>  drivers/thermal/samsung/exynos_thermal_common.h |   1 -
>  drivers/thermal/samsung/exynos_tmu.c            | 706 +++++++++++++++++-------
>  drivers/thermal/samsung/exynos_tmu.h            | 131 +----
>  drivers/thermal/samsung/exynos_tmu_data.c       | 260 +--------
>  drivers/thermal/samsung/exynos_tmu_data.h       | 174 ------
>  5 files changed, 509 insertions(+), 763 deletions(-)
>  delete mode 100644 drivers/thermal/samsung/exynos_tmu_data.h

