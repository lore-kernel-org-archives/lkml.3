Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3KEWpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 17:45:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755836Ab3KEWp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 17:45:28 -0500
Date: Tue, 5 Nov 2013 14:45:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Ron van der Wees <rvdwees@redhat.com>, Erik Mouw <erik.mouw_2@nxp.com>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        walken@google.com, Shaohua Li <shli@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH -mm] provide estimated available memory in
 /proc/meminfo
Message-Id: <20131105144526.49a233ca19298808e54ff900@linux-foundation.org>
In-Reply-To: <20131105173852.709a103b@annuminas.surriel.com>
References: <ECFC0369-0745-44AB-9858-E689F41CCB4D@nxp.com>
	<5256D4C7.90301@redhat.com>
	<DB649DE8-5595-4370-912B-BDC6BD5FF8C3@nxp.com>
	<20131025120752.GB2415@rh0004426.ams.redhat.com>
	<20131105173852.709a103b@annuminas.surriel.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Nov 2013 17:38:52 -0500 Rik van Riel <riel@redhat.com> wrote:

> Many load balancing and workload placing programs check /proc/meminfo
> to estimate how much free memory is available. They generally do this
> by adding up "free" and "cached", which was fine ten years ago, but
> is pretty much guaranteed to be wrong today.
> 
> It is wrong because Cached includes memory that is not freeable as
> page cache, for example shared memory segments, tmpfs, and ramfs,
> and it does not include reclaimable slab memory, which can take up
> a large fraction of system memory on mostly idle systems with lots
> of files.
> 
> Currently, the amount of memory that is available for a new workload,
> without pushing the system into swap, can be estimated from MemFree,
> Active(file), Inactive(file), and SReclaimable, as well as the "low"
> watermarks from /proc/zoneinfo.
> 
> However, this may change in the future, and user space really should
> not be expected to know kernel internals to come up with an estimate
> for the amount of free memory.
> 
> It is more convenient to provide such an estimate in /proc/meminfo,
> if things change in the future, we only have to change it in one
> place.
> 

That's a good idea.

>  fs/proc/meminfo.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)

Documentation/filesystems/proc.txt told me it's feeling all offended.
