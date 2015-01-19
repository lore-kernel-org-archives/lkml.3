Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbbASJq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:46:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50502 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbbASJq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:46:58 -0500
Date: Mon, 19 Jan 2015 10:46:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: "long.wanglong" <long.wanglong@huawei.com>
Cc: hannes@cmpxchg.org, shijie8@gmail.com, torvalds@linux-foundation.org,
        azurit@pobox.sk, hugh.dickins@tiscali.co.uk, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        peifeiyue@huawei.com
Subject: Re: does the semantics of MAP_LOCKED is equal to mlock() function?
Message-ID: <20150119094656.GA21052@dhcp22.suse.cz>
References: <54BCA187.6070601@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BCA187.6070601@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See http://marc.info/?l=linux-mm&m=142122902313315&w=2 for more
information.

On Mon 19-01-15 14:17:43, long.wanglong wrote:
> Hi all:
> 
> In the latest kernel, i set the memory limit (4096) in a test cgroup. and add the test task.
> the test code code is:
> 
> testcase 1: mmap with MAP_LOCKED flag(memsize = 8192)
> 
> 185                 p = mmap(NULL, memsize, PROT_WRITE | PROT_READ,
> 186                          MAP_PRIVATE | MAP_ANONYMOUS | MAP_LOCKED, 0, 0);
> 187                 if (p == MAP_FAILED)
> 188                         err(1, "mmap(lock) failed");
> 					
> expect: invoke OOM killer.
> result: not invoke OOM killer.
> 
> 
> testcase 2: mmap without MAP_LOCKED flag and the call mlock (memsize = 8192)
> 
> 185                 p = mmap(NULL, memsize, PROT_WRITE | PROT_READ,
> 186                          MAP_PRIVATE | MAP_ANONYMOUS, 0, 0);
> 187                 if (p == MAP_FAILED)
> 188                         err(1, "mmap(lock) failed");
> 189
> 190                 if (mlock(p, memsize) == -1)
> 191                         err(1, "mlock failed")
> 
> expect: invoke OOM killer.
> result: invoke OOM killer.
> 
> in the Linux Programmer's Manual:
> 
> MAP_LOCKED (since Linux 2.5.37)
> 		Lock the pages of the mapped region into memory in the manner
> 		of mlock(2).  This flag is ignored in older kernels.
> 	
> and
>        mlock() locks pages in the address range starting at addr and
>        continuing for len bytes.  All pages that contain a part of the
>        specified address range are guaranteed to be resident in RAM when the
>        call returns successfully; the pages are guaranteed to stay in RAM
>        until later unlocked.
> 	
> According to the description in the manual, the two testcases are equivalent.
> 
> why the first testcase does not invoke OOM killer?
> does the mmap with MAP_LOCKED flag will not immediately allocate physical memory?
> 
> 
> Best Regards
> Wang Long
> 

-- 
Michal Hocko
SUSE Labs
