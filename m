Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbaE1QNx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:13:53 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:38639 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbaE1QNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:13:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140528120817.71921d6a@gandalf.local.home>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CAFLxGvyV2Upn7+uTtScu2_LGazy9L+HU9DWEC==0qyZphCrauA@mail.gmail.com>
	<20140528120817.71921d6a@gandalf.local.home>
Date: Wed, 28 May 2014 09:13:51 -0700
X-Google-Sender-Auth: g6RnrlV1SgDUNDrJM9SMq439dnA
Message-ID: <CA+55aFwK5PnWonJZUA0O0dZp=k6RL7gRE5rjSTpxwcbS8ydkyQ@mail.gmail.com>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Minchan Kim <minchan@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 9:08 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> What performance impact are you looking for? Now if the system is short
> on memory, it would probably cause issues in creating tasks.

It doesn't necessarily need to be short on memory, it could just be
fragmented. But a page order of 2 should still be ok'ish.

That said, this is definitely not a rc7 issue. I'd *much* rather
disable swap from direct reclaim, although that kind of patch too
would be a "can Minchan test it, we can put it in the next merge
window and then backport it if we don't have issues".

I see that Johannes already did a patch for that (and this really
_has_ come up before), although I'd skip the WARN_ON_ONCE() part
except for perhaps Minchan testing it.

               Linus
