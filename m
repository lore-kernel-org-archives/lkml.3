Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3ETJ4n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 05:56:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44973 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753217Ab3ETJ4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 05:56:42 -0400
Date: Mon, 20 May 2013 10:56:06 +0100
From: Will Deacon <will.deacon@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Chen Gang <gang.chen@asianux.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: compiling issue, need
 'EXPORT_SYMBOL_GPL(read_current_timer)'
Message-ID: <20130520095606.GH31359@mudshark.cambridge.arm.com>
References: <5199C725.8050102@asianux.com>
 <168084c28e8ba5124c05553e97463172@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168084c28e8ba5124c05553e97463172@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 08:15:04AM +0100, Marc Zyngier wrote:
> On Mon, 20 May 2013 14:48:05 +0800, Chen Gang <gang.chen@asianux.com>
> wrote:
> > Need 'EXPORT_SYMBOL_GPL(read_current_timer)' if build with allmodconfig.
> > 
> > The related error:
> >   ERROR: "read_current_timer" [lib/rbtree_test.ko] undefined!
> >   ERROR: "read_current_timer" [lib/interval_tree_test.ko] undefined!
> >   ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
> >   ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
> > 
> > 
> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> > ---
> >  arch/arm64/kernel/time.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> > index a551f88..7fcba80 100644
> > --- a/arch/arm64/kernel/time.c
> > +++ b/arch/arm64/kernel/time.c
> > @@ -73,6 +73,7 @@ int read_current_timer(unsigned long *timer_value)
> >  	*timer_value = arch_timer_read_counter();
> >  	return 0;
> >  }
> > +EXPORT_SYMBOL_GPL(read_current_timer);
> >  
> >  void __init time_init(void)
> >  {
> 
> While this solves the problem, I'm not sure this is the best fix. The real
> issue is with get_cycles, which is a macro around read_current_timer.
> 
> AArch32 exports it because of the number of timer implementations. On
> arm64, we should be able to just return CNTVCT_EL0.
> 
> Catalin, Will, what do you think?

Should be ok once the arch timer driver has moved exclusively to virtual
time. I'm also not sure we even need to implement read_current_timer() --
it's only used for delay-loop calibration, which we don't need for the
arch timer.

Will
