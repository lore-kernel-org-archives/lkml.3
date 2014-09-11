Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaIKIBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:01:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39768 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaIKIBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:01:20 -0400
Message-ID: <541156C9.1080203@codeaurora.org>
Date: Thu, 11 Sep 2014 13:31:13 +0530
From: Chintan Pandya <cpandya@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/2] ksm: provide support to use deferrable timers
 for scanner thread
References: <1408536628-29379-1-git-send-email-cpandya@codeaurora.org> <1408536628-29379-2-git-send-email-cpandya@codeaurora.org> <alpine.LSU.2.11.1408272258050.10518@eggly.anvils> <20140903095815.GK4783@worktop.ger.corp.intel.com> <alpine.LSU.2.11.1409080023100.1610@eggly.anvils> <20140908093949.GZ6758@twins.programming.kicks-ass.net> <alpine.LSU.2.11.1409091225310.8432@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1409091225310.8432@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't mean to divert the thread too much. But just one suggestion 
offered by Harshad.

Why can't we stop invoking more of a KSM scanner thread when we are 
saturating from savings ? But again, to check whether savings are 
saturated or not, we may still want to rely upon timers and we have to 
wake the CPUs up from IDLE state.

>> here. Can't we create a new (timer) infrastructure that does the right
>> thing? Surely this isn't the only such case.
>
> A sleep-walking timer, that goes to sleep in one bed, but may wake in
> another; and defers while beds are empty?  I'd be happy to try using
> that for KSM if it already existed, and no doubt Chintan would too

This is interesting for sure :)

>
> But I don't think KSM presents a very good case for developing it.
> I think KSM's use of a sleep_millisecs timer is really just an apology
> for the amount of often wasted work that it does, and dates from before
> we niced it down 5.  I prefer the idea of a KSM which waits on activity
> amongst the restricted set of tasks it is tracking: as this patch tries.
>
> But my preference may be naive: doing lots of unnecessary work doesn't
> matter as much as waking cpus from deep sleep.

This is exactly the preference we are looking for. But yes, cannot be 
generalized for all.

>
>>
>> I know both RCU and some NOHZ_FULL muck already track when the system is
>> completely idle. This is yet another case of that.
>
> Hugh


-- 
Chintan Pandya

QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a
member of the Code Aurora Forum, hosted by The Linux Foundation
