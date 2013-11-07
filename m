Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab3KGVw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 16:52:27 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51823 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab3KGVwV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 16:52:21 -0500
Date: Thu, 7 Nov 2013 15:52:28 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: BUG: mm, numa: test segfaults, only when NUMA balancing is on
Message-ID: <20131107215228.GA4236@sgi.com>
References: <20131016155429.GP25735@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131016155429.GP25735@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 10:54:29AM -0500, Alex Thorlton wrote:
> Hi guys,
> 
> I ran into a bug a week or so ago, that I believe has something to do
> with NUMA balancing, but I'm having a tough time tracking down exactly
> what is causing it.  When running with the following configuration
> options set:
> 
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
> CONFIG_NUMA_BALANCING=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> 
> I get intermittent segfaults when running the memscale test that we've
> been using to test some of the THP changes.  Here's a link to the test:
> 
> ftp://shell.sgi.com/collect/memscale/

For anyone who's interested, this test has been moved to:

http://oss.sgi.com/projects/memtests/thp_memscale.tar.gz

It should remain there permanently.

> 
> I typically run the test with a line similar to this:
> 
> ./thp_memscale -C 0 -m 0 -c <cores> -b <memory>
> 
> Where <cores> is the number of cores to spawn threads on, and <memory>
> is the amount of memory to reserve from each core.  The <memory> field
> can accept values like 512m or 1g, etc.  I typically run 256 cores and
> 512m, though I think the problem should be reproducable on anything with
> 128+ cores.
> 
> The test never seems to have any problems when running with hugetlbfs
> on and NUMA balancing off, but it segfaults every once in a while with
> the config options above.  It seems to occur more frequently, the more
> cores you run on.  It segfaults on about 50% of the runs at 256 cores,
> and on almost every run at 512 cores.  The fewest number of cores I've
> seen a segfault on has been 128, though it seems to be rare on this many
> cores.
> 
> At this point, I'm not familiar enough with NUMA balancing code to know
> what could be causing this, and we don't typically run with NUMA
> balancing on, so I don't see this in my everyday testing, but I felt
> that it was definitely worth bringing up.
> 
> If anybody has any ideas of where I could poke around to find a
> solution, please let me know.
> 
> - Alex
