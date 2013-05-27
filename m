Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab3E0Ohu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:37:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab3E0Ohs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:37:48 -0400
Message-ID: <51A36FB3.9050607@redhat.com>
Date: Mon, 27 May 2013 10:37:39 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        x86@kernel.org
Subject: Re: [PATCH] x86, clocksource, fix !CONFIG_CLOCKSOURCE_WATCHDOG compile
References: <1361563736-28241-1-git-send-email-prarit@redhat.com> <alpine.LFD.2.02.1305271200220.4220@ionos>
In-Reply-To: <alpine.LFD.2.02.1305271200220.4220@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/27/2013 06:00 AM, Thomas Gleixner wrote:
> On Fri, 22 Feb 2013, Prarit Bhargava wrote:
> 
>> If I explicitly disable the clocksource watchdog in the x86 Kconfig,
> 
> And why do you want to do that?

Hey Thomas, I was debugging something and stumbled across this.

IIRC the issue was that there some weirdness on a series of new AMD systems and
unfortunately the watchdog would fire and switch clocksources on me :(  That
resulted in me not being able to debug the HW because the clocksource I wanted
was no longer available.

P.

> 
>> the x86 kernel will not compile unless this is properly defined.
>>
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
>>  
>>  #endif /* CONFIG_CLOCKSOURCE_WATCHDOG */
>>  
>> -- 
>> 1.7.9.3
>>
>>
