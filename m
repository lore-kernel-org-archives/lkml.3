Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbaIPQIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:08:30 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:59056 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753050AbaIPQI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:08:26 -0400
Date: Tue, 16 Sep 2014 17:07:59 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Will Deacon <will.deacon@arm.com>
Cc: Joe Perches <joe@perches.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/8] arm: Convert pr_warning to pr_warn
Message-ID: <20140916160759.GJ12361@n2100.arm.linux.org.uk>
References: <cover.1410632834.git.joe@perches.com> <7995478e8c658478cd37dabb996f7269405251ac.1410632835.git.joe@perches.com> <20140915155656.GA29744@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915155656.GA29744@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 04:56:56PM +0100, Will Deacon wrote:
> On Sat, Sep 13, 2014 at 07:31:12PM +0100, Joe Perches wrote:
> > Use the more common pr_warn.
> > 
> > Other miscellanea:
> > 
> > o Coalesce formats
> > o Realign arguments
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  arch/arm/include/asm/syscall.h   |  8 ++++----
> >  arch/arm/kernel/atags_parse.c    |  2 +-
> >  arch/arm/kernel/hw_breakpoint.c  | 18 +++++++++---------
> >  arch/arm/kernel/irq.c            |  4 ++--
> >  arch/arm/kernel/perf_event_cpu.c |  4 ++--
> >  arch/arm/kernel/smp.c            |  2 +-
> >  arch/arm/kernel/unwind.c         | 24 ++++++++++++------------
> >  arch/arm/mm/idmap.c              |  2 +-
> >  arch/arm/mm/mmu.c                |  4 ++--
> >  9 files changed, 34 insertions(+), 34 deletions(-)
> 
> It's Russell's call on this, but it really looks like more trouble than it's
> worth imo. Having git blame identify the person who wrote the original code
> is considerably more useful than being pointed at somebody making cosmetic
> changes.

I have no objection to this patch set, but I'll echo Will's comment
that having git blame identify who wrote the code is useful.

However, removing old cruft is also a useful exercise, as it keeps
things simpler (because we're not carrying around lots of excess
baggage.)  So, I think on balance it's worth the churn.

Joe, any chance you could add a KernelVersion: tag somewhere in the
commit message and throw it at patches@arm.linux.org.uk so it doesn't
get lost?

Thanks.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
