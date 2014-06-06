Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbaFFRvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:51:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbaFFRve (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:51:34 -0400
Date: Fri, 6 Jun 2014 13:51:25 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.15-rc8 oops in copy_page_rep after page fault.
Message-ID: <20140606175125.GB1741@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20140606174317.GA1741@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140606174317.GA1741@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 01:43:17PM -0400, Dave Jones wrote:
 > Not much to go on here. It rebooted right after dumping this.
 > 
 > RIP: 0010:[<ffffffff8b3287b5>]  [<ffffffff8b3287b5>] copy_page_rep+0x5/0x10
 > Call Trace:
 >  [<ffffffff8b1be8db>] ? do_huge_pmd_wp_page+0x5cb/0x850
 >  [<ffffffff8b187010>] handle_mm_fault+0x1e0/0xc50
 >  [<ffffffff8b1b4662>] ? kmem_cache_free+0x1c2/0x200
 >  [<ffffffff8b7472d9>] __do_page_fault+0x1c9/0x630
 >  [<ffffffff8b010a98>] ? perf_trace_sys_enter+0x38/0x180
 >  [<ffffffff8b11897b>] ? __acct_update_integrals+0x8b/0x120
 >  [<ffffffff8b747bfb>] ? preempt_count_sub+0xab/0x100
 >  [<ffffffff8b74775e>] do_page_fault+0x1e/0x70
 >  [<ffffffff8b7441b2>] page_fault+0x22/0x30

Ok, I can reproduce this fairly easily.

The only prerequisite seems to be that before I start the fuzzer I do..

echo 65536 > /proc/sys/vm/mmap_min_addr

If I don't do that, then it seems to survive, so maybe that's a clue ?

	Dave

