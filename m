Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404AbaKTQTh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:19:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862AbaKTQTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:19:36 -0500
Date: Thu, 20 Nov 2014 11:19:25 -0500
From: Dave Jones <davej@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120161925.GB8309@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	the arch/x86 maintainers <x86@kernel.org>
References: <20141114213124.GB3344@redhat.com>
 <CA+55aFx16ks_azU0eAcx+qZ5-o8Xo0zzP6aNjrskai8rqp+eMg@mail.gmail.com>
 <20141115213405.GA31971@redhat.com>
 <20141116014006.GA5016@redhat.com>
 <CA+55aFwLH6zGf7O=o2+H0Z8=8nW4zwUbw3Q4bJGttHACv9g+FQ@mail.gmail.com>
 <20141117170359.GA1382@redhat.com>
 <20141120150757.GE2542@lerouge>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120150757.GE2542@lerouge>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 04:08:00PM +0100, Frederic Weisbecker wrote:
 
 > > Great start to the week: I decided to confirm my recollection that .17
 > > was ok, only to hit this within 10 minutes.
 > > 
 > > Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 3
 > > CPU: 3 PID: 17176 Comm: trinity-c95 Not tainted 3.17.0+ #87
 > >  0000000000000000 00000000f3a61725 ffff880244606bf0 ffffffff9583e9fa
 > >  ffffffff95c67918 ffff880244606c78 ffffffff9583bcc0 0000000000000010
 > >  ffff880244606c88 ffff880244606c20 00000000f3a61725 0000000000000000
 > > Call Trace:
 > >  <NMI>  [<ffffffff9583e9fa>] dump_stack+0x4e/0x7a
 > >  [<ffffffff9583bcc0>] panic+0xd4/0x207
 > >  [<ffffffff95150908>] watchdog_overflow_callback+0x118/0x120
 > >  [<ffffffff95193dbe>] __perf_event_overflow+0xae/0x340
 > >  [<ffffffff95192230>] ? perf_event_task_disable+0xa0/0xa0
 > >  [<ffffffff9501a7bf>] ? x86_perf_event_set_period+0xbf/0x150
 > >  [<ffffffff95194be4>] perf_event_overflow+0x14/0x20
 > >  [<ffffffff95020676>] intel_pmu_handle_irq+0x206/0x410
 > >  [<ffffffff9501966b>] perf_event_nmi_handler+0x2b/0x50
 > >  [<ffffffff95007bb2>] nmi_handle+0xd2/0x390
 > >  [<ffffffff95007ae5>] ? nmi_handle+0x5/0x390
 > >  [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 > >  [<ffffffff950080a2>] default_do_nmi+0x72/0x1c0
 > >  [<ffffffff950082a8>] do_nmi+0xb8/0x100
 > >  [<ffffffff9584b9aa>] end_repeat_nmi+0x1e/0x2e
 > >  [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 > >  [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 > >  [<ffffffff958489b0>] ? _raw_spin_lock_irqsave+0x80/0x90
 > >  <<EOE>>  <IRQ>  [<ffffffff95101685>] lock_hrtimer_base.isra.18+0x25/0x50
 > >  [<ffffffff951019d3>] hrtimer_try_to_cancel+0x33/0x1f0
 > 
 > Ah that one got fixed in the merge window and in -stable, right?
 
If that's true, that changes everything, and this might be more
bisectable.  I did the test above on 3.17, but perhaps I should
try a run on 3.17.3

	Dave

