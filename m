Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaEEUP6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:15:58 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35133 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaEEUP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:15:57 -0400
Message-ID: <5367F17A.3070408@linaro.org>
Date: Mon, 05 May 2014 13:15:54 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/4] Convert timekeeping core to use printk_deferred (v2)
References: <1399068558-2373-1-git-send-email-john.stultz@linaro.org> <20140502160536.892e6aff76df3398529d09ad@linux-foundation.org>
In-Reply-To: <20140502160536.892e6aff76df3398529d09ad@linux-foundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 04:05 PM, Andrew Morton wrote:
> On Fri,  2 May 2014 15:09:14 -0700 John Stultz <john.stultz@linaro.org> wrote:
>
>> Recently, Jiri pointed out a potential deadlock when calling printk
>> while holding the timekeeping seqlock.
>>
>> Annoyingly, the seqlock lockdep enablement doesn't catch this, as
>> printk disables lockdep.
>>
>> When looking for possible solutions, one idea was to use a local buffer
>> and defer the printk to later. Ends up there is already similar
>> functionality in printk_sched() to avoid similar style deadlocks w/
>> the scheduler.
>>
>> Thus this patchset (based on next/akpm) renames printk_sched to
>> printk_deferred and then moves the affected timekeeping printks to make
>> use of it.
>>
>> There were some points in the discussion between Jan and Peter that
>> made it seem that there may still be problems lurking in the console
>> layer, and I'm not sure I fully understand their point, so this solution
>> may be incomplete.
>>
>> Additionally, the same issue likely affects any WARN_ONs as well, but
>> I wanted to get some thoughts on this approach before trying to remove
>> or convert affected WARN_ONS.
>>
>> Your thoughts and feedback are greatly appreciated!
> All look pretty simple and sane to me.  printk is a crazy hotspot
> lately but this patchset looks like it won't get singed.
>
> Would "printk_deferred_once" be more logical than
> "printk_once_deferred"?  Think so.  It's (((printk(deferred(once))),
> not (((printk(once(deferred))).

Sounds good.  Will update the set with this.

thanks!
-john

