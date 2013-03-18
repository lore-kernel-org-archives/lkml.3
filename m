Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3CRWVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 18:21:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47405 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab3CRWVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 18:21:46 -0400
Date: Mon, 18 Mar 2013 15:21:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: <linux-kernel@vger.kernel.org>, <sameo@linux.intel.com>,
        <p_gortmaker@yahoo.com>, <dchen@diasemi.com>,
        <rtc-linux@googlegroups.com>, Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [Patch v1] rtc: fix for the DA9052 rtc device registration
Message-Id: <20130318152145.3a458537db6c4799311a2143@linux-foundation.org>
In-Reply-To: <1363336179.30613.18.camel@dhruva>
References: <1363336179.30613.18.camel@dhruva>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013 13:59:39 +0530 Ashish Jangam <ashish.jangam@kpitcummins.com> wrote:

> DA9052/53 MFD core handles only virtual irq therefore rtc driver needs
> to be updated to work on virtual irq. Without this update DA9052/53 rtc 
> driver will fail during its registration.
> Also getting irq by it name is no longer supported in DA9052/53 core.
> 
> ...
>
> --- a/drivers/rtc/rtc-da9052.c
> +++ b/drivers/rtc/rtc-da9052.c
> @@ -239,10 +239,10 @@ static int da9052_rtc_probe(struct platform_device *pdev)
>  
>  	rtc->da9052 = dev_get_drvdata(pdev->dev.parent);
>  	platform_set_drvdata(pdev, rtc);
> -	rtc->irq = platform_get_irq_byname(pdev, "ALM");
> -	ret = request_threaded_irq(rtc->irq, NULL, da9052_rtc_irq,
> -				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
> -				   "ALM", rtc);
> +	rtc->irq =  DA9052_IRQ_ALARM;
> +
> +	ret = da9052_request_irq(rtc->da9052, rtc->irq, "ALM",
> +				da9052_rtc_irq, rtc);
>  	if (ret != 0) {
>  		rtc_err(rtc->da9052, "irq registration failed: %d\n", ret);
>  		return ret;

drivers/rtc/rtc-da9052.c was converted to use
devm_request_threaded_irq() after linux-3.8, so I cannot apply this
patch to mainline.  Can you please prepare a patch against 3.9-rc3?

Do you believe that the patch should be backported into -stable
kernels?  If so, Greg will need a different version of it - ie, the one
you have just sent.  Please send that to him at the appropriate time
(say, when you see me drop the 3.9-rc3 version from the -mm tree).




