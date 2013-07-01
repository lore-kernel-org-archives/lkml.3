Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3GAKoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:44:22 -0400
Received: from mail-db9lp0251.outbound.messaging.microsoft.com ([213.199.154.251]:11680
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686Ab3GAKoT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:44:19 -0400
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 06:44:18 EDT
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dhbe9i1155h)
From: Stehle Vincent-B46079 <B46079@freescale.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Subject: RE: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Topic: next-20130627 breaks i.MX6 sabre sd UART console
Thread-Index: Ac5zZxBZeupdDlSIRDWI6ggVo3oJ5QAkUYcAAAf2xwAAAZFOUAAA2+yAABLhygAAdGeRAA==
Date: Mon, 1 Jul 2013 10:29:08 +0000
Message-ID: <F7C43F8B2814514CA05F3436BC68046EF2EF29@039-SN2MPN1-011.039d.mgd.msft.net>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
 <51CDB26A.9060500@codeaurora.org>
 <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org> <20130629020738.GG11625@codeaurora.org>
In-Reply-To: <20130629020738.GG11625@codeaurora.org>
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

From: Stephen Boyd [mailto:sboyd@codeaurora.org] 
> (..) Is this an SMP capable device? What devicetree blob are you using?

Yes, this is an i.MX6 quad. I boot with imx6q-sabresd.dtb

> (..) Well oddly I don't see any twd in the timer list
> but that may be because you're not running more than one CPU?
> It would be good to get the output when you run SMP if it has that support.

Now that you mention it I see that mainline v3.10 boots with only one CPU. So I took next-20130625 instead, which does boot in SMP, and I captured /proc/timer_list and /proc/interrupts below.

> (..) If you can get debug_ll and earlyprinkt working it would be useful
> if you can apply the attached patch and give back the logs.

Sure; it worked, thanks. I pasted the full boot log below. There are messages about clockevents_program_event(), it seems.

Best regards,

V.

--- /proc/timer_list ---

Timer List Version: v0.7
HRTIMER_MAX_CLOCK_BASES: 4
now at 67484354137 nsecs

cpu: 0
 clock 0:
  .base:       80fa6620
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <80fa68f8>, tick_sched_timer, S:01
 # expires at 67490000000-67490000000 nsecs [in 5646514 to 5646514 nsecs]
 #1: <bf875a90>, hrtimer_wakeup, S:01
 # expires at 68540821093-68545821090 nsecs [in 1056467607 to 1061467604 nsecs]
 #2: <bef37f28>, hrtimer_wakeup, S:01
 # expires at 70726814442-70726864442 nsecs [in 3242460956 to 3242510956 nsecs]
 #3: <bf0dff28>, hrtimer_wakeup, S:01
 # expires at 90990432538-90990482538 nsecs [in 23506079052 to 23506129052 nsecs]
 #4: <bed49a90>, hrtimer_wakeup, S:01
 # expires at 86430225655326-86430325655326 nsecs [in 86362741301840 to 86362841301840 nsecs]
 clock 1:
  .base:       80fa6658
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     9030273192973 nsecs
active timers:
 clock 2:
  .base:       80fa6690
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       80fa66c8
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     9030273192973 nsecs
active timers:
  .expires_next   : 67490000000 nsecs
  .hres_active    : 1
  .nr_events      : 2441
  .nr_retries     : 0
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .last_tick      : 67480000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294944043
  .idle_calls     : 13840
  .idle_sleeps    : 1049
  .idle_entrytime : 67482221744 nsecs
  .idle_waketime  : 67474377895 nsecs
  .idle_exittime  : 67474461274 nsecs
  .idle_sleeptime : 52815293619 nsecs
  .iowait_sleeptime: 2416282884 nsecs
  .last_jiffies   : 4294944044
  .next_jiffies   : 4294944045
  .idle_expires   : 67510000000 nsecs
jiffies: 4294944044

