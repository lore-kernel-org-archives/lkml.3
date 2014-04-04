Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaDDLlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:41:47 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:57551 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaDDLlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:41:44 -0400
Message-ID: <533E9A75.4050102@linaro.org>
Date: Fri, 04 Apr 2014 12:41:41 +0100
From: Julien Grall <julien.grall@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20131104 Icedove/17.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>,
        Xen <xen-devel@lists.xenproject.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ian Campbell <ian.campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH] Xen: do hv callback accounting only on x86
References: <5057041.71iuvlcH4G@wuerfel> <12121341.4lKFpaRMcO@wuerfel>
In-Reply-To: <12121341.4lKFpaRMcO@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Adding Ian and Stefano).

On 03/25/2014 04:00 PM, Arnd Bergmann wrote:
> On Tuesday 25 March 2014 16:52:25 Arnd Bergmann wrote:
>> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
>> index 5dd2ddf..8b91c256 100644
>> --- a/drivers/xen/events/events_base.c
>> +++ b/drivers/xen/events/events_base.c
>> @@ -1235,6 +1235,7 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>>  #ifdef CONFIG_X86
>>         exit_idle();
>>  #endif
>> +       inc_irq_stat(irq_hv_callback_count);
>>
>>         __xen_evtchn_do_upcall();
>>
>> diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_base.c
>> index d5a3de8..dfa12a4 100644
>> --- a/drivers/xen/events/events_base.c
>> +++ b/drivers/xen/events/events_base.c
>> @@ -1248,8 +1248,8 @@ void xen_evtchn_do_upcall(struct pt_regs *regs)
>>         irq_enter();
>>  #ifdef CONFIG_X86
>>         exit_idle();
>> -#endif
>>         inc_irq_stat(irq_hv_callback_count);
>> +#endif
>>  
>>         __xen_evtchn_do_upcall();
> 
> That was unintended: the first half of this email is actually the patch
> that introduced the bug, while the second half is my workaround.
> The way it's formatted, you won't be able to apply it without removing
> the first half again. I'll wait if the approach is ok first and then
> resend it properly if needed.

Linus has merged xen/tip yesterday and building ARM with CONFIG_XEN=y is
now broken.

Is there any plan to push this patch (without the first half of course
:)) or reverting the following commit:
commit 99c8b79d3c165f8e2a6247c14bfa1429e7efe51f
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sun Feb 23 21:40:21 2014 +0000

    xen: Add proper irq accounting for HYPERCALL vector

Sincerely yours,

-- 
Julien Grall
