Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3JMKOB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 06:14:01 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:53006 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3JMKNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 06:13:53 -0400
Message-ID: <525A725E.5070308@linaro.org>
Date: Sun, 13 Oct 2013 12:13:50 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        nicolas.ferre@atmel.com, tglx@linutronix.de
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clocksource: at91/tc: remove deprecated IRQF_DISABLED
References: <1381639559-6981-1-git-send-email-michael.opdenacker@free-electrons.com> <525A679A.2060408@overkiz.com>
In-Reply-To: <525A679A.2060408@overkiz.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2013 11:27 AM, boris brezillon wrote:
> Hello Micheal,
>
> This flag has been removed in a recent submission (see
> https://lkml.org/lkml/2013/10/2/202), and, if I'm correct, is on his way
> for mainlining.

Yes, it has been merged in the tip tree:

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=timers/core&id=f51380a75652a4600b34ce384c4ff89ce0a15132

> On 13/10/2013 06:45, Michael Opdenacker wrote:
>> This patch proposes to remove the use of the IRQF_DISABLED flag
>>
>> It's a NOOP since 2.6.35 and it will be removed one day.
>>
>> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
>> ---
>>   drivers/clocksource/tcb_clksrc.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clocksource/tcb_clksrc.c
>> b/drivers/clocksource/tcb_clksrc.c
>> index 8a61872..2efeb3b 100644
>> --- a/drivers/clocksource/tcb_clksrc.c
>> +++ b/drivers/clocksource/tcb_clksrc.c
>> @@ -180,7 +180,7 @@ static irqreturn_t ch2_irq(int irq, void *handle)
>>
>>   static struct irqaction tc_irqaction = {
>>       .name        = "tc_clkevt",
>> -    .flags        = IRQF_TIMER | IRQF_DISABLED,
>> +    .flags        = IRQF_TIMER,
>>       .handler    = ch2_irq,
>>   };
>>
>>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