cpu: 1
 clock 0:
  .base:       80fae620
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <80fae8f8>, tick_sched_timer, S:01
 # expires at 67490000000-67490000000 nsecs [in 5646514 to 5646514 nsecs]
 clock 1:
  .base:       80fae658
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     9030273192973 nsecs
active timers:
 clock 2:
  .base:       80fae690
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       80fae6c8
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     9030273192973 nsecs
active timers:
  .expires_next   : 67490000000 nsecs
  .hres_active    : 1
  .nr_events      : 1297
  .nr_retries     : 0
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .last_tick      : 67480000000 nsecs
  .tick_stopped   : 0
  .idle_jiffies   : 4294944043
  .idle_calls     : 4804
  .idle_sleeps    : 956
  .idle_entrytime : 67480050107 nsecs
  .idle_waketime  : 67475562153 nsecs
  .idle_exittime  : 67475569865 nsecs
  .idle_sleeptime : 63549212250 nsecs
  .iowait_sleeptime: 152457798 nsecs
  .last_jiffies   : 4294944044
  .next_jiffies   : 4294944045
  .idle_expires   : 92808680164 nsecs
jiffies: 4294944044

cpu: 2
 clock 0:
  .base:       80fb6620
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <80fb68f8>, tick_sched_timer, S:01
 # expires at 67640000000-67640000000 nsecs [in 155646514 to 155646514 nsecs]
 clock 1:
  .base:       80fb6658
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     9030273192973 nsecs
active timers:
 clock 2:
  .base:       80fb6690
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       80fb66c8
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     9030273192973 nsecs
active timers:
  .expires_next   : 67640000000 nsecs
  .hres_active    : 1
  .nr_events      : 1350
  .nr_retries     : 0
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .last_tick      : 67450000000 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 4294944040
  .idle_calls     : 2712
  .idle_sleeps    : 446
  .idle_entrytime : 67440072774 nsecs
  .idle_waketime  : 67440003456 nsecs
  .idle_exittime  : 67440042425 nsecs
  .idle_sleeptime : 64448445338 nsecs
  .iowait_sleeptime: 201545335 nsecs
  .last_jiffies   : 4294944040
  .next_jiffies   : 4294944060
  .idle_expires   : 67640000000 nsecs
jiffies: 4294944044

cpu: 3
 clock 0:
  .base:       80fbe620
  .index:      0
  .resolution: 1 nsecs
  .get_time:   ktime_get
  .offset:     0 nsecs
active timers:
 #0: <80fbe8f8>, tick_sched_timer, S:01
 # expires at 67870000000-67870000000 nsecs [in 385646514 to 385646514 nsecs]
 clock 1:
  .base:       80fbe658
  .index:      1
  .resolution: 1 nsecs
  .get_time:   ktime_get_real
  .offset:     9030273192973 nsecs
active timers:
 clock 2:
  .base:       80fbe690
  .index:      2
  .resolution: 1 nsecs
  .get_time:   ktime_get_boottime
  .offset:     0 nsecs
active timers:
 clock 3:
  .base:       80fbe6c8
  .index:      3
  .resolution: 1 nsecs
  .get_time:   ktime_get_clocktai
  .offset:     9030273192973 nsecs
active timers:
  .expires_next   : 67870000000 nsecs
  .hres_active    : 1
  .nr_events      : 928
  .nr_retries     : 0
  .nr_hangs       : 0
  .max_hang_time  : 0 nsecs
  .nohz_mode      : 2
  .last_tick      : 66880000000 nsecs
  .tick_stopped   : 1
  .idle_jiffies   : 4294943983
  .idle_calls     : 2050
  .idle_sleeps    : 176
  .idle_entrytime : 66870068456 nsecs
  .idle_waketime  : 66870003047 nsecs
  .idle_exittime  : 66870041956 nsecs
  .idle_sleeptime : 64340076917 nsecs
  .iowait_sleeptime: 67903365 nsecs
  .last_jiffies   : 4294943983
  .next_jiffies   : 4294944083
  .idle_expires   : 67870000000 nsecs
jiffies: 4294944044

Tick Device: mode:     1
Broadcast device
Clock Event Device: mxc_timer1
 max_delta_ns:   65075261923
 min_delta_ns:   3863
 mult:           141733921
 shift:          31
 mode:           1
 next_event:     9223372036854775807 nsecs
 set_next_event: v2_set_next_event
 set_mode:       mxc_set_mode
 event_handler:  tick_handle_oneshot_broadcast
 retries:        0

