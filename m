Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbaE2PjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 11:39:14 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:57762 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbaE2PjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 11:39:12 -0400
MIME-Version: 1.0
In-Reply-To: <1401348405-18614-2-git-send-email-rusty@rustcorp.com.au>
References: <87oayh6s3s.fsf@rustcorp.com.au>
	<1401348405-18614-1-git-send-email-rusty@rustcorp.com.au>
	<1401348405-18614-2-git-send-email-rusty@rustcorp.com.au>
Date: Thu, 29 May 2014 08:39:11 -0700
X-Google-Sender-Auth: V66GTYEYX6hNkq2q2UbKuw3VIkY
Message-ID: <CA+55aFzybuwti5z=uGXxibLqyDwQpPE88bN4cL5YQwpfb7aMbw@mail.gmail.com>
Subject: Re: [PATCH 1/4] Hack: measure stack taken by vring from virtio_blk
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 12:26 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Results (x86-64, Minchan's .config):
>
> gcc 4.8.2: virtio_blk: stack used = 392
> gcc 4.6.4: virtio_blk: stack used = 528

I wonder if that's just random luck (although 35% more stack use seems
to be bigger than "random" - that's quite a big difference), or
whether the gcc guys are aware of having fixed some major stack spill
issue.

But yeah, Minchan uses gcc 4.6.3 according to one of his emails, so
_part_ of his stack smashing is probably due to compiler version.

                  Linus
