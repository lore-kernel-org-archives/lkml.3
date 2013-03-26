Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3CZRd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:33:57 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:38367 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3CZRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:33:56 -0400
X-IronPort-AV: E=Sophos;i="4.84,913,1355126400"; 
   d="scan'208";a="32623241"
Message-ID: <5151DC03.6070108@codeaurora.org>
Date: Tue, 26 Mar 2013 10:33:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: gic: fix irq_trigger return
References: <1363734349-32635-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1363734349-32635-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/13 16:05, Stephen Boyd wrote:
> From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
>
> The genirq layer expects a 0 in case of failure but the code is
> returning -ENXIO. Fix it.
>
> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/irqchip/irq-gic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 644d724..2ebf28a 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -236,7 +236,8 @@ static int gic_retrigger(struct irq_data *d)
>  	if (gic_arch_extn.irq_retrigger)
>  		return gic_arch_extn.irq_retrigger(d);
>  
> -	return -ENXIO;
> +	/* the genirq layer expects 0 for a failure */
> +	return 0;
>  }
>  
>  #ifdef CONFIG_SMP

Ping.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

