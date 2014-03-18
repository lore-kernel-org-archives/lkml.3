Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbaCRPyN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:54:13 -0400
Received: from ofcsgdbm.dwd.de ([141.38.3.245]:60159 "EHLO ofcsgdbm.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbaCRPyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:54:09 -0400
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Mar 2014 11:54:09 EDT
Date: Tue, 18 Mar 2014 15:47:49 +0000 (UTC)
From: Holger Kiehl <Holger.Kiehl@dwd.de>
X-X-Sender: kiehl@diagnostix.dwd.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Kernel panic with 3.10.33 and possible hpwdt watchdog
Message-ID: <alpine.LRH.2.11.1403181358060.23791@diagnostix.dwd.de>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I use a plain kernel.org kernel 3.10.33 and when I do a HP ILO (proprietary
embedded server management technology) reset of my Proliant 380p server,
the system hangs. Unfortunatly I cannot do a serial trace, so copied
everything by hand what I could read from console:

    <EOI>  <NMI>  [<ffffffff812898c1>] ? vga_set_palette+0xd1/0x130
    [<ffffffff8155e4b0>] ? panic+0x18c/0x1c7
    [<ffffffff8155e418>] ? panic+0xf4/0x1c7
    [<ffffffffa002c885>] ? hpwdt_pretimeout+0xc5/0xd0 [hpwdt]
    [<ffffffff81006389>] ? nmi_handle+0x59/0x80
    [<ffffffff8100650f>] ? default_do_nmi+0x12f/0x2a0
    [<ffffffff81006708>] ? do_nmi+0x88/0xd0
    [<ffffffff81561ff7>] ? end_repeat_nmi+0x1e/0x2e
    [<ffffffff81298e16>] ? intel_idle+0xb6/0x120
    [<ffffffff81298e16>] ? intel_idle+0xb6/0x120
    [<ffffffff81298e16>] ? intel_idle+0xb6/0x120
    <<EOE>>  [<ffffffff8146213d>] ? cpuidle_enter_state+0x3d/0xd0
    [<ffffffff814624fa>] ? cpuidle_idle_call+0xba/0x140
    [<ffffffff81085a8d>] ? __tick_nohz_idle_enter+0x8d/0x120
    [<ffffffff8100b669>] ? arch_cpu_idle+0x9/0x30
    [<ffffffff8107c3e2>] ? cpu_idle_loop+0x92/0x160
    [<ffffffff8107c51b>] ? cpu_startup_entry+0x6b/0x70
    [<ffffffff817bafe3>] ? start_kernel+0x3e2/0x3ed
    [<ffffffff817baa33>] ? repair_env_string+0x5e/0x5e
    [<ffffffff817ba6bf>] ? x86_64_start_kernel+0x12a/0x130
    ---[ end trace 2a7f5aee76758ec0 ]---
    dmar: DRHD: handling fault status reg 2
    dmar: DMAR:[DMA Read] Request device [01:00.2] fault addr e9000
    DMAR:[fault reason 06] PTE Read access is not set

If I remove the hpwdt driver and I then reset the HP ILO system, the
system also hangs, but continuously at an interval of aprrox. 2 seconds
writes the following to console:

    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 71 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.
    NMI: IOCK error (debug interrupt?) for reason 61 on CPU 0.

Also, setting nmi_watchdog=0 does not change anything.

This does not happen when I do take the default kernel of the
disrtibution (Scientific Linux 6.5) 2.6.32-431.5.1.el6.x86_64.

The bad thing is that when the hpwdt driver is loaded, the watchdog does
not reset the system, ie. it hangs forever. And I cannot use Intel TCO
WatchDog Timer Driver since it is disabled in bios.

Please, can someone give me a hint where the error could be and what I
can do so I can continue to use the kernel.org kernel.

Many thanks in advance,
Holger

PS: Please CC me since I am not subscribed

