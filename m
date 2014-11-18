Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbaKRP0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:26:19 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:33894 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843AbaKRP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:26:15 -0500
Date: Tue, 18 Nov 2014 15:26:07 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, IIO <linux-iio@vger.kernel.org>,
        Jonathan Cameron <jic23@kernel.org>, Carlo Caione <carlo@caione.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/3] iio: adc: Add module device table for autoloading
Message-ID: <20141118152607.GC13792@x1>
References: <1415734210-5657-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1415734210-5657-2-git-send-email-jacob.jun.pan@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1415734210-5657-2-git-send-email-jacob.jun.pan@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Jacob Pan wrote:

> From: Aaron Lu <aaron.lu@intel.com>
> 
> Add the module device id table so that the driver can be automatically
> loaded once the platform device is created.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  drivers/iio/adc/axp288_adc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied, thanks.

> diff --git a/drivers/iio/adc/axp288_adc.c b/drivers/iio/adc/axp288_adc.c
> index 4800286..4a6cf43 100644
> --- a/drivers/iio/adc/axp288_adc.c
> +++ b/drivers/iio/adc/axp288_adc.c
> @@ -238,15 +238,23 @@ static int axp288_adc_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static struct platform_device_id axp288_adc_id_table[] = {
> +	{ .name = "axp288_adc" },
> +	{},
> +};
> +
>  static struct platform_driver axp288_adc_driver = {
>  	.probe = axp288_adc_probe,
>  	.remove = axp288_adc_remove,
> +	.id_table = axp288_adc_id_table,
>  	.driver = {
>  		.name = "axp288_adc",
>  		.owner = THIS_MODULE,
>  	},
>  };
>  
> +MODULE_DEVICE_TABLE(platform, axp288_adc_id_table);
> +
>  module_platform_driver(axp288_adc_driver);
>  
>  MODULE_AUTHOR("Jacob Pan <jacob.jun.pan@linux.intel.com>");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
