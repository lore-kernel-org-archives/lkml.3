Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933541AbaE3PzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:55:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44982 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbaE3PzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:55:13 -0400
Message-ID: <5388A935.9050506@zytor.com>
Date: Fri, 30 May 2014 08:52:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>,
        Dave Jones <davej@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        PJ Waskiewicz <pjwaskiewicz@gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <20140528223142.GO8554@dastard>	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>	<20140529013007.GF6677@dastard>	<CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>	<20140529072633.GH6677@dastard>	<CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com>	<20140529235308.GA14410@dastard>	<20140530000649.GA3477@redhat.com>	<20140530002113.GC14410@dastard>	<20140530003219.GN10092@bbox>	<20140530013414.GF14410@dastard>	<5388A2D9.3080708@zytor.com> <CA+55aFycqAw2AqQGv8aTPs_RxyKZqMdoyeSxWRSDk2N-PiBZeg@mail.gmail.com>
In-Reply-To: <CA+55aFycqAw2AqQGv8aTPs_RxyKZqMdoyeSxWRSDk2N-PiBZeg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 08:41 AM, Linus Torvalds wrote:
> On Fri, May 30, 2014 at 8:25 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> If we removed struct thread_info from the stack allocation then one
>> could do a guard page below the stack.  Of course, we'd have to use IST
>> for #PF in that case, which makes it a non-production option.
> 
> We could just have the guard page in between the stack and the
> thread_info, take a double fault, and then just map it back in on
> double fault.
> 

Oh, duh.  Right, much better.  Similar to the espfix64 hack, too.

> That would give us 8kB of "normal" stack, with a very loud fault - and
> then an extra 7kB or so of stack (whatever the size of thread-info is)
> - after the first time it traps.
> 
> That said, it's still likely a non-production option due to the page
> table games we'd have to play at fork/clone time.

Still, seems much more tractable.

I would still like struct thread_info off the stack allocation for other
reasons (as we have discussed in the past.)

	-hpa

