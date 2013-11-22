Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab3KVRRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 12:17:36 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:59497 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755530Ab3KVRRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:17:34 -0500
Date: Fri, 22 Nov 2013 09:17:27 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 3/7] idle, thermal, acpi: Remove home grown idle
 implementations
Message-ID: <20131122171727.GT4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131120165406.14fa0f09@ultegra>
 <20131121082151.GU10022@twins.programming.kicks-ass.net>
 <20131121160716.GT4138@linux.vnet.ibm.com>
 <528E32EF.2050300@linux.intel.com>
 <20131121191916.GZ4138@linux.vnet.ibm.com>
 <528E62D0.3010003@linux.intel.com>
 <20131121200717.GB4138@linux.vnet.ibm.com>
 <20131121161005.34150ab2@ultegra>
 <20131122042036.GL4138@linux.vnet.ibm.com>
 <20131122113300.GM10022@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131122113300.GM10022@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13112217-9332-0000-0000-0000024413D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 12:33:00PM +0100, Peter Zijlstra wrote:
> On Thu, Nov 21, 2013 at 08:20:36PM -0800, Paul E. McKenney wrote:
> > The 6ms to 25ms range should be just fine as far as normal RCU grace
> > periods are concerned.  However, it does mean that expedited grace
> > periods could be delayed: They normally take a few tens of microseconds,
> > but if they were unlucky enough to show up during an idle injection,
> > they would be magnified by two to three orders of magnitude, which is
> > not pretty.
> > 
> > Hence my suggestion of hooking into RCU on idle-injection start and end
> > so that RCU considers that time period to be idle.  Just like it does
> > for user-mode execution on NO_HZ_FULL kernels, so I still don't see this
> > approach to be a problem.  I must confess that I still don't understand
> > what Arjan doesn't like about it.
> 
> Using these patches it would indeed use the RCU idle machinery as per
> the normal idle path.

OK, sorry for my confusion!

> If you can I can add more WARN_ON()s in play_idle() to ensure we're not
> called while holding any RCU locks.

An rcu_sleep_check() or something similar, please!

							Thanx, Paul

