Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab3ETSOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 14:14:31 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:43744 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab3ETSOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 14:14:30 -0400
Date: Mon, 20 May 2013 20:14:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/8] watchdog: Boot-disable by default on full dynticks
Message-ID: <20130520181424.GA22846@somewhere>
References: <1369065716-22801-1-git-send-email-fweisbec@gmail.com>
 <1369065716-22801-4-git-send-email-fweisbec@gmail.com>
 <20130520175229.GI133453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130520175229.GI133453@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 01:52:29PM -0400, Don Zickus wrote:
> On Mon, May 20, 2013 at 06:01:51PM +0200, Frederic Weisbecker wrote:
> > When the watchdog runs, it prevents the full dynticks
> > CPUs from stopping their tick because the hard lockup
> > detector uses perf events internally, which in turn
> > rely on the periodic tick.
> > 
> > Since this is a rather confusing behaviour that is not
> > easy to track down and identify for those who want to
> > test CONFIG_NO_HZ_FULL, let's default disable the
> > watchdog on boot time when full dynticks is enabled.
> > 
> > The user can still enable it later on runtime using
> > proc or sysctl.
> 
> I thought Peter committed a patch to perf so that this isn't needed any
> more?

There is the patchset that converts perf_event_task_tick() to an hrtimer.
But I'm not sure it covers everything. Also this will be for the next merge
window. And in the end this moves the problem elsewhere: we still have timer
interrupts, they just come as specific hrtimers, although may be less often,
I haven't looked yet at the patchset.
