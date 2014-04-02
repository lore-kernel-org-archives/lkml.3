Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbaDBQUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 12:20:48 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:42973 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758776AbaDBQUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 12:20:46 -0400
Date: Wed, 2 Apr 2014 09:20:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140402162043.GA11090@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140331230241.GA30019@redhat.com>
 <20140331232220.GP4284@linux.vnet.ibm.com>
 <20140331233552.GB30019@redhat.com>
 <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140401183245.GA12473@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040216-8236-0000-0000-0000013D5620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 11:32:45AM -0700, Paul E. McKenney wrote:
> On Tue, Apr 01, 2014 at 02:04:14PM -0400, Dave Jones wrote:
> > On Tue, Apr 01, 2014 at 10:55:45AM -0700, Paul E. McKenney wrote:

[ . . . ]

> >  > Waiting uninterruptibly.  Presumably blocked on mutex_lock().  But
> >  > you have CONFIG_PROVE_LOCKING(), so any deadlocks should have been
> >  > reported.
> > 
> > Lockdep had reported something a little earlier (timestamped at 1108.xxxxxx)
> > but that's a known false-positive in xfs.
> 
> Yep, I would be very surprised if that was related to the grace-period hang.

Ah, but it could be suppressing later lockdep splats.  So if this can be
reproduced without xfs, we might get additional information from lockdep.

							Thanx, Paul

