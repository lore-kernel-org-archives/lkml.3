Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab3KLJvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 04:51:07 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:58190 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KLJvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 04:51:03 -0500
Date: Tue, 12 Nov 2013 10:50:59 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>,
        John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131112095059.GB11777@gmail.com>
References: <20131111012927.GA404@localhost>
 <20131111154551.GJ19203@twins.programming.kicks-ass.net>
 <20131112094147.GA32441@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131112094147.GA32441@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


John,

Please have a look at this regression ASAP, as it's now upstream ...

Thanks,

	Ingo

* Fengguang Wu <fengguang.wu@intel.com> wrote:

> On Mon, Nov 11, 2013 at 04:45:51PM +0100, Peter Zijlstra wrote:
> > On Mon, Nov 11, 2013 at 09:29:27AM +0800, Fengguang Wu wrote:
> > > Greetings,
> > > 
> > > I got the below dmesg and the first bad commit is
> > > 
> > > commit 1ca7d67cf5d5a2aef26a8d9afd789006fa098347
> > > Author: John Stultz <john.stultz@linaro.org>
> > > Date:   Mon Oct 7 15:51:59 2013 -0700
> > > 
> > >     seqcount: Add lockdep functionality to seqcount/seqlock structures
> > >
> > 
> > > [    4.124336] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
> > > [    4.128027] Call Trace:
> > > [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
> > > [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
> > > [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
> > > [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
> > > [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> > > [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
> > 
> > The below seems to compile with i386-defconfig + CONFIG_CFQ_GROUP_IOSCHED=y
> > 
> > No idea if it runs properly or not; I seem to have misplaced my i386
> > root filesystem.
> > 
> > ---
> > Subject: block: Employ u64_stats_init()
> > 
> > Now that seqcounts are lockdep tracked thingies, we need to properly
> > initialize them, otherwise bad stuff happens.
> 
> FYI the warning is still there:
> 
> /kernel/i386-randconfig-j7-11082318/d3516a7318f8e22f5462888fdf9edc8f0f128024
> 
> +-------------------------------------------------+-------+--------------+--------------+
> |                                                 | v3.12 | 838cc7b488f8 | d3516a7318f8 |
> +-------------------------------------------------+-------+--------------+--------------+
> | boot_successes                                  | 129   | 0            | 0            |
> | boot_failures                                   | 1     | 100          | 100          |
> | BUG:kernel_early_hang_without_any_printk_output | 1     |              |              |
> | INFO:trying_to_register_non-static_key          | 0     | 100          | 100          |
> +-------------------------------------------------+-------+--------------+--------------+
> 
> Thanks,
> Fengguang
