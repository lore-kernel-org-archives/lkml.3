Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106AbaILTDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:03:37 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:43945 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaILTDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:03:36 -0400
Date: Fri, 12 Sep 2014 12:03:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] torture: Address race in module cleanup
Message-ID: <20140912190328.GK4775@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1410493224-3312-1-git-send-email-dave@stgolabs.net>
 <1410493224-3312-7-git-send-email-dave@stgolabs.net>
 <20140912180407.GF4775@linux.vnet.ibm.com>
 <1410546516.12906.9.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410546516.12906.9.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091219-1344-0000-0000-00000429872C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 11:28:36AM -0700, Davidlohr Bueso wrote:
> On Fri, 2014-09-12 at 11:04 -0700, Paul E. McKenney wrote:
> > On Thu, Sep 11, 2014 at 08:40:21PM -0700, Davidlohr Bueso wrote:
> > > When performing module cleanups by calling torture_cleanup() the
> > > 'torture_type' string in nullified However, callers are not necessarily
> > > done, and might still need to reference the variable. This impacts
> > > both rcutorture and locktorture, causing printing things like:
> > > 
> > > [   94.226618] (null)-torture: Stopping lock_torture_writer task
> > > [   94.226624] (null)-torture: Stopping lock_torture_stats task
> > > 
> > > Thus delay this operation until the very end of the cleanup process.
> > > The consequence (which shouldn't matter for this kid of program) is,
> > > of course, that we delay the window between rmmod and modprobing,
> > > for instance in module_torture_begin().
> > > 
> > > Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> > 
> > Good catch!  I had just been ignoring the (null), and my scripting
> > doesn't care, but it is better to have it taken care of.
> 
> In addition, for locktorture this issue can cause not only null but the
> printing the wrong cleanup string when a new module is loaded with a
> different torture_type.

That would be even more annoying.  ;-)

							Thanx, Paul