tick_broadcast_mask: 00000000
tick_broadcast_oneshot_mask: 00000000

Tick Device: mode:     1
Per CPU device: 0
Clock Event Device: local_timer
 max_delta_ns:   10845877002
 min_delta_ns:   1000
 mult:           850403525
 shift:          31
 mode:           3
 next_event:     67490000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 1
Clock Event Device: local_timer
 max_delta_ns:   10845877002
 min_delta_ns:   1000
 mult:           850403525
 shift:          31
 mode:           3
 next_event:     67490000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 2
Clock Event Device: local_timer
 max_delta_ns:   10845877002
 min_delta_ns:   1000
 mult:           850403525
 shift:          31
 mode:           3
 next_event:     67840000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0

Tick Device: mode:     1
Per CPU device: 3
Clock Event Device: local_timer
 max_delta_ns:   10845877002
 min_delta_ns:   1000
 mult:           850403525
 shift:          31
 mode:           3
 next_event:     67870000000 nsecs
 set_next_event: twd_set_next_event
 set_mode:       twd_set_mode
 event_handler:  hrtimer_interrupt
 retries:        0

--- /proc/interrupts ---

           CPU0       CPU1       CPU2       CPU3
 29:       2667       1326       1719       1004       GIC  29  twd
 34:          0          0          0          0       GIC  34  sdma
 51:          0          0          0          0       GIC  51  rtc alarm
 55:          0          0          0          0       GIC  55  mmc0
 56:        769          0          0          0       GIC  56  mmc1
 58:        647          0          0          0       GIC  58  IMX-uart
 63:          2          0          0          0       GIC  63  spi_imx
 68:          0          0          0          0       GIC  68  21a0000.i2c
 72:          0          0          0          0       GIC  72  ci_hdrc_imx
 75:          0          0          0          0       GIC  75  ci_hdrc_imx
 87:          9          0          0          0       GIC  87  i.MX Timer Tick
150:      33007          0          0          0       GIC 150  2188000.ethernet
151:          0          0          0          0       GIC 151  2188000.ethernet
164:          0          0          0          0  gpio-mxc   4  Volume Up
165:          0          0          0          0  gpio-mxc   5  Volume Down
192:          0          0          0          0  gpio-mxc   0  2198000.usdhc cd
194:          0          0          0          0  gpio-mxc   2  2194000.usdhc cd
384:          0          0          0          0       IPU  23  imx_drm
385:          0          0          0          0       IPU  28  imx_drm
386:          0          0          0          0       IPU  23  imx_drm
387:          0          0          0          0       IPU  28  imx_drm
IPI0:          0          0          0          0  CPU wakeup interrupts
IPI1:          0          0          0          0  Timer broadcast interrupts
IPI2:       1566       4556       2282       1940  Rescheduling interrupts
IPI3:          3          5          2          5  Function call interrupts
IPI4:          0          0          0          0  Single function call interrupts
IPI5:          0          0          0          0  CPU stop interrupts
Err:          0

--- Boot log with debug_ll, earlyprintk and patch 2 ---

U-Boot 2013.07-rc1-00209-g35186c8 (Jun 28 2013 - 18:22:00)

CPU:   Freescale i.MX6Q rev1.2 at 792 MHz
Reset cause: POR
Board: MX6Q-SabreSD
DRAM:  1 GiB
MMC:   FSL_SDHC: 0, FSL_SDHC: 1, FSL_SDHC: 2
In:    serial
Out:   serial
Err:   serial
Net:   FEC [PRIME]
Hit any key to stop autoboot:  0
Booting from net ...
FEC Waiting for PHY auto negotiation to complete.... done
BOOTP broadcast 1
DHCP client bound to address 192.168.111.121
Using FEC device
TFTP from server 192.168.111.1; our IP address is 192.168.111.121
Filename 'uImage'.
Load address: 0x12000000
Loading: #################################################################
         #################################################################
         #################################################################
         #################################################################
         #####################################
         4.2 MiB/s
