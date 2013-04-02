Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067Ab3DBSH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:07:58 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45677 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab3DBSHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:07:55 -0400
Date: Tue, 2 Apr 2013 11:07:50 -0700
From: Tejun Heo <tj@kernel.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        chris@zankel.net, cmetcalf@tilera.com, ysato@users.sourceforge.jp,
        gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: Re: [PATCH v2 5/5] dump_stack: unify debug information printed by
 show_regs()
Message-ID: <20130402180750.GA6185@htj.dyndns.org>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
 <1364610428-2074-6-git-send-email-tj@kernel.org>
 <20130330032445.GA28468@htj.dyndns.org>
 <51568277.8000404@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51568277.8000404@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vineet.

On Sat, Mar 30, 2013 at 11:43:11AM +0530, Vineet Gupta wrote:
> Although in line [2], ARC trouble-shooting code prints the task path (rather than
> comm). This was done to help identify faulting LTP open posix tests with same name
> in different directories: e.g. fork/6-1, sigqueue/6-1 ....
> Is this something you want to add to generic code as well - although it's slightly
> involved due to tsk/mm locking etc.

I don't think that'd be a particularly good idea.  Paths can be pretty
long and in general we want to limit the scope of unsafe accesses from
dump functions.  dump could easily be called from deep inside mmap
paths and you definitely don't wanna do get_mm_exec_file() which
involves read-locking mm->mmap_sem.

While it could be useful for arc where, supposedly, not a lot of
generic development and debugging would happen and flushing out bugs
in arch code is much more important, I don't really think it's a good
idea in general.

> Also I personally prefer the more compact <task-nm>/<tgid> format of [1] vs. [3].

It's taken from x86 messages which should be familiar to most number
of devs.  Given that it's a last-resort debug thing, we can change
things but there's no reason to disturb more than necessary.

> Anyhow, can you please fold the following into your patchset to reduce above
> duplication.

Sure thing.

Thanks!

-- 
tejun
