Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbaJ3PZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:25:08 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:63315 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbaJ3PZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:25:06 -0400
Date: Thu, 30 Oct 2014 11:25:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141030152502.GA378@htj.dyndns.org>
References: <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030071424.GE10476@twins.programming.kicks-ass.net>
 <20141030124440.GB29540@htj.dyndns.org>
 <20141030131904.GJ3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030131904.GJ3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Thu, Oct 30, 2014 at 02:19:04PM +0100, Peter Zijlstra wrote:
> On Thu, Oct 30, 2014 at 08:44:40AM -0400, Tejun Heo wrote:
> > On Thu, Oct 30, 2014 at 08:14:24AM +0100, Peter Zijlstra wrote:
> > > On Thu, Oct 30, 2014 at 08:07:25AM +0100, Peter Zijlstra wrote:
> > > > > and always allow execution of member tasks.
> > > 
> > > This too btw is not strictly speaking possible for all controllers. Most
> > > all sched controllers live by the grace of forcing tasks not to run at
> > > times (eg. the bandwidth controls), falsifying the 'always'.
> > 
> > Oh sure, the a task just has to run in a foreseeable future, or
> > rather, a task must not be blocked indefinitely requiring userland
> > intervention to become executable again.
> 
> Like the freezer cgroup you mean? ;-)

Oh yeah, that's horribly broken.  Merging it with jobctl stop is a
todo item.  This "stuck in a random place in kernel" thing made sense
for suspend/hibernation only because the kernel wasn't gonna run
anymore.  The fact that this got exposed to userland on a running
system just shows how little we were thinking while implementing all
the controllers.  It should be equivalent to layered job control stop
so that what's prevented from running is the userland part, not
kernel.

Thanks.

-- 
tejun
