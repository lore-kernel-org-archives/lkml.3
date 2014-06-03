Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933525AbaFCWh5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 18:37:57 -0400
Received: from mail.phunq.net ([184.71.0.62]:49070 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955AbaFCWh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 18:37:56 -0400
From: Daniel Phillips <d.phillips@partner.samsung.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH 1/2] Add a super operation for writeback
Date: Tue, 03 Jun 2014 15:37:39 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <19f0e788-f6f2-4547-9cb2-a74d70d75cd0@partner.samsung.com>
In-Reply-To: <20140603152155.GD30706@quack.suse.cz>
References: <538B9DEE.20800@phunq.net> <20140602031526.GS14410@dastard>
 <538CD855.90804@phunq.net> <20140603033322.GA14410@dastard>
 <538D72B7.3010700@phunq.net> <20140603075209.GD14410@dastard>
 <20140603140531.GB30706@quack.suse.cz> <20140603141444.GA21273@infradead.org>
 <20140603152155.GD30706@quack.suse.cz>
Organization: Samsung
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 3, 2014 8:21:55 AM PDT, Jan Kara wrote:
> On Tue 03-06-14 07:14:44, Christoph Hellwig wrote:
>> On Tue, Jun 03, 2014 at 04:05:31PM +0200, Jan Kara wrote:
>  ...
>   So I agree per-bdi / per-sb matters only in simple setups but machines
> with single rotating disk with several partitions and without LVM aren't
> that rare AFAICT from my experience.

Retribution is sure to be swift, terrible and eternal for anyone who dares 
to
break those.

> And I agree we went for per-bdi
> flushing to avoid two threads congesting a single device leading to
> suboptimal IO patterns during background writeback.

A proposal is on the table to implement s_ops->writeback() as a per-sb
operation in such a way that nothing changes in the current per-inode path.
Good or bad approach?

> So currently I'm convinced we want to go for per-sb dirty tracking. That
> also makes some speedups in that code noticeably simpler. I'm not 
convinced
> about the per-sb flushing thread - if we don't regress the multiple sb on
> bdi case when we just let the threads from different superblocks contend
> for IO, then that would be a natural thing to do. But once we have to
> introduce some synchronization between threads to avoid regressions, I
> think it might be easier to just stay with per-bdi thread which switches
> between superblocks.

Could you elaborate on the means of switching between superblocks? Do you 
mean
a new fs-writeback path just for data=journal class filesystems, or are you
suggesting changing the way all filesystems are driven?

Regards,

Daniel
