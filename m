Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3CXIRL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 04:17:11 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:43044 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab3CXIRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 04:17:06 -0400
Date: Sun, 24 Mar 2013 09:17:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] nohz: Full dynticks base interface
Message-ID: <20130324081701.GA13328@gmail.com>
References: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363879460-21595-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Ingo,
> 
> This settles the initial ground to start a special full dynticks tree in -tip
> that we can iterate incrementally to accelerate the development.
> It is based on tip:sched/core.
> 
> I tried to rearrange a bit the naming. We are probably not yet done with
> that but I guess we can fix it along with the rest.
> 
> Please pull from:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> 	full-dynticks-for-mingo
> 
> Changes on these commits since they were part of 3.9-rc1-nohz1:
> 
> * Force a timekeeping CPU over the full dynticks range
> * Rename CONFIG_NO_HZ_FULL to CONFIG_NO_HZ_EXTENDED
> * Following *_nohz_extended_* APIs renames
> * Handle CPU hotplug for timekeeping
> * Rename full_nohz= kernel parameter to nohz_extended=

Note that boot parameters suck for pretty much any purpose but quirks - 
please also add a (default off!) Kconfig option to easily enable 
nohz_extended for all CPUs.

That way I will be able to test it automatically via randconfig and such.

My next question/request after that would be: could we make sure that 
enabling this option does not break any applications or kernel 
functionality, ASAP? Once that is offered, it becomes pushable to v3.10 I 
think.

Meanwhile I have pulled your tree into tip:sched/nohz to stage and test 
it, in the hope that it becomes mergable quickly! :-)

Thanks,

	Ingo
