Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbaKTL6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 06:58:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10849 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238AbaKTL6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 06:58:13 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-47-546dd752147a
Date: Thu, 20 Nov 2014 12:58:04 +0100
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/33] thermal: exynos: convert the driver to use
 per-SoC type operations
Message-id: <20141120125804.5248eb61@amdc2363>
In-reply-to: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
References: <1415890888-8881-1-git-send-email-b.zolnierkie@samsung.com>
Organization: SPRC Poland
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t9jAd2g67khBq1/+S0aroZYbJyxntVi
	/pVrrBZnm96wW1zeNYfN4nPvEUaLGef3MVk8edjH5sDhsXPWXXaPxXteMnn0bVnF6PF5k1wA
	SxSXTUpqTmZZapG+XQJXxp+jD1gLtitWfJ05nbGBcYV0FyMnh4SAicS2mR0sELaYxIV769m6
	GLk4hAQWMUpMevaIEcL5xSjR82IVM0gVi4CqxLze5UwgNpuAnsTnu0/BbBEBLYkTl7YzgTQw
	C0xjkrizciMbSEJYIEniYNMrVhCbF6jh05smRhCbU8BD4tXUv2C2kIC7xLVH78AW8AtISrT/
	+8EMcZKdxLlPG9ghegUlfky+B3YqM9CyzduaWCFseYnNa94yT2AUnIWkbBaSsllIyhYwMq9i
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA7/Z9I7GFc1WBxiFOBgVOLhTbDIDRFiTSwrrsw9
	xCjBwawkwquxEyjEm5JYWZValB9fVJqTWnyIUZqDRUmc99A1oJRAemJJanZqakFqEUyWiYNT
	qoFRXUOU26Njcs7pCHZDnnX2Vg5v3HRlRfnOxjLc66v3sgm8tnffdp89BcLCCTfiNzptNije
	urfb0ECtk9+gap/RhOls/Ab5R2aU3+cPvSqvePV0irjVxeIf2plFiwSK+aczP5uw1OOjHtua
	c819R6rLlj1y5vpz1SxgcdriMz+XS6j/3211Q0CJpTgj0VCLuag4EQBP4hTrewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eduardo,

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

For the whole patch series:

Repository:
kernel_linux-soc-thermal/next
SHA1: 4027494124fd88e5d51127eebba315de5d8d57c8

Test HW:

Trats2 - Exynos4412
Tested-by: Lukasz Majewski <l.majewski@samsung.com>

Trats - Exynos4210
Tested-by: Lukasz Majewski <l.majewski@samsung.com>

ARNDALE(SMDK) - Exynos5250
Tested-by: Lukasz Majewski <l.majewski@samsung.com>

ARNDALE OCTA - Exynos5420
Tested-by: Lukasz Majewski <l.majewski@samsung.com>


> 
> Depends on:
> - 'next' branch of linux-soc-thermal.git kernel tree from Eduardo
> 
> Changes since v1 (https://lkml.org/lkml/2014/9/18/305):
> - rebased on top of the current linux-soc-thermal kernel
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
>  drivers/thermal/samsung/exynos_tmu.c            | 692
> ++++++++++++++++--------
> drivers/thermal/samsung/exynos_tmu.h            | 123 +----
> drivers/thermal/samsung/exynos_tmu_data.c       | 239 +-------
> drivers/thermal/samsung/exynos_tmu_data.h       | 159 ------ 5 files
> changed, 485 insertions(+), 729 deletions(-) delete mode 100644
> drivers/thermal/samsung/exynos_tmu_data.h
> 



-- 
Best regards,

Lukasz Majewski

Samsung R&D Institute Poland (SRPOL) | Linux Platform Group
