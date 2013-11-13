Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455Ab3KMQSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:18:39 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36174 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757003Ab3KMQSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:18:37 -0500
Date: Wed, 13 Nov 2013 08:18:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Matthew Whitehead <tedheadster@gmail.com>, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20131113161829.GE4138@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131113113927.GA13875@mwhitehe.csb>
 <alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
 <20131113102153.5f10e6b5@gandalf.local.home>
 <20131113103134.5b8cf02f@gandalf.local.home>
 <20131113105737.3f7a0b1b@gandalf.local.home>
 <alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
 <20131113111257.482c2955@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113111257.482c2955@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111316-8236-0000-0000-000003BE99AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 11:12:57AM -0500, Steven Rostedt wrote:
> On Wed, 13 Nov 2013 17:07:18 +0100 (CET)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> 
> > Right. It's telling you if NOHZ is enabled. It's not telling you that
> > NOHZ is active.
> 
> Yeah, which makes this code rather silly:
> 
> in rcu_prepare_for_idle():
> 
> 	/* Handle nohz enablement switches conservatively. */
> 	tne = ACCESS_ONCE(tick_nohz_enabled);
> 	if (tne != rdtp->tick_nohz_enabled_snap) {
> 		if (rcu_cpu_has_callbacks(cpu, NULL))
> 			invoke_rcu_core(); /* force nohz to see update. */
> 		rdtp->tick_nohz_enabled_snap = tne;
> 		return;
> 	}

OK, what should I be checking instead?  Not much point in trying to
get RCU out of the way of disabling the scheduling-clock interrupt
if NOHZ is disabled.  ;-)

							Thanx, Paul

