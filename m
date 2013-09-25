Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab3IYXwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:52:11 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:2555 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3IYXwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:52:09 -0400
Message-ID: <1380153009.14046.41.camel@misato.fc.hp.com>
Subject: Re: [PATCH] Staging / quickstart: remove reduplicate
 if(acpi_disabled) check
From: Toshi Kani <toshi.kani@hp.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jiang Liu <jiang.liu@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Wed, 25 Sep 2013 17:50:09 -0600
In-Reply-To: <1379847947-32366-1-git-send-email-hanjun.guo@linaro.org>
References: <1379847947-32366-1-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 11:05 +0000, Hanjun Guo wrote:
> In acpi_bus_register_driver(), there is an if (acpi_disabled) check,
> so the if(acpi_disabled) before it is reduplicate, remove it.
> 
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>

Acked-by: Toshi Kani <toshi.kani@hp.com>

-Toshi

> ---
>  drivers/staging/quickstart/quickstart.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
> index 4247d60..9f6ebdb 100644
> --- a/drivers/staging/quickstart/quickstart.c
> +++ b/drivers/staging/quickstart/quickstart.c
> @@ -390,10 +390,6 @@ static int __init quickstart_init(void)
>  {
>  	int ret;
>  
> -	/* ACPI Check */
> -	if (acpi_disabled)
> -		return -ENODEV;
> -
>  	/* ACPI driver register */
>  	ret = acpi_bus_register_driver(&quickstart_acpi_driver);
>  	if (ret)


