Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286Ab3BLQlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:41:12 -0500
Received: from mga11.intel.com ([192.55.52.93]:57376 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758698Ab3BLQlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:41:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,650,1355126400"; 
   d="scan'208";a="286231405"
Date: Tue, 12 Feb 2013 08:16:40 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.jf.intel.com>
Cc: linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.jf.intel.com>
Subject: Re: [PATCH] dw_dmac: add support for Lynxpoint DMA controllers
Message-ID: <20130212161639.GP3789@intel.com>
References: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360251388-16075-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 05:36:28PM +0200, Andy Shevchenko wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Intel Lynxpoint PCH Low Power Subsystem has DMA controller to support general
> purpose serial buses like SPI, I2C, and HSUART. This controller is enumerated
> from ACPI namespace with ACPI ID INTL9C60.
> 
Applied with correct SOBs...

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dw_dmac.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index d6abea8..5feee76 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1977,6 +1977,11 @@ static const struct of_device_id dw_dma_id_table[] = {
>  MODULE_DEVICE_TABLE(of, dw_dma_id_table);
>  #endif
>  
> +static const struct platform_device_id dw_dma_ids[] = {
> +	{ "INTL9C60", 0 },
> +	{ }
> +};
> +
>  static struct platform_driver dw_driver = {
>  	.probe		= dw_probe,
>  	.remove		= dw_remove,
> @@ -1986,6 +1991,7 @@ static struct platform_driver dw_driver = {
>  		.pm	= &dw_dev_pm_ops,
>  		.of_match_table = of_match_ptr(dw_dma_id_table),
>  	},
> +	.id_table	= dw_dma_ids,
>  };
>  
>  static int __init dw_init(void)
> -- 
> 1.7.10.4
> 
