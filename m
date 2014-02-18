Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaBRXxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 18:53:51 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44897 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaBRXxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 18:53:50 -0500
Date: Tue, 18 Feb 2014 15:53:40 -0800
From: josh@joshtriplett.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 17/55] rcutorture: Abstract torture_param()
Message-ID: <20140218235340.GA25804@cloud>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392675179-11560-17-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140218002301.GD19929@thin>
 <20140218213147.GX4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218213147.GX4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 01:31:47PM -0800, Paul E. McKenney wrote:
> On Mon, Feb 17, 2014 at 04:23:01PM -0800, Josh Triplett wrote:
> > On Mon, Feb 17, 2014 at 02:12:21PM -0800, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Create a torture_param() macro and apply it to rcutorture in order to
> > > save a few lines of code.  This same macro may be applied to other
> > > torture frameworks.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Your commit message says "torture_param", but your code says
> > "torture_parm".  Let's go with the former, please; no need to creat more
> > disemvoweled abbreviations.
> 
> Gd pnt, fxd s sggstd.

Thnks!

> > Also, this seems rather generally useful.  A quick check with "git grep
> > -B2 MODULE_PARM_DESC" turns up numerous instances of the pattern.  You
> > might consider adding this as a helper DECLARE_MODULE_PARAM_RO in
> > include/linux/moduleparam.h (possibly calling a generalized version that
> > takes the mode as another parameter).
> 
> Added to the todo list.  Another parameter is static vs. not -- I only
> had one non-static instance, which I left open-coded.

I debated that one.  You could leave out the "static" and just write
"static DECLARE_MODULE_PARAM_RO", but given that you almost always
*want* static for a module parameter...

- Josh Triplett
