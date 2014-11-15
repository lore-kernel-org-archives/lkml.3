Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaKOQAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 11:00:24 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:42771 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207AbaKOQAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 11:00:22 -0500
Message-ID: <54677893.9070707@kernel.org>
Date: Sat, 15 Nov 2014 16:00:19 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, IIO <linux-iio@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
CC: Carlo Caione <carlo@caione.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Ramakrishna Pallala <ramakrishna.pallala@intel.com>,
        Todd Brandt <todd.e.brandt@linux.intel.com>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH 1/3] iio: adc: Add module device table for autoloading
References: <1415734210-5657-1-git-send-email-jacob.jun.pan@linux.intel.com> <1415734210-5657-2-git-send-email-jacob.jun.pan@linux.intel.com>
In-Reply-To: <1415734210-5657-2-git-send-email-jacob.jun.pan@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/14 19:30, Jacob Pan wrote:
> From: Aaron Lu <aaron.lu@intel.com>
> 
> Add the module device id table so that the driver can be automatically
> loaded once the platform device is created.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  drivers/iio/adc/axp288_adc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
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
> 

