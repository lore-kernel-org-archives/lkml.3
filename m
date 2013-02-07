Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1160996Ab3BGRvC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 12:51:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43248 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759210Ab3BGRvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 12:51:00 -0500
Message-ID: <5113E978.2060201@ti.com>
Date: Thu, 7 Feb 2013 23:20:48 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Kumar, Anil" <anilkumar.v@ti.com>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <wim@iguana.be>
Subject: Re: [PATCH] watchdog: davinci_wdt: update to devm_* API
References: <1360207935-24325-1-git-send-email-anilkumar.v@ti.com>
In-Reply-To: <1360207935-24325-1-git-send-email-anilkumar.v@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/7/2013 9:02 AM, Kumar, Anil wrote:
> Update the code to use devm_* API so that driver
> core will manage resources.
> 
> Signed-off-by: Kumar, Anil <anilkumar.v@ti.com>
> ---
> This patch applies on top of v3.8-rc6.
> 
> Tested on da850 EVM.
> 
> :100644 100644 e8e8724... 6ad76a3... M	drivers/watchdog/davinci_wdt.c
>  drivers/watchdog/davinci_wdt.c |   34 +++++++++-------------------------
>  1 files changed, 9 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index e8e8724..6ad76a3 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -69,7 +69,6 @@ static unsigned long wdt_status;
>  #define WDT_REGION_INITED 2
>  #define WDT_DEVICE_INITED 3
>  
> -static struct resource	*wdt_mem;
>  static void __iomem	*wdt_base;
>  struct clk		*wdt_clk;
>  
> @@ -201,10 +200,10 @@ static struct miscdevice davinci_wdt_miscdev = {
>  
>  static int davinci_wdt_probe(struct platform_device *pdev)
>  {
> -	int ret = 0, size;
> -	struct device *dev = &pdev->dev;

Its not clear why you had to drop use of this variable?

> +	int ret = 0;
> +	static struct resource  *wdt_mem;
>  
> -	wdt_clk = clk_get(dev, NULL);
> +	wdt_clk = clk_get(&pdev->dev, NULL);

When you are converting to use devres, why not convert this to
devm_clk_get() as well?

Thanks,
Sekhar
