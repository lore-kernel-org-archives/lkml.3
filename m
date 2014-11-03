Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaKCQGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:06:01 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50415 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbaKCQF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:05:58 -0500
Date: Mon, 3 Nov 2014 16:05:52 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: db8500-prcmu: check return of devm_ioremap for error
Message-ID: <20141103160552.GD10544@x1>
References: <1414660895-29255-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414660895-29255-1-git-send-email-pramod.gurav@smartplayin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Pramod Gurav wrote:

> Error check around return value of devm_ioremap is missing. Add the same
> to avoid NULL pointer dereference.
> 
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
> ---
>  drivers/mfd/db8500-prcmu.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 193cf16..89ae8bf 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -3167,6 +3167,11 @@ static int db8500_prcmu_probe(struct platform_device *pdev)
>  	}
>  	tcdm_base = devm_ioremap(&pdev->dev, res->start,
>  			resource_size(res));
> +	if (!tcdm_base) {
> +		dev_err(&pdev->dev,
> +			"failed to ioremap prcmu-tcdm register memory\n");
> +		return -ENOENT;

No such file or directory?  I think not.

Changed to -ENOMEM and applied with Linus' Ack.

> +	}
>  
>  	/* Clean up the mailbox interrupts after pre-kernel code. */
>  	writel(ALL_MBOX_BITS, PRCM_ARM_IT1_CLR);

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
