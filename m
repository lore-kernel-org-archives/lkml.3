Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaJTMlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:41:47 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28310 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJTMlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:41:45 -0400
X-AuditID: cbfee61a-f79c06d000004e71-d6-544503065830
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: exynos: use correct offset for TMU_CONTROL
 register on Exynos5260
Date: Mon, 20 Oct 2014 14:41:07 +0200
Message-id: <17456984.pRSEMqiSfL@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1594947.1Ri7fFnV5h@amdc1032>
References: <1594947.1Ri7fFnV5h@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t9jAV02ZtcQg7NdGhYNV0Ms5l+5xmpx
	tukNu8Wbh5sZLS7vmsNm8bn3CKPFjPP7mCyePOxjc+Dw2DnrLrvH4j0vmTz6tqxi9Pi8SS6A
	JYrLJiU1J7MstUjfLoEr4/rWw8wFU0Uq5i9YzNbAuFawi5GTQ0LAROLZ5COMELaYxIV769m6
	GLk4hAQWMUo8nDKXEcJpYZK4/e4gC0gVm4CVxMT2VWAdIgJaEicubWcCKWIW6GCSaH29gQkk
	ISyQKPH0XAMbiM0ioCrxZsUPsGZeoIafx7+wg9iiAp4SO7avBKvhBIp/6uwHs4UENCUOnn7O
	ClEvKPFj8j2wXmYBeYl9+6eyQthaEut3HmeawCgwC0nZLCRls5CULWBkXsUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRHObPpHYwrmywOMQowMGoxMO7w8wlRIg1say4MvcQowQHs5IIr8t/
	oBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeA63WgUIC6YklqdmpqQWpRTBZJg5OqQbGg5/9Xqas
	/X1CdOLTzewZ9okrpou7svBonRSwFFP/vLfgfsYFDu3b5SKKzPfWd+rqu2w7Hn/W9GFB76mg
	wwdM/tQkmyq7HvaQ2vVdt+mV15ql5hP5tk+4HMUUu9nqflQqt8gXWR95s3+fDQ86LJALdHj/
	Sm+95fzGYzvDRbYrfGkTPxMSkJmtxFKckWioxVxUnAgAN2jH+W8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Eduardo, could you please merge this patch?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Thursday, September 11, 2014 03:00:49 PM Bartlomiej Zolnierkiewicz wrote:
> In exynos5260_tmu_registers tmu_ctrl entry is erroneously
> assigned twice.  The second assignment (to EXYNOS_TMU_REG_CONTROL1
> define which represents 0x24 value) overrides the first one
> (to EXYNOS_TMU_REG_CONTROL define which represents 0x20 value)
> which results in the wrong (according to the Exynos5260 SoC
> documentation that I have) offset being used for TMU_CONTROL
> register.  Fix it by removing the wrong assignment and then
> remove no longer used EXYNOS_TMU_REG_CONTROL1 define.
> 
> Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
> Cc: Lukasz Majewski <l.majewski@samsung.com>
> Cc: Eduardo Valentin <edubezval@gmail.com>
> Cc: Zhang Rui <rui.zhang@intel.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/samsung/exynos_tmu_data.c |    1 -
>  drivers/thermal/samsung/exynos_tmu_data.h |    1 -
>  2 files changed, 2 deletions(-)
> 
> Index: b/drivers/thermal/samsung/exynos_tmu_data.c
> ===================================================================
> --- a/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:41:12.567347442 +0200
> +++ b/drivers/thermal/samsung/exynos_tmu_data.c	2014-09-11 14:43:00.211350284 +0200
> @@ -273,7 +273,6 @@ struct exynos_tmu_init_data const exynos
>  static const struct exynos_tmu_registers exynos5260_tmu_registers = {
>  	.triminfo_data = EXYNOS_TMU_REG_TRIMINFO,
>  	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL,
> -	.tmu_ctrl = EXYNOS_TMU_REG_CONTROL1,
>  	.therm_trip_mode_shift = EXYNOS_TMU_TRIP_MODE_SHIFT,
>  	.therm_trip_mode_mask = EXYNOS_TMU_TRIP_MODE_MASK,
>  	.therm_trip_en_shift = EXYNOS_TMU_THERM_TRIP_EN_SHIFT,
> Index: b/drivers/thermal/samsung/exynos_tmu_data.h
> ===================================================================
> --- a/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:41:12.243347433 +0200
> +++ b/drivers/thermal/samsung/exynos_tmu_data.h	2014-09-11 14:43:36.167351233 +0200
> @@ -83,7 +83,6 @@
>  #define EXYNOS_MAX_TRIGGER_PER_REG	4
>  
>  /* Exynos5260 specific */
> -#define EXYNOS_TMU_REG_CONTROL1			0x24
>  #define EXYNOS5260_TMU_REG_INTEN		0xC0
>  #define EXYNOS5260_TMU_REG_INTSTAT		0xC4
>  #define EXYNOS5260_TMU_REG_INTCLEAR		0xC8
