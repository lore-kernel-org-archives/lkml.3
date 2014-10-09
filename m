Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbaJIVq4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:46:56 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:44346 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436AbaJIVqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:46:51 -0400
Date: Thu, 9 Oct 2014 14:46:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, zajec5@gmail.com,
        arend@broadcom.com, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bcma: fix build when CONFIG_OF_ADDRESS is not set
Message-ID: <20141009214645.GA20103@roeck-us.net>
References: <5436D3CF.2030506@hauke-m.de>
 <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412890781-24160-1-git-send-email-hauke@hauke-m.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 11:39:41PM +0200, Hauke Mehrtens wrote:
> Commit 2101e533f41a ("bcma: register bcma as device tree driver")
> introduces a hard dependency on OF_ADDRESS into the bcma driver.
> OF_ADDRESS is specifically disabled for the sparc architecture.
> This results in the following error when building sparc64:allmodconfig.
> 
> drivers/bcma/main.c: In function 'bcma_of_find_child_device':
> drivers/bcma/main.c:150:3: error: implicit declaration of function 'of_translate_address'
> 
> Fixes: 2101e533f41a ("bcma: register bcma as device tree driver")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Much better than my patch.

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Also compile tested to make sure it fixes the build problem.

Guenter

> ---
>  drivers/bcma/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
> index d1656c2..1000955 100644
> --- a/drivers/bcma/main.c
> +++ b/drivers/bcma/main.c
> @@ -132,7 +132,7 @@ static bool bcma_is_core_needed_early(u16 core_id)
>  	return false;
>  }
>  
> -#ifdef CONFIG_OF
> +#if defined(CONFIG_OF) && defined(CONFIG_OF_ADDRESS)
>  static struct device_node *bcma_of_find_child_device(struct platform_device *parent,
>  						     struct bcma_device *core)
>  {
> -- 
> 1.9.1
> 
