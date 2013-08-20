Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238Ab3HTSuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:50:11 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33578 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab3HTSuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:50:10 -0400
Date: Tue, 20 Aug 2013 21:48:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: [sched next] overflowed cpu time for kernel threads in
 /proc/PID/stat
Message-ID: <20130820184858.GA2272@swordfish>
References: <20130820111426.GA27828@swordfish.datadirectnet.com>
 <20130820151509.GA17441@somewhere>
 <20130820153549.GB2315@swordfish.minsk.epam.com>
 <20130820154257.GD17441@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820154257.GD17441@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (08/20/13 17:42), Frederic Weisbecker wrote:
> On Tue, Aug 20, 2013 at 06:35:50PM +0300, Sergey Senozhatsky wrote:
> > On (08/20/13 17:15), Frederic Weisbecker wrote:
> > > On Tue, Aug 20, 2013 at 02:14:26PM +0300, Sergey Senozhatsky wrote:
> > > Hello,
> > > 
> > > Please upload your config.
> > > 
> > > I'm adding Stanislaw in Cc in case it relates to cputime scaling.
> > >
> > 
> > please find attached.
> > 
> > 	-ss
> 
> > #
> > # CPU/Task time and stats accounting
> > #
> > CONFIG_VIRT_CPU_ACCOUNTING=y
> > CONFIG_VIRT_CPU_ACCOUNTING_GEN=y
> 
> So it happens with full dynticks cputime accounting.
> How reproducable is this? Does it always happen?
> Does it happen with CONFIG_TICK_CPU_ACCOUNTING as well? (you'll
> need to deactivate full dynticks.)
> 
> Thanks.
>

with full dynticks disabled:

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_HZ_PERIODIC=y
# CONFIG_NO_HZ_IDLE is not set
# CONFIG_NO_HZ_FULL is not set
# CONFIG_NO_HZ is not set
CONFIG_HIGH_RES_TIMERS=y

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
CONFIG_TASK_IO_ACCOUNTING=y


everything looks fine (no overflow).

	-ss

