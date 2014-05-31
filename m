Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982AbaEaBp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 21:45:29 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:45117 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaEaBp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 21:45:28 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzzHS9YSzZpxMoF1vwoBh+NxLE26Tr2OC38=PsB8Mjwig@mail.gmail.com>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	<20140528223142.GO8554@dastard>
	<CA+55aFyRk6_v6COPGVvu6hvt=i2A8-dPcs1X3Ydn1g24AxbPkg@mail.gmail.com>
	<20140529013007.GF6677@dastard>
	<20140529015830.GG6677@dastard>
	<20140529233638.GJ10092@bbox>
	<20140530001558.GB14410@dastard>
	<20140530021247.GR10092@bbox>
	<CA+55aFzzHS9YSzZpxMoF1vwoBh+NxLE26Tr2OC38=PsB8Mjwig@mail.gmail.com>
Date: Fri, 30 May 2014 18:45:27 -0700
X-Google-Sender-Auth: LukxMtmqBKV99yfTdf1-UapMljM
Message-ID: <CA+55aFxqJXZfGaspc0bNPQa_7x5kmGuHrQG8dRzta4YpLYqiBQ@mail.gmail.com>
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

On Thu, May 29, 2014 at 9:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It really might be very good to create a "struct alloc_info" that
> contains those shared arguments, and just pass a (const) pointer to
> that around. [ .. ]
>
> Ugh. I think I'll try looking at that tomorrow.

I did look at it, but the thing is horrible. I started on this
something like ten times, and always ended up running away screaming.
Some things are truly fixed (notably "order"), but most things end up
changing subtly halfway through the callchain.

I might look at it some more later, but people may have noticed that I
decided to just apply Minchan's original patch in the meantime. I'll
make an rc8 this weekend..

        Linus
