Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbaE3BYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:24:06 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:40202 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbaE3BYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:24:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140530005042.GO10092@bbox>
References: <1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard>
	<20140529015830.GG6677@dastard>
	<20140529233638.GJ10092@bbox>
	<CA+55aFyvn_fTnWEmTCSGgfM18c21-YDU_s=FJP=grDDLQe+aDA@mail.gmail.com>
	<20140530002021.GM10092@bbox>
	<CA+55aFxjXf5xLKGFBjUWimn8-=rj0=g3pku9O1MvGSoDUcEQAw@mail.gmail.com>
	<20140530005042.GO10092@bbox>
Date: Thu, 29 May 2014 18:24:02 -0700
X-Google-Sender-Auth: qElKUHqRBPmwMpqbTuh9PvFralE
Message-ID: <CA+55aFz84toJOqnuphA99c0av1nLzxcxfjiTwhBbxzaNs3J6NQ@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 5:50 PM, Minchan Kim <minchan@kernel.org> wrote:
>>
>> You could also try Dave's patch, and _not_ do my mm/vmscan.c part.
>
> Sure. While I write this, Rusty's test was crached so I will try Dave's patch,
> them yours except vmscan.c part.

Looking more at Dave's patch (well, description), I don't think there
is any way in hell we can ever apply it. If I read it right, it will
cause all IO that overflows the max request count to go through the
scheduler to get it flushed. Maybe I misread it, but that's definitely
not acceptable. Maybe it's not noticeable with a slow rotational
device, but modern ssd hardware? No way.

I'd *much* rather slow down the swap side. Not "real IO". So I think
my mm/vmscan.c patch is preferable (but yes, it might require some
work to make kswapd do better).

So you can try Dave's patch just to see what it does for stack depth,
but other than that it looks unacceptable unless I misread things.

             Linus
