Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759958Ab3CHBOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:14:06 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14517 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab3CHBOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:14:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,806,1355126400"; 
   d="scan'208";a="27895420"
Message-ID: <51393B59.3070200@codeaurora.org>
Date: Thu, 07 Mar 2013 17:14:01 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org> <1362614646-24113-4-git-send-email-sboyd@codeaurora.org> <20130308004011.GD11806@atomide.com>
In-Reply-To: <20130308004011.GD11806@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/13 16:40, Tony Lindgren wrote:
> Hi,
>
> * Stephen Boyd <sboyd@codeaurora.org> [130306 17:53]:
>> Separate the smp_twd timers from the local timer API. This will
>> allow us to remove ARM local timer support in the near future and
>> gets us closer to moving this driver to drivers/clocksource.
> Looks like applying this patch makes omap4 to stop booting for
> some reason.
>
>

Hm... Perhaps you need the clock?

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 2439843..081de6f 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -345,11 +345,11 @@ static int __init twd_local_timer_common_register(struct device_node *np)
        if (err)
                goto out_irq;
 
+       twd_get_clock(np);
+
        /* Immediately configure the timer on the boot CPU */
        twd_timer_setup(this_cpu_ptr(twd_evt));
 
-       twd_get_clock(np);
-
        return 0;
 
 out_irq:

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

