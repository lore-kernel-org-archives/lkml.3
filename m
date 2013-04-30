Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab3D3U0b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 16:26:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933325Ab3D3U03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 16:26:29 -0400
Date: Tue, 30 Apr 2013 16:24:40 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: rcu: Provide compile-time control for no-CBs CPUs
Message-ID: <20130430202440.GA18598@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	paul.mckenney@linaro.org, mmarek@suse.cz,
	linux-kbuild@vger.kernel.org
References: <20130430152126.0C564660906@gitolite.kernel.org>
 <20130430184612.GA14568@redhat.com>
 <20130430192541.GE3780@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430192541.GE3780@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 12:25:41PM -0700, Paul E. McKenney wrote:
 > On Tue, Apr 30, 2013 at 02:46:12PM -0400, Dave Jones wrote:

 > > Additionally, nowhere in any of this text does it say what a "no-CB CPU" is,
 > > or why I would care, or even what the downsides are for each option.
 > 
 > In the absence of any Kconfig change, would the following be more helpful?

A little. You've now documented the mechanism behind each choice,
but there's still no real explanation why I would pick one over the other.
The average reader of these texts isn't going to know whether running something
from a kthread is a better/worse idea than running from softirq context.

Who doesn't like saving energy ? Why would I leave it at the NONE default ?
Why is it even an option ? I'm assuming there's a reason we don't pick
(one of the) energy efficient options by default (performance?) who knows,
there's no explanation.

Why would I want to treat CPU0 differently ? What user-visible downsides
are there ? Who knows..

 > +choice
 > +	prompt "Build-forced no-CBs CPUs"
 > +	default RCU_NOCB_CPU_NONE
 > +	help
 > +	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
 > +	  from kthreads rather than from softirq context) to be specified
 > +	  at build time.  Additional no-CBs CPUs may be specified by
 > +	  the rcu_nocbs= boot parameter.
 > +
 > +config RCU_NOCB_CPU_NONE
 > +	bool "No build_forced no-CBs CPUs"
 > +	depends on RCU_NOCB_CPU
 > +	help
 > +	  This option does not force any of the CPUs to be no-CBs CPUs.
 > +	  Only CPUs designated by the rcu_nocbs= boot parameter will be
 > +	  no-CBs CPUs, whose RCU callbacks will be invoked by per-CPU
 > +	  rcuo kthreads.  All other CPUs will invoke their own RCU
 > +	  callbacks in softirq context.
 > +
 > +config RCU_NOCB_CPU_ZERO
 > +	bool "CPU 0 is a build_forced no-CBs CPU"
 > +	depends on RCU_NOCB_CPU
 > +	help
 > +	  This option forces CPU 0 to be a no-CBs CPU, so that its
 > +	  RCU callbacks are invoked by a per-CPU rcuo kthread.
 > +	  Additional CPUs may be designated as no-CBs CPUs using the
 > +	  rcu_nocbs= boot parameter will be no-CBs CPUs.  All other CPUs
 > +	  will invoke their own RCU callbacks in softirq context.
 > +
 > +	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
 > +	  or energy-efficiency reasons.
 > +
 > +config RCU_NOCB_CPU_ALL
 > +	bool "All CPUs are build_forced no-CBs CPUs"
 > +	depends on RCU_NOCB_CPU
 > +	help
 > +	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
 > +	  boot parameter will be ignored.  All CPUs' RCU callbacks will
 > +	  be executed in the context of per-CPU rcuo kthreads created
 > +	  for this purpose.
 > +
 > +	  Select this if all CPUs need to be no-CBs CPUs for real-time
 > +	  or energy-efficiency reasons.

I know how much IBMers love their acronyms. I thought you'd invented
some new rcu variant for a moment. Perhaps "kthreads named 'rcuo'"
would be clearer ?

	Dave

