Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbbAFPDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:03:08 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:56428 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755380AbbAFPDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:03:06 -0500
Date: Tue, 6 Jan 2015 10:02:50 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Leon Romanovsky <leon@leon.nu>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Dirty pages underflow on 3.14.23
Message-ID: <20150106150250.GA26895@phnom.home.cmpxchg.org>
References: <alpine.LRH.2.02.1501051744020.5119@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1501051744020.5119@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2015 at 06:05:59PM -0500, Mikulas Patocka wrote:
> Hi
> 
> I would like to report a memory management bug where the dirty pages count 
> underflowed.
> 
> It happened after some time that the Dirty pages count underflowed, as can 
> be seen in /proc/meminfo. The underflow condition was persistent, 
> /proc/meminfo was showing the big value even when the system was 
> completely idle. The counter never returned to zero.
> 
> The system didn't crash, but it became very slow - because of the big 
> value in the "Dirty" field, lazy writing was not working anymore, any 
> process that created a dirty page triggered immediate writeback, which 
> slowed down the system very much. The only fix was to reboot the machine.
> 
> The kernel version where this happened is 3.14.23. The kernel is compiled 
> without SMP and with peemption. The system is single-core 32-bit x86.
> 
> The bug probably happened during git pull or apt-get update, though one 
> can't be sure that these commands caused it.
> 
> I see that 3.14.24 containes some fix for underflow (commit 
> 6619741f17f541113a02c30f22a9ca22e32c9546, upstream commit 
> abe5f972912d086c080be4bde67750630b6fb38b), but it doesn't seem that that 
> commit fixes this condition. If you have a commit that could fix this, say 
> it.

That's an unrelated counter, but there is a known dirty underflow
problem that was addressed in 87a7e00b206a ("mm: protect
set_page_dirty() from ongoing truncation").  It should make it into
the stable kernels in the near future.  Can you reproduce this issue?

Thanks,
Johannes
