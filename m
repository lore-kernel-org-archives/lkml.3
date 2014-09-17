Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaIQQDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 12:03:12 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:57365 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870AbaIQQDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 12:03:10 -0400
Date: Wed, 17 Sep 2014 09:03:05 -0700
From: Lee Jones <lee.jones@linaro.org>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: ssbi: promote the driver to subsys level
Message-ID: <20140917160305.GH30918@lee--X1>
References: <1410915594-15599-1-git-send-email-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410915594-15599-1-git-send-email-srinivas.kandagatla@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2014, Srinivas Kandagatla wrote:

> This patch promtes the driver to be at subsystem level as this driver
> will be used by gpio controller drivers which inturn are used by many
> platform drivers.

Any reason why you're not using -EPROBE?

> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
> ---
>  drivers/mfd/ssbi.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/mfd/ssbi.c b/drivers/mfd/ssbi.c
> index b78942e..4fbe02e 100644
> --- a/drivers/mfd/ssbi.c
> +++ b/drivers/mfd/ssbi.c
> @@ -331,7 +331,12 @@ static struct platform_driver ssbi_driver = {
>  		.of_match_table = ssbi_match_table,
>  	},
>  };
> -module_platform_driver(ssbi_driver);
> +
> +static int ssbi_init(void)
> +{
> +	return platform_driver_register(&ssbi_driver);
> +}
> +subsys_initcall(ssbi_init);
>  
>  MODULE_LICENSE("GPL v2");
>  MODULE_VERSION("1.0");

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
