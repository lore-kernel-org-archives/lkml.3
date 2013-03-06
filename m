Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880Ab3CFL5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 06:57:52 -0500
Received: from fallback.hitachi.co.jp ([133.145.228.50]:56545 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab3CFL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 06:57:49 -0500
X-AuditID: 85900ec0-d60ccb900000151e-33-51372eb6cf23
Message-ID: <51372E5A.2070504@hitachi.com>
Date: Wed, 06 Mar 2013 20:54:02 +0900
From: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
User-Agent: unknown
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: snapshot error on non allocated buffer?
References: <1362498608.31874.28.camel@gandalf.local.home>
In-Reply-To: <1362498608.31874.28.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

(03/06/2013 12:50 AM), Steven Rostedt wrote:
> Hi Hiraku,
>
> I'm doing a lot of reconstruction of ftrace's buffering, and I'm also
> modifying a lot of the snapshot feature to work with the new stuff
> that's coming.
>

Many thanks. I'm trying your multi-buffer patches.

> I'm looking at the -EINVAL when you write something other than '0' or
> '1' into the snapshot file when the snapshot is not allocated. I'm
> thinking that it should just return as if it succeeded. I don't
> understand why it should return -EINVAL?
>

I thought that it might be a little strange if the clear operation
succeeded in spite of the non-allocated buffer.
(Actually, I simply implemented as you said, though.)

But I don't have trouble even if it succeeds, so I'll modify the I/F
to make it return successfully.

> Now if you want to know if the snapshot is allocated or not, I have a
> patch that shows how to use the snapshot feature when the snapshot is
> empty, and also give the status of the snapshot itself:
>
> [root] # cat /debug/tracing/snapshot
> # tracer: nop
> #
> #
> # * Snapshot is freed *
> #
> # Snapshot commands:
> # echo 0 > snapshot : Clears and frees snapshot buffer
> # echo 1 > snapshot : Allocates snapshot buffer, if not already
> allocated.
> #                      Takes a snapshot of the main buffer.
> # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
> #                      (Doesn't have to be '2' works with any number
> that
> #                       is not a '0' or '1')
>
> [root] # echo 1 > /debug/tracing/snapshot
> [root] # echo 2 > /debug/tracing/snapshot
> [root] # cat /debug/tracing/snapshot
> # tracer: nop
> #
> #
> # * Snapshot is allocated *
> #
> # Snapshot commands:
> # echo 0 > snapshot : Clears and frees snapshot buffer
> # echo 1 > snapshot : Allocates snapshot buffer, if not already
> allocated.
> #                      Takes a snapshot of the main buffer.
> # echo 2 > snapshot : Clears snapshot buffer (but does not allocate)
> #                      (Doesn't have to be '2' works with any number
> that
> #                       is not a '0' or '1')
>

This seems good for me and also users.

>
> As this is a new feature for 3.9, and we are still in -rc1, I think this
> might be a good thing to add now. As well as not returning -EINVAL on
> writing to the file when the snapshot buffer isn't allocated.
>
> What do you think?
>

I think it's OK.
I'll send a patch to make the file not return -EINVAL. Does it need to
be based on 3.9-rc1 or tip tree?

Thanks,
Hiraku Toyooka

