Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756466AbaCZUeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:34:36 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:36793 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbaCZUee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:34:34 -0400
MIME-Version: 1.0
In-Reply-To: <533337BD.5070901@free-electrons.com>
References: <1395858127-18730-1-git-send-email-s.nawrocki@samsung.com>
	<CAOMZO5DJPKvha7A-foktsB2dEw9xGXL_++uBXj_3ScAPTXNOkw@mail.gmail.com>
	<53333145.4080903@gmail.com>
	<CAOMZO5AEry8sJW_+0aJS8ush+sYPPWk9LRU0b8RUUGa-hO_G1A@mail.gmail.com>
	<533337BD.5070901@free-electrons.com>
Date: Wed, 26 Mar 2014 17:34:33 -0300
Message-ID: <CAOMZO5BY3GhherGK+n-XEaazRRVwPU8s6X-DQg6_V62mVj8fjQ@mail.gmail.com>
Subject: Re: [PATCH] clk: register fixed-clock only if #clock-cells property
 is present
From: Fabio Estevam <festevam@gmail.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, t.figa@samsung.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Kevin Hilman <khilman@linaro.org>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 5:25 PM, Gregory CLEMENT
<gregory.clement@free-electrons.com> wrote:

> However, Fabio, could you apply the following patch without the patch
> "clk: reverse default clk provider initialization order in
> of_clk_init()" and then sent me the traces. I would like to be sure
> that there is not any side effect.

Here is the result, thanks.

Hierarchical RCU implementation.
NR_IRQS:16 nr_irqs:16 16
L310 cache controller enabled
l2x0: 16 ways, CACHE_ID 0x410000c7, AUX_CTRL 0x32070000, Cache size: 1024 kB
parent_ready: Testing ccm
parent_ready: Ready
of_clk_init: Initializing ccm
Switching to timer-based delay loop
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #951
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:00000000 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
[<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:00000000 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<8007e854>] (clocks_calc_mult_shift) from [<8089a8d0>]
(sched_clock_register+0x60/0x238)
 r10:f0018074 r9:00000000 r8:80020ba0 r7:00000020 r6:00000000 r5:80932eac
 r4:00000000
[<8089a870>] (sched_clock_register) from [<80884588>]
(mxc_timer_init+0xf8/0x190)
 r10:f0018074 r9:00000000 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac
 r4:00000000
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7380 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b02c4>] (of_clk_init+0x150/0x208)
 r10:809234d4 r9:00000000 r8:ee7ce5b0 r7:ee002ac0 r6:ee002b00 r5:fffffffe
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd800 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd7fc r5:808d692c r4:10c5387d
sched_clock: 32 bits at 0 Hz, resolution 0ns, wraps every 0ns
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #951
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:ee011a00 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
[<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:00000000 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<8007ea84>] (__clocksource_updatefreq_scale) from [<8007ec3c>]
(__clocksource_register_scale+0x14/0x54)
 r10:000000c8 r9:00000000 r8:f0020024 r7:807b3e68 r6:ee0119c0 r5:00000000
 r4:ee011a00
[<8007ec28>] (__clocksource_register_scale) from [<808ae6f8>]
(clocksource_mmio_init+0x8c/0xa8)
 r4:ffffffff r3:00000001
[<808ae66c>] (clocksource_mmio_init) from [<808845ac>]
(mxc_timer_init+0x11c/0x190)
 r10:f0018074 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac r4:808dc900
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7380 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b02c4>] (of_clk_init+0x150/0x208)
 r10:809234d4 r9:00000000 r8:ee7ce5b0 r7:ee002ac0 r6:ee002b00 r5:fffffffe
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd800 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd7fc r5:808d692c r4:10c5387d
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #951
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:ee011a00 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
[<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:00000000 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<8007e854>] (clocks_calc_mult_shift) from [<8007eb28>]
(__clocksource_updatefreq_scale+0xa4/0x1a4)
 r10:00000001 r9:a3d70a3d r8:70a3d70a r7:0000000b r6:ee011a00 r5:00000001
 r4:00000001
