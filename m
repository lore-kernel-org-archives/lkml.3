Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572AbaIVRCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:02:10 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:60155 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521AbaIVRCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:02:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140922164237.GA30229@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
	<8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
	<94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
	<20140919112147.GA4639@infradead.org>
	<x49tx3zpsfg.fsf@segfault.boston.devel.redhat.com>
	<CANP1eJH0XYgcjzExLmqmViqpCiowquOj1yuWX1wFsbceteLYpw@mail.gmail.com>
	<20140922164237.GA30229@infradead.org>
Date: Mon, 22 Sep 2014 13:02:03 -0400
Message-ID: <CANP1eJG0CDtAA-7q3MvQE7Fz0=awYu0V4p43w-1vw2oV=gg-qQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Moyer <jmoyer@redhat.com>,
        "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Andreas Dilger <adilger@dilger.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'll send out the next RFC with 2 syscalls and magic position values.
I'm waiting for Jeff to chime in on the v2 patchset before I send out
the next one.

On Mon, Sep 22, 2014 at 12:42 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Sep 22, 2014 at 12:32:02PM -0400, Milosz Tanski wrote:
>> I spent some time thinking about multi-position scatter/gather in
>> context of this over the weekend. The non-blocking case seams easy,
>> the implementation I purposed needs an extra loop. Where this gets
>> hairy is making the non-trivial blocking case work well (as in have
>> concurrent requests for each of the ranges) in the filesystem code. If
>> that's the road we're going to go down I have a gut feeling we're
>> going to get stuck in the same spot(s) as the other non-blocking
>> buffered r/w attempts from the past.
>
> The other thing sis that we have a basically ready, easy to use
> implementation of flagged I/O (my name for the new syscalls), while
> S/G I/O will take forever to discuss and is the natual vehicle for
> other extensions like T10 DIX.
>
> I'd like to suggest you consolidate your syscalls down from 4 to 2
> as suggestes by overloading the negative offset argument, giving
> us two more syscalls slows for S/G once it's ready.  Note that
> a sync S/G syscalls should of course also support these flags, although
> I suspect the primary use cases for S/G I/O would be through the aio
> machinery.



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
