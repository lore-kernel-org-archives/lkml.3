Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaIVQcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 12:32:06 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:39071 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbaIVQcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 12:32:04 -0400
MIME-Version: 1.0
In-Reply-To: <x49tx3zpsfg.fsf@segfault.boston.devel.redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
	<94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
	<20140919112147.GA4639@infradead.org>
	<x49tx3zpsfg.fsf@segfault.boston.devel.redhat.com>
Date: Mon, 22 Sep 2014 12:32:02 -0400
Message-ID: <CANP1eJH0XYgcjzExLmqmViqpCiowquOj1yuWX1wFsbceteLYpw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
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

On Mon, Sep 22, 2014 at 11:48 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Christoph Hellwig <hch@infradead.org> writes:
>
>> Without the atomic WRITE SCATTERED use case adding the syscalls seems
>> rather pointless, and I'd really avoid blocking nice software only
>> features like the per-I/O nonblock flag (and the similarly trivial
>> per-I/O sync option I have a prototype for) on it.
>
> Andreas and Zach pointed out that the scatter/gather system calls also
> help network file systems.  I'm not yet sure how much work it would be,
> but it certainly seems worth considering readx/writex (or whatever we
> want to call them) to avoid needlessly adding a ton of system calls.
>
> Cheers,
> Jeff

I spent some time thinking about multi-position scatter/gather in
context of this over the weekend. The non-blocking case seams easy,
the implementation I purposed needs an extra loop. Where this gets
hairy is making the non-trivial blocking case work well (as in have
concurrent requests for each of the ranges) in the filesystem code. If
that's the road we're going to go down I have a gut feeling we're
going to get stuck in the same spot(s) as the other non-blocking
buffered r/w attempts from the past.

Best,
- Milosz

-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
