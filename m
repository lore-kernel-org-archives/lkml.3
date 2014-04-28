Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaD1Tgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:36:49 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:40580 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753727AbaD1Tgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:36:48 -0400
Date: Mon, 28 Apr 2014 15:36:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: lockdep warning after recent cleanup in console code
Message-ID: <20140428153642.413ec8e8@gandalf.local.home>
In-Reply-To: <20140428192416.GE9091@quack.suse.cz>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
	<20140428134331.68771bf7@gandalf.local.home>
	<20140428175139.GD9091@quack.suse.cz>
	<20140428141439.3580dce9@gandalf.local.home>
	<20140428192416.GE9091@quack.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 21:24:16 +0200
Jan Kara <jack@suse.cz> wrote:


>   So I had a look and we are missing mutex_release() in
> console_trylock_for_printk() if we don't have a console to print to.
> Attached patch should fix the problem.
> 

Note, your patch changes the logic a bit. It causes the
mutex_acquire(&console_lock_dep_map) to happen on console_suspend,
which the original code never did.

-- Steve
