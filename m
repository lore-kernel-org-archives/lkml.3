Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab3JGAwq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 20:52:46 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:63127 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab3JGAwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 20:52:45 -0400
X-AuditID: 9c930197-b7bd9ae000006889-c6-525205db642b
Date: Mon, 7 Oct 2013 09:53:57 +0900
From: Minchan Kim <minchan@kernel.org>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, ch0.han@lge.com, gunho.lee@lge.com
Subject: Re: [RFC,3/5] squashfs: remove cache for normal data page
Message-ID: <20131007005357.GA12810@bbox>
References: <524E5C8B.7090807@lougher.demon.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524E5C8B.7090807@lougher.demon.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 07:13:31AM +0100, Phillip Lougher wrote:
> Minchan Kim <minchan@kernel.org> wrote:
> >Sqsuashfs have used cache for normal data pages but it's pointless
> >because MM already has cache layer and squashfs adds extra pages
> >into MM's page cache when it reads a page from compressed block.
> >
> >This patch removes cache usage for normal data pages so it could
> >remove unnecessary one copy
> 
> 1. As I mentioned last week, the use of the "unnecessary" cache is there
> to prevent two or more processes simultaneously trying to read the same
> pages.  Without this, such racing processes will decompress the same
> blocks repeatedly.
> 
> It is easy to dismiss this as an rare event, but, when it happens it
> has a major impact on performance, because the racing processes
> can get stuck in a lock-step arrangement, repeatedly trying to access
> the same blocks until the eof.  If the file is many megabytes or
> gigabytes in size (such as when Squashfs is used as a container fs for
> cetain liveCDs, or virtual machine disk images) this will lead to
> a significant reduction in performance.
> 
> So I consider this a major regression.
> 
> 2. You patch also adds another regression, which is to reintroduce
> kmap() rather than kmap_atomic().
> 
> I was asked to remove this at my first submission attempt
> in 2005
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0503.2/0809.html
> 
> So I'm not particularly willing to reintroduce it now.
> 
> 3. Your patch potentially reintroduces this bug
> 
> http://www.spinics.net/lists/linux-fsdevel/msg02555.html
> http://zaitcev.livejournal.com/86954.html
> 
> 4. You patch is unconditional.  With such code changes as this
> it is always essential to make this a "buy in option", with the
> original behaviour retained as default.  Otherwise, lots of users
> potentially find their embedded/enterprise/mission critical
> system unexpectedly breaks when upgrading the kernel, and I get
> a lot of angry email.
> 
> Phillip

I will handle all your points in next patchset.

Thanks for the review!

-- 
Kind regards,
Minchan Kim
