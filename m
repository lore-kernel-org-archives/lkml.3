Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096Ab3IYPUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:20:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:40207 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752Ab3IYPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:20:47 -0400
Message-ID: <5242FF4B.6050901@linaro.org>
Date: Wed, 25 Sep 2013 17:20:43 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Preeti Murthy <preeti.lkml@gmail.com>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/4] arm: zynq: Enable global timer
References: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1379530118-22813-1-git-send-email-soren.brinkmann@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2013 08:48 PM, Soren Brinkmann wrote:
> Hi all,
> 
> here's a v2. I reused the subject from my v1 submission although the focus of
> this series moved a bit towards the timer subsystem.
> I replaced Stephen's fix to prevent per cpu devices from becoming
> the broadcast device with Thomas' proposal, but I kept the original commit
> message. I split the whole approach in small chunks that I found reasonable.
> 
> In 4/4, I picked up Grant's comment regarding the DT node name.
> 
> v2:
>  - drop 1/2 of the original series
>  - implement preventing per cpu devices from becoming broadcast device according
>    to Thomas' proposal
>    - introduce new CLOCK_EVT_FEAT_PERCPU flag
>    - set the flag for the arm_global_timer
>    - filter per cpu devices based on this flag when choosing the broadcast
>      device
>  - rename DT node to avoid '_'s
>  
> 
> Soren Brinkmann (4):
>   clockchips: Add FEAT_PERCPU clockevent flag
>   clocksource/arm_global_timer: Set FEAT_PERCPU flag
>   tick: broadcast: Deny per-cpu clockevents from being broadcast sources
>   arm: zynq: Enable arm_global_timer
> 
>  arch/arm/boot/dts/zynq-7000.dtsi       | 8 ++++++++
>  arch/arm/mach-zynq/Kconfig             | 1 +
>  drivers/clocksource/arm_global_timer.c | 3 ++-
>  include/linux/clockchips.h             | 1 +
>  kernel/time/tick-broadcast.c           | 1 +
>  5 files changed, 13 insertions(+), 1 deletion(-)

This patches falls under different maintainer's umbrella.

I acked-by the patches, so if someone is willing to take the patches I
am ok with that. I am ok also to pick them into my tree with the
acked-by maintainer. Just let me know ...

Thanks
  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

