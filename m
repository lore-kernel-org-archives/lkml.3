Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab3F1Hjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 03:39:54 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48134 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3F1Hjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 03:39:52 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Dave Chinner <david@fromorbit.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <20130627044705.GB29790@dastard>
	<87y59w5dye.fsf@devron.myhome.or.jp> <20130627063816.GD29790@dastard>
	<87ppv83tnn.fsf@devron.myhome.or.jp> <20130627094042.GZ29338@dastard>
	<87mwqb3m1e.fsf@devron.myhome.or.jp>
	<20130627183631.GB22832@thunk.org>
	<871u7nrupn.fsf@devron.myhome.or.jp>
	<20130627234521.GC22832@thunk.org>
	<87hagjqdpi.fsf@devron.myhome.or.jp> <20130628052352.GA9047@dastard>
Date: Fri, 28 Jun 2013 16:39:49 +0900
In-Reply-To: <20130628052352.GA9047@dastard> (Dave Chinner's message of "Fri,
	28 Jun 2013 15:23:52 +1000")
Message-ID: <877gheof96.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

>> > A performance regression using fsstress?  That's not a program
>> > intended to be a useful benchmark for measuring performance.
>> 
>> Right. fsstress is used as stress tool for me too as part of CI, with
>> background vmstat 1. Anyway, it is why I noticed this.
>> 
>> I agree it would not be high priority. But I don't think we should stop
>> to optimize it.
>
> But you're not proposing any sort of optimisation at all - you're
> simply proposing to hack around the problem so you don't have to
> care about it. The VFS is a shared resource - it has to work well
> for everyone - and that means we need to fix problems and not ignore
> them.

Agree, vfs has to work well for everyone. To work well, vfs should not
force unnecessary overhead/wait.

I'm not saying to stop optimizing wait_sb_inodes() itself, I'm saying it
is not enough.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
