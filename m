Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505AbaDBWsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:48:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54078 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932414AbaDBWst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:48:49 -0400
Date: Wed, 2 Apr 2014 18:48:40 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140402224840.GA5385@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140331232220.GP4284@linux.vnet.ibm.com>
 <20140331233552.GB30019@redhat.com>
 <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
 <20140402162043.GA11090@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140402162043.GA11090@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 09:20:43AM -0700, Paul E. McKenney wrote:
 > On Tue, Apr 01, 2014 at 11:32:45AM -0700, Paul E. McKenney wrote:
 > > On Tue, Apr 01, 2014 at 02:04:14PM -0400, Dave Jones wrote:
 > > > On Tue, Apr 01, 2014 at 10:55:45AM -0700, Paul E. McKenney wrote:
 > 
 > [ . . . ]
 > 
 > > >  > Waiting uninterruptibly.  Presumably blocked on mutex_lock().  But
 > > >  > you have CONFIG_PROVE_LOCKING(), so any deadlocks should have been
 > > >  > reported.
 > > > 
 > > > Lockdep had reported something a little earlier (timestamped at 1108.xxxxxx)
 > > > but that's a known false-positive in xfs.
 > > 
 > > Yep, I would be very surprised if that was related to the grace-period hang.
 > 
 > Ah, but it could be suppressing later lockdep splats.  So if this can be
 > reproduced without xfs, we might get additional information from lockdep.

Hrmph.

$ git bisect bad
The merge base 5cb480f6b488128140c940abff3c36f524a334a8 is bad.
This means the bug has been fixed between 5cb480f6b488128140c940abff3c36f524a334a8 and [455c6fdbd219161bd09b1165f11699d6d73de11c 62c206bd514600d4d73751ade00dca8e488390a3 e086481baf9d0436bdd6e9b739bfa4a83fb89ef5].

Not sure where to go from here..

The 'good' news is I can reproduce it pretty reliably now.
I start my fuzz tester, and immediately do a git diff in my working tree,
and then boom..

	Dave

