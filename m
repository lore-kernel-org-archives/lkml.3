Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933772AbaE3QGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 12:06:09 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:50832 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaE3QGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 12:06:04 -0400
MIME-Version: 1.0
In-Reply-To: <5388A935.9050506@zytor.com>
References: <20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard>
	<CA+55aFzdq2V-Q3WUV7hQJG8jBSAvBqdYLVTNtbD4ObVZ5yDRmw@mail.gmail.com>
	<20140529072633.GH6677@dastard>
	<CA+55aFx+j4104ZFmA-YnDtyfmV4FuejwmGnD5shfY0WX4fN+Kg@mail.gmail.com>
	<20140529235308.GA14410@dastard>
	<20140530000649.GA3477@redhat.com>
	<20140530002113.GC14410@dastard>
	<20140530003219.GN10092@bbox>
	<20140530013414.GF14410@dastard>
	<5388A2D9.3080708@zytor.com>
	<CA+55aFycqAw2AqQGv8aTPs_RxyKZqMdoyeSxWRSDk2N-PiBZeg@mail.gmail.com>
	<5388A935.9050506@zytor.com>
Date: Fri, 30 May 2014 09:06:03 -0700
X-Google-Sender-Auth: qmK36jLgyaTh5ND5BosZdOvUBtQ
Message-ID: <CA+55aFwHS2xErW6TgBHGR9JP0QZW9W7GSLec5WzbV+GGYFUu6A@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Chinner <david@fromorbit.com>, Minchan Kim <minchan@kernel.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 30, 2014 at 8:52 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> That said, it's still likely a non-production option due to the page
>> table games we'd have to play at fork/clone time.
>
> Still, seems much more tractable.

We might be able to make it more attractive by having a small
front-end cache of the 16kB allocations with the second page unmapped.
That would at least capture the common "lots of short-lived processes"
case without having to do kernel page table work.

               Linus
