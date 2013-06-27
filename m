Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab3F0Xhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:37:48 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47988 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab3F0Xhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:37:46 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tux3@tux3.org
Subject: Re: [PATCH] Optimize wait_sb_inodes()
References: <87ehbpntuk.fsf@devron.myhome.or.jp>
	<20130626231143.GC28426@dastard> <87wqpg76ls.fsf@devron.myhome.or.jp>
	<20130627044705.GB29790@dastard> <87y59w5dye.fsf@devron.myhome.or.jp>
	<20130627063816.GD29790@dastard> <87ppv83tnn.fsf@devron.myhome.or.jp>
	<20130627094042.GZ29338@dastard> <87mwqb3m1e.fsf@devron.myhome.or.jp>
	<20130627183631.GB22832@thunk.org>
Date: Fri, 28 Jun 2013 08:37:40 +0900
In-Reply-To: <20130627183631.GB22832@thunk.org> (Theodore Ts'o's message of
	"Thu, 27 Jun 2013 14:36:31 -0400")
Message-ID: <871u7nrupn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o <tytso@mit.edu> writes:

> Let's go up a level.  Why are you so focused on optimizing sync(2)?
> What's the use case where you anticipate applications using sync(2) or
> syncfs(2)?    Or is this for the purpose of Tux3's benchmarketing?
>
> In practice, sync(2) as a data integrity mechanism is a bit
> heavyweight for most applications.  In general the complaint with ext3
> or ext4 is that fsync(2) is forcing a full filesystem-wide sync, and
> not just a sync specific to the file.
>
> System administrators use it sometimes[1], sometimes out of superstition,
> but how many applications actually use it?  And why?
>
> [1] In fact, I've heard an argument that sync(2) should be optionally
> made privileged and only accessible to root, since there were cases
> where system administrators would login to a heavily loaded server as
> a non-privileged user, type "sync" out of reflex or habit, and the
> resulting huge amounts of I/O would blow the 99.9th percentile latency
> guarantees for all of the latency-sensitive services running on that
> server.
>
> If the goal is to optimize file system freeze operations, sure.  But
> that's also not a common operation, so if it burns a little extra CPU
> time, it wouldn't cause me to think that it was a high priority issue.
> Decreasing the wall clock time for a file system freeze operation
> would probably be a far more interesting goal.

I'm not focusing on optimizing sync(2), not like you are suspecting. It
might be an issue of visibility of our work.

Well, anyway, it is simple. This issue was came as the performance
regression when I was experimenting to use kernel bdi flusher from own
flusher. The issue was sync(2) like I said.  And this was just I
couldn't solve this issue by tux3 side unlike other optimizations.

Simple patch was enough to optimize that. And there was no reason to
keep to hide the patch, then share this lack of vfs with community.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
