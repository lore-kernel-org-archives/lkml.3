Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaDDGbs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 02:31:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53320 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaDDGbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 02:31:44 -0400
Message-ID: <533E518C.5020807@ti.com>
Date: Fri, 4 Apr 2014 12:00:36 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] irqchip/irq-crossbar: not allocating enough memory
References: <20140403072134.GA14286@mwanda>
In-Reply-To: <20140403072134.GA14286@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 April 2014 12:51 PM, Dan Carpenter wrote:
> We are allocating the size of a pointer and not the size of the data.
> This will lead to memory corruption.
>
> There isn't actually a "cb_device" struct, btw.  The code is only able
> to compile because GCC knows that all pointers are the same size.
>
> Fixes: 96ca848ef7ea ('DRIVERS: IRQCHIP: CROSSBAR: Add support for Crossbar IP')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossbar.c
> index fc817d2..3d15d16 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -107,7 +107,7 @@ static int __init crossbar_of_init(struct device_node *node)
>  	int i, size, max, reserved = 0, entry;
>  	const __be32 *irqsr;
>  
> -	cb = kzalloc(sizeof(struct cb_device *), GFP_KERNEL);
> +	cb = kzalloc(sizeof(*cb), GFP_KERNEL);
>  
>  	if (!cb)
>  		return -ENOMEM;
Yes. correct. Thanks for the catch.

Acked-by: Sricharan R <r.sricharan@ti.com>


Regards,
 Sricharan
