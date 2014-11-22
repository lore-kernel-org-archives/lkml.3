Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaKWFYc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 00:24:32 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaKWFYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 00:24:31 -0500
Date: Sat, 22 Nov 2014 00:02:39 -0800
From: Darren Hart <dvhart@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: dvhart@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: futex testsuite suggestion...
Message-ID: <20141122080239.GA7886@vmdeb7>
References: <20141027.155656.1414383076601514662.davem@davemloft.net>
 <544EAB1A.2030403@linux.intel.com>
 <20141027.163116.627611711460671434.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027.163116.627611711460671434.davem@davemloft.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 04:31:16PM -0400, David Miller wrote:
> From: Darren Hart <dvhart@linux.intel.com>
> Date: Mon, 27 Oct 2014 13:29:14 -0700
> 
> > On 10/27/14 12:56, David Miller wrote:
> >> I'd like to suggest that you add a test that triggers transparent
> >> hugepages, because if an architecture doesn't implement
> >> __get_user_pages_fast() such futexes cause a machine to hang.
> >> 
> >> I hacked up something simple that took the existing performance
> >> test and made it operate in a register allocated using memalign().
> >> 
> >> I would suggest doing a memalign(HUGEPAGE_SIZE, HUGEPAGE_SIZE) then
> >> iterating running a futex test within each normal page within that
> >> hugepage.
> > 
> > Do you want this option for the performance tests, or would a less
> > intensive functional test be sufficient?
> 
> I think a functional test is sufficient.

Hi David,

>From your suggestion I put together a simple transparent hugepage functional
test. See the "thp" branch, functional/futex_wait_thp.c.

I'd like your thoughts on if this functions as desired. Is the simple single
threaded timeout sufficient, or would you prefer to see a waiter/waker pair of
threads for each iteration?

Some TODOs still:

I wasn't sure if there was a way to test for hugepagesize and my quick search
didn't reveal anything (other than /proc/meminfo).

Check at runtime if the test is getting a huge page, otherwise it just reports
success, but used several regular pages instead.

-- 
Darren Hart
Intel Open Source Technology Center
