Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaJMMH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 08:07:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43310 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaJMMHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 08:07:25 -0400
Message-ID: <543BC071.2090905@ti.com>
Date: Mon, 13 Oct 2014 15:07:13 +0300
From: Tero Kristo <t-kristo@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
CC: Mike Turquette <mturquette@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CLK: TI: Remove unused includes of linux/clk-private.h
References: <1412351519-29214-1-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1412351519-29214-1-git-send-email-tomeu.vizoso@collabora.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomeu,

Please add a changelog to this patch. Also, just replace the 
clk-private.h includes with clk-provider.h, do not add the include to 
the generic header. Rest of the kernel does that where needed.

Other than that, looks good to me.

-Tero

On 10/03/2014 06:51 PM, Tomeu Vizoso wrote:
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>   drivers/clk/ti/clk-44xx.c | 1 -
>   drivers/clk/ti/clk-54xx.c | 1 -
>   drivers/clk/ti/clk-7xx.c  | 1 -
>   include/linux/clk/ti.h    | 1 +
>   4 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/drivers/clk/ti/clk-44xx.c b/drivers/clk/ti/clk-44xx.c
> index 02517a8..8ea705e 100644
> --- a/drivers/clk/ti/clk-44xx.c
> +++ b/drivers/clk/ti/clk-44xx.c
> @@ -12,7 +12,6 @@
>
>   #include <linux/kernel.h>
>   #include <linux/list.h>
> -#include <linux/clk-private.h>
>   #include <linux/clkdev.h>
>   #include <linux/clk/ti.h>
>
> diff --git a/drivers/clk/ti/clk-54xx.c b/drivers/clk/ti/clk-54xx.c
> index 5e18399..e823d0b 100644
> --- a/drivers/clk/ti/clk-54xx.c
> +++ b/drivers/clk/ti/clk-54xx.c
> @@ -12,7 +12,6 @@
>
>   #include <linux/kernel.h>
>   #include <linux/list.h>
> -#include <linux/clk-private.h>
>   #include <linux/clkdev.h>
>   #include <linux/io.h>
>   #include <linux/clk/ti.h>
> diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
> index 62ac8f6..afd61a6 100644
> --- a/drivers/clk/ti/clk-7xx.c
> +++ b/drivers/clk/ti/clk-7xx.c
> @@ -12,7 +12,6 @@
>
>   #include <linux/kernel.h>
>   #include <linux/list.h>
> -#include <linux/clk-private.h>
>   #include <linux/clkdev.h>
>   #include <linux/clk/ti.h>
>
> diff --git a/include/linux/clk/ti.h b/include/linux/clk/ti.h
> index e8d8a35..ced953a 100644
> --- a/include/linux/clk/ti.h
> +++ b/include/linux/clk/ti.h
> @@ -16,6 +16,7 @@
>   #define __LINUX_CLK_TI_H__
>
>   #include <linux/clkdev.h>
> +#include <linux/clk-provider.h>
>
>   /**
>    * struct dpll_data - DPLL registers and integration data
>

