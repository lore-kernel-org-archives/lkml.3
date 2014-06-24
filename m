Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaFXOWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 10:22:25 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:34069 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbaFXOWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 10:22:23 -0400
Message-ID: <53A9899C.9040005@akamai.com>
Date: Tue, 24 Jun 2014 09:22:20 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Baron, Jason" <jbaron@akamai.com>
Subject: Re: [PATCH] panic: add TAINT_SOFTLOCKUP
References: <1401847955-3345-1-git-send-email-johunt@akamai.com>	<20140623151121.44f17779004e94ab620b837c@linux-foundation.org>	<53A8ADEC.6070406@akamai.com> <20140623155118.e2446a6110a9889454db2386@linux-foundation.org>
In-Reply-To: <20140623155118.e2446a6110a9889454db2386@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 05:51 PM, Andrew Morton wrote:
> On Mon, 23 Jun 2014 17:45:00 -0500 Josh Hunt <johunt@akamai.com> wrote:
>
>> On 06/23/2014 05:11 PM, Andrew Morton wrote:
>>> On Tue,  3 Jun 2014 22:12:35 -0400 Josh Hunt <johunt@akamai.com> wrote:
>>>
>>>> This taint flag will be set if the system has ever entered a softlockup
>>>> state. Similar to TAINT_WARN it is useful to know whether or not the system
>>>> has been in a softlockup state when debugging.
>>>>
>>>> ...
>>>>
>>>> @@ -329,6 +329,7 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
>>>>
>>>>    		if (softlockup_panic)
>>>>    			panic("softlockup: hung tasks");
>>>> +		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
>>>>    		__this_cpu_write(soft_watchdog_warn, true);
>>>>    	} else
>>>>    		__this_cpu_write(soft_watchdog_warn, false);
>>>
>>> Would make more sense to have applied the taint *before* calling
>>> panic()?
>>
>> Andrew
>>
>> Yep, that's a good call. Thanks. Do you want me to send a v2 or did you
>> take care of it?
>
> I fixed it up.
>
>> In addition to adding the softlockup taint flag, do you think it'd be
>> reasonable to add another flag for page allocation failures? I think
>> it'd be nice to be able to account for these conditions somehow without
>> having to parse dmesg, etc. As with the softlockup flag, it's helpful to
>> know if your system had encountered a page allocation failure at some
>> point before the crash or whatever you're debugging.
>
> I don't know, really.  Allocation failures are often an expected thing
> as drivers try to work out how much memory they can allocate.  Those
> things can be screened out by testing __GFP_NOWARN.  GFP_ATOMIC
> failures should probably be ignored, except for when they shouldn't.
> But even then, allocation failures are somewhat common.  And recency is
> a concern: an allocation failure 10 minutes ago is unlikely to be
> relevant.
>
> But that's just me waving hands around.  I'd be interested to hear from
> people whose kernels crash more often than mine, and from those whose
> job is to support them (ie distro people?).
>

Anyone you'd suggest adding to this thread to get other feedback about 
tracking page allocation failures? I could also spin up a patch and cc them.

Thanks
Josh
