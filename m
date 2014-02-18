Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaBRAXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:23:17 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:46628 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaBRAXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:23:15 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 16:23:01 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 17/55] rcutorture: Abstract torture_param()
Message-ID: <20140218002301.GD19929@thin>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392675179-11560-17-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392675179-11560-17-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 02:12:21PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> Create a torture_param() macro and apply it to rcutorture in order to
> save a few lines of code.  This same macro may be applied to other
> torture frameworks.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Your commit message says "torture_param", but your code says
"torture_parm".  Let's go with the former, please; no need to creat more
disemvoweled abbreviations.

Also, this seems rather generally useful.  A quick check with "git grep
-B2 MODULE_PARM_DESC" turns up numerous instances of the pattern.  You
might consider adding this as a helper DECLARE_MODULE_PARAM_RO in
include/linux/moduleparam.h (possibly calling a generalized version that
takes the mode as another parameter).

- Josh Triplett
