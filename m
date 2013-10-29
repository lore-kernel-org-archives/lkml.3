Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3J2KlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 06:41:08 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57307 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab3J2KlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 06:41:05 -0400
Date: Tue, 29 Oct 2013 11:41:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Tom Weber <l_linux-kernel@mail2news.4t2.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Automatic NUMA balancing patches for tip-urgent/stable
Message-ID: <20131029104102.GB26154@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
 <20131024122646.GB2402@suse.de>
 <20131026121148.GC24439@gmail.com>
 <20131029094208.GB2400@suse.de>
 <20131029094856.GA25306@gmail.com>
 <20131029102419.GC2400@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029102419.GC2400@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> Bah, I have tip as a remote tree but looked at my local copy of 
> the commits in the incorrect branch. Lets try this again
> 
> 37bf06375c90a42fe07b9bebdb07bc316ae5a0ce..afcae2655b0ab67e65f161b1bb214efcfa1db415

Ok, these work a lot better and cherry-pick cleanly on top of -rc7.

> 10fc05d0e551146ad6feb0ab8902d28a2d3c5624 mm: numa: Document automatic NUMA balancing sysctls

We can certainly leave out this one - the rest still cherry-picks 
cleanly.

> c69307d533d7aa7cc8894dbbb8a274599f8630d7 sched/numa: Fix comments

I was able to leave out this one as well.

> 0c3a775e1e0b069bf765f8355b723ce0d18dcc6c mm: numa: Do not account for a hinting fault if we raced
> ff9042b11a71c81238c70af168cd36b98a6d5a3c mm: Wait for THP migrations to complete during NUMA hinting faults
> b8916634b77bffb233d8f2f45703c80343457cc1 mm: Prevent parallel splits during THP migration
> 8191acbd30c73e45c24ad16c372e0b42cc7ac8f8 mm: numa: Sanitize task_numa_fault() callsites
> a54a407fbf7735fd8f7841375574f5d9b0375f93 mm: Close races between THP migration and PMD numa clearing
> afcae2655b0ab67e65f161b1bb214efcfa1db415 mm: Account for a THP NUMA hinting update as one PTE update

Ok, these seem essential and cherry-pick cleanly.

Would be nice to avoid the 'Sanitize task_numa_fault() callsites' 
change, but the remaining fixes rely on it and are well tested 
together.

I've stuck these into tip:core/urgent with a -stable tag and will 
send them to Linus if he cuts an -rc8 (which seems unlikely at this 
point though).

If there's no -rc8 then please forward the above list of 6 commits 
to Greg so that it can be applied to -stable.

Thanks,

	Ingo
