Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaBXBSM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 20:18:12 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:34363 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaBXBSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 20:18:10 -0500
Date: Sun, 23 Feb 2014 17:18:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rcu: ensure kernel/rcu/rcu.h can be sourced/used
 stand-alone
Message-ID: <20140224011802.GD8264@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140219185850.GA23050@linux.vnet.ibm.com>
 <1392838407-29704-1-git-send-email-paul.gortmaker@windriver.com>
 <20140220015317.GL4250@linux.vnet.ibm.com>
 <20140220020213.GA9907@windriver.com>
 <20140220090039.GQ4250@linux.vnet.ibm.com>
 <20140223172714.GA3774@linux.vnet.ibm.com>
 <20140224000103.GB13295@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140224000103.GB13295@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022401-1344-0000-0000-00000605458E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 23, 2014 at 07:01:04PM -0500, Paul Gortmaker wrote:
> [Re: [PATCH v2] rcu: ensure kernel/rcu/rcu.h can be sourced/used stand-alone] On 23/02/2014 (Sun 09:27) Paul E. McKenney wrote:
> 
> > On Thu, Feb 20, 2014 at 01:00:39AM -0800, Paul E. McKenney wrote:
> > > On Wed, Feb 19, 2014 at 09:02:13PM -0500, Paul Gortmaker wrote:
> > > > [Re: [PATCH v2] rcu: ensure kernel/rcu/rcu.h can be sourced/used stand-alone] On 19/02/2014 (Wed 17:53) Paul E. McKenney wrote:
> > > > 
> > > > > On Wed, Feb 19, 2014 at 02:33:27PM -0500, Paul Gortmaker wrote:
> > > > > > The kbuild test bot uncovered an implicit dependence on the
> > > > > > trace header being present before rcu.h in ia64 allmodconfig
> > > > > > that looks like this:
> > > > > > 
> > > > > > In file included from kernel/ksysfs.c:22:0:
> > > > > > kernel/rcu/rcu.h: In function '__rcu_reclaim':
> > > > > > kernel/rcu/rcu.h:107:3: error: implicit declaration of function 'trace_rcu_invoke_kfree_callback' [-Werror=implicit-function-declaration]
> > > > > > kernel/rcu/rcu.h:112:3: error: implicit declaration of function 'trace_rcu_invoke_callback' [-Werror=implicit-function-declaration]
> > > > > > cc1: some warnings being treated as errors
> > > > > > 
> > > > > > Looking at other rcu.h users, we can find that they all
> > > > > > were sourcing the trace header in advance of rcu.h itself,
> > > > > > as seen in the context of this diff.  There were also some
> > > > > > inconsistencies as to whether it was or wasn't sourced based
> > > > > > on the parent tracing Kconfig.
> > > > > > 
> > > > > > Rather than "fix" it at each use site, and have inconsistent
> > > > > > use based on whether "#ifdef CONFIG_RCU_TRACE" was used or not,
> > > > > > lets just source the trace header just once, in the actual consumer
> > > > > > of it, which is rcu.h itself.  We include it unconditionally, as
> > > > > > build testing shows us that is a hard requirement for some files.
> > > > > > 
> > > > > > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > > > > > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > > > > 
> > > > > Queued for 3.16, thank you, Paul!
> > > > 
> > > > Thanks!
> > > > 
> > > > I'm assuming you meant 3.15 -- unless of course you are allowing
> > > > for an insurance policy for me possibly breaking the build.  ;)
> > > 
> > > Well, it does seem to be doing better in testing.  ;-)
> > > 
> > > I split off the stuff for the 3.15 merge window a few days back, but
> > > if the lack of this patch is causing a problem, I could be talked into
> > > slipping it in.
> > 
> > And it does seem to be doing well, so I will be putting it forward for 3.15.
> 
> Great, thanks -- there was really no rush; I'd just assumed that the
> 3.16 was a typo, since I personally can't plan that far ahead.  ;)

I like to hammer new patches for a few weeks before passing them on.
My experience is that if I fail to do so, they hammer me somewhat later.  ;-)

							Thanx, Paul

