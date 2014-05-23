Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180AbaEWKLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:11:04 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:42387 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaEWKLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:11:01 -0400
Date: Fri, 23 May 2014 11:10:56 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: db8500-prcmu: remove check for
 CONFIG_DBX500_PRCMU_DEBUG
Message-ID: <20140523101056.GR19747@lee--X1>
References: <1400792131.16407.33.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400792131.16407.33.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A check for CONFIG_DBX500_PRCMU_DEBUG was added in v3.6. But there's no
> Kconfig symbol DBX500_PRCMU_DEBUG. So remove this check.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. Note that db8500_prcmu_debug_dump() is nowhere to be found in
> the tree.
> 
> This check has been in the tree for less than two years. Am I being
> impatient here?
> 
>  drivers/mfd/db8500-prcmu.c | 3 ---
>  1 file changed, 3 deletions(-)

Applied, thanks.

> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 7694e0700d34..c248bde367ab 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -2303,9 +2303,6 @@ int prcmu_ac_wake_req(void)
>  
>  	if (!wait_for_completion_timeout(&mb0_transfer.ac_wake_work,
>  			msecs_to_jiffies(5000))) {
> -#if defined(CONFIG_DBX500_PRCMU_DEBUG)
> -		db8500_prcmu_debug_dump(__func__, true, true);
> -#endif
>  		pr_crit("prcmu: %s timed out (5 s) waiting for a reply.\n",
>  			__func__);
>  		ret = -EFAULT;

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
