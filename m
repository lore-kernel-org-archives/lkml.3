Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab3DQTmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:42:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:10893 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430Ab3DQTmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,495,1363158000"; 
   d="scan'208";a="296528424"
Message-ID: <516EFB0F.3000603@linux.intel.com>
Date: Wed, 17 Apr 2013 12:42:07 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: zhang.yi20@zte.com.cn
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] futex: bugfix for robust futex deadlock when waking only
 one thread in handle_futex_death
References: <OFD68395F8.51EA74C8-ON48257B50.00324CEE-48257B50.003AB601@zte.com.cn>
In-Reply-To: <OFD68395F8.51EA74C8-ON48257B50.00324CEE-48257B50.003AB601@zte.com.cn>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/17/2013 03:40 AM, zhang.yi20@zte.com.cn wrote:
> Darren Hart <dvhart@linux.intel.com> wrote on 2013/04/17 01:05:28:
> 
> 
>>
>> Performance isn't an issue here as this is an error path. The question
>> is if the
>> changed behavior will constitute a problem for existing applications. 
> Rather
>> than a serialized cascading wake, we have them all wake at once. If an
>> application depended on the first waker after owner death to do some 
> cleanup
>> before the rest came along, I could imagine some potential for failure
>> there.
>>
> 
> I don't find out there are any APIs can wake all waiters at once, so still 
> use futex_wake.
> When waiter return form futex_wait syscall, glibc check the futex's value 
> and try to modify it by using atomic instructions, and let the waiter 
> return only if successed.
> The applications which not use the glibc's library should follow this.

Indeed they *should*. :-)

> 
>> One possible alternative would be to wake waiters for a different
>> process group
>> when OWNER_DEAD is set, and leave it as a single wake.
>>
> 
> To wake one waiter of other process cannot slove this problem , because it 
> can be exiting too.

If I understood the point of your change, it was to ensure all tasks
would be woken because tasks that were exiting wouldn't propogate the
wake. If there are nothing but exiting tasks available.... does it even
matter?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
