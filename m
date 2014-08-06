Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594AbaHFQXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 12:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbaHFQXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 12:23:37 -0400
Date: Wed, 6 Aug 2014 12:23:08 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: perf related boot hang.
Message-ID: <20140806162308.GD14261@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140806143621.GA13832@redhat.com>
 <20140806161934.GF19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140806161934.GF19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 06:19:34PM +0200, Peter Zijlstra wrote:
 > On Wed, Aug 06, 2014 at 10:36:21AM -0400, Dave Jones wrote:
 > > On Linus current tree, when I cold-boot one of my boxes, it locks up
 > > during boot up with this trace..
 > > 
 > > Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 2
 > > CPU: 2 PID: 577 Comm: in:imjournal Not tainted 3.16.0+ #33
 > >  ffff880244c06c88 000000008b73013e ffff880244c06bf0 ffffffffb47ee207
 > >  ffffffffb4c51118 ffff880244c06c78 ffffffffb47ebcf8 0000000000000010
 > >  ffff880244c06c88 ffff880244c06c20 000000008b73013e 0000000000000000
 > > Call Trace:
 > >  <NMI>  [<ffffffffb47ee207>] dump_stack+0x4e/0x7a
 > >  [<ffffffffb47ebcf8>] panic+0xd4/0x207
 > >  [<ffffffffb4145448>] watchdog_overflow_callback+0x118/0x120
 > >  [<ffffffffb4186f0e>] __perf_event_overflow+0xae/0x350
 > >  [<ffffffffb4185380>] ? perf_event_task_disable+0xa0/0xa0
 > >  [<ffffffffb401a4ef>] ? x86_perf_event_set_period+0xbf/0x150
 > >  [<ffffffffb4187d34>] perf_event_overflow+0x14/0x20
 > >  [<ffffffffb40203a6>] intel_pmu_handle_irq+0x206/0x410
 > >  [<ffffffffb401939b>] perf_event_nmi_handler+0x2b/0x50
 > >  [<ffffffffb4007b72>] nmi_handle+0xd2/0x390
 > >  [<ffffffffb4007aa5>] ? nmi_handle+0x5/0x390
 > >  [<ffffffffb40d8301>] ? lock_acquired+0x131/0x450
 > >  [<ffffffffb4008062>] default_do_nmi+0x72/0x1c0
 > > 
 > > 
 > > If I reset it, it then seems to always boot up fine.
 > 
 > Uhm,. cute! And that's the entire stacktrace? It would seem to me there
 > would be at least a 'task' context below that. CPUs simply do not _only_
 > run NMI code, and that trace starts at default_do_nmi().
 
There may have been more to follow, but the machine had locked up solid,
so I couldn't get any more output.  Next time I see it, I'll go check
the console to see if there's anything extra.

Curiously, I just hit another NMI related bug (see other mail) while fuzzing.

	Dave

