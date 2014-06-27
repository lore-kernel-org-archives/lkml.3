Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaF0IVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:21:38 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34812 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094AbaF0IUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:20:51 -0400
Date: Fri, 27 Jun 2014 09:20:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Keerthy <j-keerthy@ti.com>
Cc: linux-omap@vger.kernel.org, lgirdwood@gmail.com, broonie@kernel.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com
Subject: Re: [PATCH v2 7/9] regulator: palmas: Add palmas_pmic_driver_data
 structure
Message-ID: <20140627082045.GD19645@lee--X1>
References: <1403085540-20014-1-git-send-email-j-keerthy@ti.com>
 <1403085540-20014-8-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403085540-20014-8-git-send-email-j-keerthy@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Keerthy wrote:

> Add palmas_pmic_driver_data structure.
> 
> Signed-off-by: Keerthy <j-keerthy@ti.com>
> ---
>  include/linux/mfd/palmas.h |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
> 
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 0136e58..1a045ba 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -53,6 +53,8 @@ struct palmas_pmic;
>  struct palmas_gpadc;
>  struct palmas_resource;
>  struct palmas_usb;
> +struct palmas_pmic_driver_data;
> +struct palmas_pmic_platform_data;

Are you sure all of these forward declarations are required?  I'd
prefer that you re-ordered the header file, rather than have them all
looming here.

>  enum palmas_usb_state {
>  	PALMAS_USB_STATE_DISCONNECT,
> @@ -76,6 +78,8 @@ struct palmas {
>  	struct mutex irq_lock;
>  	struct regmap_irq_chip_data *irq_data;
>  
> +	struct palmas_pmic_driver_data *pmic_ddata;
> +
>  	/* Child Devices */
>  	struct palmas_pmic *pmic;
>  	struct palmas_gpadc *gpadc;
> @@ -107,6 +111,27 @@ struct regs_info {
>  	int	sleep_id;
>  };
>  
> +struct palmas_pmic_driver_data {
> +	int smps_start;
> +	int smps_end;
> +	int ldo_begin;
> +	int ldo_end;
> +	int max_reg;
> +	struct regs_info *palmas_regs_info;
> +	struct of_regulator_match *palmas_matches;
> +	struct palmas_sleep_requestor_info *sleep_req_info;
> +	int (*smps_register)(struct palmas_pmic *pmic,
> +			     struct palmas_pmic_driver_data *ddata,
> +			     struct palmas_pmic_platform_data *pdata,
> +			     const char *pdev_name,
> +			     struct regulator_config config);
> +	int (*ldo_register)(struct palmas_pmic *pmic,
> +			    struct palmas_pmic_driver_data *ddata,
> +			    struct palmas_pmic_platform_data *pdata,
> +			    const char *pdev_name,
> +			    struct regulator_config config);
> +};
> +
>  struct palmas_gpadc_platform_data {
>  	/* Channel 3 current source is only enabled during conversion */
>  	int ch3_current;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
