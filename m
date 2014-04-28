Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399AbaD2Ilk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:41:40 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:59159 "EHLO
	cdptpa-queue01.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933221AbaD2IlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:41:20 -0400
Date: Mon, 28 Apr 2014 14:14:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jan Kara <jack@suse.cz>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Shevchenko, Andriy" <andriy.shevchenko@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: lockdep warning after recent cleanup in console code
Message-ID: <20140428141439.3580dce9@gandalf.local.home>
In-Reply-To: <20140428175139.GD9091@quack.suse.cz>
References: <1398702925.11914.292.camel@smile.fi.intel.com>
	<20140428134331.68771bf7@gandalf.local.home>
	<20140428175139.GD9091@quack.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2014 19:51:39 +0200
Jan Kara <jack@suse.cz> wrote:

> On Mon 28-04-14 13:43:31, Steven Rostedt wrote:
> > Things have changed with regard to printk() in linux-next. Now it
> > appears that lockdep is going haywire over it. I don't understand the
> > exact reason for the lockdep_off() and lockdep_on() logic that is in
> > printk(), but it obviously seems to be causing issues with the new
> > changes.
> > 
> > Care to take a look?
>   The obvious cause is that I moved lockdep_on() somewhat earlier in
> vprintk_emit() so lockdep now covers more of printk code. And apparently
> something is wrong there...
> 

Exactly, and I rather know *exactly* what is wrong before we just start
throwing patches at the problem and hope it goes away. That's not how
to solve a software bug.

-- Steve
