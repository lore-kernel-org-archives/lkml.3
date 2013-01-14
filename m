Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823Ab3ANLZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 06:25:20 -0500
Received: from www.linutronix.de ([62.245.132.108]:58521 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756389Ab3ANLZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 06:25:18 -0500
Date: Mon, 14 Jan 2013 12:25:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Stephen Boyd <sboyd@codeaurora.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at x86/lib/debugobjects.c:908
 check_results.constprop.9+0x129/0x153()
In-Reply-To: <20130114023107.GA9061@localhost>
Message-ID: <alpine.LFD.2.02.1301141224460.7475@ionos>
References: <20130114023107.GA9061@localhost>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jan 2013, Fengguang Wu wrote:

> Hi Stephen,
> 
> I got this warning when testing kernels in kvm:
> 
> [    0.000000] --------------------------------------------------------
> [    0.000000] 133 out of 218 testcases failed, as expected. |
> [    0.000000] ----------------------------------------------------
> [    0.000000] ODEBUG: 8 of 8 active objects replaced
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at /c/kernel-tests/src/x86/lib/debugobjects.c:908 check_results.constprop.9+0x129/0x153()
> [    0.000000] Hardware name: Bochs
> [    0.000000] ODEBUG: selftest warnings failed 4 != 5
> [    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.2.0-06292-g59a5680 #1
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff810587ea>] warn_slowpath_common+0x7a/0xb0
> [    0.000000]  [<ffffffff818ff01f>] ? check_results.constprop.9+0x35/0x153
> [    0.000000]  [<ffffffff81058896>] warn_slowpath_fmt+0x46/0x50
> [    0.000000]  [<ffffffff81435c81>] ? _raw_spin_lock_irqsave+0x61/0x70
> [    0.000000]  [<ffffffff818ff01f>] ? check_results.constprop.9+0x35/0x153
> [    0.000000]  [<ffffffff818ff113>] check_results.constprop.9+0x129/0x153
> [    0.000000]  [<ffffffff818ff6d6>] debug_objects_mem_init+0x412/0x4a6
> [    0.000000]  [<ffffffff818e0a15>] start_kernel+0x3c0/0x443
> [    0.000000]  [<ffffffff818e0000>] ? __init_begin+0x14000/0x14000
> [    0.000000]  [<ffffffff818e0156>] x86_64_start_reservations+0x131/0x135
> [    0.000000]  [<ffffffff818e0259>] x86_64_start_kernel+0xff/0x10e
> [    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
> [    0.000000] hpet clockevent registered
> [    0.000000] Fast TSC calibration using PIT
> [    0.000000] Detected 3092.385 MHz processor.
> [    0.008004] Calibrating delay loop (skipped), value calculated using timer frequency.. 6184.77 BogoMIPS (lpj=12369540)
> 
> feac18dda25134005909e7770c77464e65608bd8 is the first bad commit
> 
> commit feac18dda25134005909e7770c77464e65608bd8
> Author: Stephen Boyd <sboyd@codeaurora.org>
> Date:   Mon Nov 7 19:48:26 2011 -0800
> 
>     debugobjects: Be smarter about static objects
> 
>     Make debugobjects use the return code from the fixup function. That
>     allows us better diagnostics in the activate check than relying on a
>     WARN_ON() in the object specific code.
> 
>     [ tglx@linutronix.de: Split out the debugobjects vs. the timer change ]
> 
>     Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>     Cc: Christine Chan <cschan@codeaurora.org>
>     Cc: John Stultz <john.stultz@linaro.org>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Link: http://lkml.kernel.org/r/1320724108-20788-2-git-send-email-sboyd@codeaurora.org
>     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

That's already fixed by:

commit 9f78ff005a6b6313728247113948450b2adddde8
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Mon Mar 5 14:59:17 2012 -0800

    debugobjects: Fix selftest for static warnings

Thanks,

	tglx
