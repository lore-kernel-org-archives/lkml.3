Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbaE1QLg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:11:36 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776AbaE1QLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:11:34 -0400
Message-ID: <53860AAD.3080107@nod.at>
Date: Wed, 28 May 2014 18:11:25 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Minchan Kim <minchan@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        mst@redhat.com, Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>	<1401260039-18189-2-git-send-email-minchan@kernel.org>	<CAFLxGvyV2Upn7+uTtScu2_LGazy9L+HU9DWEC==0qyZphCrauA@mail.gmail.com> <20140528120817.71921d6a@gandalf.local.home>
In-Reply-To: <20140528120817.71921d6a@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 28.05.2014 18:08, schrieb Steven Rostedt:
> On Wed, 28 May 2014 17:43:50 +0200
> Richard Weinberger <richard.weinberger@gmail.com> wrote:
> 
> 
>>> diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
>>> index 8de6d9cf3b95..678205195ae1 100644
>>> --- a/arch/x86/include/asm/page_64_types.h
>>> +++ b/arch/x86/include/asm/page_64_types.h
>>> @@ -1,7 +1,7 @@
>>>  #ifndef _ASM_X86_PAGE_64_DEFS_H
>>>  #define _ASM_X86_PAGE_64_DEFS_H
>>>
>>> -#define THREAD_SIZE_ORDER      1
>>> +#define THREAD_SIZE_ORDER      2
>>>  #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
>>>  #define CURRENT_MASK (~(THREAD_SIZE - 1))
>>
>> Do you have any numbers of the performance impact of this?
>>
> 
> What performance impact are you looking for? Now if the system is short
> on memory, it would probably cause issues in creating tasks. But other
> than that, I'm not sure what you are looking for.

Allocating more continuous memory for every thread is not cheap.
I'd assume that such a change will cause more pressure on the allocator.

Thanks,
//richard
