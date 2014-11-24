Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750908AbaKXWH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:07:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54309 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaKXWHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:07:25 -0500
Date: Mon, 24 Nov 2014 17:07:23 -0500 (EST)
Message-Id: <20141124.170723.349362016189517646.davem@davemloft.net>
To: dvhart@infradead.org
Cc: dvhart@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: futex testsuite suggestion...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141122080239.GA7886@vmdeb7>
References: <544EAB1A.2030403@linux.intel.com>
	<20141027.163116.627611711460671434.davem@davemloft.net>
	<20141122080239.GA7886@vmdeb7>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Nov 2014 14:07:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@infradead.org>
Date: Sat, 22 Nov 2014 00:02:39 -0800

> From your suggestion I put together a simple transparent hugepage functional
> test. See the "thp" branch, functional/futex_wait_thp.c.
> 
> I'd like your thoughts on if this functions as desired. Is the simple single
> threaded timeout sufficient, or would you prefer to see a waiter/waker pair of
> threads for each iteration?
> 
> Some TODOs still:
> 
> I wasn't sure if there was a way to test for hugepagesize and my quick search
> didn't reveal anything (other than /proc/meminfo).
> 
> Check at runtime if the test is getting a huge page, otherwise it just reports
> success, but used several regular pages instead.

This looks excellent!  I did a test run on my sparc64 box and it passed
as well.

I do not thinks thread waiter/waker pairs are necessary for this test.

And indeed I do not know of any way other than /proc/meminfo to test
for this.  Perhaps there are some tricks in the LTP testsuite?

Thanks!
