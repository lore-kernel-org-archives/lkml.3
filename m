Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbaE2LJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 07:09:11 -0400
Received: from ozlabs.org ([103.22.144.67]:33565 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756341AbaE2LJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 07:09:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Minchan Kim <minchan@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: virtio ring cleanups, which save stack on older gcc
In-Reply-To: <20140529074117.GI10092@bbox>
References: <87oayh6s3s.fsf@rustcorp.com.au> <1401348405-18614-1-git-send-email-rusty@rustcorp.com.au> <20140529074117.GI10092@bbox>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 29 May 2014 20:38:33 +0930
Message-ID: <87fvjs7sge.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minchan Kim <minchan@kernel.org> writes:
> Hello Rusty,
>
> On Thu, May 29, 2014 at 04:56:41PM +0930, Rusty Russell wrote:
>> They don't make much difference: the easier fix is use gcc 4.8
>> which drops stack required across virtio block's virtio_queue_rq
>> down to that kmalloc in virtio_ring from 528 to 392 bytes.
>> 
>> Still, these (*lightly tested*) patches reduce to 432 bytes,
>> even for gcc 4.6.4.  Posted here FYI.
>
> I am testing with below which was hack for Dave's idea so don't have
> a machine to test your patches until tomorrow.
> So, I will queue your patches into testing machine tomorrow morning.

More interesting would be updating your compiler to 4.8, I think.
Saving <100 bytes on virtio is not going to save you, right?

Cheers,
Rusty.
