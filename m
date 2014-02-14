Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaBNNar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:30:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55038 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752557AbaBNNaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:30:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Josh Cartwright <joshc@codeaurora.org>, linux-acpi@vger.kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / platform: drop redundant ACPI_HANDLE check
Date: Fri, 14 Feb 2014 14:45:29 +0100
Message-ID: <1746200.FR6bSit96i@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392350443-20074-1-git-send-email-joshc@codeaurora.org>
References: <1392350443-20074-1-git-send-email-joshc@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 13, 2014 10:00:43 PM Josh Cartwright wrote:
> The acpi_dev_pm_attach/_detach functions perform their own checks to
> ensure the device has an ACPI companion.  It is not necessary for the
> caller to do so.
> 
> This mirrors what other busses with ACPI dev PM support do (i2c, spi,
> sdio).
> 
> Cc: Len Brown <lenb@kernel.org>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Josh Cartwright <joshc@codeaurora.org>

Hi Greg,

If you want to take this, please feel free to add:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

to it.  If you want me to take it, please let me know.

Rafael


> ---
>  drivers/base/platform.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index bc78848..e714709 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -481,11 +481,10 @@ static int platform_drv_probe(struct device *_dev)
>  	struct platform_device *dev = to_platform_device(_dev);
>  	int ret;
>  
> -	if (ACPI_HANDLE(_dev))
> -		acpi_dev_pm_attach(_dev, true);
> +	acpi_dev_pm_attach(_dev, true);
>  
>  	ret = drv->probe(dev);
> -	if (ret && ACPI_HANDLE(_dev))
> +	if (ret)
>  		acpi_dev_pm_detach(_dev, true);
>  
>  	if (drv->prevent_deferred_probe && ret == -EPROBE_DEFER) {
> @@ -508,8 +507,7 @@ static int platform_drv_remove(struct device *_dev)
>  	int ret;
>  
>  	ret = drv->remove(dev);
> -	if (ACPI_HANDLE(_dev))
> -		acpi_dev_pm_detach(_dev, true);
> +	acpi_dev_pm_detach(_dev, true);
>  
>  	return ret;
>  }
> @@ -520,8 +518,7 @@ static void platform_drv_shutdown(struct device *_dev)
>  	struct platform_device *dev = to_platform_device(_dev);
>  
>  	drv->shutdown(dev);
> -	if (ACPI_HANDLE(_dev))
> -		acpi_dev_pm_detach(_dev, true);
> +	acpi_dev_pm_detach(_dev, true);
>  }
>  
>  /**
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
