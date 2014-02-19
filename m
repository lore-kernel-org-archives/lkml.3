Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbaBSTGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:06:00 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:64655 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbaBSTF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:05:59 -0500
Date: Wed, 19 Feb 2014 14:05:55 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [workqueue] BUG: unable to handle kernel paging request at
 ffff880000798f60
Message-ID: <20140219190555.GR10134@htj.dyndns.org>
References: <20140219124122.GH7735@localhost>
 <20140219124614.GM15586@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140219124614.GM15586@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 01:46:14PM +0100, Peter Zijlstra wrote:
> On Wed, Feb 19, 2014 at 08:41:22PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git
> > 
> > commit 84604340d034a074036e86e85c4055a1c7ea5529
> > Author:     Peter Zijlstra <peterz@infradead.org>
> > AuthorDate: Tue Feb 11 12:00:36 2014 +0100
> > Commit:     Tejun Heo <tj@kernel.org>
> > CommitDate: Tue Feb 11 10:25:17 2014 -0500
> > 
> >     workqueue: Fix workqueue lockdep name
> >     
> >     Tommi noticed a 'funny' lock class name: "%s#5" from a lock acquired
> >     in process_one_work(). It turns out that commit b196be89cdc14 forgot
> >     to change the lockdep_init_map() when it changed the @lock_name
> >     argument from a string to a format.
> >     
> >     Fixes: b196be89cdc14 ("workqueue: make alloc_workqueue() take printf
> >     fmt and args for name")
> >     
> >     Reported-by: Tommi Rantala <tt.rantala@gmail.com>
> >     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >     Signed-off-by: Tejun Heo <tj@kernel.org>
> >     Cc: stable@vger.kernel.org
> 
> I seem to remember tj already having reverted this patch.

Hmmm... right, this shouldn't be in the tree anymore.  Let me check.
Yeap, it's not there anymore.

Thanks.

-- 
tejun
