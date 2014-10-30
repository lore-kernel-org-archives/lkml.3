Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbaJ3HHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:07:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:49836 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbaJ3HHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:07:35 -0400
Date: Thu, 30 Oct 2014 08:07:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141030070725.GG3337@twins.programming.kicks-ass.net>
References: <20141020161855.GF12020@console-pimps.org>
 <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029182234.GA13393@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 02:22:34PM -0400, Tejun Heo wrote:
> On Wed, Oct 29, 2014 at 10:41:47AM -0700, Vikas Shivappa wrote:
> > Was wondering if it is a requirement of the 'full hierarchy' for the child
> > to inherit the cbm of parent ? .
> > Alternately we can allocate the CLOSid when a cgroup is created and have an
> > empty cbm - but dont let the tasks to be added unless the user assigns a
> 
> Please don't do that.  All controllers must be fully hierarchical,

With you so far.

> shouldn't fail task migration

If this means echo $tid > tasks, then sorry we can't do. There is a
limited number of hardware resources backing this thing. At some point
they're consumed and something must give.

So either we fail mkdir, but that means allocating CLOS IDs for possibly
empty cgroups, or we allocate on demand which means failing task
assignment.

The same -- albeit for a different reason -- is true of the RT sched
groups, we simply cannot instantiate them such that tasks can join,
sysads _have_ to configure them before we can add tasks to them.

> and always allow execution of member tasks.

If we accept tasks, they'll run.
