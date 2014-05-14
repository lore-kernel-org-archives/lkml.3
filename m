Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbaENLKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 07:10:09 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:35889 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981AbaENLKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 07:10:06 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of/selftest: clean-up of_selftest_platform_populate
 pass/fail handling
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>
In-Reply-To: <1399997908-30916-1-git-send-email-robherring2@gmail.com>
References: <1399997908-30916-1-git-send-email-robherring2@gmail.com>
Date: Wed, 14 May 2014 12:10:01 +0100
Message-Id: <20140514111001.4233CC4153D@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 11:18:28 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <robh@kernel.org>
> 
> Move the pass/fail checks into selftest() calls instead of a separate if
> condition. Unconditionally calling pass was wrong.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>

Acked-by: Grant Likely <grant.likely@linaro.org>

> ---
>  drivers/of/selftest.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/of/selftest.c b/drivers/of/selftest.c
> index fe70b86..c1d7d38 100644
> --- a/drivers/of/selftest.c
> +++ b/drivers/of/selftest.c
> @@ -440,22 +440,18 @@ static void __init of_selftest_platform_populate(void)
>  	/* Test that a missing irq domain returns -EPROBE_DEFER */
>  	np = of_find_node_by_path("/testcase-data/testcase-device1");
>  	pdev = of_find_device_by_node(np);
> -	if (!pdev)
> -		selftest(0, "device 1 creation failed\n");
> +	selftest(pdev, "device 1 creation failed\n");
> +
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq != -EPROBE_DEFER)
> -		selftest(0, "device deferred probe failed - %d\n", irq);
> +	selftest(irq == -EPROBE_DEFER, "device deferred probe failed - %d\n", irq);
>  
>  	/* Test that a parsing failure does not return -EPROBE_DEFER */
>  	np = of_find_node_by_path("/testcase-data/testcase-device2");
>  	pdev = of_find_device_by_node(np);
> -	if (!pdev)
> -		selftest(0, "device 2 creation failed\n");
> +	selftest(pdev, "device 2 creation failed\n");
>  	irq = platform_get_irq(pdev, 0);
> -	if (irq >= 0 || irq == -EPROBE_DEFER)
> -		selftest(0, "device parsing error failed - %d\n", irq);
> +	selftest(irq < 0 && irq != -EPROBE_DEFER, "device parsing error failed - %d\n", irq);
>  
> -	selftest(1, "passed");
>  }
>  
>  static int __init of_selftest(void)
> -- 
> 1.9.1
> 

