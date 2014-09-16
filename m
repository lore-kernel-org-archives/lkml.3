Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbaIPUeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:34:36 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:37229 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840AbaIPUef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:34:35 -0400
MIME-Version: 1.0
In-Reply-To: <x49sijrxt1f.fsf@segfault.boston.devel.redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<x49sijrxt1f.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 16 Sep 2014 16:34:33 -0400
Message-ID: <CANP1eJF_LjNVeD838D-H=005jtGTvGY=h5wPZBHfT6Z9iuKK_g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff,

Which git repository do the man pages live in?

- Milosz

On Tue, Sep 16, 2014 at 3:30 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Milosz Tanski <milosz@adfin.com> writes:
>
>> This patcheset introduces an ability to perform a non-blocking read from
>> regular files in buffered IO mode. This works by only for those filesystems
>> that have data in the page cache.
>>
>> It does this by introducing new syscalls new syscalls readv2/writev2 and
>> preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
>> syscalls that accept an extra flag argument (O_NONBLOCK).
>>
>> It's a very common patern today (samba, libuv, etc..) use a large threadpool to
>> perform buffered IO operations. They submit the work form another thread
>> that performs network IO and epoll or other threads that perform CPU work. This
>> leads to increased latency for processing, esp. in the case of data that's
>> already cached in the page cache.
>>
>> With the new interface the applications will now be able to fetch the data in
>> their network / cpu bound thread(s) and only defer to a threadpool if it's not
>> there. In our own application (VLDB) we've observed a decrease in latency for
>> "fast" request by avoiding unnecessary queuing and having to swap out current
>> tasks in IO bound work threads.
>>
>> I have co-developed these changes with Christoph Hellwig, a whole lot of his
>> fixes went into the first patch in the series (were squashed with his
>> approval).
>>
>> I am going to post the perf report in a reply-to to this RFC.
>
> You can send the performance data along with the patch series, no need to
> separate it off in a reply.
>
> One additional patch I'd like to see is a man page update.  That would
> help clarify exactly what you're trying to accomplish.
>
> I look forward to v2!
>
> Cheers,
> Jeff



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