done
Bytes transferred = 4359040 (428380 hex)
BOOTP broadcast 1
DHCP client bound to address 192.168.111.121
Using FEC device
TFTP from server 192.168.111.1; our IP address is 192.168.111.121
Filename 'imx6q-sabresd.dtb'.
Load address: 0x11000000
Loading: ##
         2.8 MiB/s
done
Bytes transferred = 26879 (68ff hex)
## Booting kernel from Legacy Image at 12000000 ...
   Image Name:   Linux-3.10.0-next-20130701+
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    4358976 Bytes = 4.2 MiB
   Load Address: 10008000
   Entry Point:  10008000
   Verifying Checksum ... OK
## Flattened Device Tree blob at 11000000
   Booting using the fdt blob at 0x11000000
   Loading Kernel Image ... OK
OK
   Using Device Tree in place at 11000000, end 110098fe

Starting kernel ...

Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Linux version 3.10.0-next-20130701+ (vstehle@debian) (gcc version 4.7.2 (Debian 4.7.2-5) ) #1 SMP Mon Jul 1 11:52:44 CEST 2013
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
      .text : 0x80008000 - 0x806fb4e4   (7118 kB)
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
Checking mxc_timer1
0: mxc_timer1 is per-cpu
0: mxc_timer1 is trying broadcast
mxc_timer1 is now the broadcast
Setting up static identity map for 0x8051be70 - 0x8051bee0
Checking dummy_timer
0: dummy_timer is per-cpu
0: dummy_timer is trying broadcast
CPU1: Booted secondary processor
Checking dummy_timer
1: dummy_timer is per-cpu
1: dummy_timer is preferred
CPU1: thread -1, cpu 1, socket 0, mpidr 80000001
Checking local_timer
CPU2: Booted secondary processor
1: local_timer is per-cpu
1: local_timer is preferred
Checking dummy_timer
1: dummy_timer is per-cpu
1: dummy_timer is trying broadcast
Checking dummy_timer
2: dummy_timer is per-cpu
2: dummy_timer is preferred
CPU2: thread -1, cpu 2, socket 0, mpidr 80000002
Checking local_timer
CPU3: Booted secondary processor
2: local_timer is per-cpu
2: local_timer is preferred
Checking dummy_timer
2: dummy_timer is per-cpu
2: dummy_timer is trying broadcast
Checking dummy_timer
3: dummy_timer is per-cpu
3: dummy_timer is preferred
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
Switched to clocksource mxc_timer1
------------[ cut here ]------------
------------[ cut here ]------------
WARNING: CPU: 2 PID: 0 at kernel/time/clockevents.c:212 clockevents_program_event+0x134/0x148()
Modules linked in:
CPU: 2 PID: 0 Comm: swapper/2 Not tainted 3.10.0-next-20130701+ #1
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<805176a0>] (dump_stack+0x78/0x94)
[<805176a0>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800613f4>] (clockevents_program_event+0x134/0x148)
[<800613f4>] (clockevents_program_event+0x134/0x148) from [<80061900>] (tick_handle_periodic+0x64/0x88)
[<80061900>] (tick_handle_periodic+0x64/0x88) from [<80013f48>] (twd_handler+0x2c/0x40)
[<80013f48>] (twd_handler+0x2c/0x40) from [<800774e8>] (handle_percpu_devid_irq+0x80/0xa0)
[<800774e8>] (handle_percpu_devid_irq+0x80/0xa0) from [<80073d40>] (generic_handle_irq+0x20/0x30)
[<80073d40>] (generic_handle_irq+0x20/0x30) from [<8000edb8>] (handle_IRQ+0x4c/0xb0)
[<8000edb8>] (handle_IRQ+0x4c/0xb0) from [<800086d4>] (gic_handle_irq+0x28/0x5c)
[<800086d4>] (gic_handle_irq+0x28/0x5c) from [<80012080>] (__irq_svc+0x40/0x54)
Exception stack(0xbf899f98 to 0xbf899fe0)
9f80:                                                       00000000 00003ecc
9fa0: 00000000 8001cf60 bf898000 8078c428 00000001 8078c428 807508e8 80750894
9fc0: 8051e3ac 00000000 80750894 bf899fe0 8000f0cc 8000f0d0 60000113 ffffffff
[<80012080>] (__irq_svc+0x40/0x54) from [<8000f0d0>] (arch_cpu_idle+0x30/0x3c)
[<8000f0d0>] (arch_cpu_idle+0x30/0x3c) from [<80059f74>] (cpu_startup_entry+0x64/0x138)
[<80059f74>] (cpu_startup_entry+0x64/0x138) from [<100081ec>] (0x100081ec)
---[ end trace f6330182bcabb113 ]---
NET: Registered protocol family 2
TCP established hash table entries: 8192 (order: 4, 65536 bytes)
TCP bind hash table entries: 8192 (order: 4, 65536 bytes)
TCP: Hash tables configured (established 8192 bind 8192)
TCP: reno registered
UDP hash table entries: 512 (order: 2, 16384 bytes)
UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
WARNING: CPU: 3 PID: 0 at kernel/time/clockevents.c:212 clockevents_program_event+0x134/0x148()
Modules linked in:
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.10.0-next-20130701+ #1
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<805176a0>] (dump_stack+0x78/0x94)
[<805176a0>] (dump_stack+0x78/0x94) from [<8002407c>] (warn_slowpath_common+0x64/0x88)
[<8002407c>] (warn_slowpath_common+0x64/0x88) from [<800240bc>] (warn_slowpath_null+0x1c/0x24)
[<800240bc>] (warn_slowpath_null+0x1c/0x24) from [<800613f4>] (clockevents_program_event+0x134/0x148)
[<800613f4>] (clockevents_program_event+0x134/0x148) from [<80061900>] (tick_handle_periodic+0x64/0x88)
[<80061900>] (tick_handle_periodic+0x64/0x88) from [<80013f48>] (twd_handler+0x2c/0x40)
[<80013f48>] (twd_handler+0x2c/0x40) from [<800774e8>] (handle_percpu_devid_irq+0x80/0xa0)
[<800774e8>] (handle_percpu_devid_irq+0x80/0xa0) from [<80073d40>] (generic_handle_irq+0x20/0x30)
[<80073d40>] (generic_handle_irq+0x20/0x30) from [<8000edb8>] (handle_IRQ+0x4c/0xb0)
[<8000edb8>] (handle_IRQ+0x4c/0xb0) from [<800086d4>] (gic_handle_irq+0x28/0x5c)
[<800086d4>] (gic_handle_irq+0x28/0x5c) from [<80012080>] (__irq_svc+0x40/0x54)
Exception stack(0xbf89bf98 to 0xbf89bfe0)
bf80:                                                       00000000 00000052
bfa0: 00000000 8001cf60 bf89a000 8078c428 00000001 8078c428 807508e8 80750894
bfc0: 8051e3ac 00000000 80750894 bf89bfe0 8000f0cc 8000f0d0 60000113 ffffffff
[<80012080>] (__irq_svc+0x40/0x54) from [<8000f0d0>] (arch_cpu_idle+0x30/0x3c)
[<8000f0d0>] (arch_cpu_idle+0x30/0x3c) from [<80059f74>] (cpu_startup_entry+0x64/0x138)
[<80059f74>] (cpu_startup_entry+0x64/0x138) from [<100081ec>] (0x100081ec)
---[ end trace f6330182bcabb114 ]---
INFO: rcu_sched self-detected stall on CPU
INFO: rcu_sched self-detected stall on CPU { 2}  (t=2100 jiffies g=4294966998 c=4294966997 q=8)
CPU: 2 PID: 0 Comm: swapper/2 Tainted: G        W    3.10.0-next-20130701+ #1
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<805176a0>] (dump_stack+0x78/0x94)
[<805176a0>] (dump_stack+0x78/0x94) from [<8007ccf8>] (rcu_check_callbacks+0x2a8/0x700)
[<8007ccf8>] (rcu_check_callbacks+0x2a8/0x700) from [<80031ac4>] (update_process_times+0x38/0x64)
[<80031ac4>] (update_process_times+0x38/0x64) from [<8006191c>] (tick_handle_periodic+0x80/0x88)
[<8006191c>] (tick_handle_periodic+0x80/0x88) from [<80013f48>] (twd_handler+0x2c/0x40)
[<80013f48>] (twd_handler+0x2c/0x40) from [<800774e8>] (handle_percpu_devid_irq+0x80/0xa0)
[<800774e8>] (handle_percpu_devid_irq+0x80/0xa0) from [<80073d40>] (generic_handle_irq+0x20/0x30)
[<80073d40>] (generic_handle_irq+0x20/0x30) from [<8000edb8>] (handle_IRQ+0x4c/0xb0)
[<8000edb8>] (handle_IRQ+0x4c/0xb0) from [<800086d4>] (gic_handle_irq+0x28/0x5c)
[<800086d4>] (gic_handle_irq+0x28/0x5c) from [<80012080>] (__irq_svc+0x40/0x54)
Exception stack(0xbf899f98 to 0xbf899fe0)
9f80:                                                       00000000 00003ecc
9fa0: 00000000 8001cf60 bf898000 8078c428 00000001 8078c428 807508e8 80750894
9fc0: 8051e3ac 00000000 80750894 bf899fe0 8000f0cc 8000f0d0 60000113 ffffffff
[<80012080>] (__irq_svc+0x40/0x54) from [<8000f0d0>] (arch_cpu_idle+0x30/0x3c)
[<8000f0d0>] (arch_cpu_idle+0x30/0x3c) from [<80059f74>] (cpu_startup_entry+0x64/0x138)
[<80059f74>] (cpu_startup_entry+0x64/0x138) from [<100081ec>] (0x100081ec)
 { 3}  (t=2115 jiffies g=4294966998 c=4294966997 q=8)
