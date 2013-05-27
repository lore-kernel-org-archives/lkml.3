Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3E0Uqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 16:46:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42885 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757261Ab3E0Uqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 16:46:54 -0400
Date: Mon, 27 May 2013 22:46:51 +0200
From: Jan Kara <jack@suse.cz>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Nonblocking buffered AIO from userspace
Message-ID: <20130527204651.GB21682@quack.suse.cz>
References: <CANP1eJFz8kQguZ0zSZHx7KR=3XkNaxNg94bD92MkFZhR3pZHYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANP1eJFz8kQguZ0zSZHx7KR=3XkNaxNg94bD92MkFZhR3pZHYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Thu 23-05-13 16:49:49, Milosz Tanski wrote:
> I need some advice on the best way to accomplish non-blocking buffered
> disk IO from my user space application. Unlike some of the other
> database systems I'm trying to outsource as much work to the kernel as
> possible. I would prefer to avoid having to resolve to O_DIRECT and
> io_submit to fetch the data and having to reimplement the page /
> buffer cache & read ahead.
> 
> The application is read heavy with occasional long running write jobs.
> Since I'm not too concerned about the performance on the write path I
> am able to run that work in threads and block.
> 
> Current I'm mmaping the files, and the make the read path quite simple
> and is great for disk scans when my data set is stored in memory. When
> the data is not cached the performance becomes more unpredictable,
> esp. when I'm doing an indexed read (giant bitmap indexes). Here's how
> my IO path looks like:
> 
> application <--> fscache (SSD) <--> cephfs <--> ceph cluster
> 
> Ultimately what I'd like is a way to do non-blocking scatter gather IO
> from disk or page cache into my application. I'd like to be
> non-blocking because it often happens that I can do something useful
> while waiting on IO like uncompress indexes for another request that
> is waiting, process network IO., etc.
> 
> With mmap my blocking is unpredictable and mlock() blocks and only
> lets me lock a range and not a vector of page ranges.
  Maybe the API you are looking for is madvise(MADV_WILLNEED)? That forces
asynchronous readahead for the specified range.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
