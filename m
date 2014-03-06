Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbaCFByK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 20:54:10 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:59263 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbaCFByF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 20:54:05 -0500
MIME-Version: 1.0
In-Reply-To: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
References: <1394014430-26485-1-git-send-email-iivanov@mm-sol.com>
Date: Wed, 5 Mar 2014 17:54:03 -0800
Message-ID: <CA+bK7J5ABQ9WcSKkLf=DfTEv3xb_ZKDYgjHTqwLbapYr63ivxQ@mail.gmail.com>
Subject: Re: [PATCH v5 00/14] usb: phy: msm: Fixes, cleanups and DT support
From: Tim Bird <tbird20d@gmail.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>, David Brown <davidb@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan,

I'm still unsuccessful at getting this patch set to work on my kernel.
 Below is a sequence of register dumps showing the boot (and reset
during boot).  It shows a status transition in my kernel when I pull
the controller out of reset, and re-write PORTSC:PTS to ULPI
(simultaneously writing other bits in PORTSC to 0) This is at 3.109535
in the boot log below.  The status I'm seeing back from the other
registers doesn't make sense, and is different from what I see in 3.4
(where USB runs successfully on the board).  Is there some connection
between the PMIC and the USB that I'm missing?  The transition from
vbus B session valid to vbus B session end seems wrong (as does the
ULPII transitioning to 1).

In measuring voltages on the board, it appears that that vbus from the
connector (at 5V) gets routed through the PMIC, but comes out at 3.3V
on its way to the PHY VBUS input (measured at R179).  This seems
really weird - maybe you can shed some light on what is going on here.

Could you possibly send me your zImage and dtb file, so I can test
them on my board to make sure that the hardware is working?

Thanks,
 -- Tim

Here is my bootup sequence:
[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] TRB: version 88888
[    0.000000] Linux version 3.13.0-rc6-00148-g1076101-dirty
(10102229@ussvlx8980) (gcc version 4.6.x-
google 20120106 (prerelease) (GCC) ) #79 SMP PREEMPT Wed Mar 5
17:41:54 PST 2014
[    0.000000] CPU: ARMv7 Processor [512f06f0] revision 0 (ARMv7),
cr=10c5387d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, PIPT
instruction cache
[    0.000000] Machine model: Qualcomm APQ8074 Dragonboard
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: Data cache writealloc
[    0.000000] On node 0 totalpages: 524288
[    0.000000] free_area_init_node: node 0, pgdat c08abac0,
node_mem_map c0922000
[    0.000000]   Normal zone: 1520 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 194560 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2576 pages used for memmap
[    0.000000]   HighMem zone: 329728 pages, LIFO batch:31
[    0.000000] PERCPU: Embedded 8 pages/cpu @c1935000 s12224 r8192
d12352 u32768
[    0.000000] pcpu-alloc: s12224 r8192 d12352 u32768 alloc=8*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 522768
[    0.000000] Kernel command line: console=ttyMSM,115200,n8
androidboot.hardware=qcom user_debug=31 m
axcpus=2 msm_rtb.filter=0x37 ehci-hcd.park=3 earlyprintk debug
androidboot.emmc=true androidboot.seria
lno=40081a14 androidboot.baseband=apq
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7,
524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144
bytes)
[    0.000000] Memory: 2068932K/2097152K available (4458K kernel code,
257K rwdata, 1820K rodata, 283K
 init, 443K bss, 28220K reserved, 1318912K highmem)