CPU: 3 PID: 0 Comm: swapper/3 Tainted: G        W    3.10.0-next-20130701+ #1
[<800147d4>] (unwind_backtrace+0x0/0xf0) from [<80011538>] (show_stack+0x10/0x14)
[<80011538>] (show_stack+0x10/0x14) from [<805176a0>] (dump_stack+0x78/0x94)
[<805176a0>] (dump_stack+0x78/0x94) from [<8007ccf8>] (rcu_check_callbacks+0x2a8/0x700)
[<8007ccf8>] (rcu_check_callbacks+0x2a8/0x700) from [<80031ac4>] (update_process_times+0x38/0x64)
[<80031ac4>] (update_process_times+0x38/0x64) from [<8006191c>] (tick_handle_periodic+0x80/0x88)
[<8006191c>] (tick_handle_periodic+0x80/0x88) from [<80013f48>] (twd_handler+0x2c/0x40)
[<80013f48>] (twd_handler+0x2c/0x40) from [<800774e8>] (handle_percpu_devid_irq+0x80/0xa0)
[<800774e8>] (handle_percpu_devid_irq+0x80/0xa0) from [<80073d40>] (generic_handle_irq+0x20/0x30)
[<80073d40>] (generic_handle_irq+0x20/0x30) from [<8000edb8>] (handle_IRQ+0x4c/0xb0)
[<8000edb8>] (handle_IRQ+0x4c/0xb0) from [<800086d4>] (gic_handle_irq+0x28/0x5c)
[<800086d4>] (gic_handle_irq+0x28/0x5c) from [<80012080>] (__irq_svc+0x40/0x54)
Exception stack(0xbf89bf98 to 0xbf89bfe0)
bf80:                                                       00000000 00000052
bfa0: 00000000 8001cf60 bf89a000 8078c428 00000001 8078c428 807508e8 80750894
bfc0: 8051e3ac 00000000 80750894 bf89bfe0 8000f0cc 8000f0d0 60000113 ffffffff
[<80012080>] (__irq_svc+0x40/0x54) from [<8000f0d0>] (arch_cpu_idle+0x30/0x3c)
[<8000f0d0>] (arch_cpu_idle+0x30/0x3c) from [<80059f74>] (cpu_startup_entry+0x64/0x138)
[<80059f74>] (cpu_startup_entry+0x64/0x138) from [<100081ec>] (0x100081ec)


