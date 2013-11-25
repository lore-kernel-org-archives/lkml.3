Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab3KYPRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:17:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31153 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3KYPR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:17:28 -0500
X-AuditID: cbfee61a-b7f316d000007e34-f3-52936a065a36
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] thermal: EXYNOS: always register TMU driver with core
 thermal framework
Date: Mon, 25 Nov 2013 16:17:14 +0100
Message-id: <1440196.1vM1gSXuH1@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <2244251.cWS1a83qbK@amdc1032>
References: <2244251.cWS1a83qbK@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t9jQV32rMlBBreXs1k0XA2xWLP/J5PF
	2aY37BaXd81hs/jce4TRYsb5fUwWTx72sTmweyze85LJo2/LKkaP4ze2M3l83iQXwBLFZZOS
	mpNZllqkb5fAlbHs5g/WgiaZiu+PrzI1MK4Q72Lk5JAQMJFY37SCHcIWk7hwbz1bFyMXh5DA
	dEaJP5NOQzktTBKrdp9gAaliE7CSmNi+ihHEFhHQk7jx4gkTiM0scI9R4uKXLBBbWCBOYmXn
	erB6FgFViR9Pb7CC2LwCmhLnT0wAi4sKeErs2L6SDcTmFNCSWLKwC8wWAqr52faHHaJeUOLH
	5HssEPPlJfbtn8oKYWtJrN95nGkCo8AsJGWzkJTNQlK2gJF5FaNoakFyQXFSeq6hXnFibnFp
	Xrpecn7uJkZwaD+T2sG4ssHiEKMAB6MSD69F5aQgIdbEsuLK3EOMEhzMSiK80wwmBwnxpiRW
	VqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpgvPD9v9SP2+1X12xX
	el1ued7suZVaizLbwqctF5KWnSqIzz+27vbTSJsF8iyKly8faX/1teta7eEDHW8rmOPr6m5+
	CXOojvx6oukRk8+z1ZPvfry0pW/+uzCLK5o6qWUCVkfvW/uYSr6JS7k/+47pkjbN3TmKHh9X
	/ev4xxSd+eW37M1Dm3InnVZiKc5INNRiLipOBADMzZUcaQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Could you please also apply this patch?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Friday, October 04, 2013 02:38:25 PM Bartlomiej Zolnierkiewicz wrote:
> There is little sense in having separate config option for
> registering EXYNOS TMU driver with the core thermal framework.
> Fix it by integrating EXYNOS_THERMAL_CORE config option with
> EXYNOS_THERMAL one.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/thermal/samsung/Kconfig                 | 14 +++-----------
>  drivers/thermal/samsung/Makefile                |  2 +-
>  drivers/thermal/samsung/exynos_thermal_common.h | 12 ------------
>  3 files changed, 4 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/thermal/samsung/Kconfig b/drivers/thermal/samsung/Kconfig
> index f760389..04eabee 100644
> --- a/drivers/thermal/samsung/Kconfig
> +++ b/drivers/thermal/samsung/Kconfig
> @@ -5,14 +5,6 @@ config EXYNOS_THERMAL
>  	  If you say yes here you get support for the TMU (Thermal Management
>  	  Unit) driver for SAMSUNG EXYNOS series of SoCs. This driver initialises
>  	  the TMU, reports temperature and handles cooling action if defined.
> -	  This driver uses the Exynos core thermal APIs and TMU configuration
> -	  data from the supported SoCs.
> -
> -config EXYNOS_THERMAL_CORE
> -	bool "Core thermal framework support for EXYNOS SOCs"
> -	depends on EXYNOS_THERMAL
> -	help
> -	  If you say yes here you get support for EXYNOS TMU
> -	  (Thermal Management Unit) common registration/unregistration
> -	  functions to the core thermal layer and also to use the generic
> -	  CPU cooling APIs.
> +	  This driver uses the Exynos core thermal APIs, TMU configuration data
> +	  from the supported SoCs, common registration/unregistration functions
> +	  to the core thermal layer and also the generic CPU cooling APIs.
> diff --git a/drivers/thermal/samsung/Makefile b/drivers/thermal/samsung/Makefile
> index c09d830..a829107 100644
> --- a/drivers/thermal/samsung/Makefile
> +++ b/drivers/thermal/samsung/Makefile
> @@ -4,4 +4,4 @@
>  obj-$(CONFIG_EXYNOS_THERMAL)			+= exynos_thermal.o
>  exynos_thermal-y				:= exynos_tmu.o
>  exynos_thermal-y				+= exynos_tmu_data.o
> -exynos_thermal-$(CONFIG_EXYNOS_THERMAL_CORE)	+= exynos_thermal_common.o
> +exynos_thermal-y				+= exynos_thermal_common.o
> diff --git a/drivers/thermal/samsung/exynos_thermal_common.h b/drivers/thermal/samsung/exynos_thermal_common.h
> index 3eb2ed9..8681679 100644
> --- a/drivers/thermal/samsung/exynos_thermal_common.h
> +++ b/drivers/thermal/samsung/exynos_thermal_common.h
> @@ -88,20 +88,8 @@ struct thermal_sensor_conf {
>  	struct device *dev;
>  };
>  
> -/*Functions used exynos based thermal sensor driver*/
> -#ifdef CONFIG_EXYNOS_THERMAL_CORE
>  void exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf);
>  int exynos_register_thermal(struct thermal_sensor_conf *sensor_conf);
>  void exynos_report_trigger(struct thermal_sensor_conf *sensor_conf);
> -#else
> -static inline void
> -exynos_unregister_thermal(struct thermal_sensor_conf *sensor_conf) { return; }
>  
> -static inline int
> -exynos_register_thermal(struct thermal_sensor_conf *sensor_conf) { return 0; }
> -
> -static inline void
> -exynos_report_trigger(struct thermal_sensor_conf *sensor_conf) { return; }
> -
> -#endif /* CONFIG_EXYNOS_THERMAL_CORE */
>  #endif /* _EXYNOS_THERMAL_COMMON_H */

