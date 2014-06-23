Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbaFWNxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:53:17 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:48546 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753837AbaFWNxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:53:15 -0400
Date: Mon, 23 Jun 2014 08:53:12 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, dave.hansen@intel.com,
        ak@linux.intel.com, umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
In-Reply-To: <20140621060625.GG4615@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1406230851120.2892@gentwo.org>
References: <20140621025958.GA7185@linux.vnet.ibm.com> <20140621042958.GA4515@thin> <20140621060625.GG4615@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jun 2014, Paul E. McKenney wrote:

> > I like this approach *far* better.  This is the kind of thing I had in
> > mind when I suggested using the fqs machinery: remove the poll entirely
> > and just thwack a CPU if it takes too long without a quiescent state.
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
>
> Glad you like it.  Not a fan of the IPI myself, but then again if you
> are spending that must time looping in the kernel, an extra IPI is the
> least of your problems.

Good. The IPI is only used when actually necessary. The code inserted
was always there and always executed although rarely needed.

