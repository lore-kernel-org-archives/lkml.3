Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327AbaAWTes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:34:48 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63623 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932189AbaAWTeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:34:44 -0500
Date: Thu, 23 Jan 2014 11:34:41 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123193441.GV9037@kmo>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <1390420413.5567.949.camel@haakon3.risingtidesystems.com>
 <1390502404.5567.994.camel@haakon3.risingtidesystems.com>
 <20140123191229.GW11314@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123191229.GW11314@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 08:12:29PM +0100, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 10:40:04AM -0800, Nicholas A. Bellinger wrote:
> > On Wed, 2014-01-22 at 11:53 -0800, Nicholas A. Bellinger wrote:
> > > Hi Peter,
> > > 
> > > Does this satisfy your questions..?
> > > 
> > > Do you have any more concerns about TASK_RUNNING + prepare_to_wait()
> > > usage in percpu_ida_alloc() that need to be addressed before I can drop
> > > this series into target-pending/for-next to address the original bug..?
> > > 
> > 
> > Given the silence, 
> 
> You mean the silence in which I send a 4+ emails earlier today?
> 
> > I'll assume your OK with the initial TASK_RUNNING +
> > prepare_to_wait() bit, right..?
> 
> No, I would prefer not to do that. While it does work its awkward at
> best.

I do like the improvements, but personally, I really don't see anything wrong
with the initial patch and for backporting that really is what we should do -
this code _is_ subtle enough backporting our (your) improvements is not
something I'd want to do, having debugged this code when I first wrote it...
