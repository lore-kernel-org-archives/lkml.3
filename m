Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759715Ab3BYPBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:01:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754212Ab3BYPBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:01:50 -0500
Message-ID: <512B7CD3.8070904@redhat.com>
Date: Mon, 25 Feb 2013 10:01:39 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG compile
References: <1361563736-28241-1-git-send-email-prarit@redhat.com> <alpine.LFD.2.02.1302222111400.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302222111400.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/22/2013 03:14 PM, Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Prarit Bhargava wrote:
> 
>> If I explicitly disable the clocksource watchdog in the x86 Kconfig,
>> the x86 kernel will not compile unless this is properly defined.
> 
> You shouldn't do that. :)
>  
>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: x86@kernel.org
>> ---
>>  kernel/time/clocksource.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>> index c958338..e04821f 100644
>> --- a/kernel/time/clocksource.c
>> +++ b/kernel/time/clocksource.c
>> @@ -450,6 +450,7 @@ static void clocksource_enqueue_watchdog(struct clocksource *cs)
>>  static inline void clocksource_dequeue_watchdog(struct clocksource *cs) { }
>>  static inline void clocksource_resume_watchdog(void) { }
>>  static inline int clocksource_watchdog_kthread(void *data) { return 0; }
>> +void clocksource_mark_unstable(struct clocksource *cs) { }
> 
> Unless this is defined as
> 
>> +static inline void clocksource_mark_unstable(struct clocksource *cs) { }
> 
> Right?

Thomas,

Actually that needs to be "void clocksource_mark_unstable()" as it is exported
in include/linux/clocksource.h as such.

The other static inline functions above it are only used in clocksource.c.

So I think my patch is correct ...

P.

> 
> 	tglx
