Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbaGKSKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:10:46 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:35111 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbaGKSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:10:45 -0400
Date: Fri, 11 Jul 2014 13:10:41 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 11/17] rcu: Bind grace-period kthreads to
 non-NO_HZ_FULL CPUs
In-Reply-To: <20140708183846.GJ6571@localhost.localdomain>
Message-ID: <alpine.DEB.2.11.1407111309150.4777@gentwo.org>
References: <20140707223756.GA7187@linux.vnet.ibm.com> <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com> <1404772701-8804-11-git-send-email-paulmck@linux.vnet.ibm.com> <20140708152358.GF6571@localhost.localdomain> <20140708154723.GN4603@linux.vnet.ibm.com>
 <20140708183846.GJ6571@localhost.localdomain>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Frederic Weisbecker wrote:

> > I was figuring that a fair number of the kthreads might eventually
> > be using this, not just for the grace-period kthreads.
>
> Ok makes sense. But can we just rename the cpumask to housekeeping_mask?

That would imply that all no-nohz processors are housekeeping? So all
processors with a tick are housekeeping?

Could we make that set configurable? Ideally I'd like to have the ability
restrict the housekeeping to one processor.

