Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935631Ab3BTDXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 22:23:55 -0500
Received: from mga11.intel.com ([192.55.52.93]:20911 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933950Ab3BTDXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 22:23:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,699,1355126400"; 
   d="scan'208";a="289369247"
Date: Wed, 20 Feb 2013 11:23:52 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: WARNING: at kernel/mutex.c:386 __mutex_lock_common()
Message-ID: <20130220032352.GA11437@localhost>
References: <20130218013720.GC10963@localhost>
 <CAMuW1wfEW2ECthuCkWW_=QimXX9xUJQNfeM9U9gNRuLaJXZ_AQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuW1wfEW2ECthuCkWW_=QimXX9xUJQNfeM9U9gNRuLaJXZ_AQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [    0.000000]
> > [    0.000000] ------------[ cut here ]------------
> > [    0.000000] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:386 __mutex_lock_common+0x5a9/0x870()
> > [    0.000000] Hardware name: Bochs
> > [    0.000000] Modules linked in:
> > [    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc7-00071-g11eb5a2 #180
> > [    0.000000] Call Trace:
> > [    0.000000]  [<ffffffff81047102>] warn_slowpath_common+0xb2/0x120
> > [    0.000000]  [<ffffffff81047195>] warn_slowpath_null+0x25/0x30
> > [    0.000000]  [<ffffffff814ebdd9>] __mutex_lock_common+0x5a9/0x870
> > [    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
> > [    0.000000]  [<ffffffff810bcb8f>] ? trace_hardirqs_off_caller+0xaf/0x120
> > [    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
> > [    0.000000]  [<ffffffff810be38c>] ? lockdep_init_map+0xfc/0x230
> > [    0.000000]  [<ffffffff814ec621>] mutex_lock_nested+0x61/0x80
> > [    0.000000]  [<ffffffff810bcc1d>] ? trace_hardirqs_off+0x1d/0x30
> > [    0.000000]  [<ffffffff81a66ef8>] rcu_cpu_notify+0xa8/0x451
> > [    0.000000]  [<ffffffff814ecc31>] ? mutex_unlock+0x11/0x20
> > [    0.000000]  [<ffffffff81a3f952>] rcu_init+0x3b3/0x408
> > [    0.000000]  [<ffffffff81a21e0c>] start_kernel+0x34a/0x744
> > [    0.000000]  [<ffffffff81a216e6>] ? repair_env_string+0x81/0x81
> > [    0.000000]  [<ffffffff81a21120>] ? early_idt_handlers+0x120/0x120
> > [    0.000000]  [<ffffffff81a212fd>] x86_64_start_reservations+0x185/0x190
> > [    0.000000]  [<ffffffff81a214a8>] x86_64_start_kernel+0x1a0/0x1b6
> > [    0.000000] ---[ end trace 8e966724b1809892 ]---
> Weird, that code path should not be hit from __mutex_lock_common from
> mutex_lock_nested, I'll create a patch with some tests to make sure
> that lib/locking-selftests.c will perform tests on common mutexes to
> ensure that code path is not hit, and this bug will not happen again.
> 
> Can you change __mutex_lock_common from inline to __always_inline and
> check if that gets rid of the warning?
 
Maarten, that trick worked! Thanks!

Fengguang
