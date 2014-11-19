Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319AbaKSToW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 14:44:22 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:37126 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbaKSToT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 14:44:19 -0500
Date: Wed, 19 Nov 2014 11:44:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Chuck Ebbert <cebbert.lkml@gmail.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
Message-ID: <20141119194414.GN5050@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141013022454.289398272@linuxfoundation.org>
 <20141013112834.GA10826@khazad-dum.debian.net>
 <20141013082319.175d90bb@as>
 <20141119172235.GA31260@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119172235.GA31260@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111919-0033-0000-0000-000002BF44D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 09:22:35AM -0800, Greg Kroah-Hartman wrote:
> On Mon, Oct 13, 2014 at 08:23:19AM -0500, Chuck Ebbert wrote:
> > On Mon, 13 Oct 2014 08:28:35 -0300
> > Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > 
> > > On Mon, 13 Oct 2014, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 3.17.1
> > > > release. There are 25 patches in this series, all will be posted
> > > > as a response to this one.  If anyone has any issues with these
> > > > being applied, please let me know.
> > > 
> > > Actually, 3.17 is a filesystem killer for some unlucky users due to
> > > the libata blacklist being disabled by a bug.
> > > 
> > > Patch:
> > > https://git.kernel.org/cgit/linux/kernel/git/tj/libata.git/patch/?id=1c40279960bcd7d52dbdf1d466b20d24b99176c8
> > > 1c40279960bcd7d52dbdf1d466b20d24b99176c8 (libata: Un-break ATA
> > > blacklist)
> > > 
> > 
> > There are some more bugs too:
> > 
> > 
> > RCU stalls, fix has been in rcu/urgent for 7 days:
> > https://git.kernel.org/cgit/linux/kernel/git/paulmck/linux-rcu.git/commit/?h=rcu/urgent&id=789cbbeca4eb7141cbd748ee93772471101b507b
> 
> Doesn't build in 3.17 properly :(
> 
> > blk-mq bio merging (still no good fix available):
> > https://lkml.org/lkml/2014/10/9/729
> > (The fix sitting in the block tree:
> > https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git/commit/?h=for-3.18/core&id=764f612c6c3c231b9c12cfae7c328ccc9c453258
> > is wrong according to that message.)
> 
> Did this ever get resolved?
> 
> > Stalls when using nohz, requires series of six patches to fix that
> > didn't make 3.17 and weren't marked for -stable:
> > 
> > From a80e49e2cc3145af014a8ae44f575829cc236192 Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: nohz: Move nohz full init call to tick init
> > 
> > From c5c38ef3d70377dc504a6a3f611a3ec814bc757b Mon Sep 17 00:00:00 2001
> > From: Peter Zijlstra <peterz@infradead.org>
> > Subject: irq_work: Introduce arch_irq_work_has_interrupt()
> > 
> > From 76a33061b9323b7fdb220ae5fa116c10833ec22e Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: irq_work: Force raised irq work to run on irq work interrupt
> > 
> > From 3010279f0fc36f0388872203e63ca49912f648fd Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: x86: Tell irq work about self IPI support
> > 
> > From 09f6edd424218eb69078551b2ecfada1f2d098eb Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: arm: Tell irq work about self IPI support
> > 
> > From 3631073659d0aafeaa52227bb61a100efaf901dc Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> To: 09f6edd424218eb69078551b2ecfada1f2d098eb
> To: Chuck Ebbert <cebbert.lkml@gmail.com>
> Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
> 	linux-kernel@vger.kernel.org, stable@kernel.org
> Bcc: 
> Subject: Re: [PATCH 3.17 00/25] 3.17.1-stable review
> Reply-To: 
> In-Reply-To: <20141013082319.175d90bb@as>
> 
> On Mon, Oct 13, 2014 at 08:23:19AM -0500, Chuck Ebbert wrote:
> > On Mon, 13 Oct 2014 08:28:35 -0300
> > Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > 
> > > On Mon, 13 Oct 2014, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 3.17.1
> > > > release. There are 25 patches in this series, all will be posted
> > > > as a response to this one.  If anyone has any issues with these
> > > > being applied, please let me know.
> > > 
> > > Actually, 3.17 is a filesystem killer for some unlucky users due to
> > > the libata blacklist being disabled by a bug.
> > > 
> > > Patch:
> > > https://git.kernel.org/cgit/linux/kernel/git/tj/libata.git/patch/?id=1c40279960bcd7d52dbdf1d466b20d24b99176c8
> > > 1c40279960bcd7d52dbdf1d466b20d24b99176c8 (libata: Un-break ATA
> > > blacklist)
> > > 
> > 
> > There are some more bugs too:
> > 
> > 
> > RCU stalls, fix has been in rcu/urgent for 7 days:
> > https://git.kernel.org/cgit/linux/kernel/git/paulmck/linux-rcu.git/commit/?h=rcu/urgent&id=789cbbeca4eb7141cbd748ee93772471101b507b
> 
> Doesn't build in 3.17 properly :(

Older kernels can use rcu_note_context_switch() instead of
rcu_note_voluntary_context_switch(), which didn't show up until quite
recently.  Please note that rcu_note_context_switch() is quite a bit
more heavy-weight than is rcu_note_voluntary_context_switch(), but it
should be OK in this context.

							Thanx, Paul

> > blk-mq bio merging (still no good fix available):
> > https://lkml.org/lkml/2014/10/9/729
> > (The fix sitting in the block tree:
> > https://git.kernel.org/cgit/linux/kernel/git/axboe/linux-block.git/commit/?h=for-3.18/core&id=764f612c6c3c231b9c12cfae7c328ccc9c453258
> > is wrong according to that message.)
> 
> Did this ever get resolved?
> 
> > Stalls when using nohz, requires series of six patches to fix that
> > didn't make 3.17 and weren't marked for -stable:
> > 
> > From a80e49e2cc3145af014a8ae44f575829cc236192 Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: nohz: Move nohz full init call to tick init
> > 
> > From c5c38ef3d70377dc504a6a3f611a3ec814bc757b Mon Sep 17 00:00:00 2001
> > From: Peter Zijlstra <peterz@infradead.org>
> > Subject: irq_work: Introduce arch_irq_work_has_interrupt()
> > 
> > From 76a33061b9323b7fdb220ae5fa116c10833ec22e Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: irq_work: Force raised irq work to run on irq work interrupt
> > 
> > From 3010279f0fc36f0388872203e63ca49912f648fd Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: x86: Tell irq work about self IPI support
> > 
> > From 09f6edd424218eb69078551b2ecfada1f2d098eb Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: arm: Tell irq work about self IPI support
> > 
> > From 3631073659d0aafeaa52227bb61a100efaf901dc Mon Sep 17 00:00:00 2001
> > From: Frederic Weisbecker <fweisbec@gmail.com>
> > Subject: arm64: Tell irq work about self IPI support
> 
> These are pretty intrusive, maybe 3.18 is better for people to use :)
> 
> If Frederic says it's ok for me to backport these, I will, but I want
> his ack first.
> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

