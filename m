Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaKZAEm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 19:04:42 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56151 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaKZAEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 19:04:40 -0500
Date: Tue, 25 Nov 2014 16:04:33 -0800
From: josh@joshtriplett.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Catalina Mocanu <catalina.mocanu@gmail.com>
Subject: Re: linux-next: manual merge of the tiny tree with the tip tree
Message-ID: <20141126000433.GA25720@cloud>
References: <20141125101044.GA20465@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125101044.GA20465@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 11:10:44AM +0100, Ingo Molnar wrote:
> * Josh Triplett <josh@joshtriplett.org> wrote:
> > On Tue, Nov 25, 2014 at 07:16:45AM +0100, Ingo Molnar wrote:
> > > * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > Hi Josh,
> > > > 
> > > > Today's linux-next merge of the tiny tree got a conflict in
> > > > kernel/time/Makefile between commit fd866e2b116b ("time: Rename
> > > > udelay_test.c to test_udelay.c") from the tip tree and commit
> > > > d1f6d68d03ea ("kernel: time: Compile out NTP support") from the tiny
> > > > tree.
> > > 
> > > So I think a timer subsystem commit d1f6d68d03ea with this 
> > > magnitude of linecount increase:
> > > 
> > >  Signed-off-by: Catalina Mocanu <catalina.mocanu@gmail.com>
> > >  [josh: Handle CONFIG_COMPAT=y.]
> > >  Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > >  Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> > >  ---
> > >   drivers/pps/Kconfig        |  2 +-
> > >   include/linux/timex.h      | 15 +++++++++++++--
> > >   init/Kconfig               | 10 ++++++++++
> > >   kernel/compat.c            |  8 ++++++--
> > >   kernel/sys_ni.c            |  4 ++++
> > >   kernel/time/Makefile       |  3 ++-
> > >   kernel/time/ntp_internal.h | 28 ++++++++++++++++++++++++++++
> > >   kernel/time/posix-timers.c |  2 ++
> > >   kernel/time/time.c         |  2 ++
> > >   kernel/time/timekeeping.c  |  2 ++
> > >   10 files changed, 70 insertions(+), 6 deletions(-)
> > > 
> > > at minimum needs the ack of timer folks, before it can be 
> > > committed to Git. Or is the tiny tree plan to submit all
> > > patches to the appropriate subsystem or gather acks, before 
> > > sending it upstream?
> > 
> > Yes, absolutely.  I planned to send out a tinification patch 
> > review series later this week with all 10 current patches (both 
> > those reviewed on LKML and those only reviewed elsewhere).
> 
> But, but: _please_ don't push patches towards linux-next that 
> haven't been acked by maintainers.
[...snip clear explanation of linux-next...]

Thanks for the clarification, Ingo!  Mind if I use your explanation as
the basis for additional documentation of linux-next?

I've moved the tiny/next branch of my tree to tiny/work, and I'll make
sure that tiny/next only gets patches that have gotten all the necessary
reviews.

- Josh Triplett
