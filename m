Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932164Ab3BGTIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:08:00 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:49056 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758751Ab3BGTH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:07:59 -0500
Date: Thu, 7 Feb 2013 20:07:54 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ANNOUNCE] 3.8-rc6-nohz4
Message-ID: <20130207190754.GB25223@gmail.com>
References: <1360175338-6735-1-git-send-email-fweisbec@gmail.com>
 <1360205415.2621.60.camel@gandalf.local.home>
 <20130207111025.GD8945@gmail.com>
 <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hySiyn8Ci6XKFSRsMr7FabgpwSbOuNDP_GsefFDsbT2Cg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> 2013/2/7 Ingo Molnar <mingo@kernel.org>:
> >
> > * Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> >> I'll reply to this as I come up with comments.
> >>
> >> First thing is, don't call it NO_HZ_FULL. A better name would
> >> be NO_HZ_CPU. I would like to reserve NO_HZ_FULL when we
> >> totally remove jiffies :-)
> >
> > I don't think we want yet another config option named in a
> > weird way.
> >
> > What we want instead is to just split NO_HZ up into its
> > conceptual parts:
> >
> >    CONFIG_NO_HZ_IDLE
> 
> Renaming CONFIG_NO_HZ to CONFIG_NO_HZ_IDLE is something I 
> considered. I was just worried about this option being present 
> in many defconfig.

I don't think renaming it is an option - it's present not just 
in defconfigs, but in various distro configs, etc.

But we can add new config variables and use the existing 
CONFIG_NO_HZ value to set their default values.

> Perhaps we can do that renaming and keep CONFIG_NO_HZ around a 
> little while for backward compatibility (pretty much like what 
> we've done for CONFIG_PERF_COUNTERS -> CONFIG_PERF_EVENTS).

Yes.

> >    CONFIG_NO_HZ_USER_SPACE
> >    CONFIG_NO_HZ_KERNEL_SPACE
> >
> > Where the current status quo is NO_HZ_IDLE=y, and Frederic is
> > about to introduce NO_HZ_USER_SPACE=y. When jiffies get removed
> > we get NO_HZ_KERNEL_SPACE=y.
> 
> Note on my tree I stop the tick on both rings. I believe that 
> restarting the tick on kernel entry isn't something we should 
> seriously consider. It would be a costly operation that may 
> make things worse. And in fact there is no big difference. 
> Just kernelspace has more opportunities to be disturbed (RCU 
> IPIs, async timer/work scheduled by the kernel, etc...) and 
> get its tick restarted sometimes.

Ok.

Could we just simplify things and make this an unconditional 
option of NO_HZ? Any reason why we'd want to make this 
configurable, other than debugging?

I'm worried about the proliferation of not easily separable 
config options. We already have way too many timer and scheduler 
options to begin with.

> At least for now we seem to agree on CONFIG_NO_HZ_IDLE and 
> keep CONFIG_NO_HZ for compatibility. Are you ok with that? If 
> so I'll send a patch.

What would be the name of the new config option?

Can we just keep CONFIG_NO_HZ and extend it with your bits, and 
make sure they work well?

Thanks,

	Ingo
