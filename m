Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaH1R1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 13:27:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54756 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaH1R1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 13:27:03 -0400
Message-ID: <53FF6653.60802@ti.com>
Date: Thu, 28 Aug 2014 20:26:43 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, <santosh.shilimkar@ti.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: Dan Carpenter <dan.carpenter@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irqchip: keystone: remove warning unsigned 'kirq->irq'
 is never less than zero
References: <1406126430-9978-1-git-send-email-grygorii.strashko@ti.com> <1409246189-29727-1-git-send-email-grygorii.strashko@ti.com>
In-Reply-To: <1409246189-29727-1-git-send-email-grygorii.strashko@ti.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On 08/28/2014 08:16 PM, Grygorii Strashko wrote:
> Remove static checker warning:
>
> 	drivers/irqchip/irq-keystone.c:166 keystone_irq_probe()
> 	warn: unsigned 'kirq->irq' is never less than zero.
>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---

Sorry, forgot to mention that this is incremental fix for the patch
https://lkml.org/lkml/2014/7/23/891
"[PATCH v2] irqchip: add keystone irq controller ip driver" which is
in linux-next already.

>   drivers/irqchip/irq-keystone.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-keystone.c b/drivers/irqchip/irq-keystone.c
> index fea26bc..608abf9 100644
> --- a/drivers/irqchip/irq-keystone.c
> +++ b/drivers/irqchip/irq-keystone.c
> @@ -36,7 +36,7 @@ struct keystone_irq_device {
>   	struct device		*dev;
>   	struct irq_chip		 chip;
>   	u32			 mask;
> -	u32			 irq;
> +	int			 irq;
>   	struct irq_domain	*irqd;
>   	struct regmap		*devctrl_regs;
>   	u32			devctrl_offset;
>

