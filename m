Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaHSTXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 15:23:51 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:51761 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaHSTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 15:23:50 -0400
Message-ID: <53F3A441.1040103@kernel.org>
Date: Tue, 19 Aug 2014 20:23:45 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu
CC: Lars-Peter Clausen <lars@metafoo.de>, Peter Meerwald <pmeerw@pmeerw.net>,
        linux-iio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] iio: adc: xilinx: Remove .owner field for driver
References: <32522124850adfda5c6cb8a7759d0e3a63893c1e.1407931250.git.michal.simek@xilinx.com>
In-Reply-To: <32522124850adfda5c6cb8a7759d0e3a63893c1e.1407931250.git.michal.simek@xilinx.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/14 13:00, Michal Simek wrote:
> There is no need to init .owner field.
> 
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
> 
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Applied to the togreg branch of iio.git

Thanks,

Jonathan
> ---
> 
>  drivers/iio/adc/xilinx-xadc-core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/iio/adc/xilinx-xadc-core.c b/drivers/iio/adc/xilinx-xadc-core.c
> index fd2745c62943..92541a80b041 100644
> --- a/drivers/iio/adc/xilinx-xadc-core.c
> +++ b/drivers/iio/adc/xilinx-xadc-core.c
> @@ -1322,7 +1322,6 @@ static struct platform_driver xadc_driver = {
>  	.remove = xadc_remove,
>  	.driver = {
>  		.name = "xadc",
> -		.owner = THIS_MODULE,
>  		.of_match_table = xadc_of_match_table,
>  	},
>  };
> --
> 1.8.2.3
> 
