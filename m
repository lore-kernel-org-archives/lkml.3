Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752207Ab3F1FYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 01:24:24 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:24926 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab3F1FYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 01:24:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtINAMQdzVF5LB/8/2dsb2JhbABbgwkxujKFIQQBgQcXdIIjAQEFOhwjEAgDGAklDwUlAyETiA0NuzgEFo4igR0HgwJjA5dEih+HJ4MjKg
Date: Fri, 28 Jun 2013 15:23:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
Message-ID: <20130628052352.GA9047@dastard>
References: <20130627044705.GB29790@dastard>
 <87y59w5dye.fsf@devron.myhome.or.jp>
 <20130627063816.GD29790@dastard>
 <87ppv83tnn.fsf@devron.myhome.or.jp>
 <20130627094042.GZ29338@dastard>
 <87mwqb3m1e.fsf@devron.myhome.or.jp>
 <20130627183631.GB22832@thunk.org>
 <871u7nrupn.fsf@devron.myhome.or.jp>
 <20130627234521.GC22832@thunk.org>
 <87hagjqdpi.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hagjqdpi.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 28, 2013 at 09:30:17AM +0900, OGAWA Hirofumi wrote:
> Theodore Ts'o <tytso@mit.edu> writes:
> 
> > On Fri, Jun 28, 2013 at 08:37:40AM +0900, OGAWA Hirofumi wrote:
> >> 
> >> Well, anyway, it is simple. This issue was came as the performance
> >> regression when I was experimenting to use kernel bdi flusher from own
> >> flusher. The issue was sync(2) like I said.  And this was just I
> >> couldn't solve this issue by tux3 side unlike other optimizations.
> >
> > A performance regression using fsstress?  That's not a program
> > intended to be a useful benchmark for measuring performance.
> 
> Right. fsstress is used as stress tool for me too as part of CI, with
> background vmstat 1. Anyway, it is why I noticed this.
> 
> I agree it would not be high priority. But I don't think we should stop
> to optimize it.

But you're not proposing any sort of optimisation at all - you're
simply proposing to hack around the problem so you don't have to
care about it. The VFS is a shared resource - it has to work well
for everyone - and that means we need to fix problems and not ignore
them.

As I said, wait_sb_inodes() is fixable. I'm not fixing for tux3,
though - I'm fixing it because it's causing soft lockups on XFS and
ext4 in 3.10-rc6:

https://lkml.org/lkml/2013/6/27/772

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
