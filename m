Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaIDKFN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 06:05:13 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35796 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaIDKFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 06:05:08 -0400
Date: Thu, 4 Sep 2014 11:05:03 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: pcf50633: use sprintf directly
Message-ID: <20140904100503.GF1397@lee--X1>
References: <1409823132-12705-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409823132-12705-1-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Sep 2014, Andy Shevchenko wrote:

> When dump a content of the registers let's use snprintf() directly with %*ph
> specifier.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/mfd/pcf50633-core.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index c87f7a0..8401552 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -106,10 +106,7 @@ static ssize_t show_dump_regs(struct device *dev, struct device_attribute *attr,
>  			} else
>  				dump[n1] = pcf50633_reg_read(pcf, n + n1);
>  
> -		hex_dump_to_buffer(dump, sizeof(dump), 16, 1, buf1, 128, 0);
> -		buf1 += strlen(buf1);
> -		*buf1++ = '\n';
> -		*buf1 = '\0';
> +		buf1 += sprintf(buf1, "%*ph\n", (int)sizeof(dump), dump);
>  	}
>  
>  	return buf1 - buf;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
