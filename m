Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab3FYDHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:07:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:6936 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab3FYDH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:07:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,933,1363158000"; 
   d="scan'208";a="322042749"
Date: Mon, 24 Jun 2013 23:07:21 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-nvme@lists.infradead.org,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RFC: Allow block drivers to poll for I/O instead of sleeping
Message-ID: <20130625030721.GA8211@linux.intel.com>
References: <20130620201713.GV8211@linux.intel.com>
 <20130623100920.GA19021@gmail.com>
 <CA+55aFy+COdk5+ucwxtc1At=PAYTJxeUaUV6rP9XstHdNV0hbQ@mail.gmail.com>
 <20130624071718.GS9422@kernel.dk>
 <20130625001102.GA6623@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625001102.GA6623@home.goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 08:11:02PM -0400, Steven Rostedt wrote:
> What about hooking into the idle_balance code? That happens if we are
> about to go to idle but before the full schedule switch to the idle
> task.
> 
> 
> In __schedule(void):
> 
> 	if (unlikely(!rq->nr_running))
> 		idle_balance(cpu, rq);

That may be a great place to try it from the PoV of the scheduler, but are
you OK with me threading a struct backing_dev_info * all the way through
the scheduler to idle_balance()?  :-)
