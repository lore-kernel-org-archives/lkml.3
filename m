Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3I2Fi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 01:38:56 -0400
Received: from one.firstfloor.org ([193.170.194.197]:32931 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3I2Fiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 01:38:54 -0400
Date: Sun, 29 Sep 2013 07:38:52 +0200
From: Andi Kleen <andi@firstfloor.org>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: x86 force enabling perf events
Message-ID: <20130929053852.GS18242@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Frederic,

I noticed that an allnoconfig x86 build builds perf events.

I think it comes from this commit of yours:

commit 99e8c5a3b875a34d894a711c9a3669858d6adf45
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Thu Dec 17 01:33:54 2009 +0100

    hw-breakpoints: Fix hardware breakpoints -> perf events dependency
    
    The kbuild's select command doesn't propagate through the config
    dependencies.
    
    Hence the current rules of hardware breakpoint's config can't
    ensure perf can never be disabled under us.

Given that perf is quite big these days, and there are likely a lot of systems
which don't need it (everything which noone does development with) 
that seems very drastic.

Is there a way to solve your old build problem without that
unconditional select?

   text    data     bss     dec     hex filename
  40154     879     216   41249    a121 kernel/events/built-in.o
    816      29       8     853     355 kernel/events/callchain.o
  36305     694     200   37199    914f kernel/events/core.o
   1840     136       8    1984     7c0 kernel/events/hw_breakpoint.o
   1170       0       0    1170     492 kernel/events/ring_buffer.o
   3122     985       0    4107    100b arch/x86/kernel/cpu/perf_event_amd.o
   1839     304      16    2159     86f arch/x86/kernel/cpu/perf_event_amd_uncore.o
   4641    4009       0    8650    21ca arch/x86/kernel/cpu/perf_event_intel_ds.o
  11189       1       0   11190    2bb6 arch/x86/kernel/cpu/perf_event_intel_lbr.o
  12590    4613       1   17204    4334 arch/x86/kernel/cpu/perf_event_intel.o
  20987   12523     164   33674    838a arch/x86/kernel/cpu/perf_event_intel_uncore.o
   1686     897       0    2583     a17 arch/x86/kernel/cpu/perf_event_knc.o
  12065    5117     108   17290    438a arch/x86/kernel/cpu/perf_event.o
   3436    1476       0    4912    1330 arch/x86/kernel/cpu/perf_event_p4.o
   1234     376       0    1610     64a arch/x86/kernel/cpu/perf_event_p6.o


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
