Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162725Ab3DEUMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:12:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59012 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162705Ab3DEUMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:12:05 -0400
X-IronPort-AV: E=Sophos;i="4.87,416,1363158000"; 
   d="scan'208";a="36109523"
Message-ID: <515F3015.6010107@codeaurora.org>
Date: Fri, 05 Apr 2013 13:12:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH] ARM: arch_timer: Silence debug preempt warnings
References: <1364934672-31554-1-git-send-email-sboyd@codeaurora.org> <515E5CFC.4090900@codeaurora.org> <515EA195.4010307@arm.com>
In-Reply-To: <515EA195.4010307@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/13 03:04, Marc Zyngier wrote:
>
>>>  drivers/clocksource/arm_arch_timer.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
>>> index d7ad425..5928c29 100644
>>> --- a/drivers/clocksource/arm_arch_timer.c
>>> +++ b/drivers/clocksource/arm_arch_timer.c
>>> @@ -248,7 +248,7 @@ static void __cpuinit arch_timer_stop(struct clock_event_device *clk)
>>>  static int __cpuinit arch_timer_cpu_notify(struct notifier_block *self,
>>>  					   unsigned long action, void *hcpu)
>>>  {
>>> -	struct clock_event_device *evt = this_cpu_ptr(arch_timer_evt);
>>> +	struct clock_event_device *evt = __this_cpu_ptr(arch_timer_evt);
>>>  
>>>  	switch (action & ~CPU_TASKS_FROZEN) {
>>>  	case CPU_STARTING:
> I'm afraid this would hide bugs if we start using the notifier for other
> purposes than exclusivity non-preemptible contexts.
>
> How about moving the this_cpu_ptr() down to the cases themselves, maybe
> with a nice comment?

Ok. v2 coming up.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

