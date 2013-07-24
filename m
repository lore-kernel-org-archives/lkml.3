Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3GXLyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 07:54:22 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:44200 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3GXLyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 07:54:19 -0400
Date: Wed, 24 Jul 2013 12:54:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Kevin Hilman <khilman@linaro.org>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-omap@vger.kernel.org,
        Ruslan Bilovol <ruslan.bilovol@ti.com>, linux-kernel@vger.kernel.org,
        Naga Venkata Srikanth V <vnv.srikanth@samsung.com>,
        Oleg_Kosheliev <oleg.kosheliev@ti.com>
Subject: Re: [PATCH 1/4] mfd: twl6030-irq: migrate to IRQ threaded handler
Message-ID: <20130724115413.GK26801@laptop>
References: <1374595624-15054-1-git-send-email-grygorii.strashko@ti.com>
 <1374595624-15054-2-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374595624-15054-2-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jul 2013, Grygorii Strashko wrote:

> From: Naga Venkata Srikanth V <vnv.srikanth@samsung.com>
> 
> 1) Removed request_irq() and replaced it with request_threaded_irq().
> 
> 2) Removed generic_handle_irq() and replaced it with
> handle_nested_irq().
>   Handling of these interrupts is nested, as we are handling an
> interrupt (for e.g rtc, mmc1) when we are still servicing TWL irq.
> 
> 3) Removed I2C read-retry logic for the case when twl_i2c_read() is
> failed inside IRQ handler - there is no sense to do that, so just report
> an error and return.
> 
> Signed-off-by: Naga Venkata Srikanth V <vnv.srikanth@samsung.com>
> Signed-off-by: Oleg_Kosheliev <oleg.kosheliev@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/mfd/twl6030-irq.c |  146 +++++++++++++++------------------------------
>  1 file changed, 49 insertions(+), 97 deletions(-)
> 
> diff --git a/drivers/mfd/twl6030-irq.c b/drivers/mfd/twl6030-irq.c

<snip>

> +	status = request_threaded_irq(irq_num, NULL, twl6030_irq_thread,
> +				      IRQF_ONESHOT, "TWL6030-PIH", NULL);

Oh, and please use managed resources for this: devm_*

>  	if (status < 0) {
>  		dev_err(dev, "could not claim irq %d: %d\n", irq_num, status);
>  		goto fail_irq;
>  	}
>  

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
