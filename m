Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab3EGIOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:14:31 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:65492 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757460Ab3EGIO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:14:29 -0400
Date: Tue, 7 May 2013 09:14:24 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Samuel Ortiz'" <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        "'Mika Westerberg'" <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH 1/8] mfd: intel_msic: remove unnecessary
 platform_set_drvdata()
Message-ID: <20130507081424.GA3102@gmail.com>
References: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <002e01ce4a0e$cbe76460$63b62d20$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 May 2013, Jingoo Han wrote:

> The driver core clears the driver data to NULL after device_release
> or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
> (device-core: Ensure drvdata = NULL when no driver is bound).
> Thus, it is not needed to manually clear the device driver data to NULL.
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  drivers/mfd/intel_msic.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/intel_msic.c b/drivers/mfd/intel_msic.c
> index 5be3b5e..977506e 100644
> --- a/drivers/mfd/intel_msic.c
> +++ b/drivers/mfd/intel_msic.c
> @@ -443,7 +443,6 @@ static int intel_msic_remove(struct platform_device *pdev)
>  	struct intel_msic *msic = platform_get_drvdata(pdev);
>  
>  	intel_msic_remove_devices(msic);
> -	platform_set_drvdata(pdev, NULL);
>  
>  	return 0;
>  }

For the set:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
