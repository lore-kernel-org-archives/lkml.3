Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaJGUys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:54:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837AbaJGUyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:54:47 -0400
Date: Tue, 7 Oct 2014 16:54:34 -0400
From: Dave Jones <davej@redhat.com>
To: Meelis Roos <mroos@ut.ee>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.17
Message-ID: <20141007205434.GA25487@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Meelis Roos <mroos@ut.ee>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <alpine.LRH.2.11.1410072337230.7472@adalberg.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1410072337230.7472@adalberg.ut.ee>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 11:45:20PM +0300, Meelis Roos wrote:
 > > Anyway, back to 3.17. Nothing major happened during the last week, as
 > > you can see from the appended shortlog. Mostly drivers (i915, nouveau,
 > > ethernet, scsi, sound) and some networking fixes.  With some misc
 > > noise all over.
 > > 
 > > Go out and test,
 > 
 > Unfortunately my computer still livelocks with watchdog timeouts. The
 > previous reports are here: https://lkml.org/lkml/2014/9/28/40 and
 > https://lkml.org/lkml/2014/9/30/217 and this time the dmesg is like that 
 > (config is also below):
 > 
 > [87785.429373] Call Trace:
 > [87785.429375]  <NMI>  [<ffffffff814636f3>] ? dump_stack+0x41/0x51
 > [87785.429385]  [<ffffffff8104494d>] ? warn_slowpath_common+0x6d/0x90
 > [87785.429388]  [<ffffffff810449b7>] ? warn_slowpath_fmt+0x47/0x50
 > [87785.429392]  [<ffffffff810c60e0>] ? watchdog_overflow_callback+0x90/0xc0
 > [87785.429397]  [<ffffffff810d1a47>] ? __perf_event_overflow+0x87/0x2c0
 > [87785.429401]  [<ffffffff8101d0b5>] ? intel_pmu_handle_irq+0x1d5/0x390
 > [87785.429406]  [<ffffffff81015c86>] ? perf_event_nmi_handler+0x26/0x40
 > [87785.429410]  [<ffffffff810068e1>] ? nmi_handle+0x61/0xc0
 > [87785.429413]  [<ffffffff81006a03>] ? do_nmi+0xc3/0x340
 > [87785.429418]  [<ffffffff8146a91a>] ? end_repeat_nmi+0x1e/0x2e
 > [87785.429423]  [<ffffffff81093f7b>] ? lock_hrtimer_base.isra.29+0x1b/0x40
 > [87785.429427]  [<ffffffff81093f7b>] ? lock_hrtimer_base.isra.29+0x1b/0x40
 > [87785.429430]  [<ffffffff81093f7b>] ? lock_hrtimer_base.isra.29+0x1b/0x40
 > [87785.429432]  <<EOE>>  <IRQ>  [<ffffffff810944ba>] ? hrtimer_try_to_cancel+0x1a/0x80
 > [87785.429439]  [<ffffffff8109453a>] ? hrtimer_cancel+0x1a/0x20
 > [87785.429442]  [<ffffffff810a1a1d>] ? tick_nohz_restart+0xd/0x80
 > [87785.429445]  [<ffffffff810a1e3c>] ? __tick_nohz_full_check+0x9c/0xa0
 > [87785.429448]  [<ffffffff810c891c>] ? irq_work_run_list+0x3c/0x70
 > [87785.429451]  [<ffffffff810c8965>] ? irq_work_run+0x15/0x40
 > [87785.429454]  [<ffffffff81093aff>] ? update_process_times+0x4f/0x60
 > [87785.429457]  [<ffffffff810a1957>] ? tick_sched_timer+0x37/0x60
 > [87785.429461]  [<ffffffff810943f1>] ? __run_hrtimer.isra.32+0x41/0xf0
 > [87785.429464]  [<ffffffff8109478f>] ? hrtimer_interrupt+0xef/0x240
 > [87785.429468]  [<ffffffff8102cce6>] ? smp_apic_timer_interrupt+0x36/0x50
 > [87785.429472]  [<ffffffff81469e8a>] ? apic_timer_interrupt+0x6a/0x70
 > [87785.429473]  <EOI> 

See this thread.. https://lkml.org/lkml/2014/10/7/572

	Dave

