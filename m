Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964786Ab3CHSRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 13:17:08 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17707 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab3CHSRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 13:17:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,809,1355126400"; 
   d="scan'208";a="28226191"
Message-ID: <513A2B20.30805@codeaurora.org>
Date: Fri, 08 Mar 2013 10:17:04 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] ARM: smp_twd: Divorce smp_twd from local timer
 API
References: <1362614646-24113-1-git-send-email-sboyd@codeaurora.org> <1362614646-24113-4-git-send-email-sboyd@codeaurora.org> <20130308004011.GD11806@atomide.com> <51393B59.3070200@codeaurora.org> <20130308180730.GE11806@atomide.com>
In-Reply-To: <20130308180730.GE11806@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/13 10:07, Tony Lindgren wrote:
>
> Adding that produces the following:
>
> ...
> OMAP clockevent source: GPTIMER1 at 32768 Hz
> sched_clock: 32 bits at 32kHz, resolution 30517ns, wraps every 131071999ms
> OMAP clocksource: 32k_counter at 32768 Hz
> Console: colour dummy device 80x30
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> Unable to handle kernel NULL pointer dereference at virtual address 0000001d
> pgd = c0004000
> [0000001d] *pgd=00000000
> Internal error: Oops: 5 [#1] SMP ARM
> Modules linked in:
> CPU: 0    Not tainted  (3.9.0-rc1-12182-g90ac757-dirty #42)
> PC is at 0xe7d7f0a0
> LR is at twd_handler+0x34/0x40
> pc : [<e7d7f0a0>]    lr : [<c001a650>]    psr: 200001d3
> sp : c0791ea0  ip : c0790000  fp : 00000004
> r10: ed806780  r9 : c0805840  r8 : 00e0c000
> r7 : c07919c0  r6 : ed801900  r5 : 0000001d  r4 : 00000001
> r3 : fa240600  r2 : fa24060c  r1 : c0090d28  r0 : c0090d28
> Flags: nzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
> Control: 10c53c7d  Table: 8000404a  DAC: 00000017
> Process swapper/0 (pid: 0, stack limit = 0xc0790240)
> Stack: (0xc0791ea0 to 0xc0792000)
> 1ea0: c07997a8 c00ac80c 0000001d c078e248 c0790000 00000000 c07997a8 00000000
> 1ec0: c0790000 c00a9e2c 0000001d c00152a8 fa24010c c0791f00 c0799904 fa240110
> 1ee0: c082b260 c000868c 200001d3 c004901c 20000153 ffffffff c0791f34 c052db64
> 1f00: 00000001 00000001 c079bc90 00000000 00000000 00000000 00000048 00000048
> 1f20: c082b260 00000000 c0790000 00000004 00000000 c0791f48 60000153 c004901c
> 1f40: 20000153 ffffffff 00000000 00000000 00000000 00000000 c082b260 00000048
> 1f60: 00000000 00000000 00000000 60000153 c033e2ec c0791fac c08292bc c0829240
> 1f80: c076f678 ffffffff 411fc092 c07988c0 00000000 c0529c88 c068460c c0791fac
> 1fa0: c082924c c07515b4 c068460c c080bb1c 00000011 c0829258 bfffffff c0736884
> 1fc0: ffffffff ffffffff c0736474 00000000 00000000 c076f678 00000000 10c53c7d
> 1fe0: c0798934 c076fa7c c079d16c 8000406a 00000000 80008074 00000000 00000000
> [<c001a650>] (twd_handler+0x34/0x40) from [<c00ac80c>] (handle_percpu_devid_irq+0xb8/0x128)
> [<c00ac80c>] (handle_percpu_devid_irq+0xb8/0x128) from [<c00a9e2c>] (generic_handle_irq+0x30/0x3c)
> [<c00a9e2c>] (generic_handle_irq+0x30/0x3c) from [<c00152a8>] (handle_IRQ+0x48/0xa8)
> [<c00152a8>] (handle_IRQ+0x48/0xa8) from [<c000868c>] (gic_handle_irq+0x30/0x6c)
> [<c000868c>] (gic_handle_irq+0x30/0x6c) from [<c052db64>] (__irq_svc+0x44/0x5c)
> Exception stack(0xc0791f00 to 0xc0791f48)
> 1f00: 00000001 00000001 c079bc90 00000000 00000000 00000000 00000048 00000048
> 1f20: c082b260 00000000 c0790000 00000004 00000000 c0791f48 60000153 c004901c
> 1f40: 20000153 ffffffff
> [<c052db64>] (__irq_svc+0x44/0x5c) from [<c004901c>] (vprintk_emit+0x1f8/0x544)
> [<c004901c>] (vprintk_emit+0x1f8/0x544) from [<c0529c88>] (printk+0x30/0x40)
> [<c0529c88>] (printk+0x30/0x40) from [<c07515b4>] (lockdep_info+0x10/0xb4)
> [<c07515b4>] (lockdep_info+0x10/0xb4) from [<c0736884>] (start_kernel+0x1dc/0x328)
> [<c0736884>] (start_kernel+0x1dc/0x328) from [<80008074>] (0x80008074)
> Code: 57555555 55755154 557d5554 55d55655 (54555575) 
>

Ah. Two bugs :-(

----8<-----

diff --git a/arch/arm/kernel/smp_twd.c b/arch/arm/kernel/smp_twd.c
index 081de6f..4ea3e9d 100644
--- a/arch/arm/kernel/smp_twd.c
+++ b/arch/arm/kernel/smp_twd.c
@@ -227,7 +227,7 @@ static void __cpuinit twd_calibrate_rate(void)
 
 static irqreturn_t twd_handler(int irq, void *dev_id)
 {
-       struct clock_event_device *evt = *(struct clock_event_device **)dev_id;
+       struct clock_event_device *evt = dev_id;
 
        if (twd_timer_ack()) {
                evt->event_handler(evt);


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

