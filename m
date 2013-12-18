Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab3LRLqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 06:46:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44272 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab3LRLqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 06:46:48 -0500
Date: Wed, 18 Dec 2013 12:46:33 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        John Stultz <john.stultz@linaro.org>, Alex Shi <alex.shi@linaro.org>,
        Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 03/13] rcu: Exclude all potential timekeepers from
 sysidle detection
Message-ID: <20131218114633.GR3694@twins.programming.kicks-ass.net>
References: <1387320692-28460-1-git-send-email-fweisbec@gmail.com>
 <1387320692-28460-4-git-send-email-fweisbec@gmail.com>
 <20131217232714.GD19211@linux.vnet.ibm.com>
 <20131217234913.GB18689@localhost.localdomain>
 <20131218114318.GR13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131218114318.GR13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 12:43:18PM +0100, Peter Zijlstra wrote:
> On Wed, Dec 18, 2013 at 12:49:15AM +0100, Frederic Weisbecker wrote:
> > That's to start simple as CPU 0 can't be offlined.
> 
> Yes it can, see CONFIG_BOOTPARAM_HOTPLUG_CPU0

Also, that's a traditional weirdness of x86. Other archs might not have
this constraint at all and can hotplug any cpu.

So relying on the fact that cpu 0 cannot be hotplugged is broken.
