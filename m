Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3CHUR6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:17:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12088 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab3CHUR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:17:57 -0500
X-IronPort-AV: E=Sophos;i="4.84,809,1355126400"; 
   d="scan'208";a="28006230"
Message-ID: <513A4774.3040605@codeaurora.org>
Date: Fri, 08 Mar 2013 12:17:56 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org> <1362614646-24113-4-git-send-email-sboyd@codeaurora.org> <20130308004011.GD11806@atomide.com> <51393B59.3070200@codeaurora.org> <20130308180730.GE11806@atomide.com> <513A2B20.30805@codeaurora.org> <20130308194802.GG11806@atomide.com> <513A40EF.8050403@codeaurora.org> <20130308200811.GJ11806@atomide.com>
In-Reply-To: <20130308200811.GJ11806@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/13 12:08, Tony Lindgren wrote:
> * Stephen Boyd <sboyd@codeaurora.org> [130308 11:54]:
>> On 03/08/13 11:48, Tony Lindgren wrote:
>>> * Stephen Boyd <sboyd@codeaurora.org> [130308 10:21]:
>>>> diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
>>>> index 081de6f..4ea3e9d 100644
>>>> --- a/arch/arm/kernel/smp_twd.c
>>>> +++ b/arch/arm/kernel/smp_twd.c
>>>> @@ -227,7 +227,7 @@ static void __cpuinit twd_calibrate_rate(void)
>>>>  
>>>>  static irqreturn_t twd_handler(int irq, void *dev_id)
>>>>  {
>>>> -       struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
>>>> +       struct clock_event_device *evt = dev_id;
>>>>  
>>>>         if (twd_timer_ack()) {
>>>>                 evt->event_handler(evt);
>>>>
>>> Yup thanks that fixes it, both fixes are needed. So for this patch + the
>>> two fixes please feel free to add:
>>>
>>> Acked-by: Tony Lindgren <tony@atomide.com>
>> Great. Thanks for testing.
> Hmm noticed one more thing: vexpress no longer boots in qemu for
> me after applying this. Sorry did not get any debug_ll output, but
> maybe you can take a look at it. I tested with omap2plus_defconfig +
> linaro-qemu:
>
> $ qemu-system-arm -machine vexpress-a9 -m 1024 -curses -net nic -net \
> user -serial stdio -append console=ttyAMA0,115200n8 rw \
> root=/dev/mmcblk0p2 rootwait physmap.enabled=0 -kernel zImage \
> -initrd initrd.img -sd rootfs.img
>
>

I wonder if you're hitting something similar to this issue on versatile
boards [1]. Can you try that patch? Otherwise I will try to get qemu
running (something I've never done, do you have instructions?).

[1] http://article.gmane.org/gmane.linux.ports.arm.kernel/221539

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

