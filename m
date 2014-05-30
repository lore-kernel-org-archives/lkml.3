Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933599AbaE3P2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:28:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44391 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501AbaE3P2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:28:37 -0400
Message-ID: <5388A2D9.3080708@zytor.com>
Date: Fri, 30 May 2014 08:25:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <20140528223142.GO8554@dastard> <CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com> <20140529013007.GF6677@dastard> <CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com> <20140529072633.GH6677@dastard> <CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com> <20140529235308.GA14410@dastard> <20140530000649.GA3477@redhat.com> <20140530002113.GC14410@dastard> <20140530003219.GN10092@bbox> <20140530013414.GF14410@dastard>
In-Reply-To: <20140530013414.GF14410@dastard>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 06:34 PM, Dave Chinner wrote:
>> ...
>> "kworker/u24:1 (94) used greatest stack depth: 8K bytes left, it means
>> there is some horrible stack hogger in your kernel. Please report it
>> the LKML and enable stacktrace to investigate who is culprit"
> 
> That, however, presumes that a user can reproduce the problem on
> demand. Experience tells me that this is the exception rather than
> the norm for production systems, and so capturing the stack in real
> time is IMO the only useful thing we could add...
> 

If we removed struct thread_info from the stack allocation then one
could do a guard page below the stack.  Of course, we'd have to use IST
for #PF in that case, which makes it a non-production option.

	-hpa


