Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbaCZTu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 15:50:58 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55176 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755633AbaCZTu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 15:50:56 -0400
Message-ID: <53332F99.6060805@free-electrons.com>
Date: Wed, 26 Mar 2014 20:50:49 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Kevin Hilman <khilman@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH v3] clk: respect the clock dependencies in of_clk_init
References: <1393265413-16641-1-git-send-email-gregory.clement@free-electrons.com> <531068F4.3060903@free-electrons.com> <20140321035233.32624.98694@quantum> <CAGa+x85XLDZqCkz9R95d2Vj9eODx4q8W=9QhmMfivdPf2GdsaQ@mail.gmail.com> <5332FA20.4010206@free-electrons.com> <CAOMZO5B6UVJ-dQ-RnzNAhu8-7H_u354rw8tRcpmZ3LWS4cDYFQ@mail.gmail.com>
In-Reply-To: <CAOMZO5B6UVJ-dQ-RnzNAhu8-7H_u354rw8tRcpmZ3LWS4cDYFQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabio,

On 26/03/2014 17:22, Fabio Estevam wrote:
> Hi Gregory,
> 
> On Wed, Mar 26, 2014 at 1:02 PM, Gregory CLEMENT
> <gregory.clement@free-electrons.com> wrote:
>> I don't have any imx6 board, but should it be possible for you or the imx6
>> maintainer to add earlyprintk to see exactly what happen here?
> 
> Below is the log with earlyprintk enabled.
> 
> Regards,
> 
> Fabio Estevam
> 
> Starting kernel ...
> 
> Uncompressing Linux... done, booting the kernel.
> Booting Linux on physical CPU 0x0
> Linux version 3.14.0-rc8-next-20140326 (fabio@fabio-Latitude-E6410)
> (gcc version 4.7.3 (Ubuntu/Linaro 4.7.3-1ubuntu1) ) #942 SMP Wed M
> ar 26 13:20:56 BRT 2014
> CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c5387d
> CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
> Machine model: Wandboard i.MX6 Quad Board
> bootconsole [earlycon0] enabled
> Memory policy: Data cache writealloc
> PERCPU: Embedded 8 pages/cpu @ee7a4000 s8960 r8192 d15616 u32768
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520720
> Kernel command line: console=ttymxc0,115200 root=/dev/nfs ip=dhcp
> nfsroot=192.168.0.2:/tftpboot/rfs,v3,tcp earlyprintk
> PID hash table entries: 4096 (order: 2, 16384 bytes)
> Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
> Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
> Memory: 2063904K/2097152K available (6455K kernel code, 402K rwdata,
> 2200K rodata, 320K init, 5513K bss, 33248K reserved, 270336K high
> mem)
> Virtual kernel memory layout:
>     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
>     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
>     lowmem  : 0x80000000 - 0xef800000   (1784 MB)
>     pkmap   : 0x7fe00000 - 0x80000000   (   2 MB)
>     modules : 0x7f000000 - 0x7fe00000   (  14 MB)
>       .text : 0x80008000 - 0x8087bfdc   (8656 kB)
>       .init : 0x8087c000 - 0x808cc300   ( 321 kB)
>       .data : 0x808ce000 - 0x80932980   ( 403 kB)
>        .bss : 0x80932988 - 0x80e950f8   (5514 kB)
> SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
> Hierarchical RCU implementation.
> NR_IRQS:16 nr_irqs:16 16
> L310 cache controller enabled
> l2x0: 16 ways, CACHE_ID 0x410000c7, AUX_CTRL 0x32070000, Cache size: 1024 kB
> Switching to timer-based delay loop
> Division by zero in kernel.
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326 #942
> Backtrace:
> [<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
>  r6:00000000 r5:00000000 r4:00000000 r3:00000000
> [<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
> [<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
>  r5:00000000 r4:00000000
> [<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
> [<8007e854>] (clocks_calc_mult_shift) from [<8089a8d0>]
> (sched_clock_register+0x60/0x238)
>  r10:f0018074 r9:00000000 r8:80020ba0 r7:00000020 r6:00000000 r5:80932eac
>  r4:00000000
> [<8089a870>] (sched_clock_register) from [<80884588>]
> (mxc_timer_init+0xf8/0x190)
>  r10:f0018074 r9:00000000 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac
>  r4:00000000
> [<80884490>] (mxc_timer_init) from [<808910b0>]
> (imx6q_clocks_init+0x2c00/0x2d24)
>  r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
> [<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
>  r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
>  r4:00000001
> [<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
>  r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
>  r4:00000001
> [<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
> [<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
>  r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
> sched_clock: 32 bits at 0 Hz, resolution 0ns, wraps every 0ns
> Division by zero in kernel.
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326 #942
> Backtrace:
> [<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
>  r6:ee011a00 r5:00000000 r4:00000000 r3:00000000
> [<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
> [<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
>  r5:00000000 r4:00000000
> [<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
> [<8007ea84>] (__clocksource_updatefreq_scale) from [<8007ec3c>]
> (__clocksource_register_scale+0x14/0x54)
>  r10:000000c8 r9:00000000 r8:f0020024 r7:807b3e58 r6:ee0119c0 r5:00000000
>  r4:ee011a00
> [<8007ec28>] (__clocksource_register_scale) from [<808ae6f8>]
> (clocksource_mmio_init+0x8c/0xa8)
>  r4:ffffffff r3:00000001
> [<808ae66c>] (clocksource_mmio_init) from [<808845ac>]
> (mxc_timer_init+0x11c/0x190)
>  r10:f0018074 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac r4:808dc900
> [<80884490>] (mxc_timer_init) from [<808910b0>]
> (imx6q_clocks_init+0x2c00/0x2d24)
>  r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
> [<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
>  r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
>  r4:00000001
> [<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
>  r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
>  r4:00000001
> [<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
> [<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
>  r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
> Division by zero in kernel.
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326 #942
> Backtrace:
> [<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
>  r6:ee011a00 r5:00000000 r4:00000000 r3:00000000
> [<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
> [<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
>  r5:00000000 r4:00000000
> [<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
> [<8007e854>] (clocks_calc_mult_shift) from [<8007eb28>]
> (__clocksource_updatefreq_scale+0xa4/0x1a4)
>  r10:00000001 r9:a3d70a3d r8:70a3d70a r7:0000000b r6:ee011a00 r5:00000001
>  r4:00000001
> [<8007ea84>] (__clocksource_updatefreq_scale) from [<8007ec3c>]
> (__clocksource_register_scale+0x14/0x54)
>  r10:000000c8 r9:00000000 r8:f0020024 r7:807b3e58 r6:ee0119c0 r5:00000000
>  r4:ee011a00
> [<8007ec28>] (__clocksource_register_scale) from [<808ae6f8>]
> (clocksource_mmio_init+0x8c/0xa8)
>  r4:ffffffff r3:00000001
> [<808ae66c>] (clocksource_mmio_init) from [<808845ac>]
> (mxc_timer_init+0x11c/0x190)
>  r10:f0018074 r8:00000057 r7:f0020024 r6:ee022b80 r5:80932eac r4:808dc900
> [<80884490>] (mxc_timer_init) from [<808910b0>]
> (imx6q_clocks_init+0x2c00/0x2d24)
>  r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
> [<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
>  r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
>  r4:00000001
> [<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
>  r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
>  r4:00000001
> [<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
> [<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
>  r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
> Division by zero in kernel.
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326 #942
> Backtrace:
> [<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
>  r6:ee022b80 r5:00000000 r4:00000000 r3:00000000
> [<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
> [<8064cbd8>] (dump_stack) from [<80011a94>] (__div0+0x18/0x20)
>  r5:808dc900 r4:00000000
> [<80011a7c>] (__div0) from [<8029582c>] (Ldiv0_64+0x8/0x18)
> [<80082314>] (clockevents_config) from [<800823b4>]
> (clockevents_config_and_register+0x1c/0x28)
>  r5:80932eac r4:808dc900
> [<80082398>] (clockevents_config_and_register) from [<808845d8>]
> (mxc_timer_init+0x148/0x190)
>  r4:808dc900 r3:fffffffe
> [<80884490>] (mxc_timer_init) from [<808910b0>]
> (imx6q_clocks_init+0x2c00/0x2d24)
>  r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
> [<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
>  r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
>  r4:00000001
> [<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
>  r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
>  r4:00000001
> [<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
> [<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
>  r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 0 at kernel/time/clockevents.c:44 cev_delta2ns+0xe8/0x104()
> Modules linked in:
> CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.14.0-rc8-next-20140326 #942
> Backtrace:
> [<80011cd4>] (dump_backtrace) from [<80011e70>] (show_stack+0x18/0x1c)
>  r6:80081cb8 r5:00000000 r4:00000000 r3:00000000
> [<80011e58>] (show_stack) from [<8064cc60>] (dump_stack+0x88/0xa4)
> [<8064cbd8>] (dump_stack) from [<80028f78>] (warn_slowpath_common+0x70/0x94)
>  r5:00000009 r4:00000000
> [<80028f08>] (warn_slowpath_common) from [<80028fc0>]
> (warn_slowpath_null+0x24/0x2c)
>  r8:000000ff r7:000000ff r6:00000000 r5:808dc900 r4:00000000
> [<80028f9c>] (warn_slowpath_null) from [<80081cb8>] (cev_delta2ns+0xe8/0x104)
> [<80081bd0>] (cev_delta2ns) from [<80082374>] (clockevents_config+0x60/0x84)
>  r9:00000000 r8:00000057 r7:f0020024 r6:ee022b80 r5:808dc900 r4:00000000
> [<80082314>] (clockevents_config) from [<800823b4>]
> (clockevents_config_and_register+0x1c/0x28)
>  r5:80932eac r4:808dc900
> [<80082398>] (clockevents_config_and_register) from [<808845d8>]
> (mxc_timer_init+0x148/0x190)
>  r4:808dc900 r3:fffffffe
> [<80884490>] (mxc_timer_init) from [<808910b0>]
> (imx6q_clocks_init+0x2c00/0x2d24)
>  r8:00000004 r7:809334d0 r6:808c7310 r5:ee7ccbe8 r4:f0020000
> [<8088e4b0>] (imx6q_clocks_init) from [<808b024c>] (of_clk_init+0xd8/0x198)
>  r10:80923594 r9:809234d4 r8:00000000 r7:ee002ac0 r6:ee002b00 r5:ee7ce5b0
>  r4:00000001
> [<808b0174>] (of_clk_init) from [<80880364>] (time_init+0x2c/0x38)
>  r10:ef7fc9c0 r9:412fc09a r8:808d6880 r7:808bd790 r6:ffffffff r5:809329c0
>  r4:00000001
> [<80880338>] (time_init) from [<8087ca2c>] (start_kernel+0x1f8/0x388)
> [<8087c834>] (start_kernel) from [<10008074>] (0x10008074)
>  r10:00000000 r8:1000406a r7:808db644 r6:808bd78c r5:808d692c r4:10c5387d
> ---[ end trace 3406ff24bd97382e ]---

Thanks for the traces. As I guessed some clocks are not initialized in time.
I am a bit disappointed because I tried to write a patch which in worst
case didn't change this order.

Viewing the code clock support for imx6, I think the problem could be due to
the fact that some link between the clock are not exposed to the device tree.

I need to have a closer look to sort out it.

Gregory

> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
