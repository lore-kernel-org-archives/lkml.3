Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbaIPWtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 18:49:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45976 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbaIPWtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 18:49:10 -0400
Date: Tue, 16 Sep 2014 15:49:14 -0700
From: Darren Hart <dvhart@infradead.org>
To: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Cc: mjg59@srcf.ucam.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/2] intel-rst: Use ACPI_FAILURE() macro instead
 !ACPI_SUCCESS() for error checking
Message-ID: <20140916224914.GA17720@vmdeb7>
References: <1410902036-10282-1-git-send-email-peter.ujfalusi@gmail.com>
 <1410902036-10282-2-git-send-email-peter.ujfalusi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410902036-10282-2-git-send-email-peter.ujfalusi@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 12:13:55AM +0300, Peter Ujfalusi wrote:
> ACPI_SUCCESS is defined as:
> #define ACPI_SUCCESS(a)			(!(a))
> 
> There is no need for the the double ! since there is already a macro
> defined for failures: ACPI_FAILURE()
> 

Cc: linux-acpi

Thanks,

Darren

> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
> ---
>  drivers/platform/x86/intel-rst.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/intel-rst.c b/drivers/platform/x86/intel-rst.c
> index d45bca3..8c6a8fe 100644
> --- a/drivers/platform/x86/intel-rst.c
> +++ b/drivers/platform/x86/intel-rst.c
> @@ -35,7 +35,7 @@ static ssize_t irst_show_wakeup_events(struct device *dev,
>  	acpi = to_acpi_device(dev);
>  
>  	status = acpi_evaluate_integer(acpi->handle, "GFFS", NULL, &value);
> -	if (!ACPI_SUCCESS(status))
> +	if (ACPI_FAILURE(status))
>  		return -EINVAL;
>  
>  	return sprintf(buf, "%lld\n", value);
> @@ -59,7 +59,7 @@ static ssize_t irst_store_wakeup_events(struct device *dev,
>  
>  	status = acpi_execute_simple_method(acpi->handle, "SFFS", value);
>  
> -	if (!ACPI_SUCCESS(status))
> +	if (ACPI_FAILURE(status))
>  		return -EINVAL;
>  
>  	return count;
> @@ -81,7 +81,7 @@ static ssize_t irst_show_wakeup_time(struct device *dev,
>  	acpi = to_acpi_device(dev);
>  
>  	status = acpi_evaluate_integer(acpi->handle, "GFTV", NULL, &value);
> -	if (!ACPI_SUCCESS(status))
> +	if (ACPI_FAILURE(status))
>  		return -EINVAL;
>  
>  	return sprintf(buf, "%lld\n", value);
> @@ -105,7 +105,7 @@ static ssize_t irst_store_wakeup_time(struct device *dev,
>  
>  	status = acpi_execute_simple_method(acpi->handle, "SFTV", value);
>  
> -	if (!ACPI_SUCCESS(status))
> +	if (ACPI_FAILURE(status))
>  		return -EINVAL;
>  
>  	return count;
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Darren Hart
Intel Open Source Technology Center
