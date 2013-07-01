Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab3GATpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 15:45:20 -0400
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:41161
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061Ab3GATpR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 15:45:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zz1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Topic: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Index: Ac5zZxBZeupdDlSIRDWI6ggVo3oJ5QAkUYcAAAf2xwAAAZFOUAAA2+yAABLhygAAdGeRAAAHHZgAAACKafAACWuggAACoBRA
Date: Mon, 1 Jul 2013 19:45:09 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF30821@039-SN2MPN1-011.039d.mgd.msft.net>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
 <51CDB26A.9060500@codeaurora.org>
 <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org>
 <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net>
 <alpine.DEB.2.02.1307011425500.4013@ionos.tec.linutronix.de>
 <F7C43F8B2814514CA05F3436BC68046EF2F708@039-SN2MPN1-011.039d.mgd.msft.net>
 <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1307011531210.4013@ionos.tec.linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.214.137.192]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner [mailto:tglx@linutronix.de]
(..)
> Though that does not explain why dev->next_event is set to KTIME_MAX
> after we installed the mxc_timer1 as the system clocksource. And we
> really need to know why that happens.
> 
> Here is some more debugging which should shine some light on that.

...and here is your log :)

Best regards,

V.

Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Linux version 3.10.0-next-20130701+ (vstehle@debian) (gcc version 4.7.2 (Debian 4.7.2-5) ) #2 SMP Mon Jul 1 21:36:54 CEST 2013
CPU: ARMv7 Processor [412fc09a] revision 10 (ARMv7), cr=10c53c7d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine: Freescale i.MX6 Quad/DualLite (Device Tree), model: Freescale i.MX6 Quad SABRE Smart Device Board
bootconsole [earlycon0] enabled
Memory policy: ECC disabled, Data cache writealloc
On node 0 totalpages: 262144
free_area_init_node: node 0, pgdat 8078bd00, node_mem_map 807ea000
  Normal zone: 2048 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 262144 pages, LIFO batch:31
PERCPU: Embedded 7 pages/cpu @81007000 s7680 r8192 d12800 u32768
pcpu-alloc: s7680 r8192 d12800 u32768 alloc=8*4096
pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 260096
Kernel command line: console=ttymxc0,115200 root=/dev/nfs ip=dhcp nfsroot=192.168.111.1:/tftpboot/debian,v3,tcp rw earlyprintk debug
PID hash table entries: 4096 (order: 2, 16384 bytes)
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1031272K/1048576K available (5380K kernel code, 273K rwdata, 1736K rodata, 303K init, 373K bss, 17304K reserved)
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    vmalloc : 0xc0800000 - 0xff000000   (1000 MB)
    lowmem  : 0x80000000 - 0xc0000000   (1024 MB)
    modules : 0x7f000000 - 0x80000000   (  16 MB)
      .text : 0x80008000 - 0x806fb4dc   (7118 kB)
      .init : 0x806fc000 - 0x80747e00   ( 304 kB)
      .data : 0x80748000 - 0x8078c540   ( 274 kB)
       .bss : 0x8078c540 - 0x807e9bb4   ( 374 kB)
SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
Hierarchical RCU implementation.
NR_IRQS:16 nr_irqs:16 16
sched_clock: 32 bits at 66MHz, resolution 15ns, wraps every 65075ms
Checking mxc_timer1
0: mxc_timer1 is per-cpu
0: mxc_timer1 is preferred
clockevents_shutdown 0 80755900
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<807032b4>] (mxc_timer_init+0x134/0x178)
[<807032b4>] (mxc_timer_init+0x134/0x178) from [<80728358>] (of_clk_init+0x38/0x64)
[<80728358>] (of_clk_init+0x38/0x64) from [<8070f06c>] (imx6q_timer_init+0xc/0x4c)
[<8070f06c>] (imx6q_timer_init+0xc/0x4c) from [<806ffbf4>] (time_init+0x1c/0x2c)
[<806ffbf4>] (time_init+0x1c/0x2c) from [<806fc768>] (start_kernel+0x1a8/0x308)
[<806fc768>] (start_kernel+0x1a8/0x308) from [<10008074>] (0x10008074)
---[ end trace 1b75b31a2719ed1c ]---
CPU identified as i.MX6Q, silicon rev 1.2
Console: colour dummy device 80x30
Calibrating delay loop... 1581.05 BogoMIPS (lpj=7905280)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
Checking local_timer
0: local_timer is per-cpu
0: local_timer is preferred
clockevents_shutdown 0 810071c0
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<80014024>] (twd_timer_setup+0xac/0x20c)
[<80014024>] (twd_timer_setup+0xac/0x20c) from [<80013004>] (percpu_timer_setup+0x5c/0xb4)
[<80013004>] (percpu_timer_setup+0x5c/0xb4) from [<80700518>] (smp_prepare_cpus+0x50/0x7c)
[<80700518>] (smp_prepare_cpus+0x50/0x7c) from [<806fc920>] (kernel_init_freeable+0x58/0x1c4)
[<806fc920>] (kernel_init_freeable+0x58/0x1c4) from [<80513c28>] (kernel_init+0x8/0xe4)
[<80513c28>] (kernel_init+0x8/0xe4) from [<8000e578>] (ret_from_fork+0x14/0x3c)
---[ end trace 1b75b31a2719ed1d ]---
Checking mxc_timer1
0: mxc_timer1 is per-cpu
0: mxc_timer1 is trying broadcast
mxc_timer1 is now the broadcast
clockevents_shutdown 0 80755900
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80062390>] (tick_install_broadcast_device+0x68/0xbc)
[<80062390>] (tick_install_broadcast_device+0x68/0xbc) from [<80060ee8>] (clockevents_register_device+0x90/0x128)
[<80060ee8>] (clockevents_register_device+0x90/0x128) from [<80014024>] (twd_timer_setup+0xac/0x20c)
[<80014024>] (twd_timer_setup+0xac/0x20c) from [<80013004>] (percpu_timer_setup+0x5c/0xb4)
[<80013004>] (percpu_timer_setup+0x5c/0xb4) from [<80700518>] (smp_prepare_cpus+0x50/0x7c)
[<80700518>] (smp_prepare_cpus+0x50/0x7c) from [<806fc920>] (kernel_init_freeable+0x58/0x1c4)
[<806fc920>] (kernel_init_freeable+0x58/0x1c4) from [<80513c28>] (kernel_init+0x8/0xe4)
[<80513c28>] (kernel_init+0x8/0xe4) from [<8000e578>] (ret_from_fork+0x14/0x3c)
---[ end trace 1b75b31a2719ed1e ]---
tick_clock_notify
Setting up static identity map for 0x8051bfd0 - 0x8051c040
Checking dummy_timer
0: dummy_timer is per-cpu
0: dummy_timer is trying broadcast
CPU1: Booted secondary processor
Checking dummy_timer
1: dummy_timer is per-cpu
1: dummy_timer is preferred
clockevents_shutdown 1 8100ff00
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<803e9c44>] (dummy_timer_cpu_notify+0x1c/0x24)
[<803e9c44>] (dummy_timer_cpu_notify+0x1c/0x24) from [<800471fc>] (notifier_call_chain+0x44/0x84)
[<800471fc>] (notifier_call_chain+0x44/0x84) from [<80027628>] (__cpu_notify+0x2c/0x48)
[<80027628>] (__cpu_notify+0x2c/0x48) from [<800133e0>] (secondary_start_kernel+0xdc/0x140)
[<800133e0>] (secondary_start_kernel+0xdc/0x140) from [<100081ec>] (0x100081ec)
---[ end trace 1b75b31a2719ed1f ]---
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
Checking local_timer
CPU2: Booted secondary processor
1: local_timer is per-cpu
1: local_timer is preferred
clockevents_shutdown 1 8100f1c0
------------[ cut here ]------------
WARNING: CPU: 1 PID: 0 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 1 PID: 0 Comm: swapper/1 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<80014024>] (twd_timer_setup+0xac/0x20c)
[<80014024>] (twd_timer_setup+0xac/0x20c) from [<80013004>] (percpu_timer_setup+0x5c/0xb4)
[<80013004>] (percpu_timer_setup+0x5c/0xb4) from [<80013404>] (secondary_start_kernel+0x100/0x140)
[<80013404>] (secondary_start_kernel+0x100/0x140) from [<100081ec>] (0x100081ec)
---[ end trace 1b75b31a2719ed20 ]---
Checking dummy_timer
1: dummy_timer is per-cpu
1: dummy_timer is trying broadcast
Checking dummy_timer
2: dummy_timer is per-cpu
2: dummy_timer is preferred
clockevents_shutdown 2 81017f00
------------[ cut here ]------------
WARNING: CPU: 2 PID: 0 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<803e9c44>] (dummy_timer_cpu_notify+0x1c/0x24)
[<803e9c44>] (dummy_timer_cpu_notify+0x1c/0x24) from [<800471fc>] (notifier_call_chain+0x44/0x84)
[<800471fc>] (notifier_call_chain+0x44/0x84) from [<80027628>] (__cpu_notify+0x2c/0x48)
[<80027628>] (__cpu_notify+0x2c/0x48) from [<800133e0>] (secondary_start_kernel+0xdc/0x140)
[<800133e0>] (secondary_start_kernel+0xdc/0x140) from [<100081ec>] (0x100081ec)
---[ end trace 1b75b31a2719ed21 ]---
CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
Checking local_timer
CPU3: Booted secondary processor
2: local_timer is per-cpu
2: local_timer is preferred
clockevents_shutdown 2 810171c0
------------[ cut here ]------------
WARNING: CPU: 2 PID: 0 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<80014024>] (twd_timer_setup+0xac/0x20c)
[<80014024>] (twd_timer_setup+0xac/0x20c) from [<80013004>] (percpu_timer_setup+0x5c/0xb4)
[<80013004>] (percpu_timer_setup+0x5c/0xb4) from [<80013404>] (secondary_start_kernel+0x100/0x140)
[<80013404>] (secondary_start_kernel+0x100/0x140) from [<100081ec>] (0x100081ec)
---[ end trace 1b75b31a2719ed22 ]---
Checking dummy_timer
2: dummy_timer is per-cpu
2: dummy_timer is trying broadcast
Checking dummy_timer
3: dummy_timer is per-cpu
3: dummy_timer is preferred
clockevents_shutdown 3 8101ff00
------------[ cut here ]------------
WARNING: CPU: 3 PID: 0 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<803e9c44>] (dummy_timer_cpu_notify+0x1c/0x24)
[<803e9c44>] (dummy_timer_cpu_notify+0x1c/0x24) from [<800471fc>] (notifier_call_chain+0x44/0x84)
[<800471fc>] (notifier_call_chain+0x44/0x84) from [<80027628>] (__cpu_notify+0x2c/0x48)
[<80027628>] (__cpu_notify+0x2c/0x48) from [<800133e0>] (secondary_start_kernel+0xdc/0x140)
[<800133e0>] (secondary_start_kernel+0xdc/0x140) from [<100081ec>] (0x100081ec)
---[ end trace 1b75b31a2719ed23 ]---
CPU3: thread -1, cpu 3, socket 0, mpidr 80000003
Checking local_timer
Brought up 4 CPUs
SMP: Total of 4 processors activated (6324.22 BogoMIPS).
CPU: All CPU(s) started in SVC mode.
devtmpfs: initialized
pinctrl core: initialized pinctrl subsystem
regulator-dummy: no parameters
NET: Registered protocol family 16
DMA: preallocated 256 KiB pool for atomic coherent allocations
syscon 20c8000.anatop: regmap [mem 0x020c8000-0x020c8fff] registered
vdd1p1: 800 <--> 1375 mV at 1100 mV 
vdd3p0: 2800 <--> 3150 mV at 3000 mV 
vdd2p5: 2000 <--> 2750 mV at 2400 mV 
cpu: 725 <--> 1450 mV at 1150 mV 
vddpu: 725 <--> 1450 mV at 1150 mV 
vddsoc: 725 <--> 1450 mV at 1200 mV 
syscon 20e0000.iomuxc-gpr: regmap [mem 0x020e0000-0x020e0037] registered
3: local_timer is per-cpu
3: local_timer is preferred
clockevents_shutdown 3 8101f1c0
------------[ cut here ]------------
WARNING: CPU: 3 PID: 0 at kernel/time/clockevents.c:98 clockevents_exchange_device+0x7c/0x8c()
Modules linked in:
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.10.0-next-20130701+ #2
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<80517800>] (dump_stack+0x78/0x94)
[<80517800>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800615f0>] (clockevents_exchange_device+0x7c/0x8c)
[<800615f0>] (clockevents_exchange_device+0x7c/0x8c) from [<80061d90>] (tick_check_new_device+0xf4/0x158)
[<80061d90>] (tick_check_new_device+0xf4/0x158) from [<80060eb0>] (clockevents_register_device+0x58/0x128)
[<80060eb0>] (clockevents_register_device+0x58/0x128) from [<80014024>] (twd_timer_setup+0xac/0x20c)
[<80014024>] (twd_timer_setup+0xac/0x20c) from [<80013004>] (percpu_timer_setup+0x5c/0xb4)
[<80013004>] (percpu_timer_setup+0x5c/0xb4) from [<80013404>] (secondary_start_kernel+0x100/0x140)
[<80013404>] (secondary_start_kernel+0x100/0x140) from [<100081ec>] (0x100081ec)
---[ end trace 1b75b31a2719ed24 ]---
Checking dummy_timer
3: dummy_timer is per-cpu
3: dummy_timer is trying broadcast
hw-breakpoint: found 5 (+1 reserved) breakpoint and 1 watchpoint registers.
hw-breakpoint: maximum watchpoint size is 4 bytes.
imx6q-pinctrl 20e0000.iomuxc: initialized IMX pinctrl driver
bio: create slab <bio-0> at 0
mxs-dma 110000.dma-apbh: initialized
usb_otg_vbus: 5000 mV 
wm8962-supply: no parameters
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
i2c i2c-0: IMX I2C adapter registered
Linux video capture interface: v2.00
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
Advanced Linux Sound Architecture Driver Initialized.
tick_clock_notify
Switched to clocksource mxc_timer1
bc_setup_oneshot 3 80755900
next 800000000098967f nevt 7fffffffffffffff per 989680 nxtp 48b7b900 now 4890a0f3 2 810171c0 93
------------[ cut here ]------------
WARNING: CPU: 2 PID: 0 at kernel/time/clockevents.c:214 clockevents_program_event+0x134/0x148()
Modules linked in:
next 800000001d34ce7f nevt 7fffffffffffffff per 989680 nxtp 48b7b900 now 489c4ed4 2 810171c0 93
next 8000000226bf35ff nevt 7fffffffffffffff per 989680 nxtp 49504f80 now 49193e51 2 810171c0 93
next 8000000430e233ff nevt 7fffffffffffffff per 989680 nxtp 49504f80 now 49995518 2 810171c0 93
next 800000063b0531ff nevt 7fffffffffffffff per 989680 nxtp 49504f80 now 4a1b13ff 2 810171c0 93
next 8000000845c0c67f nevt 7fffffffffffffff per 989680 nxtp 49504f80 now 4a9d8aca 2 810171c0 93
...