[    0.000000] Virtual kernel memory layout:
[    0.000000]     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
[    0.000000]     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
[    0.000000]     vmalloc : 0xf0000000 - 0xff000000   ( 240 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xef800000   ( 760 MB)
[    0.000000]     pkmap   : 0xbfe00000 - 0xc0000000   (   2 MB)
[    0.000000]     modules : 0xbf000000 - 0xbfe00000   (  14 MB)
[    0.000000]       .text : 0xc0208000 - 0xc0829de8   (6280 kB)
[    0.000000]       .init : 0xc082a000 - 0xc0870fc0   ( 284 kB)
[    0.000000]       .data : 0xc0872000 - 0xc08b240c   ( 258 kB)
[    0.000000]        .bss : 0xc08b240c - 0xc092139c   ( 444 kB)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=4,
Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] Architected cp15 and mmio timer(s) running at 19.20MHz
(virt/virt).
[    0.000000] sched_clock: 56 bits at 19MHz, resolution 52ns, wraps
every 3579139424256ns
[    0.000000] Switching to timer-based delay loop
[    0.000000] Console: colour dummy device 80x30
[    0.009136] Calibrating delay loop (skipped), value calculated
using timer frequency.. 38.40 BogoMI
PS (lpj=192000)
[    0.019535] pid_max: default: 32768 minimum: 301
[    0.024383] Mount-cache hash table entries: 512
[    0.029530] CPU: Testing write buffer coherency: ok
[    0.033969] CPU0: thread -1, cpu 0, socket 0, mpidr 80000000
[    0.039532] Setting up static identity map for 0x63b910 - 0x63b968
[    0.119860] CPU1: failed to boot: -38
[    0.139881] CPU2: failed to boot: -38
[    0.159915] CPU3: failed to boot: -38
[    0.162640] Brought up 1 CPUs
[    0.165657] SMP: Total of 1 processors activated.
[    0.170459] CPU: All CPU(s) started in SVC mode.
[    0.184094] VFP support v0.3: implementor 51 architecture 0 part 6f
variant 2 rev 0
[    0.191855] pinctrl core: initialized pinctrl subsystem
[    0.196365] regulator-dummy: no parameters
[    0.200498] NET: Registered protocol family 16
[    0.205042] DMA: preallocated 256 KiB pool for atomic coherent
allocations
[    0.215631] hw-breakpoint: found 5 (+1 reserved) breakpoint and 4
watchpoint registers.
[    0.222677] hw-breakpoint: maximum watchpoint size is 8 bytes.
[    0.232176] bio: create slab <bio-0> at 0
[    0.235853] SCSI subsystem initialized
[    0.240139] Switched to clocksource arch_sys_counter
[    0.249150] cfg80211: Calling CRDA to update world regulatory
domain
[    0.277578] NET: Registered protocol family 2
[    0.281408] TCP established hash table entries: 8192 (order: 3,
32768 bytes)
[    0.288130] TCP bind hash table entries: 8192 (order: 4, 65536
bytes)
[    0.294707] TCP: Hash tables configured (established 8192 bind
8192)
[    0.301082] TCP: reno registered
[    0.304335] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    0.310353] UDP-Lite hash table entries: 512 (order: 2, 16384
bytes)
[    0.316930] NET: Registered protocol family 1
[    0.321476] RPC: Registered named UNIX socket transport module.
[    0.327158] RPC: Registered udp transport module.
[    0.331972] RPC: Registered tcp transport module.
[    0.336707] RPC: Registered tcp NFSv4.1 backchannel transport
module.
[    0.343435] Trying to unpack rootfs image as initramfs...
[    0.565367] Freeing initrd memory: 3508K (c2000000 - c236d000)
[    0.570590] using sfpb hardware mutex registers (auto)
[    0.575592] smem_of_init: initialized successfully
[    0.580643] parse_smd_devicetree: enable_irq_wake() failed on 57
[    0.586427] parse_smsm_devicetree: enable_irq_wake() failed on 58
[    0.592650] parse_smd_devicetree: enable_irq_wake() failed on 188
[    0.598750] parse_smsm_devicetree: enable_irq_wake() failed on 189
[    0.605025] parse_smd_devicetree: enable_irq_wake() failed on 174
[    0.611184] parse_smsm_devicetree: enable_irq_wake() failed on 176
[    0.617414] parse_smd_devicetree: enable_irq_wake() failed on 200
[    0.623562] SMD successfully initialized
[    0.705001] bounce pool size: 64 pages
[    0.713164] NFS: Registering the id_resolver key type
[    0.717291] Key type id_resolver registered
[    0.721553] Key type id_legacy registered
[    0.726032] fuse init (API version 7.22)
[    0.729846] msgmni has been set to 1471
[    0.734961] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.741474] io scheduler noop registered
[    0.745392] io scheduler deadline registered
[    0.749838] io scheduler cfq registered (default)
[    0.754787] msm_serial:
detecte���~�`���怞f�~�����~��f��~������xx`���怞f�~`��fx��
 �
����fxf���~`ff�f��~�f������x����������f������f��fx�f�ff~`��x������r������msm_seri
a
l: console setup on port #0
[    0.786273] console [ttyMSM0] enabled
[    0.786273] console [ttyMSM0] enabled
[    0.793666] bootconsole [earlycon0] disabled
[    0.793666] bootconsole [earlycon0] disabled
[    0.802411] msm_serial: driver initialized
[    0.807063] brd: module loaded
[    0.809555] loop: module loaded
[    0.809963] SCSI Media Changer driver v0.25
[    0.812776] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels,
max=256) (6 bit encapsulation en
abled).
[    0.816828] CSLIP: code copyright 1989 Regents of the University of
California.
[    0.826380] TRB: in msm_otg_probe
[    0.833527] TRB: in msm_otg_read_dt
[    0.836962] TRB: in msm_otg_read_dt, mode=2
[    0.840321] msm_otg f9a55000.usb: OTG regs = f005e000
[    0.844438] msm_otg f9a55000.usb: unable to get hsusb vddcx
[    0.849656] platform f9a55000.usb: Driver msm_otg requests probe
deferral
[    0.855162] msm_hsusb f9a55000.gadget: in ci_hdrc_msm_probe
[    0.862003] platform f9a55000.gadget: Driver msm_hsusb requests
probe deferral
[    0.867588] mousedev: PS/2 mouse device common for all mice
[    0.874700] i2c /dev entries driver
[    0.880503] oprofile: no performance counters
[    0.883657] oprofile: using timer interrupt.
[    0.888204] TCP: cubic registered
[    0.892452] NET: Registered protocol family 17
[    0.895718] Key type dns_resolver registered
[    0.900092] Registering SWP/SWPB emulation handler
[    0.905177] 8841_s1: 675 <--> 1050 mV at 0 mV normal idle
[    0.909257] 8841_s1_ao: 675 <--> 1050 mV at 0 mV normal idle
[    0.914863] 8841_s1_so: 675 <--> 1050 mV at 675 mV normal idle
[    0.920666] 8841_s2: 500 <--> 1050 mV at 0 mV normal idle
[    0.926286] 8841_s2_corner: 0 <--> 0 mV at 0 mV normal idle
[    0.931849] 8841_s2_corner_ao: 0 <--> 0 mV at 0 mV normal idle
[    0.937649] 8841_s2_floor_corner: 0 <--> 0 mV at 0 mV normal idle
[    0.943415] 8841_s3: 1050 mV normal idle
[    0.949641] 8841_s4: 815 <--> 900 mV at 0 mV normal idle
[    0.953634] 8841_s4_corner: 0 <--> 0 mV at 0 mV normal idle
[    0.959013] 8841_s4_floor_corner: 0 <--> 0 mV at 0 mV normal idle
[    0.964861] 8941_s1: 1300 mV normal idle
[    0.970851] 8941_s2: 2150 mV normal idle
[    0.974911] 8941_s3: 1800 mV normal idle
[    0.978896] 8941_l1: 1225 mV normal idle
[    0.982918] 8941_l2: 1200 mV normal idle
[    0.986891] 8941_l3: 1200 mV normal idle
[    0.990902] 8941_l4: 1225 mV normal idle
[    0.994876] 8941_l5: 1800 mV normal idle
[    0.998871] 8941_l6: 1800 mV normal idle
[    1.002886] 8941_l7: 1800 mV normal idle
[    1.006976] 8941_l9: 1800 <--> 2950 mV at 2950 mV normal idle
[    1.010892] 8941_l10: 1800 <--> 2950 mV at 2950 mV normal idle
[    1.016574] 8941_l11: 1300 mV normal idle
[    1.022398] 8941_l12: 1800 mV normal idle
[    1.026441] 8941_l12_ao: 1800 mV normal idle
[    1.030651] 8941_l13: 1800 <--> 2950 mV at 2950 mV normal idle
[    1.035073] 8941_l14: 1800 mV normal idle
[    1.040813] 8941_l15: 2050 mV normal idle
[    1.044956] 8941_l16: 2700 mV normal idle
[    1.049029] 8941_l17: 2700 mV normal idle
[    1.053134] 8941_l18: 2850 mV normal idle
[    1.057198] 8941_l19: 3300 mV normal idle
[    1.061307] 8941_l20: 2950 mV normal idle
[    1.065358] 8941_l21: 2950 mV normal idle
[    1.069445] 8941_l22: 3000 mV normal idle
[    1.073534] 8941_l23: 2800 mV normal idle
[    1.077600] 8941_l24: 3075 mV normal idle
[    1.081698] 8941_lvs1: no parameters
[    1.085743] 8941_lvs2: no parameters
[    1.089474] 8941_lvs3: no parameters
[    1.092765] msm_rpm_dev_probe(): RPM probe completed successfully
[    1.096898] TRB: in msm_otg_probe
[    1.102323] TRB: in msm_otg_read_dt
[    1.105538] TRB: in msm_otg_read_dt, mode=2
[    1.108878] msm_otg f9a55000.usb: OTG regs = f0062000
[    1.113364] TRB: voltage initialized status=0
[    1.119019] TRB: 9999 - before interrupt reset in msm_otg_probe
[    1.122575]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    1.128283]    ### PORTSC (184) val=cc000004
[    1.133855]      PTS (31:30) transceiver select =11b: serial
[    1.143136]     PSPD (27:26) port speed =11b: ???
[    1.148067]     PHCD (23) clock disable =0
[    1.148504]     LS (11:10) line status = 00b: SEO
[    1.156835]     PE (2) port enabled =1
[    1.157272]     CCS (0) current connect status =0
[    1.160850]   remainder=00000000
[    1.165605]   ### OTGSC (1a4) val=00000e20
[    1.168905]     1MSIE (29) 1MS timer int enable =0
[    1.172828]     BSVIE (27) vbus B valid int enable =0
[    1.177586]     FIELD_1MSS (21) 1ms timer status =0
[    1.182725]     FIELD_1MST (13) 1ms timer toggle =0
[    1.187395]     BSE (12) vbus B session end =0
[    1.192271]     BSV (11) vbus B session valid =1
[    1.196769]     ASV (10) vbus A session valid =1
[    1.201562]     AVV (9) A vbus valid =1
[    1.206143]     IDPU (5) ID pullup =1
[    1.209702]   remainder=00000000
[    1.213540]   ### USBINTR (148) val=00000000
[    1.216822]     SLE (8) sleep int =0
[    1.221090]     URE (6) USB reset int=0
[    1.224633]     PCE (2) port change detect int=0
[    1.228193]     UEI (1) USB error int=0
[    1.233069]     UI (0) USB int=0
[    1.236611]   remainder=00000000
[    1.240085]   ### USBSTS (144) val=60000000
[    1.243313]     ULPI (10) ULPI event complete=0
[    1.247202]     SOF (7) SOF received=0
[    1.251733]     UEI (1) USB error=0
[    1.255535]     UI (0) USB int=0
[    1.258920]   remainder=60000000
[    1.262412]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    1.265606]      SUSPENDM=0
[    1.270567]      OpMode=00b normal
[    1.276017]      TermSelect=0
[    1.276628]      XcvrSelect=00b HS
[    1.282720]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    1.282969]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    1.288176]      DmPulldown=0
[    1.293225]      DpPulldown=0
[    1.296161]    ### ULPI_USB_INT_STS (13) val=00000000
[    1.299114]      SessEnd=0
[    1.304164] TRB: msm writel(),         addr=f0062148, val=00000000
[    1.306755] TRB: msm writel(),         addr=f00621a4, val=00000000
[    1.312952] TRB: in msm_usb_reset, entering
[    1.319077]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    1.323177]    ### PORTSC (184) val=cc000004
[    1.328714]      PTS (31:30) transceiver select =11b: serial
[    1.337998]     PSPD (27:26) port speed =11b: ???
[    1.342960]     PHCD (23) clock disable =0
[    1.343383]     LS (11:10) line status = 00b: SEO
[    1.351729]     PE (2) port enabled =1
[    1.352151]     CCS (0) current connect status =0
[    1.355711]   remainder=00000000
[    1.360500]   ### OTGSC (1a4) val=00000e00
[    1.363782]     1MSIE (29) 1MS timer int enable =0
[    1.367689]     BSVIE (27) vbus B valid int enable =0
[    1.372482]     FIELD_1MSS (21) 1ms timer status =0
[    1.377585]     FIELD_1MST (13) 1ms timer toggle =0
[    1.382290]     BSE (12) vbus B session end =0
[    1.387134]     BSV (11) vbus B session valid =1
[    1.391665]     ASV (10) vbus A session valid =1
[    1.396422]     AVV (9) A vbus valid =1
[    1.401039]     IDPU (5) ID pullup =0
[    1.404581]   remainder=00000000
[    1.408399]   ### USBINTR (148) val=00000000
[    1.411717]     SLE (8) sleep int =0
[    1.415952]     URE (6) USB reset int=0
[    1.419511]     PCE (2) port change detect int=0
[    1.423088]     UEI (1) USB error int=0
[    1.427930]     UI (0) USB int=0
[    1.431508]   remainder=00000000
[    1.434963]   ### USBSTS (144) val=60000400
[    1.438174]     ULPI (10) ULPI event complete=1
[    1.442099]     SOF (7) SOF received=0
[    1.446594]     UEI (1) USB error=0
[    1.450430]     UI (0) USB int=0
[    1.453798]   remainder=60000000
[    1.457273]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    1.460502]      SUSPENDM=0
[    1.465429]      OpMode=00b normal
[    1.470914]      TermSelect=0
[    1.471507]      XcvrSelect=00b HS
[    1.477580]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    1.477848]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    1.483072]      DmPulldown=0
[    1.488086]      DpPulldown=0
[    1.491056]    ### ULPI_USB_INT_STS (13) val=00000000
[    1.493993]      SessEnd=0
[    1.499023] TRB: in msm_link_reset, entering
[    1.501648]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    1.506058]    ### PORTSC (184) val=cc000004
[    1.511369]      PTS (31:30) transceiver select =11b: serial
[    1.520652]     PSPD (27:26) port speed =11b: ???
[    1.525583]     PHCD (23) clock disable =0
[    1.526021]     LS (11:10) line status = 00b: SEO
[    1.534368]     PE (2) port enabled =1
[    1.534790]     CCS (0) current connect status =0
[    1.538350]   remainder=00000000
[    1.543139]   ### OTGSC (1a4) val=00000e00
[    1.546421]     1MSIE (29) 1MS timer int enable =0
[    1.550346]     BSVIE (27) vbus B valid int enable =0
[    1.555104]     FIELD_1MSS (21) 1ms timer status =0
[    1.560240]     FIELD_1MST (13) 1ms timer toggle =0
[    1.564912]     BSE (12) vbus B session end =0
[    1.569772]     BSV (11) vbus B session valid =1
[    1.574303]     ASV (10) vbus A session valid =1
[    1.579062]     AVV (9) A vbus valid =1
[    1.583677]     IDPU (5) ID pullup =0
[    1.587219]   remainder=00000000
[    1.591056]   ### USBINTR (148) val=00000000
[    1.594338]     SLE (8) sleep int =0
[    1.598591]     URE (6) USB reset int=0
[    1.602167]     PCE (2) port change detect int=0
[    1.605709]     UEI (1) USB error int=0
[    1.610587]     UI (0) USB int=0
[    1.614129]   remainder=00000000
[    1.617601]   ### USBSTS (144) val=60000400
[    1.620830]     ULPI (10) ULPI event complete=1
[    1.624720]     SOF (7) SOF received=0
[    1.629233]     UEI (1) USB error=0
[    1.633069]     UI (0) USB int=0
[    1.636437]   remainder=60000000
[    1.639912]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    1.643141]      SUSPENDM=0
[    1.648068]      OpMode=00b normal
[    1.653535]      TermSelect=0
[    1.654145]      XcvrSelect=00b HS
[    1.660236]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    1.660487]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    1.665693]      DmPulldown=0
[    1.670743]      DpPulldown=0
[    1.673678]    ### ULPI_USB_INT_STS (13) val=00000000
[    1.676631]      SessEnd=0
[    1.681681] TRB: msm_otg_link_clk_reset, assert=1
[    1.684268] TRB: calling reset_control_assert
[    1.690280]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    1.693385]    ### PORTSC (184) val=08130000
[    1.698766]      PTS (31:30) transceiver select =00b: other
[    1.708050]     PSPD (27:26) port speed =10b: high
[    1.712926]     PHCD (23) clock disable =0
[    1.713348]     LS (11:10) line status = 00b: SEO
[    1.721782]     PE (2) port enabled =0
[    1.722201]     CCS (0) current connect status =0
[    1.725762]   remainder=00130000
[    1.730553]   ### OTGSC (1a4) val=08130000
[    1.733835]     1MSIE (29) 1MS timer int enable =0
[    1.737741]     BSVIE (27) vbus B valid int enable =1
[    1.742532]     FIELD_1MSS (21) 1ms timer status =0
[    1.747638]     FIELD_1MST (13) 1ms timer toggle =0
[    1.752341]     BSE (12) vbus B session end =0
[    1.757185]     BSV (11) vbus B session valid =0
[    1.761717]     ASV (10) vbus A session valid =0
[    1.766474]     AVV (9) A vbus valid =0
[    1.771091]     IDPU (5) ID pullup =0
[    1.774632]   remainder=00130000
[    1.778452]   ### USBINTR (148) val=08130000
[    1.781770]     SLE (8) sleep int =0
[    1.786004]     URE (6) USB reset int=0
[    1.789563]     PCE (2) port change detect int=0
[    1.793140]     UEI (1) USB error int=0
[    1.797982]     UI (0) USB int=0
[    1.801560]   remainder=08130000
[    1.805015]   ### USBSTS (144) val=08130000
[    1.808226]     ULPI (10) ULPI event complete=0
[    1.812150]     SOF (7) SOF received=0
[    1.816646]     UEI (1) USB error=0
[    1.820482]     UI (0) USB int=0
[    1.823850]   remainder=08130000
[    1.827324]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    1.830554]      SUSPENDM=0
[    1.835482]      OpMode=00b normal
[    1.840965]      TermSelect=0
[    1.841559]      XcvrSelect=00b HS
[    1.847633]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    1.847899]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    1.853125]      DmPulldown=0
[    1.858138]      DpPulldown=0
[    1.861108]    ### ULPI_USB_INT_STS (13) val=00000000
[    1.864045]      SessEnd=0
[    1.869075] TRB: msm_link_reset 1 - before
msm_otg_link_clk_reset(0)
[    1.871703] TRB: msm_otg_link_clk_reset, assert=0
[    1.878192] TRB: calling reset_control_deassert
[    1.882813] TRB: msm_link_reset 2 - before USB_PHY_CTRL2 |= (1<<16)
[    1.887136]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    1.893403]    ### PORTSC (184) val=cc000004
[    1.898940]      PTS (31:30) transceiver select =11b: serial
[    1.908223]     PSPD (27:26) port speed =11b: ???
[    1.913188]     PHCD (23) clock disable =0
[    1.913608]     LS (11:10) line status = 00b: SEO
[    1.921954]     PE (2) port enabled =1
[    1.922376]     CCS (0) current connect status =0
[    1.925936]   remainder=00000000
[    1.930726]   ### OTGSC (1a4) val=00000e00
[    1.934007]     1MSIE (29) 1MS timer int enable =0
[    1.937916]     BSVIE (27) vbus B valid int enable =0
[    1.942707]     FIELD_1MSS (21) 1ms timer status =0
[    1.947810]     FIELD_1MST (13) 1ms timer toggle =0
[    1.952515]     BSE (12) vbus B session end =0
[    1.957359]     BSV (11) vbus B session valid =1
[    1.961890]     ASV (10) vbus A session valid =1
[    1.966647]     AVV (9) A vbus valid =1
[    1.971263]     IDPU (5) ID pullup =0
[    1.974806]   remainder=00000000
[    1.978626]   ### USBINTR (148) val=00000000
[    1.981942]     SLE (8) sleep int =0
[    1.986177]     URE (6) USB reset int=0
[    1.989735]     PCE (2) port change detect int=0
[    1.993315]     UEI (1) USB error int=0
[    1.998157]     UI (0) USB int=0
[    2.001732]   remainder=00000000
[    2.005188]   ### USBSTS (144) val=60000400
[    2.008401]     ULPI (10) ULPI event complete=1
[    2.012324]     SOF (7) SOF received=0
[    2.016820]     UEI (1) USB error=0
[    2.020657]     UI (0) USB int=0
[    2.024024]   remainder=60000000
[    2.027497]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    2.030727]      SUSPENDM=0
[    2.035655]      OpMode=00b normal
[    2.041138]      TermSelect=0
[    2.041733]      XcvrSelect=00b HS
[    2.047807]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    2.048074]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    2.053324]      DmPulldown=0
[    2.058312]      DpPulldown=0
[    2.061282]    ### ULPI_USB_INT_STS (13) val=00000000
[    2.064217]      SessEnd=0
[    2.069250] TRB: msm readl(),          addr=f0062278, val=000c3c32
[    2.071877] TRB: msm writel(),         addr=f0062278, val=000d3c32
[    2.078022]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    2.084201]    ### PORTSC (184) val=cc000004
[    2.089651]      PTS (31:30) transceiver select =11b: serial
[    2.098935]     PSPD (27:26) port speed =11b: ???
[    2.103900]     PHCD (23) clock disable =0
[    2.104321]     LS (11:10) line status = 00b: SEO
[    2.112665]     PE (2) port enabled =1
[    2.113087]     CCS (0) current connect status =0
[    2.116647]   remainder=00000000
[    2.121439]   ### OTGSC (1a4) val=00000e00
[    2.124720]     1MSIE (29) 1MS timer int enable =0
[    2.128627]     BSVIE (27) vbus B valid int enable =0
[    2.133418]     FIELD_1MSS (21) 1ms timer status =0
[    2.138523]     FIELD_1MST (13) 1ms timer toggle =0
[    2.143226]     BSE (12) vbus B session end =0
[    2.148071]     BSV (11) vbus B session valid =1
[    2.152603]     ASV (10) vbus A session valid =1
[    2.157360]     AVV (9) A vbus valid =1
[    2.161976]     IDPU (5) ID pullup =0
[    2.165519]   remainder=00000000
[    2.169337]   ### USBINTR (148) val=00000000
[    2.172655]     SLE (8) sleep int =0
[    2.176890]     URE (6) USB reset int=0
[    2.180466]     PCE (2) port change detect int=0
[    2.184010]     UEI (1) USB error int=0
[    2.188868]     UI (0) USB int=0
[    2.192444]   remainder=00000000
[    2.195899]   ### USBSTS (144) val=60000400
[    2.199112]     ULPI (10) ULPI event complete=1
[    2.203036]     SOF (7) SOF received=0
[    2.207532]     UEI (1) USB error=0
[    2.211367]     UI (0) USB int=0
[    2.214737]   remainder=60000000
[    2.218209]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    2.221439]      SUSPENDM=0
[    2.226368]      OpMode=00b normal
[    2.231851]      TermSelect=0
[    2.232443]      XcvrSelect=00b HS
[    2.238518]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    2.238784]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    2.244010]      DmPulldown=0
[    2.249023]      DpPulldown=0
[    2.251994]    ### ULPI_USB_INT_STS (13) val=00000000
[    2.254929]      SessEnd=0
[    2.259961] TRB: msm_link_reset 3 - before PORTSC:PTS |=
PORTSC_PTS_SERIAL
[    2.262589] TRB: msm readl(),          addr=f0062184, val=cc000004
[    2.269428] PORTSC_PTS_ULPI=80000000
[    2.275605] PORTSC_PTS_SERIAL=c0000000
[    2.279320] TRB: msm writel(),         addr=f0062184, val=cc000004
[    2.282899] TRB: msm_link_reset 4
[    2.289042] TRB: doing ULPI_FUNC_CTRL: clear SUSPENDM
[    2.292449] TRB: ulpi_write reg=0x6, val=0x40
[    2.297464] TRB: msm writel(),         addr=f0062170, val=60060040
[    2.301825] TRB: msm readl(),          addr=f0062170, val=28060040
[    2.307883]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    2.314063]    ### PORTSC (184) val=cc000004
[    2.319512]      PTS (31:30) transceiver select =11b: serial
[    2.328796]     PSPD (27:26) port speed =11b: ???
[    2.333760]     PHCD (23) clock disable =0
[    2.334183]     LS (11:10) line status = 00b: SEO
[    2.342527]     PE (2) port enabled =1
[    2.342949]     CCS (0) current connect status =0
[    2.346509]   remainder=00000000
[    2.351299]   ### OTGSC (1a4) val=00000e00
[    2.354580]     1MSIE (29) 1MS timer int enable =0
[    2.358489]     BSVIE (27) vbus B valid int enable =0
[    2.363280]     FIELD_1MSS (21) 1ms timer status =0
[    2.368383]     FIELD_1MST (13) 1ms timer toggle =0
[    2.373088]     BSE (12) vbus B session end =0
[    2.377932]     BSV (11) vbus B session valid =1
[    2.382463]     ASV (10) vbus A session valid =1
[    2.387220]     AVV (9) A vbus valid =1
[    2.391836]     IDPU (5) ID pullup =0
[    2.395379]   remainder=00000000
[    2.399199]   ### USBINTR (148) val=00000000
[    2.402515]     SLE (8) sleep int =0
[    2.406750]     URE (6) USB reset int=0
[    2.410326]     PCE (2) port change detect int=0
[    2.413870]     UEI (1) USB error int=0
[    2.418729]     UI (0) USB int=0
[    2.422305]   remainder=00000000
[    2.425761]   ### USBSTS (144) val=60000400
[    2.428974]     ULPI (10) ULPI event complete=1
[    2.432897]     SOF (7) SOF received=0
[    2.437393]     UEI (1) USB error=0
[    2.441229]     UI (0) USB int=0
[    2.444597]   remainder=60000000
[    2.448071]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    2.451301]      SUSPENDM=0
[    2.456229]      OpMode=00b normal
[    2.461712]      TermSelect=0
[    2.462306]      XcvrSelect=00b HS
[    2.468380]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    2.468645]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    2.473870]      DmPulldown=0
[    2.478886]      DpPulldown=0
[    2.481854]    ### ULPI_USB_INT_STS (13) val=00000000
[    2.484791]      SessEnd=0
[    2.489823] TRB: msm_link_reset 5 - before msm_otg_phy_clk_reset
[    2.492447] TRB: msm_otg_phy_clk_reset
[    2.498599]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    2.502171]    ### PORTSC (184) val=cc000004
[    2.507620]      PTS (31:30) transceiver select =11b: serial
[    2.516903]     PSPD (27:26) port speed =11b: ???
[    2.521868]     PHCD (23) clock disable =0
[    2.522290]     LS (11:10) line status = 00b: SEO
[    2.530635]     PE (2) port enabled =1
[    2.531056]     CCS (0) current connect status =0
[    2.534616]   remainder=00000000
[    2.539389]   ### OTGSC (1a4) val=00000e00
[    2.542706]     1MSIE (29) 1MS timer int enable =0
[    2.546595]     BSVIE (27) vbus B valid int enable =0
[    2.551386]     FIELD_1MSS (21) 1ms timer status =0
[    2.556492]     FIELD_1MST (13) 1ms timer toggle =0
[    2.561197]     BSE (12) vbus B session end =0
[    2.566040]     BSV (11) vbus B session valid =1
[    2.570572]     ASV (10) vbus A session valid =1
[    2.575329]     AVV (9) A vbus valid =1
[    2.579926]     IDPU (5) ID pullup =0
[    2.583504]   remainder=00000000
[    2.587306]   ### USBINTR (148) val=00000000
[    2.590623]     SLE (8) sleep int =0
[    2.594858]     URE (6) USB reset int=0
[    2.598417]     PCE (2) port change detect int=0
[    2.601994]     UEI (1) USB error int=0
[    2.606836]     UI (0) USB int=0
[    2.610413]   remainder=00000000
[    2.613869]   ### USBSTS (144) val=60000400
[    2.617080]     ULPI (10) ULPI event complete=1
[    2.621006]     SOF (7) SOF received=0
[    2.625500]     UEI (1) USB error=0
[    2.629319]     UI (0) USB int=0
[    2.632722]   remainder=60000000
[    2.636179]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    2.639391]      SUSPENDM=0
[    2.644353]      OpMode=00b normal
[    2.649802]      TermSelect=0
[    2.650430]      XcvrSelect=00b HS
[    2.656488]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    2.656753]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    2.661978]      DmPulldown=0
[    2.666992]      DpPulldown=0
[    2.669945]    ### ULPI_USB_INT_STS (13) val=00000000
[    2.672916]      SessEnd=0
[    2.677929] TRB: msm_link_reset 6 - before ulpi_read(ULPI_DEBUG)
[    2.680557] TRB: msm writel(),         addr=f0062170, val=40150000
[    2.686703] TRB: msm readl(),          addr=f0062170, val=08150000
[    2.692711] TRB: msm readl(),          addr=f0062170, val=08150000
[    2.698856] TRB: ulpi_read reg=0x15, val=0x0
[    2.705032] TRB: in msm_link_reset, leaving
[    2.709446] msm_otg f9a55000.usb: phy_reset: success
[    2.713367] TRB: in msm_otg_reset, entering
[    2.718558]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    2.722483]    ### PORTSC (184) val=cc000004
[    2.728020]      PTS (31:30) transceiver select =11b: serial
[    2.737302]     PSPD (27:26) port speed =11b: ???
[    2.742267]     PHCD (23) clock disable =0
[    2.742689]     LS (11:10) line status = 00b: SEO
[    2.751033]     PE (2) port enabled =1
[    2.751455]     CCS (0) current connect status =0
[    2.755015]   remainder=00000000
[    2.759789]   ### OTGSC (1a4) val=00000e00
[    2.763104]     1MSIE (29) 1MS timer int enable =0
[    2.766994]     BSVIE (27) vbus B valid int enable =0
[    2.771787]     FIELD_1MSS (21) 1ms timer status =0
[    2.776891]     FIELD_1MST (13) 1ms timer toggle =0
[    2.781596]     BSE (12) vbus B session end =0
[    2.786439]     BSV (11) vbus B session valid =1
[    2.790971]     ASV (10) vbus A session valid =1
[    2.795728]     AVV (9) A vbus valid =1
[    2.800345]     IDPU (5) ID pullup =0
[    2.803887]   remainder=00000000
[    2.807705]   ### USBINTR (148) val=00000000
[    2.811023]     SLE (8) sleep int =0
[    2.815258]     URE (6) USB reset int=0
[    2.818817]     PCE (2) port change detect int=0
[    2.822394]     UEI (1) USB error int=0
[    2.827236]     UI (0) USB int=0
[    2.830812]   remainder=00000000
[    2.834269]   ### USBSTS (144) val=60000400
[    2.837480]     ULPI (10) ULPI event complete=1
[    2.841403]     SOF (7) SOF received=0
[    2.845899]     UEI (1) USB error=0
[    2.849719]     UI (0) USB int=0
[    2.853122]   remainder=60000000
[    2.856578]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    2.859791]      SUSPENDM=0
[    2.864752]      OpMode=00b normal
[    2.870219]      TermSelect=0
[    2.870811]      XcvrSelect=00b HS
[    2.876886]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    2.877153]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    2.882378]      DmPulldown=0
[    2.887391]      DpPulldown=0
[    2.890362]    ### ULPI_USB_INT_STS (13) val=00000000
[    2.893297]      SessEnd=0
[    2.898328] TRB: issuing USBCMD_RESET to USB_USBCMD
[    2.900954] TRB: msm writel(),         addr=f0062140, val=00000002
[    2.905715] TRB: msm readl(),          addr=f0062140, val=00080002
[    2.911984] TRB: msm readl(),          addr=f0062140, val=00080000
[    2.918126]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    2.924306]    ### PORTSC (184) val=cc000004
[    2.929756]      PTS (31:30) transceiver select =11b: serial
[    2.939039]     PSPD (27:26) port speed =11b: ???
[    2.944003]     PHCD (23) clock disable =0
[    2.944426]     LS (11:10) line status = 00b: SEO
[    2.952770]     PE (2) port enabled =1
[    2.953191]     CCS (0) current connect status =0
[    2.956752]   remainder=00000000
[    2.961541]   ### OTGSC (1a4) val=00000e00
[    2.964825]     1MSIE (29) 1MS timer int enable =0
[    2.968732]     BSVIE (27) vbus B valid int enable =0
[    2.973523]     FIELD_1MSS (21) 1ms timer status =0
[    2.978626]     FIELD_1MST (13) 1ms timer toggle =0
[    2.983331]     BSE (12) vbus B session end =0
[    2.988175]     BSV (11) vbus B session valid =1
[    2.992707]     ASV (10) vbus A session valid =1
[    2.997464]     AVV (9) A vbus valid =1
[    3.002080]     IDPU (5) ID pullup =0
[    3.005623]   remainder=00000000
[    3.009441]   ### USBINTR (148) val=00000000
[    3.012758]     SLE (8) sleep int =0
[    3.016993]     URE (6) USB reset int=0
[    3.020571]     PCE (2) port change detect int=0
[    3.024113]     UEI (1) USB error int=0
[    3.028974]     UI (0) USB int=0
[    3.032548]   remainder=00000000
[    3.036004]   ### USBSTS (144) val=60000000
[    3.039217]     ULPI (10) ULPI event complete=0
[    3.043140]     SOF (7) SOF received=0
[    3.047636]     UEI (1) USB error=0
[    3.051496]     UI (0) USB int=0
[    3.054841]   remainder=60000000
[    3.058314]    ### ULPI_FUNC_CTRL (4,5,6) val=00000000
[    3.061545]      SUSPENDM=0
[    3.066471]      OpMode=00b normal
[    3.071954]      TermSelect=0
[    3.072549]      XcvrSelect=00b HS
[    3.078623]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    3.078890]    ### ULPI_OTG_CTRL (a,b,c) val=00000000
[    3.084112]      DmPulldown=0
[    3.089128]      DpPulldown=0
[    3.092098]    ### ULPI_USB_INT_STS (13) val=00000000
[    3.095033]      SessEnd=0
[    3.100064] TRB: in msm_otg_reset, 11111 !!! check regs here
(before) !!!
[    3.102692] TRB: turning PTS transceiver back to ULPI and resetting
rest of PORTSC
[    3.109535] TRB: msm writel(),         addr=f0062184, val=80000000
[    3.117013] TRB: in msm_otg_reset, 11122 !!! check regs here
(after) !!!
[    3.123178]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    3.130017]    ### PORTSC (184) val=8c000804
[    3.135328]      PTS (31:30) transceiver select =10b: ulpi
[    3.144611]     PSPD (27:26) port speed =11b: ???
[    3.149367]     PHCD (23) clock disable =0
[    3.149806]     LS (11:10) line status = 10b: J-state
[    3.158136]     PE (2) port enabled =1
[    3.158922]     CCS (0) current connect status =0
[    3.162499]   remainder=00000000
[    3.167255]   ### OTGSC (1a4) val=003e1000
[    3.170570]     1MSIE (29) 1MS timer int enable =0
[    3.174460]     BSVIE (27) vbus B valid int enable =0
[    3.179236]     FIELD_1MSS (21) 1ms timer status =1
[    3.184373]     FIELD_1MST (13) 1ms timer toggle =0
[    3.189045]     BSE (12) vbus B session end =1
[    3.193922]     BSV (11) vbus B session valid =0
[    3.198418]     ASV (10) vbus A session valid =0
[    3.203210]     AVV (9) A vbus valid =0
[    3.207792]     IDPU (5) ID pullup =0
[    3.211367]   remainder=001e0000
[    3.215171]   ### USBINTR (148) val=00000000
[    3.218470]     SLE (8) sleep int =0
[    3.222741]     URE (6) USB reset int=0
[    3.226281]     PCE (2) port change detect int=0
[    3.229841]     UEI (1) USB error int=0
[    3.234719]     UI (0) USB int=0
[    3.238261]   remainder=00000000
[    3.241750]   ### USBSTS (144) val=40000480
[    3.244946]     ULPI (10) ULPI event complete=1
[    3.248852]     SOF (7) SOF received=1
[    3.253382]     UEI (1) USB error=0
[    3.257185]     UI (0) USB int=0
[    3.260586]   remainder=40000000
[    3.264045]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    3.267255]      SUSPENDM=1
[    3.272217]      OpMode=10b disable bit-stuff and NRZI encoding
[    3.277670]      TermSelect=1
[    3.281071]      XcvrSelect=01b FS
[    3.286870]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    3.287136]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    3.292361]      DmPulldown=1
[    3.297374]      DpPulldown=1
[    3.300345]    ### ULPI_USB_INT_STS (13) val=00000008
[    3.303279]      SessEnd=1
[    3.308312] TRB: msm writel(),         addr=f0062090, val=00000000
[    3.310937] TRB: in msm_otg_reset, 11133
[    3.317081]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    3.321180]    ### PORTSC (184) val=8c000804
[    3.326457]      PTS (31:30) transceiver select =10b: ulpi
[    3.335741]     PSPD (27:26) port speed =11b: ???
[    3.340532]     PHCD (23) clock disable =0
[    3.340952]     LS (11:10) line status = 10b: J-state
[    3.349282]     PE (2) port enabled =1
[    3.350066]     CCS (0) current connect status =0
[    3.353643]   remainder=00000000
[    3.358399]   ### OTGSC (1a4) val=003e3000
[    3.361717]     1MSIE (29) 1MS timer int enable =0
[    3.365605]     BSVIE (27) vbus B valid int enable =0
[    3.370398]     FIELD_1MSS (21) 1ms timer status =1
[    3.375502]     FIELD_1MST (13) 1ms timer toggle =1
[    3.380207]     BSE (12) vbus B session end =1
[    3.385051]     BSV (11) vbus B session valid =0
[    3.389565]     ASV (10) vbus A session valid =0
[    3.394355]     AVV (9) A vbus valid =0
[    3.398939]     IDPU (5) ID pullup =0
[    3.402514]   remainder=001e0000
[    3.406316]   ### USBINTR (148) val=00000000
[    3.409617]     SLE (8) sleep int =0
[    3.413885]     URE (6) USB reset int=0
[    3.417427]     PCE (2) port change detect int=0
[    3.421004]     UEI (1) USB error int=0
[    3.425849]     UI (0) USB int=0
[    3.429407]   remainder=00000000
[    3.432895]   ### USBSTS (144) val=40000480
[    3.436092]     ULPI (10) ULPI event complete=1
[    3.439997]     SOF (7) SOF received=1
[    3.444527]     UEI (1) USB error=0
[    3.448330]     UI (0) USB int=0
[    3.451731]   remainder=40000000
[    3.455190]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    3.458402]      SUSPENDM=1
[    3.463364]      OpMode=10b disable bit-stuff and NRZI encoding
[    3.468817]      TermSelect=1
[    3.472218]      XcvrSelect=01b FS
[    3.478015]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    3.478282]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    3.483505]      DmPulldown=1
[    3.488521]      DpPulldown=1
[    3.491489]    ### ULPI_USB_INT_STS (13) val=00000008
[    3.494426]      SessEnd=1
[    3.499458] TRB: msm writel(),         addr=f0062098, val=00000008
[    3.502084] TRB: in msm_otg_reset, 22222
[    3.508226]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    3.512326]    ### PORTSC (184) val=8c000804
[    3.517603]      PTS (31:30) transceiver select =10b: ulpi
[    3.526886]     PSPD (27:26) port speed =11b: ???
[    3.531677]     PHCD (23) clock disable =0
[    3.532099]     LS (11:10) line status = 10b: J-state
[    3.540444]     PE (2) port enabled =1
[    3.541212]     CCS (0) current connect status =0
[    3.544773]   remainder=00000000
[    3.549547]   ### OTGSC (1a4) val=003e1000
[    3.552862]     1MSIE (29) 1MS timer int enable =0
[    3.556752]     BSVIE (27) vbus B valid int enable =0
[    3.561543]     FIELD_1MSS (21) 1ms timer status =1
[    3.566649]     FIELD_1MST (13) 1ms timer toggle =0
[    3.571351]     BSE (12) vbus B session end =1
[    3.576195]     BSV (11) vbus B session valid =0
[    3.580728]     ASV (10) vbus A session valid =0
[    3.585485]     AVV (9) A vbus valid =0
[    3.590083]     IDPU (5) ID pullup =0
[    3.593661]   remainder=001e0000
[    3.597462]   ### USBINTR (148) val=00000000
[    3.600778]     SLE (8) sleep int =0
[    3.605015]     URE (6) USB reset int=0
[    3.608574]     PCE (2) port change detect int=0
[    3.612151]     UEI (1) USB error int=0
[    3.616994]     UI (0) USB int=0
[    3.620569]   remainder=00000000
[    3.624026]   ### USBSTS (144) val=40000480
[    3.627237]     ULPI (10) ULPI event complete=1
[    3.631160]     SOF (7) SOF received=1
[    3.635657]     UEI (1) USB error=0
[    3.639476]     UI (0) USB int=0
[    3.642879]   remainder=40000000
[    3.646335]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    3.649548]      SUSPENDM=1
[    3.654509]      OpMode=10b disable bit-stuff and NRZI encoding
[    3.659962]      TermSelect=1
[    3.663363]      XcvrSelect=01b FS
[    3.669160]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    3.669428]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    3.674653]      DmPulldown=1
[    3.679667]      DpPulldown=1
[    3.682637]    ### ULPI_USB_INT_STS (13) val=00000008
[    3.685571]      SessEnd=1
[    3.690621] TRB: msm readl(),          addr=f0062278, val=000c3c32
[    3.693214] TRB: msm writel(),         addr=f0062278, val=000d3c32
[    3.699375] TRB: in msm_otg_reset, leaving
[    3.705554]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    3.709618]    ### PORTSC (184) val=8c000804
[    3.715103]      PTS (31:30) transceiver select =10b: ulpi
[    3.724386]     PSPD (27:26) port speed =11b: ???
[    3.729143]     PHCD (23) clock disable =0
[    3.729581]     LS (11:10) line status = 10b: J-state
[    3.737912]     PE (2) port enabled =1
[    3.738695]     CCS (0) current connect status =0
[    3.742272]   remainder=00000000
[    3.747028]   ### OTGSC (1a4) val=003e1000
[    3.750345]     1MSIE (29) 1MS timer int enable =0
[    3.754235]     BSVIE (27) vbus B valid int enable =0
[    3.759009]     FIELD_1MSS (21) 1ms timer status =1
[    3.764148]     FIELD_1MST (13) 1ms timer toggle =0
[    3.768818]     BSE (12) vbus B session end =1
[    3.773695]     BSV (11) vbus B session valid =0
[    3.778193]     ASV (10) vbus A session valid =0
[    3.782984]     AVV (9) A vbus valid =0
[    3.787567]     IDPU (5) ID pullup =0
[    3.791143]   remainder=001e0000
[    3.794944]   ### USBINTR (148) val=00000000
[    3.798245]     SLE (8) sleep int =0
[    3.802514]     URE (6) USB reset int=0
[    3.806056]     PCE (2) port change detect int=0
[    3.809616]     UEI (1) USB error int=0
[    3.814494]     UI (0) USB int=0
[    3.818034]   remainder=00000000
[    3.821525]   ### USBSTS (144) val=40000480
[    3.824719]     ULPI (10) ULPI event complete=1
[    3.828627]     SOF (7) SOF received=1
[    3.833157]     UEI (1) USB error=0
[    3.836958]     UI (0) USB int=0
[    3.840361]   remainder=40000000
[    3.843818]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    3.847030]      SUSPENDM=1
[    3.851992]      OpMode=10b disable bit-stuff and NRZI encoding
[    3.857446]      TermSelect=1
[    3.860847]      XcvrSelect=01b FS
[    3.866644]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    3.866909]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    3.872134]      DmPulldown=1
[    3.877148]      DpPulldown=1
[    3.880101]    ### ULPI_USB_INT_STS (13) val=00000008
[    3.883072]      SessEnd=1
[    3.990164] TRB: in msm_phy_reset, entering
[    3.990181]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    3.993140]    ### PORTSC (184) val=8c000804
[    3.998693]      PTS (31:30) transceiver select =10b: ulpi
[    4.007977]     PSPD (27:26) port speed =11b: ???
[    4.012768]     PHCD (23) clock disable =0
[    4.013188]     LS (11:10) line status = 10b: J-state
[    4.021536]     PE (2) port enabled =1
[    4.022303]     CCS (0) current connect status =0
[    4.025864]   remainder=00000000
[    4.030653]   ### OTGSC (1a4) val=003e3000
[    4.033935]     1MSIE (29) 1MS timer int enable =0
[    4.037843]     BSVIE (27) vbus B valid int enable =0
[    4.042634]     FIELD_1MSS (21) 1ms timer status =1
[    4.047738]     FIELD_1MST (13) 1ms timer toggle =1
[    4.052466]     BSE (12) vbus B session end =1
[    4.057286]     BSV (11) vbus B session valid =0
[    4.061818]     ASV (10) vbus A session valid =0
[    4.066575]     AVV (9) A vbus valid =0
[    4.071192]     IDPU (5) ID pullup =0
[    4.074735]   remainder=001e0000
[    4.078553]   ### USBINTR (148) val=00000000
[    4.081870]     SLE (8) sleep int =0
[    4.086105]     URE (6) USB reset int=0
[    4.089664]     PCE (2) port change detect int=0
[    4.093240]     UEI (1) USB error int=0
[    4.098085]     UI (0) USB int=0
[    4.101660]   remainder=00000000
[    4.105116]   ### USBSTS (144) val=40000480
[    4.108327]     ULPI (10) ULPI event complete=1
[    4.112276]     SOF (7) SOF received=1
[    4.116746]     UEI (1) USB error=0
[    4.120583]     UI (0) USB int=0
[    4.123951]   remainder=40000000
[    4.127426]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    4.130654]      SUSPENDM=1
[    4.135583]      OpMode=10b disable bit-stuff and NRZI encoding
[    4.141070]      TermSelect=1
[    4.144437]      XcvrSelect=01b FS
[    4.150268]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    4.150519]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    4.155724]      DmPulldown=1
[    4.160773]      DpPulldown=1
[    4.163711]    ### ULPI_USB_INT_STS (13) val=00000008
[    4.166662]      SessEnd=1
[    4.171713] TRB: msm readl(),          addr=f0062278, val=000d3c32
[    4.174303] TRB: msm writel(),         addr=f0062278, val=000d3c33
[    4.180523] TRB: msm readl(),          addr=f0062278, val=000d3c33
[    4.186630] TRB: msm writel(),         addr=f0062278, val=000d3c32
[    4.192810] TRB: in msm_phy_reset, leaving
[    4.198953]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    4.203052]    ### PORTSC (184) val=8c000804
[    4.208502]      PTS (31:30) transceiver select =10b: ulpi
[    4.217785]     PSPD (27:26) port speed =11b: ???
[    4.222578]     PHCD (23) clock disable =0
[    4.222998]     LS (11:10) line status = 10b: J-state
[    4.231345]     PE (2) port enabled =1
[    4.232111]     CCS (0) current connect status =0
[    4.235671]   remainder=00000000
[    4.240463]   ### OTGSC (1a4) val=003e3000
[    4.243745]     1MSIE (29) 1MS timer int enable =0
[    4.247651]     BSVIE (27) vbus B valid int enable =0
[    4.252444]     FIELD_1MSS (21) 1ms timer status =1
[    4.257547]     FIELD_1MST (13) 1ms timer toggle =1
[    4.262252]     BSE (12) vbus B session end =1
[    4.267096]     BSV (11) vbus B session valid =0
[    4.271626]     ASV (10) vbus A session valid =0
[    4.276384]     AVV (9) A vbus valid =0
[    4.281000]     IDPU (5) ID pullup =0
[    4.284543]   remainder=001e0000
[    4.288361]   ### USBINTR (148) val=00000000
[    4.291679]     SLE (8) sleep int =0
[    4.295914]     URE (6) USB reset int=0
[    4.299473]     PCE (2) port change detect int=0
[    4.303050]     UEI (1) USB error int=0
[    4.307892]     UI (0) USB int=0
[    4.311470]   remainder=00000000
[    4.314925]   ### USBSTS (144) val=40000480
[    4.318136]     ULPI (10) ULPI event complete=1
[    4.322061]     SOF (7) SOF received=1
[    4.326557]     UEI (1) USB error=0
[    4.330392]     UI (0) USB int=0
[    4.333762]   remainder=40000000
[    4.337234]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    4.340464]      SUSPENDM=1
[    4.345392]      OpMode=10b disable bit-stuff and NRZI encoding
[    4.350879]      TermSelect=1
[    4.354247]      XcvrSelect=01b FS
[    4.360060]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    4.360345]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    4.365534]      DmPulldown=1
[    4.370584]      DpPulldown=1
[    4.373519]    ### ULPI_USB_INT_STS (13) val=00000008
[    4.376472]      SessEnd=1
[    4.381519] TRB: in msm_usb_reset, leaving
[    4.384108]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    4.388191]    ### PORTSC (184) val=8c000804
[    4.393675]      PTS (31:30) transceiver select =10b: ulpi
[    4.402959]     PSPD (27:26) port speed =11b: ???
[    4.407716]     PHCD (23) clock disable =0
[    4.408154]     LS (11:10) line status = 10b: J-state
[    4.416485]     PE (2) port enabled =1
[    4.417268]     CCS (0) current connect status =0
[    4.420846]   remainder=00000000
[    4.425602]   ### OTGSC (1a4) val=003e1000
[    4.428900]     1MSIE (29) 1MS timer int enable =0
[    4.432825]     BSVIE (27) vbus B valid int enable =0
[    4.437583]     FIELD_1MSS (21) 1ms timer status =1
[    4.442721]     FIELD_1MST (13) 1ms timer toggle =0
[    4.447391]     BSE (12) vbus B session end =1
[    4.452268]     BSV (11) vbus B session valid =0
[    4.456766]     ASV (10) vbus A session valid =0
[    4.461556]     AVV (9) A vbus valid =0
[    4.466139]     IDPU (5) ID pullup =0
[    4.469698]   remainder=001e0000
[    4.473536]   ### USBINTR (148) val=00000000
[    4.476818]     SLE (8) sleep int =0
[    4.481087]     URE (6) USB reset int=0
[    4.484629]     PCE (2) port change detect int=0
[    4.488189]     UEI (1) USB error int=0
[    4.493067]     UI (0) USB int=0
[    4.496608]   remainder=00000000
[    4.500080]   ### USBSTS (144) val=40000480
[    4.503310]     ULPI (10) ULPI event complete=1
[    4.507200]     SOF (7) SOF received=1
[    4.511730]     UEI (1) USB error=0
[    4.515531]     UI (0) USB int=0
[    4.518917]   remainder=40000000
[    4.522409]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    4.525603]      SUSPENDM=1
[    4.530564]      OpMode=10b disable bit-stuff and NRZI encoding
[    4.536017]      TermSelect=1
[    4.539403]      XcvrSelect=01b FS
[    4.545218]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    4.545484]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    4.550707]      DmPulldown=1
[    4.555723]      DpPulldown=1
[    4.558674]    ### ULPI_USB_INT_STS (13) val=00000008
[    4.561644]      SessEnd=1
[    4.566695] TRB: in msm_otg_probe, mode=2, otg_control=3
[    4.569267] creating debugfs msm_otg/mode
[    4.574854] msm_hsusb f9a55000.gadget: in ci_hdrc_msm_probe
[    4.578655] TRB: in ci_get_platdata
[    4.584042] TRB: in ci_get_platdata, dr_mode=2
[    4.587589] TRB!!!!!!!!!!!!: in ci_hdrc_probe
[    4.592042] TRB: hw_device_init
[    4.596434] TRB: in hw_alloc_regmap, is_lpg=0
[    4.599391] TRB: ci hw_read: reg=f0064108, mask=00020000,
val=00000000
[    4.603922] TRB: in hw_alloc_regmap, is_lpg=0
[    4.610346] TRB: ci hw_read: reg=f0064124, mask=0000001f,
val=00000010
[    4.614756] TRB: ci hw_read: reg=f0064184, mask=00800000,
val=00000000
[    4.621196] TRB: ci hw_write: reg=f0064148, mask=ffffffff,
data=00000000
[    4.627690] TRB: ci hw_write: reg=f0064144, mask=ffffffff,
data=ffffffff
[    4.634570] ci_hdrc ci_hdrc.0: ChipIdea HDRC found, lpm: 0; cap:
f0064100 op: f0064140
[    4.641249] TRB: hw_device_init done
[    4.648953] TRB: msm_phy_init, entering
[    4.652701]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    4.656247]    ### PORTSC (184) val=8c000804
[    4.661817]      PTS (31:30) transceiver select =10b: ulpi
[    4.671101]     PSPD (27:26) port speed =11b: ???
[    4.675857]     PHCD (23) clock disable =0
[    4.676296]     LS (11:10) line status = 10b: J-state
[    4.684626]     PE (2) port enabled =1
[    4.685412]     CCS (0) current connect status =0
[    4.688970]   remainder=00000000
[    4.693762]   ### OTGSC (1a4) val=003e1000
[    4.697044]     1MSIE (29) 1MS timer int enable =0
[    4.700968]     BSVIE (27) vbus B valid int enable =0
[    4.705726]     FIELD_1MSS (21) 1ms timer status =1
[    4.710862]     FIELD_1MST (13) 1ms timer toggle =0
[    4.715535]     BSE (12) vbus B session end =1
[    4.720411]     BSV (11) vbus B session valid =0
[    4.724909]     ASV (10) vbus A session valid =0
[    4.729683]     AVV (9) A vbus valid =0
[    4.734300]     IDPU (5) ID pullup =0
[    4.737842]   remainder=001e0000
[    4.741677]   ### USBINTR (148) val=00000000
[    4.744959]     SLE (8) sleep int =0
[    4.749213]     URE (6) USB reset int=0
[    4.752789]     PCE (2) port change detect int=0
[    4.756332]     UEI (1) USB error int=0
[    4.761208]     UI (0) USB int=0
[    4.764750]   remainder=00000000
[    4.768224]   ### USBSTS (144) val=00000080
[    4.771452]     ULPI (10) ULPI event complete=0
[    4.775342]     SOF (7) SOF received=1
[    4.779855]     UEI (1) USB error=0
[    4.783691]     UI (0) USB int=0
[    4.787059]   remainder=00000000
[    4.790551]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    4.793745]      SUSPENDM=1
[    4.798690]      OpMode=10b disable bit-stuff and NRZI encoding
[    4.804161]      TermSelect=1
[    4.807546]      XcvrSelect=01b FS
[    4.813359]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    4.813625]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    4.818833]      DmPulldown=1
[    4.823882]      DpPulldown=1
[    4.826818]    ### ULPI_USB_INT_STS (13) val=00000008
[    4.829771]      SessEnd=1
[    4.834817] TRB: ulpi_init() 1
[    4.837405] TRB: ulpi_init() 2
[    4.840462] TRB: ulpi_init() 3
[    4.843484] TRB: ulpi: write 0x63 to 0x81
[    4.846522] TRB: ulpi_init() 4
[    4.850619] TRB: ulpi_write reg=0x81, val=0x63
[    4.853555] TRB: msm writel(),         addr=f0062170, val=60810063
[    4.857984] TRB: msm readl(),          addr=f0062170, val=28810863
[    4.864164] TRB: ulpi_init() 5
[    4.870321] TRB: ulpi_init() 6
[    4.873344] TRB: ulpi_init() 7 - done
[    4.876382] TRB: in msm_phy_reset, entering
[    4.880116]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    4.884129]    ### PORTSC (184) val=8c000804
[    4.889665]      PTS (31:30) transceiver select =10b: ulpi
[    4.898949]     PSPD (27:26) port speed =11b: ???
[    4.903740]     PHCD (23) clock disable =0
[    4.904161]     LS (11:10) line status = 10b: J-state
[    4.912508]     PE (2) port enabled =1
[    4.913276]     CCS (0) current connect status =0
[    4.916836]   remainder=00000000
[    4.921626]   ### OTGSC (1a4) val=003e1000
[    4.924908]     1MSIE (29) 1MS timer int enable =0
[    4.928815]     BSVIE (27) vbus B valid int enable =0
[    4.933606]     FIELD_1MSS (21) 1ms timer status =1
[    4.938711]     FIELD_1MST (13) 1ms timer toggle =0
[    4.943415]     BSE (12) vbus B session end =1
[    4.948259]     BSV (11) vbus B session valid =0
[    4.952790]     ASV (10) vbus A session valid =0
[    4.957547]     AVV (9) A vbus valid =0
[    4.962163]     IDPU (5) ID pullup =0
[    4.965706]   remainder=001e0000
[    4.969524]   ### USBINTR (148) val=00000000
[    4.972842]     SLE (8) sleep int =0
[    4.977077]     URE (6) USB reset int=0
[    4.980652]     PCE (2) port change detect int=0
[    4.984196]     UEI (1) USB error int=0
[    4.989057]     UI (0) USB int=0
[    4.992632]   remainder=00000000
[    4.996088]   ### USBSTS (144) val=00000480
[    4.999299]     ULPI (10) ULPI event complete=1
[    5.003224]     SOF (7) SOF received=1
[    5.007718]     UEI (1) USB error=0
[    5.011559]     UI (0) USB int=0
[    5.014924]   remainder=00000000
[    5.018397]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    5.021627]      SUSPENDM=1
[    5.026556]      OpMode=10b disable bit-stuff and NRZI encoding
[    5.032042]      TermSelect=1
[    5.035410]      XcvrSelect=01b FS
[    5.041240]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    5.041491]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    5.046697]      DmPulldown=1
[    5.051770]      DpPulldown=1
[    5.054682]    ### ULPI_USB_INT_STS (13) val=00000008
[    5.057634]      SessEnd=1
[    5.062685] TRB: msm readl(),          addr=f0062278, val=000d3c32
[    5.065276] TRB: msm writel(),         addr=f0062278, val=000d3c33
[    5.071494] TRB: msm readl(),          addr=f0062278, val=000d3c33
[    5.077602] TRB: msm writel(),         addr=f0062278, val=000d3c32
[    5.083783] TRB: in msm_phy_reset, leaving
[    5.089926]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    5.094023]    ### PORTSC (184) val=8c000804
[    5.099475]      PTS (31:30) transceiver select =10b: ulpi
[    5.108759]     PSPD (27:26) port speed =11b: ???
[    5.113549]     PHCD (23) clock disable =0
[    5.113970]     LS (11:10) line status = 10b: J-state
[    5.122317]     PE (2) port enabled =1
[    5.123083]     CCS (0) current connect status =0
[    5.126644]   remainder=00000000
[    5.131435]   ### OTGSC (1a4) val=003e1000
[    5.134717]     1MSIE (29) 1MS timer int enable =0
[    5.138624]     BSVIE (27) vbus B valid int enable =0
[    5.143415]     FIELD_1MSS (21) 1ms timer status =1
[    5.148520]     FIELD_1MST (13) 1ms timer toggle =0
[    5.153223]     BSE (12) vbus B session end =1
[    5.158067]     BSV (11) vbus B session valid =0
[    5.162598]     ASV (10) vbus A session valid =0
[    5.167357]     AVV (9) A vbus valid =0
[    5.171972]     IDPU (5) ID pullup =0
[    5.175514]   remainder=001e0000
[    5.179335]   ### USBINTR (148) val=00000000
[    5.182650]     SLE (8) sleep int =0
[    5.186887]     URE (6) USB reset int=0
[    5.190463]     PCE (2) port change detect int=0
[    5.194005]     UEI (1) USB error int=0
[    5.198866]     UI (0) USB int=0
[    5.202441]   remainder=00000000
[    5.205896]   ### USBSTS (144) val=00000480
[    5.209109]     ULPI (10) ULPI event complete=1
[    5.213032]     SOF (7) SOF received=1
[    5.217529]     UEI (1) USB error=0
[    5.221365]     UI (0) USB int=0
[    5.224733]   remainder=00000000
[    5.228208]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    5.231437]      SUSPENDM=1
[    5.236364]      OpMode=10b disable bit-stuff and NRZI encoding
[    5.241850]      TermSelect=1
[    5.245218]      XcvrSelect=01b FS
[    5.251050]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    5.251299]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    5.256506]      DmPulldown=1
[    5.261556]      DpPulldown=1
[    5.264491]    ### ULPI_USB_INT_STS (13) val=00000008
[    5.267444]      SessEnd=1
[    5.272495] TRB: msm readl(),          addr=f0062278, val=000d3c32
[    5.275084] TRB: msm writel(),         addr=f0062278, val=000d3c32
[    5.281263] TRB: msm_phy_init, leaving
[    5.287407]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    5.291160]    ### PORTSC (184) val=8c000804
[    5.296610]      PTS (31:30) transceiver select =10b: ulpi
[    5.305893]     PSPD (27:26) port speed =11b: ???
[    5.310683]     PHCD (23) clock disable =0
[    5.311105]     LS (11:10) line status = 10b: J-state
[    5.319435]     PE (2) port enabled =1
[    5.320237]     CCS (0) current connect status =0
[    5.323781]   remainder=00000000
[    5.328553]   ### OTGSC (1a4) val=003e3000
[    5.331869]     1MSIE (29) 1MS timer int enable =0
[    5.335759]     BSVIE (27) vbus B valid int enable =0
[    5.340552]     FIELD_1MSS (21) 1ms timer status =1
[    5.345655]     FIELD_1MST (13) 1ms timer toggle =1
[    5.350358]     BSE (12) vbus B session end =1
[    5.355202]     BSV (11) vbus B session valid =0
[    5.359718]     ASV (10) vbus A session valid =0
[    5.364508]     AVV (9) A vbus valid =0
[    5.369090]     IDPU (5) ID pullup =0
[    5.372668]   remainder=001e0000
[    5.376470]   ### USBINTR (148) val=00000000
[    5.379768]     SLE (8) sleep int =0
[    5.384039]     URE (6) USB reset int=0
[    5.387582]     PCE (2) port change detect int=0
[    5.391159]     UEI (1) USB error int=0
[    5.396001]     UI (0) USB int=0
[    5.399560]   remainder=00000000
[    5.403048]   ### USBSTS (144) val=00000480
[    5.406245]     ULPI (10) ULPI event complete=1
[    5.410168]     SOF (7) SOF received=1
[    5.414664]     UEI (1) USB error=0
[    5.418484]     UI (0) USB int=0
[    5.421885]   remainder=00000000
[    5.425343]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    5.428554]      SUSPENDM=1
[    5.433517]      OpMode=10b disable bit-stuff and NRZI encoding
[    5.438968]      TermSelect=1
[    5.442371]      XcvrSelect=01b FS
[    5.448168]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    5.448434]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    5.453659]      DmPulldown=1
[    5.458672]      DpPulldown=1
[    5.461643]    ### ULPI_USB_INT_STS (13) val=00000008
[    5.464579]      SessEnd=1
[    5.469611] TRB: getting interrupt
[    5.472233] TRB: ci->irq=166
[    5.475602] TRB: ci hw_read: reg=f0064124, mask=00000180,
val=00000180
[    5.478647] ci_hdrc ci_hdrc.0: It is OTG capable controller
[    5.484998] TRB: ci hw_write: reg=f00641a4, mask=7f000000,
data=00000000
[    5.490469] TRB: ci hw_write: reg=f00641a4, mask=007f0000,
data=007f0000
[    5.497396] TRB: in ci_hdrc_gadget_init
[    5.504092] TRB: ci hw_read: reg=f0064124, mask=00000080,
val=00000080
[    5.507638] TRB: setting irq = udc_irq
[    5.514307] TRB: in usb_add_gadget_udc_release()
[    5.518066] TRB: in ci_hdrc_probe, doing otg_set_peripheral, with
ci->gadget=ef02c068
[    5.522774] TRB: in msm_otg_set_peripheral
[    5.530480] TRB: MOSP 1
[    5.534454] TRB: MOSP 6
[    5.536798] peripheral driver registered w/ tranceiver
[    5.539232] TRB: MOSP 7
[    5.544452] TRB: MOSP 8
[    5.546786] TRB: MOSP 9
[    5.549211] TRB: ret=0
[    5.551663] TRB: in msm_otg_sm_work: state=0
[    5.554075] TRB: MOSW 1 OTG_STATE_UNDEFINED state
[    5.558502] TRB: in msm_otg_reset, entering
[    5.563210] TRB: ci hw_read: reg=f00641a4, mask=ffffffff,
val=00201000
[    5.567101] TRB: ci_udc_vbus_session, vbus_active=0
[    5.573731] TRB: ci_udc_vbus_session, gadget_ready=0
[    5.578470] TRB: ci hw_write: reg=f00641a4, mask=007f0000,
data=00080000
[    5.583701]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    5.590382]    ### PORTSC (184) val=8c000804
[    5.595656]      PTS (31:30) transceiver select =10b: ulpi
[    5.604961] TRB: ci hw_write: reg=f00641a4, mask=08000000,
data=08000000
[    5.605382] TRB Requesting irq 166:ci_hdrc_msm
[    5.612179] TRB: Creating device files for ci_hdrc.0
[    5.616477] /home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAANLYA31050138_JB_V11/kernel-
14-test-usb/drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    5.622285] Freeing unused kernel memory: 280K (c082a000 -
c0870000)
[    5.636246]     PSPD (27:26) port speed =11b: ???
[    5.646953]     PHCD (23) clock disable =0
[    5.647390]     LS (11:10) line status = 10b: J-state
[    5.655720]     PE (2) port enabled =1
[    5.656504]     CCS (0) current connect status =0
[    5.660065]   remainder=00000000
[    5.676227]   ### OTGSC (1a4) val=08203000
[    5.676246]     1MSIE (29) 1MS timer int enable =0
[    5.679202]     BSVIE (27) vbus B valid int enable =1
mkdir: can't create directory '/dev': File exists[    5.689521]
FIELD_1MSS (21) 1ms timer status =
1

[    5.698400]     FIELD_1MST (13) 1ms timer toggle =1
[    5.698419]     BSE (12) vbus B session end =1
[    5.706024]     BSV (11) vbus B session valid =0
[    5.707588]     ASV (10) vbus A session valid =0
[    5.715575]     AVV (9) A vbus valid =0
[    5.716961]     IDPU (5) ID pullup =0
[    5.723884]   remainder=00000000
[    5.724341]   ### USBINTR (148) val=00000000
[    5.727639]     SLE (8) sleep int =0
[    5.740198]     URE (6) USB reset int=0
[    5.740216]     PCE (2) port change detect int=0
[    5.742827]     UEI (1) USB error int=0
[    5.747686]     UI (0) USB int=0
[    5.760258]   remainder=00000000
[    5.760276]   ### USBSTS (144) val=00000480
[    5.762538]     ULPI (10) ULPI event complete=1
[    5.766444]     SOF (7) SOF received=1
[    5.785969]     UEI (1) USB error=0
[    5.785985]     UI (0) USB int=0
[    5.788248]   remainder=00000000
[    5.792913]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    5.794934]      SUSPENDM=1
[    5.799879]      OpMode=10b disable bit-stuff and NRZI encoding
[    5.815934]      TermSelect=1
[    5.818195]      XcvrSelect=01b FS
[    5.824011]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    5.824275]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    5.829482]      DmPulldown=1
[    5.850184]      DpPulldown=1
[    5.850204]    ### ULPI_USB_INT_STS (13) val=00000008
[    5.852120]      SessEnd=1
[    5.857150] TRB: issuing USBCMD_RESET to USB_USBCMD
[    5.859758] TRB: msm writel(),         addr=f0062140, val=00000002
[    5.880186] TRB: msm readl(),          addr=f0062140, val=00080002
[    5.880210] TRB: msm readl(),          addr=f0062140, val=00080000
[    5.885247]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    5.900183]    ### PORTSC (184) val=8c000804
[    5.900202]      PTS (31:30) transceiver select =10b: ulpi
[    5.908448]     PSPD (27:26) port speed =11b: ???
[    5.930184]     PHCD (23) clock disable =0
[    5.930202]     LS (11:10) line status = 10b: J-state
[    5.937580]     PE (2) port enabled =1
[    5.938366]     CCS (0) current connect status =0
[    5.950183]   remainder=00000000
[    5.950200]   ### OTGSC (1a4) val=08203000
[    5.952463]     1MSIE (29) 1MS timer int enable =0
[    5.956369]     BSVIE (27) vbus B valid int enable =1
[    5.970185]     FIELD_1MSS (21) 1ms timer status =1
[    5.970203]     FIELD_1MST (13) 1ms timer toggle =1
[    5.973853]     BSE (12) vbus B session end =1
[    5.978715]     BSV (11) vbus B session valid =0
[    6.000181]     ASV (10) vbus A session valid =0
[    6.000200]     AVV (9) A vbus valid =0
[    6.003849]     IDPU (5) ID pullup =0
[    6.007407]   remainder=00000000
[    6.020179]   ### USBINTR (148) val=00000000
[    6.020197]     SLE (8) sleep int =0
[    6.023498]     URE (6) USB reset int=0
[    6.027057]     PCE (2) port change detect int=0
[    6.040225]     UEI (1) USB error int=0
[    6.040243]     UI (0) USB int=0
[    6.042851]   remainder=00000000
[    6.046326]   ### USBSTS (144) val=00000080
[    6.049537]     ULPI (10) ULPI event complete=0
sh: can't access tty; job control turned off
/ # [    6.063965]     SOF (7) SOF received=1
[    6.063983]     UEI (1) USB error=0
[    6.067703]     UI (0) USB int=0
[    6.071138]   remainder=00000000
[    6.074564]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    6.077775]      SUSPENDM=1
[    6.082836]      OpMode=10b disable bit-stuff and NRZI encoding
[    6.088191]      TermSelect=1
[    6.091613]      XcvrSelect=01b FS
[    6.097388]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    6.097655]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    6.102890]      DmPulldown=1
[    6.107894]      DpPulldown=1
[    6.110866]    ### ULPI_USB_INT_STS (13) val=00000008
[    6.113800]      SessEnd=1
[    6.118833] TRB: in msm_otg_reset, 11111 !!! check regs here
(before) !!!
[    6.121459] TRB: turning PTS transceiver back to ULPI and resetting
rest of PORTSC
[    6.128302] TRB: msm writel(),         addr=f0062184, val=80000000
[    6.135780] TRB: in msm_otg_reset, 11122 !!! check regs here
(after) !!!
[    6.141946]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    6.148783]    ### PORTSC (184) val=8c000804
[    6.154095]      PTS (31:30) transceiver select =10b: ulpi
[    6.163377]     PSPD (27:26) port speed =11b: ???
[    6.168134]     PHCD (23) clock disable =0
[    6.168573]     LS (11:10) line status = 10b: J-state
[    6.176902]     PE (2) port enabled =1
[    6.177687]     CCS (0) current connect status =0
[    6.181264]   remainder=00000000
[    6.186021]   ### OTGSC (1a4) val=08203000
[    6.189320]     1MSIE (29) 1MS timer int enable =0
[    6.193244]     BSVIE (27) vbus B valid int enable =1
[    6.198000]     FIELD_1MSS (21) 1ms timer status =1
[    6.203140]     FIELD_1MST (13) 1ms timer toggle =1
[    6.207810]     BSE (12) vbus B session end =1
[    6.212688]     BSV (11) vbus B session valid =0
[    6.217185]     ASV (10) vbus A session valid =0
[    6.221976]     AVV (9) A vbus valid =0
[    6.226559]     IDPU (5) ID pullup =0
[    6.230117]   remainder=00000000
[    6.233953]   ### USBINTR (148) val=00000000
[    6.237237]     SLE (8) sleep int =0
[    6.241506]     URE (6) USB reset int=0
[    6.245049]     PCE (2) port change detect int=0
[    6.248608]     UEI (1) USB error int=0
[    6.253484]     UI (0) USB int=0
[    6.257026]   remainder=00000000
[    6.260517]   ### USBSTS (144) val=00000480
[    6.263711]     ULPI (10) ULPI event complete=1
[    6.267619]     SOF (7) SOF received=1
[    6.272149]     UEI (1) USB error=0
[    6.275949]     UI (0) USB int=0
[    6.279336]   remainder=00000000
[    6.282826]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    6.286022]      SUSPENDM=1
[    6.290984]      OpMode=10b disable bit-stuff and NRZI encoding
[    6.296436]      TermSelect=1
[    6.299821]      XcvrSelect=01b FS
[    6.305637]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    6.305901]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    6.311127]      DmPulldown=1
[    6.316141]      DpPulldown=1
[    6.319094]    ### ULPI_USB_INT_STS (13) val=00000008
[    6.322064]      SessEnd=1
[    6.327080] TRB: msm writel(),         addr=f0062090, val=00000000
[    6.329687] TRB: in msm_otg_reset, 11133
[    6.335865]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    6.339929]    ### PORTSC (184) val=8c000804
[    6.345241]      PTS (31:30) transceiver select =10b: ulpi
[    6.354522]     PSPD (27:26) port speed =11b: ???
[    6.359281]     PHCD (23) clock disable =0
[    6.359719]     LS (11:10) line status = 10b: J-state
[    6.368048]     PE (2) port enabled =1
[    6.368833]     CCS (0) current connect status =0
[    6.372411]   remainder=00000000
[    6.377167]   ### OTGSC (1a4) val=08201000
[    6.380481]     1MSIE (29) 1MS timer int enable =0
[    6.384373]     BSVIE (27) vbus B valid int enable =1
[    6.389146]     FIELD_1MSS (21) 1ms timer status =1
[    6.394285]     FIELD_1MST (13) 1ms timer toggle =0
[    6.398956]     BSE (12) vbus B session end =1
[    6.403832]     BSV (11) vbus B session valid =0
[    6.408331]     ASV (10) vbus A session valid =0
[    6.413121]     AVV (9) A vbus valid =0
[    6.417704]     IDPU (5) ID pullup =0
[    6.421281]   remainder=00000000
[    6.425083]   ### USBINTR (148) val=00000000
[    6.428381]     SLE (8) sleep int =0
[    6.432652]     URE (6) USB reset int=0
[    6.436194]     PCE (2) port change detect int=0
[    6.439755]     UEI (1) USB error int=0
[    6.444632]     UI (0) USB int=0
[    6.448173]   remainder=00000000
[    6.451662]   ### USBSTS (144) val=00000480
[    6.454858]     ULPI (10) ULPI event complete=1
[    6.458765]     SOF (7) SOF received=1
[    6.463295]     UEI (1) USB error=0
[    6.467096]     UI (0) USB int=0
[    6.470498]   remainder=00000000
[    6.473955]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    6.477168]      SUSPENDM=1
[    6.482130]      OpMode=10b disable bit-stuff and NRZI encoding
[    6.487583]      TermSelect=1
[    6.490984]      XcvrSelect=01b FS
[    6.496781]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    6.497047]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    6.502273]      DmPulldown=1
[    6.507287]      DpPulldown=1
[    6.510256]    ### ULPI_USB_INT_STS (13) val=00000008
[    6.513192]      SessEnd=1
[    6.518224] TRB: msm writel(),         addr=f0062098, val=00000008
[    6.520849] TRB: in msm_otg_reset, 22222
[    6.526993]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    6.531093]    ### PORTSC (184) val=8c000804
[    6.536369]      PTS (31:30) transceiver select =10b: ulpi
[    6.545653]     PSPD (27:26) port speed =11b: ???
[    6.550443]     PHCD (23) clock disable =0
[    6.550866]     LS (11:10) line status = 10b: J-state
[    6.559193]     PE (2) port enabled =1
[    6.559978]     CCS (0) current connect status =0
[    6.563557]   remainder=00000000
[    6.568312]   ### OTGSC (1a4) val=08203000
[    6.571628]     1MSIE (29) 1MS timer int enable =0
[    6.575517]     BSVIE (27) vbus B valid int enable =1
[    6.580309]     FIELD_1MSS (21) 1ms timer status =1
[    6.585415]     FIELD_1MST (13) 1ms timer toggle =1
[    6.590102]     BSE (12) vbus B session end =1
[    6.594979]     BSV (11) vbus B session valid =0
[    6.599477]     ASV (10) vbus A session valid =0
[    6.604268]     AVV (9) A vbus valid =0
[    6.608849]     IDPU (5) ID pullup =0
[    6.612426]   remainder=00000000
[    6.616229]   ### USBINTR (148) val=00000000
[    6.619529]     SLE (8) sleep int =0
[    6.623797]     URE (6) USB reset int=0
[    6.627340]     PCE (2) port change detect int=0
[    6.630917]     UEI (1) USB error int=0
[    6.635760]     UI (0) USB int=0
[    6.639318]   remainder=00000000
[    6.642809]   ### USBSTS (144) val=00000480
[    6.646003]     ULPI (10) ULPI event complete=1
[    6.649910]     SOF (7) SOF received=1
[    6.654440]     UEI (1) USB error=0
[    6.658243]     UI (0) USB int=0
[    6.661644]   remainder=00000000
[    6.665102]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    6.668314]      SUSPENDM=1
[    6.673276]      OpMode=10b disable bit-stuff and NRZI encoding
[    6.678729]      TermSelect=1
[    6.682131]      XcvrSelect=01b FS
[    6.687928]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    6.688194]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    6.693418]      DmPulldown=1
[    6.698432]      DpPulldown=1
[    6.701402]    ### ULPI_USB_INT_STS (13) val=00000008
[    6.704337]      SessEnd=1
[    6.709371] TRB: msm readl(),          addr=f0062278, val=000c3c32
[    6.711997] TRB: msm writel(),         addr=f0062278, val=000d3c32
[    6.718141] TRB: in msm_otg_reset, leaving
[    6.724320]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[    6.728384]    ### PORTSC (184) val=8c000804
[    6.733869]      PTS (31:30) transceiver select =10b: ulpi
[    6.743151]     PSPD (27:26) port speed =11b: ???
[    6.747908]     PHCD (23) clock disable =0
[    6.748347]     LS (11:10) line status = 10b: J-state
[    6.756676]     PE (2) port enabled =1
[    6.757461]     CCS (0) current connect status =0
[    6.761038]   remainder=00000000
[    6.765796]   ### OTGSC (1a4) val=08201000
[    6.769093]     1MSIE (29) 1MS timer int enable =0
[    6.773017]     BSVIE (27) vbus B valid int enable =1
[    6.777775]     FIELD_1MSS (21) 1ms timer status =1
[    6.782913]     FIELD_1MST (13) 1ms timer toggle =0
[    6.787584]     BSE (12) vbus B session end =1
[    6.792460]     BSV (11) vbus B session valid =0
[    6.796959]     ASV (10) vbus A session valid =0
[    6.801750]     AVV (9) A vbus valid =0
[    6.806334]     IDPU (5) ID pullup =0
[    6.809892]   remainder=00000000
[    6.813728]   ### USBINTR (148) val=00000000
[    6.817010]     SLE (8) sleep int =0
[    6.821280]     URE (6) USB reset int=0
[    6.824823]     PCE (2) port change detect int=0
[    6.828383]     UEI (1) USB error int=0
[    6.833260]     UI (0) USB int=0
[    6.836802]   remainder=00000000
[    6.840290]   ### USBSTS (144) val=00000480
[    6.843486]     ULPI (10) ULPI event complete=1
[    6.847393]     SOF (7) SOF received=1
[    6.851922]     UEI (1) USB error=0
[    6.855724]     UI (0) USB int=0
[    6.859110]   remainder=00000000
[    6.862600]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[    6.865796]      SUSPENDM=1
[    6.870758]      OpMode=10b disable bit-stuff and NRZI encoding
[    6.876211]      TermSelect=1
[    6.879596]      XcvrSelect=01b FS
[    6.885409]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[    6.885676]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[    6.890900]      DmPulldown=1
[    6.895915]      DpPulldown=1
[    6.898867]    ### ULPI_USB_INT_STS (13) val=00000008
[    6.901838]      SessEnd=1
[    6.906855] TRB: msm readl(),          addr=f00621a4, val=08203000
[    6.909461] TRB: msm_otg_init_sm, pdata->mode=2
[    6.915638] TRB: MOSW 2 OTG_STATE_B_IDLE state

/ #
/ #
/ # cd lib/modules
/lib/modules # ls
ansi_cprng.ko          g_zero.ko              regs
g_hid.ko               libcomposite.ko        usb_f_mass_storage.ko
g_mass_storage.ko      loadem.sh              usb_f_ss_lb.ko
/lib/modules # insmod libcomposite.ko
/lib/modules # insmod usb_f_ss_lb.ko
/lib/modules # insmod usb_f_mass_storage.ko
/lib/modules # insmod g_zero.ko
[  213.753592] TRB: usb_gadget_probe_driver
[  213.753614] ------------[ cut here ]------------
[  213.756588] WARNING: CPU: 0 PID: 92 at
/home/CORPUSERS/10102229/work/dragonboard/APQ8074_M8974AAAAA
NLYA31050138_JB_V11/kernel-14-test-usb/drivers/usb/gadget/udc-core.c:416
usb_gadget_probe_driver+0x20/
0xf4()
[  213.770179] TRB: usb_gadget_probe_driver
[  213.779313] Modules linked in: g_zero(+) usb_f_mass_storage
usb_f_ss_lb libcomposite
[  213.791182] CPU: 0 PID: 92 Comm: insmod Not tainted
3.13.0-rc6-00148-g1076101-dirty #79
[  213.791229] [<c0214144>] (unwind_backtrace+0x0/0xf8) from
[<c0211ba8>] (show_stack+0x10/0x14)
[  213.798950] [<c0211ba8>] (show_stack+0x10/0x14) from [<c063198c>]
(dump_stack+0x64/0xb4)
[  213.807674] [<c063198c>] (dump_stack+0x64/0xb4) from [<c022afd8>]
(warn_slowpath_common+0x68/0x88)
[  213.815820] [<c022afd8>] (warn_slowpath_common+0x68/0x88) from
[<c022b08c>] (warn_slowpath_fmt+0x30
/0x40)
[  213.824582] [<c022b08c>] (warn_slowpath_fmt+0x30/0x40) from
[<c0522b0c>] (usb_gadget_probe_driver+0
x20/0xf4)
[  213.834218] [<c0522b0c>] (usb_gadget_probe_driver+0x20/0xf4) from
[<c0208860>] (do_one_initcall+0x1
10/0x174)
[  213.844116] [<c0208860>] (do_one_initcall+0x110/0x174) from
[<c0285740>] (load_module+0x185c/0x1c6c
)
[  213.853922] [<c0285740>] (load_module+0x185c/0x1c6c) from
[<c0285c40>] (SyS_init_module+0xf0/0x100)
[  213.863034] [<c0285c40>] (SyS_init_module+0xf0/0x100) from
[<c020e3c0>] (ret_fast_syscall+0x0/0x30)
[  213.871805] ---[ end trace babbb03ea78eda66 ]---
[  213.880816] TRB: in udc_bind_to_driver
[  213.885647] TRB: udc_bind_to_driver 1
[  213.889245] zero gadget: Gadget Zero, version: Cinco de Mayo 2008
[  213.892967] zero gadget: zero ready
[  213.899016] TRB: udc_bind_to_driver 2
[  213.902335] TRB: udc_bind_to_driver 3 - calling
usb_gadget_udc_start
[  213.906136] TRB: calling through gadget->ops->udc_start()
[  213.912580] TRB: ci_udc_start()
[  213.917850] TRB: CIS 1
[  213.920821] TRB: CIS 2
[  213.923231] TRB: CIS 3
[  213.925576] TRB: CIS 4
[  213.927919] TRB: CIS 5
[  213.930295] TRB: CIS 6, vbus_active=0
[  213.932608] TRB: udc_bind_to_driver 4
[  213.936341] TRB: udc_bind_to_driver 5
[  213.939988] TRB: udc_bind_to_driver 6
[  213.943837] TRB: udc_bind_to_driver 7
/lib/modules #
/lib/modules # regs
sh: regs: not found
/lib/modules # ./regs
[  242.314425] TRB: in msm_otg_reg_show
[  242.314445]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[  242.317057]    ### PORTSC (184) val=8c000804
[  242.322426]      PTS (31:30) transceiver select =10b: ulpi
[  242.331671]     PSPD (27:26) port speed =11b: ???
[  242.336407]     PHCD (23) clock disable =0
[  242.336844]     LS (11:10) line status = 10b: J-state
[  242.345174]     PE (2) port enabled =1
[  242.345957]     CCS (0) current connect status =0
[  242.349519]   remainder=00000000
[  242.354310]   ### OTGSC (1a4) val=08203000
[  242.357591]     1MSIE (29) 1MS timer int enable =0
[  242.361515]     BSVIE (27) vbus B valid int enable =1
[  242.366272]     FIELD_1MSS (21) 1ms timer status =1
[  242.371410]     FIELD_1MST (13) 1ms timer toggle =1
[  242.376081]     BSE (12) vbus B session end =1
[  242.380960]     BSV (11) vbus B session valid =0
[  242.385456]     ASV (10) vbus A session valid =0
[  242.390248]     AVV (9) A vbus valid =0
[  242.394830]     IDPU (5) ID pullup =0
[  242.398389]   remainder=00000000
[  242.402225]   ### USBINTR (148) val=00000000
[  242.405509]     SLE (8) sleep int =0
[  242.409760]     URE (6) USB reset int=0
[  242.413367]     PCE (2) port change detect int=0
[  242.416880]     UEI (1) USB error int=0
[  242.421758]     UI (0) USB int=0
[  242.425297]   remainder=00000000
[  242.428771]   ### USBSTS (144) val=00000480
[  242.432000]     ULPI (10) ULPI event complete=1
[  242.435890]     SOF (7) SOF received=1
[  242.440420]     UEI (1) USB error=0
[  242.444222]     UI (0) USB int=0
[  242.447606]   remainder=00000000
[  242.451099]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[  242.454292]      SUSPENDM=1
[  242.459237]      OpMode=10b disable bit-stuff and NRZI encoding
[  242.464709]      TermSelect=1
[  242.468093]      XcvrSelect=01b FS
[  242.473909]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[  242.474173]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[  242.479381]      DmPulldown=1
[  242.484430]      DpPulldown=1
[  242.487366]    ### ULPI_USB_INT_STS (13) val=00000008
[  242.490335]      SessEnd=1
See regs in dmesg log
/lib/modules # echo none >/debugfs/msm_otg/mode
[  256.055595] TRB: in msm_otg_mode_write
[  256.055615] TRB: in msm_otg_mode_write, req_mode=0
[  256.058262] TRB: requested 'unknown' mode
[  256.063135] TRB: doing nothing 1
/lib/modules # echo peripheral >/debugfs/msm_otg/mode
[  263.136812] TRB: in msm_otg_mode_write
[  263.136983] TRB: in msm_otg_mode_write, req_mode=2
[  263.140685] TRB: requested 'peripheral' mode
[  263.145417] TRB: in msm_otg_sm_work: state=1
[  263.149832] TRB: MOSW 2 OTG_STATE_B_IDLE state
[  263.154289] TRB: msm writel(),         addr=f0062170, val=40040000
[  263.158342] TRB: msm readl(),          addr=f0062170, val=08045500
[  263.164547] TRB: msm readl(),          addr=f0062170, val=08045500
[  263.170706] TRB: ulpi_read reg=0x4, val=0x55
[  263.176828] TRB: ulpi_write reg=0x4, val=0x4d
[  263.181276] TRB: msm writel(),         addr=f0062170, val=6004004d
[  263.185511] TRB: msm readl(),          addr=f0062170, val=2804554d
[  263.191606] TRB: ulpi_write reg=0x86, val=0x3f
[  263.197747] TRB: msm writel(),         addr=f0062170, val=6086003f
[  263.202194] TRB: msm readl(),          addr=f0062170, val=2886553f
[  263.208339] TRB: ulpi_write reg=0x92, val=0x1f
[  263.214519] TRB: msm writel(),         addr=f0062170, val=6092001f
[  263.218931] TRB: msm readl(),          addr=f0062170, val=2892551f
[  263.225112] TRB: ulpi_write reg=0x95, val=0x1f
[  263.231271] TRB: msm writel(),         addr=f0062170, val=6095001f
[  263.235685] TRB: msm readl(),          addr=f0062170, val=2895551f
[  263.241967] TRB: ulpi_write reg=0x85, val=0x10
[  263.248009] TRB: msm writel(),         addr=f0062170, val=60850010
[  263.252455] TRB: msm readl(),          addr=f0062170, val=28855510
/lib/modules # [  263.350167] TRB: msm writel(),
addr=f0062170, val=40870000
[  263.350187] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.355227] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.361408] TRB: ulpi_read reg=0x87, val=0x0
[  263.460167] TRB: msm writel(),         addr=f0062170, val=40870000
[  263.460187] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.465227] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.471407] TRB: ulpi_read reg=0x87, val=0x0
[  263.570166] TRB: msm writel(),         addr=f0062170, val=40870000
[  263.570186] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.575224] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.581406] TRB: ulpi_read reg=0x87, val=0x0
[  263.680166] TRB: msm writel(),         addr=f0062170, val=40870000
[  263.680186] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.685225] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.691407] TRB: ulpi_read reg=0x87, val=0x0
[  263.790166] TRB: msm writel(),         addr=f0062170, val=40870000
[  263.790186] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.795225] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.801407] TRB: ulpi_read reg=0x87, val=0x0
[  263.900165] TRB: msm writel(),         addr=f0062170, val=40870000
[  263.900186] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.905224] TRB: msm readl(),          addr=f0062170, val=08870000
[  263.911405] TRB: ulpi_read reg=0x87, val=0x0
[  263.917550] TRB: ulpi_write reg=0x86, val=0x10
[  263.921992] TRB: msm writel(),         addr=f0062170, val=60860010
[  263.926233] TRB: msm readl(),          addr=f0062170, val=28860010
[  263.932411] TRB: ulpi_write reg=0x85, val=0x2
[  263.938556] TRB: msm writel(),         addr=f0062170, val=60850002
[  263.943003] TRB: msm readl(),          addr=f0062170, val=28850002
[  263.949061] TRB: ulpi_write reg=0x85, val=0x1
[  263.955240] TRB: msm writel(),         addr=f0062170, val=60850001
[  263.959652] TRB: msm readl(),          addr=f0062170, val=28850001
[  264.000165] TRB: msm writel(),         addr=f0062170, val=40870000
[  264.000185] TRB: msm readl(),          addr=f0062170, val=08870000
[  264.005224] TRB: msm readl(),          addr=f0062170, val=08870000
[  264.011405] TRB: ulpi_read reg=0x87, val=0x0
[  264.017552] TRB: ulpi_write reg=0x86, val=0x3f
[  264.021993] TRB: msm writel(),         addr=f0062170, val=6086003f
[  264.026231] TRB: msm readl(),          addr=f0062170, val=2886003f
[  264.032410] TRB: ulpi_write reg=0x92, val=0x1f
[  264.038554] TRB: msm writel(),         addr=f0062170, val=6092001f
[  264.043002] TRB: msm readl(),          addr=f0062170, val=2892001f
[  264.049146] TRB: ulpi_write reg=0x95, val=0x1f
[  264.055326] TRB: msm writel(),         addr=f0062170, val=6095001f
[  264.059739] TRB: msm readl(),          addr=f0062170, val=2895001f
[  264.065918] TRB: msm writel(),         addr=f0062170, val=40040000
[  264.072082] TRB: msm readl(),          addr=f0062170, val=08044d00
[  264.078228] TRB: msm readl(),          addr=f0062170, val=08044d00
[  264.084407] TRB: ulpi_read reg=0x4, val=0x4d
[  264.090568] TRB: ulpi_write reg=0x4, val=0x45
[  264.094978] TRB: msm writel(),         addr=f0062170, val=60040045
[  264.099234] TRB: msm readl(),          addr=f0062170, val=28044d45
[  264.105337] TRB: in msm_otg_sm_work: state=1
[  264.111507] TRB: MOSW 2 OTG_STATE_B_IDLE state
[  264.115903] msm_otg f9a55000.usb: Avail curr from USB = 100
[  264.120171] TRB: msm_otg_start_peripheral, on=1
[  264.125620] TRB: msm_otg_start_peripheral, gadget on
[  264.130153] TRB: ci_udc_vbus_session, vbus_active=1
[  264.135343] TRB: ci_udc_vbus_session, gadget_ready=1
[  264.139944] TRB: ci_udc_vbus_session, reset controller
[  264.145168] TRB: hw_device_reset
[  264.150100] TRB: ci hw_write: reg=f00641b4, mask=ffffffff,
data=ffffffff
[  264.153507] TRB: ci hw_write: reg=f0064140, mask=00000001,
data=00000000
[  264.160191] TRB: ci hw_write: reg=f0064140, mask=00000002,
data=00000002
[  264.166858] TRB: ci hw_read: reg=f0064140, mask=00000002,
val=00000002
[  264.173569] TRB: ci hw_read: reg=f0064140, mask=00000002,
val=00000000
[  264.179881] ci_hdrc ci_hdrc.0: CI_HDRC_CONTROLLER_RESET_EVENT
received
[  264.186405] TRB: msm_phy_init, entering
[  264.192912]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[  264.196630]    ### PORTSC (184) val=8c000804
[  264.202199]      PTS (31:30) transceiver select =10b: ulpi
[  264.211483]     PSPD (27:26) port speed =11b: ???
[  264.216240]     PHCD (23) clock disable =0
[  264.216679]     LS (11:10) line status = 10b: J-state
[  264.225009]     PE (2) port enabled =1
[  264.225792]     CCS (0) current connect status =0
[  264.229353]   remainder=00000000
[  264.234144]   ### OTGSC (1a4) val=08203000
[  264.237425]     1MSIE (29) 1MS timer int enable =0
[  264.241350]     BSVIE (27) vbus B valid int enable =1
[  264.246108]     FIELD_1MSS (21) 1ms timer status =1
[  264.251246]     FIELD_1MST (13) 1ms timer toggle =1
[  264.255916]     BSE (12) vbus B session end =1
[  264.260794]     BSV (11) vbus B session valid =0
[  264.265291]     ASV (10) vbus A session valid =0
[  264.270064]     AVV (9) A vbus valid =0
[  264.274682]     IDPU (5) ID pullup =0
[  264.278224]   remainder=00000000
[  264.282060]   ### USBINTR (148) val=00000000
[  264.285343]     SLE (8) sleep int =0
[  264.289596]     URE (6) USB reset int=0
[  264.293171]     PCE (2) port change detect int=0
[  264.296715]     UEI (1) USB error int=0
[  264.301590]     UI (0) USB int=0
[  264.305132]   remainder=00000000
[  264.308605]   ### USBSTS (144) val=00000080
[  264.311834]     ULPI (10) ULPI event complete=0
[  264.315723]     SOF (7) SOF received=1
[  264.320255]     UEI (1) USB error=0
[  264.324056]     UI (0) USB int=0
[  264.327442]   remainder=00000000
[  264.330933]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[  264.334127]      SUSPENDM=1
[  264.339073]      OpMode=10b disable bit-stuff and NRZI encoding
[  264.344543]      TermSelect=1
[  264.347927]      XcvrSelect=01b FS
[  264.353742]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[  264.354008]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[  264.359215]      DmPulldown=1
[  264.364263]      DpPulldown=1
[  264.367200]    ### ULPI_USB_INT_STS (13) val=00000008
[  264.370170]      SessEnd=1
[  264.375184] TRB: ulpi_init() 1
[  264.377788] TRB: ulpi_init() 2
[  264.380842] TRB: ulpi_init() 3
[  264.383865] TRB: ulpi: write 0x63 to 0x81
[  264.386905] TRB: ulpi_init() 4
[  264.391000] TRB: ulpi_write reg=0x81, val=0x63
[  264.393937] TRB: msm writel(),         addr=f0062170, val=60810063
[  264.398367] TRB: msm readl(),          addr=f0062170, val=28810863
[  264.404546] TRB: ulpi_init() 5
[  264.410704] TRB: ulpi_init() 6
[  264.413725] TRB: ulpi_init() 7 - done
[  264.416766] TRB: in msm_phy_reset, entering
[  264.420516]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[  264.424494]    ### PORTSC (184) val=8c000804
[  264.430048]      PTS (31:30) transceiver select =10b: ulpi
[  264.439331]     PSPD (27:26) port speed =11b: ???
[  264.444122]     PHCD (23) clock disable =0
[  264.444543]     LS (11:10) line status = 10b: J-state
[  264.452890]     PE (2) port enabled =1
[  264.453658]     CCS (0) current connect status =0
[  264.457219]   remainder=00000000
[  264.462008]   ### OTGSC (1a4) val=08203000
[  264.465290]     1MSIE (29) 1MS timer int enable =0
[  264.469197]     BSVIE (27) vbus B valid int enable =1
[  264.473989]     FIELD_1MSS (21) 1ms timer status =1
[  264.479093]     FIELD_1MST (13) 1ms timer toggle =1
[  264.483797]     BSE (12) vbus B session end =1
[  264.488640]     BSV (11) vbus B session valid =0
[  264.493171]     ASV (10) vbus A session valid =0
[  264.497929]     AVV (9) A vbus valid =0
[  264.502546]     IDPU (5) ID pullup =0
[  264.506088]   remainder=00000000
[  264.509906]   ### USBINTR (148) val=00000000
[  264.513224]     SLE (8) sleep int =0
[  264.517459]     URE (6) USB reset int=0
[  264.521035]     PCE (2) port change detect int=0
[  264.524579]     UEI (1) USB error int=0
[  264.529439]     UI (0) USB int=0
[  264.533014]   remainder=00000000
[  264.536470]   ### USBSTS (144) val=00000480
[  264.539682]     ULPI (10) ULPI event complete=1
[  264.543605]     SOF (7) SOF received=1
[  264.548102]     UEI (1) USB error=0
[  264.551937]     UI (0) USB int=0
[  264.555306]   remainder=00000000
[  264.558779]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[  264.562010]      SUSPENDM=1
[  264.566938]      OpMode=10b disable bit-stuff and NRZI encoding
[  264.572425]      TermSelect=1
[  264.575793]      XcvrSelect=01b FS
[  264.581623]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[  264.581873]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[  264.587079]      DmPulldown=1
[  264.592128]      DpPulldown=1
[  264.595064]    ### ULPI_USB_INT_STS (13) val=00000008
[  264.598017]      SessEnd=1
[  264.603068] TRB: msm readl(),          addr=f0062278, val=000c3c32
[  264.605657] TRB: msm writel(),         addr=f0062278, val=000c3c33
[  264.611878] TRB: msm readl(),          addr=f0062278, val=000c3c33
[  264.617985] TRB: msm writel(),         addr=f0062278, val=000c3c32
[  264.624164] TRB: in msm_phy_reset, leaving
[  264.630325]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[  264.634390]    ### PORTSC (184) val=8c000804
[  264.639856]      PTS (31:30) transceiver select =10b: ulpi
[  264.649140]     PSPD (27:26) port speed =11b: ???
[  264.653930]     PHCD (23) clock disable =0
[  264.654352]     LS (11:10) line status = 10b: J-state
[  264.662700]     PE (2) port enabled =1
[  264.663466]     CCS (0) current connect status =0
[  264.667027]   remainder=00000000
[  264.671817]   ### OTGSC (1a4) val=08201000
[  264.675099]     1MSIE (29) 1MS timer int enable =0
[  264.679006]     BSVIE (27) vbus B valid int enable =1
[  264.683798]     FIELD_1MSS (21) 1ms timer status =1
[  264.688901]     FIELD_1MST (13) 1ms timer toggle =0
[  264.693606]     BSE (12) vbus B session end =1
[  264.698450]     BSV (11) vbus B session valid =0
[  264.702982]     ASV (10) vbus A session valid =0
[  264.707739]     AVV (9) A vbus valid =0
[  264.712354]     IDPU (5) ID pullup =0
[  264.715897]   remainder=00000000
[  264.719716]   ### USBINTR (148) val=00000000
[  264.723033]     SLE (8) sleep int =0
[  264.727269]     URE (6) USB reset int=0
[  264.730844]     PCE (2) port change detect int=0
[  264.734388]     UEI (1) USB error int=0
[  264.739248]     UI (0) USB int=0
[  264.742822]   remainder=00000000
[  264.746279]   ### USBSTS (144) val=00000480
[  264.749491]     ULPI (10) ULPI event complete=1
[  264.753416]     SOF (7) SOF received=1
[  264.757911]     UEI (1) USB error=0
[  264.761746]     UI (0) USB int=0
[  264.765115]   remainder=00000000
[  264.768590]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[  264.771820]      SUSPENDM=1
[  264.776745]      OpMode=10b disable bit-stuff and NRZI encoding
[  264.782233]      TermSelect=1
[  264.785601]      XcvrSelect=01b FS
[  264.791432]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[  264.791681]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[  264.796888]      DmPulldown=1
[  264.801937]      DpPulldown=1
[  264.804874]    ### ULPI_USB_INT_STS (13) val=00000008
[  264.807825]      SessEnd=1
[  264.812875] TRB: msm readl(),          addr=f0062278, val=000c3c32
[  264.815466] TRB: msm writel(),         addr=f0062278, val=000d3c32
[  264.821646] TRB: msm_phy_init, leaving
[  264.827789]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[  264.831543]    ### PORTSC (184) val=8c000804
[  264.836991]      PTS (31:30) transceiver select =10b: ulpi
[  264.846275]     PSPD (27:26) port speed =11b: ???
[  264.851068]     PHCD (23) clock disable =0
[  264.851488]     LS (11:10) line status = 10b: J-state
[  264.859816]     PE (2) port enabled =1
[  264.860619]     CCS (0) current connect status =0
[  264.864162]   remainder=00000000
[  264.868936]   ### OTGSC (1a4) val=08201000
[  264.872252]     1MSIE (29) 1MS timer int enable =0
[  264.876142]     BSVIE (27) vbus B valid int enable =1
[  264.880933]     FIELD_1MSS (21) 1ms timer status =1
[  264.886038]     FIELD_1MST (13) 1ms timer toggle =0
[  264.890742]     BSE (12) vbus B session end =1
[  264.895585]     BSV (11) vbus B session valid =0
[  264.900099]     ASV (10) vbus A session valid =0
[  264.904892]     AVV (9) A vbus valid =0
[  264.909474]     IDPU (5) ID pullup =0
[  264.913050]   remainder=00000000
[  264.916852]   ### USBINTR (148) val=00000000
[  264.920169]     SLE (8) sleep int =0
[  264.924404]     URE (6) USB reset int=0
[  264.927962]     PCE (2) port change detect int=0
[  264.931541]     UEI (1) USB error int=0
[  264.936383]     UI (0) USB int=0
[  264.939942]   remainder=00000000
[  264.943431]   ### USBSTS (144) val=00000480
[  264.946626]     ULPI (10) ULPI event complete=1
[  264.950551]     SOF (7) SOF received=1
[  264.955045]     UEI (1) USB error=0
[  264.958865]     UI (0) USB int=0
[  264.962267]   remainder=00000000
[  264.965725]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[  264.968937]      SUSPENDM=1
[  264.973899]      OpMode=10b disable bit-stuff and NRZI encoding
[  264.979352]      TermSelect=1
[  264.982753]      XcvrSelect=01b FS
[  264.988551]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[  264.988817]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[  264.994042]      DmPulldown=1
[  264.999055]      DpPulldown=1
[  265.002026]    ### ULPI_USB_INT_STS (13) val=00000008
[  265.004961]      SessEnd=1
[  265.009994] TRB: ci hw_write: reg=f00641a8, mask=00000010,
data=00000010
[  265.012624] TRB: ci hw_write: reg=f00641a8, mask=00000003,
data=00000000
[  265.019462] TRB: ci hw_write: reg=f00641a8, mask=00000003,
data=00000002
[  265.026163] TRB: ci hw_write: reg=f00641a8, mask=00000008,
data=00000008
[  265.032847] TRB: ci hw_read: reg=f00641a8, mask=00000003,
val=00000002
[  265.039512] TRB hw_device_reset done
[  265.045863] TRB: ucd.c:hw_device_state, dma=791977984
[  265.049581] TRB: ci hw_write: reg=f0064158, mask=ffffffff,
data=2f34a000
[  265.054550] TRB: ci hw_write: reg=f0064148, mask=ffffffff,
data=00000147
[  265.061318] TRB: ci hw_write: reg=f0064140, mask=00000001,
data=00000001
[  265.067985] TRB: ucd.c:hw_device_state done
[  265.074684] ci_hdrc ci_hdrc.0: Connected to host

/lib/modules # ./regs
[  270.226712] TRB: in msm_otg_reg_show
[  270.226731]  motg->pdata->otg_control==OTG_PMIC_CONTROL=0
[  270.229343]    ### PORTSC (184) val=8c000804
[  270.234715]      PTS (31:30) transceiver select =10b: ulpi
[  270.243956]     PSPD (27:26) port speed =11b: ???
[  270.248692]     PHCD (23) clock disable =0
[  270.249131]     LS (11:10) line status = 10b: J-state
[  270.257460]     PE (2) port enabled =1
[  270.258245]     CCS (0) current connect status =0
[  270.261822]   remainder=00000000
[  270.266578]   ### OTGSC (1a4) val=08203000
[  270.269876]     1MSIE (29) 1MS timer int enable =0
[  270.273801]     BSVIE (27) vbus B valid int enable =1
[  270.278558]     FIELD_1MSS (21) 1ms timer status =1
[  270.283698]     FIELD_1MST (13) 1ms timer toggle =1
[  270.288368]     BSE (12) vbus B session end =1
[  270.293245]     BSV (11) vbus B session valid =0
[  270.297743]     ASV (10) vbus A session valid =0
[  270.302534]     AVV (9) A vbus valid =0
[  270.307115]     IDPU (5) ID pullup =0
[  270.310691]   remainder=00000000
[  270.314495]   ### USBINTR (148) val=00000147
[  270.317794]     SLE (8) sleep int =1
[  270.322063]     URE (6) USB reset int=1
[  270.325606]     PCE (2) port change detect int=1
[  270.329166]     UEI (1) USB error int=1
[  270.334042]     UI (0) USB int=1
[  270.337585]   remainder=00000000
[  270.341073]   ### USBSTS (144) val=00000480
[  270.344270]     ULPI (10) ULPI event complete=1
[  270.348176]     SOF (7) SOF received=1
[  270.352706]     UEI (1) USB error=0
[  270.356507]     UI (0) USB int=0
[  270.359894]   remainder=00000000
[  270.363383]    ### ULPI_FUNC_CTRL (4,5,6) val=00000055
[  270.366579]      SUSPENDM=1
[  270.371542]      OpMode=10b disable bit-stuff and NRZI encoding
[  270.376995]      TermSelect=1
[  270.380396]      XcvrSelect=01b FS
[  270.386193]    ### ULPI_IFC_CTRL (7,7,9) val=00000000
[  270.386459]    ### ULPI_OTG_CTRL (a,b,c) val=00000006
[  270.391684]      DmPulldown=1
[  270.396698]      DpPulldown=1
[  270.399652]    ### ULPI_USB_INT_STS (13) val=00000008
[  270.402620]      SessEnd=1
See regs in dmesg log
/lib/modules # echo "no joy!"
no joy!

On Wed, Mar 5, 2014 at 2:13 AM, Ivan T. Ivanov <iivanov@mm-sol.com> wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
>
> Hi,
>
> This is a fifth version of patches posted earlier here [1].
>
> They have been tested on AP8074 DragonBoard. Only gadget
> mode utilized for now.
>
> CV Test Suite engine "Chapter 9 tests" are passing except
> "Halt Endpoint Test".
>
> usbtest driver report following failure:
> test 13 --> 32 (Broken pipe)    ep 81 couldn't set halt, -32
>
> Changes since v4:
>  - Drop patch [1/15] usb: phy: msm: Move mach dependent code to platform data
>    it is already merged.
>  - Address comments regarding devicetree bindings.
>
> [1] https://lkml.org/lkml/2013/11/12/298
>
> Ivan T. Ivanov (14):
>   usb: phy: msm: Move global regulators variables to driver state
>   usb: phy: msm: Migrate to Managed Device Resource allocation
>   usb: phy: msm: Remove unnecessarily check for valid regulators.
>   usb: phy: msm: Fix checkpatch.pl warnings
>   usb: phy: msm: Replace custom enum usb_mode_type with enum
>     usb_dr_mode
>   usb: phy: msm: Remove unused pclk_src_name
>   usb: phy: msm: Remove HSUSB prefix from regulator names
>   usb: phy: msm: Properly check result from platform_get_irq()
>   usb: phy: msm: Add device tree support and binding information
>   usb: phy: msm: Use reset framework for LINK and PHY resets
>   usb: phy: msm: Add support for secondary PHY control
>   usb: phy: msm: Correct USB PHY Reset sequence for newer platform
>   usb: phy: msm: Handle disconnect events
>   usb: phy: msm: Vote for corner of VDD CX instead of voltage of VDD CX
>
>  .../devicetree/bindings/usb/msm-hsusb.txt          |   78 +++
>  arch/arm/mach-msm/board-msm7x30.c                  |    2 +-
>  arch/arm/mach-msm/board-qsd8x50.c                  |    2 +-
>  drivers/usb/phy/phy-msm-usb.c                      |  674 +++++++++++---------
>  include/linux/usb/msm_hsusb.h                      |   39 +-
>  include/linux/usb/msm_hsusb_hw.h                   |    6 +
>  6 files changed, 474 insertions(+), 327 deletions(-)
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
 -- Tim Bird
Senior Software Engineer, Sony Mobile
Architecture Group Chair, CE Workgroup, Linux Foundation