[<8007ea84>] (__clocksource_updatefreq_scale) from [<8007ec3c>]
(__clocksource_register_scale+0x14/0x54)
 r10:000000c8 r9:00000000 r8:f0020024 r7:807b3e68 r6:ee0119c0 r5:00000000
 r4:ee011a00
[<8007ec28>] (__clocksource_register_scale) from [<808ae6f8>]
(clocksource_mmio_init+0x8c/0xa8)
 r4:ffffffff r3:00000001
[<808ae66c>] (clocksource_mmio_init) from [<808845ac>]
(mxc_timer_init+0x11c/0x190)
 r10:f0018074 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac r4:808dc900
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7380 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b02c4>] (of_clk_init+0x150/0x208)
 r10:809234d4 r9:00000000 r8:ee7ce5b0 r7:ee002ac0 r6:ee002b00 r5:fffffffe
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd800 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd7fc r5:808d692c r4:10c5387d
Division by zero in kernel.
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #951
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:ee022b80 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
[<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
 r5:808dc900 r4:00000000
[<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
[<80082314>] (clockevents_config) from [<800823b4>]
(clockevents_config_and_register+0x1c/0x28)
 r5:80932eac r4:808dc900
[<80082398>] (clockevents_config_and_register) from [<808845d8>]
(mxc_timer_init+0x148/0x190)
 r4:808dc900 r3:fffffffe
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7380 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b02c4>] (of_clk_init+0x150/0x208)
 r10:809234d4 r9:00000000 r8:ee7ce5b0 r7:ee002ac0 r6:ee002b00 r5:fffffffe
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd800 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd7fc r5:808d692c r4:10c5387d
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/time/clockevents.c:44 cev_delta2ns+0xe8/0x104()
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326+ #951
Backtrace:
[<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
 r6:80081cb8 r5:00000000 r4:00000000 r3:00000000
[<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
[<8064cbd8>] (dump_stack) from [<80028f78>] (warn_slowpath_common+0x70/0x94)
 r5:00000009 r4:00000000
[<80028f08>] (warn_slowpath_common) from [<80028fc0>]
(warn_slowpath_null+0x24/0x2c)
 r8:000000ff r7:000000ff r6:00000000 r5:808dc900 r4:00000000
[<80028f9c>] (warn_slowpath_null) from [<80081cb8>] (cev_delta2ns+0xe8/0x104)
[<80081bd0>] (cev_delta2ns) from [<80082374>] (clockevents_config+0x60/0x84)
 r9:00000000 r8:00000057 r7:f0020024 r6:ee022b80 r5:808dc900 r4:00000000
[<80082314>] (clockevents_config) from [<800823b4>]
(clockevents_config_and_register+0x1c/0x28)
 r5:80932eac r4:808dc900
[<80082398>] (clockevents_config_and_register) from [<808845d8>]
(mxc_timer_init+0x148/0x190)
 r4:808dc900 r3:fffffffe
[<80884490>] (mxc_timer_init) from [<808910b0>]
(imx6q_clocks_init+0x2c00/0x2d24)
 r8:00000004 r7:809334d0 r6:808c7380 r5:ee7ccbe8 r4:f0020000
[<8088e4b0>] (imx6q_clocks_init) from [<808b02c4>] (of_clk_init+0x150/0x208)
 r10:809234d4 r9:00000000 r8:ee7ce5b0 r7:ee002ac0 r6:ee002b00 r5:fffffffe
 r4:00000001
[<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
 r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd800 r6:ffffffff r5:809329c0
 r4:00000001
[<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
[<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
 r10:00000000 r8:1000406a r7:808db644 r6:808bd7fc r5:808d692c r4:10c5387d
---[ end trace 3406ff24bd97382e ]---
parent_ready: Testing osc
parent_ready: Ready
of_clk_init: Initializing osc
parent_ready: Testing ckih1
parent_ready: Ready
of_clk_init: Initializing ckih1
parent_ready: Testing ckil
parent_ready: Ready
of_clk_init: Initializing ckil
