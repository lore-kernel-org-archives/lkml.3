Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751250Ab3G0J5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 05:57:11 -0400
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2201 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3G0J5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 05:57:06 -0400
Message-ID: <51F39966.1020301@xs4all.nl>
Date: Sat, 27 Jul 2013 11:56:54 +0200
From: Jim Bos <jim876@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130629 Thunderbird/17.0.7
MIME-Version: 1.0
To: Dave Airlie <airlied@linux.ie>
CC: torvalds@linux-foundation.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes - regular pull req
References: <alpine.DEB.2.00.1307261150280.5725@skynet.skynet.ie>
In-Reply-To: <alpine.DEB.2.00.1307261150280.5725@skynet.skynet.ie>
Content-Type: multipart/mixed;
 boundary="------------040208000807040507050708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040208000807040507050708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 07/26/2013 12:52 PM, Dave Airlie wrote:
> 
> This is just a regular fixes pull apart from the qxl one, it has radeon 
> and intel bits in it,
> 
> the intel fixes are for a regression with the RC6 fix and a 3.10 hdmi 
> regression, whereas radeon is more DPM fixes, a few lockup fixes and 
> some rn50/r100 DAC fixes.
> 
> Dave.
> 
> The following changes since commit 07bc9dc1b01bad7084fed3d2659e5d83317869bc:
> 
>   Merge branch 'merge' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-07-24 11:07:18 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://people.freedesktop.org/~airlied/linux drm-fixes
> 
> for you to fetch changes up to bf903e4141fce4b35072d5b8fa0ddd299aaf01ea:
> 
>   Merge tag 'drm-intel-fixes-2013-07-25' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes (2013-07-26 20:38:14 +1000)
> 
> ----------------------------------------------------------------
> 
> Alex Deucher (8):
>       drm/radeon: wait for 3D idle before using CP DMA
>       drm/radeon/vm: only align the pt base to 32k
>       drm/radeon: fix endian issues with DP handling (v3)
>       drm/radeon: improve dac adjust heuristics for legacy pdac
>       drm/radeon/dpm: fix a typo in the rv6xx mclk setup
>       drm/radeon/dpm: fix displaygap programming on rv6xx
>       drm/radeon/dpm: implement force performance levels for rv6xx
>       drm/radeon/dpm: fix r600_enable_sclk_control()
> 
> Daniel Vetter (1):
>       drm/i915: fix hdmi portclock limits
> 
> Dave Airlie (2):
>       Merge branch 'drm-fixes-3.11' of git://people.freedesktop.org/~agd5f/linux into drm-fixes
>       Merge tag 'drm-intel-fixes-2013-07-25' of git://people.freedesktop.org/~danvet/drm-intel into drm-fixes
> 
> Jani Nikula (1):
>       drm/i915: initialize gt_lock early with other spin locks
> 
> Mark Kettenis (1):
>       drm/radeon: fix combios tables on older cards
> 
> Ondrej Zary (1):
>       drm/radeon: Another card with wrong primary dac adj
> 
>  drivers/gpu/drm/i915/i915_dma.c         |   1 +
>  drivers/gpu/drm/i915/intel_hdmi.c       |  19 +++-
>  drivers/gpu/drm/i915/intel_pm.c         |   2 -
>  drivers/gpu/drm/radeon/atombios_dp.c    |  43 ++++++++-
>  drivers/gpu/drm/radeon/r600.c           |   5 +-
>  drivers/gpu/drm/radeon/r600_dpm.c       |   4 +-
>  drivers/gpu/drm/radeon/radeon_asic.c    |   1 +
>  drivers/gpu/drm/radeon/radeon_asic.h    |   2 +
>  drivers/gpu/drm/radeon/radeon_combios.c | 159 ++++++++++----------------------
>  drivers/gpu/drm/radeon/radeon_gart.c    |   8 +-
>  drivers/gpu/drm/radeon/rv6xx_dpm.c      |  41 +++++++-
>  11 files changed, 158 insertions(+), 127 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

FYI, with these commits, I'm still seeing attached stack trace and
 " [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the
VCPU!!! "
messages  *after* resuming from Suspend-2-Ram.

This is with new power management enabled (radeon.dpm=1) which seems to
work just fine.

_
Jim



--------------040208000807040507050708
Content-Type: text/plain; charset=UTF-8;
 name="dmesg.slowpatch-UVD.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg.slowpatch-UVD.txt"

[  198.100849] ACPI: Low-level resume complete
[  198.100883] PM: Restoring platform NVS memory
[  198.101277] Enabling non-boot CPUs ...
[  198.101305] smpboot: Booting Node 0 Processor 1 APIC 0x2
[  198.114618] CPU1 is up
[  198.114629] smpboot: Booting Node 0 Processor 2 APIC 0x4
[  198.127911] CPU2 is up
[  198.127922] smpboot: Booting Node 0 Processor 3 APIC 0x6
[  198.141200] CPU3 is up
[  198.143177] ACPI: Waking up from system sleep state S3
[  198.154441] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
[  198.167770] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
[  198.207819] pcieport 0000:00:1c.3: System wakeup disabled by ACPI
[  198.234485] pcieport 0000:00:1c.5: System wakeup disabled by ACPI
[  198.247912] PM: noirq resume of devices complete after 104.343 msecs
[  198.248040] PM: early resume of devices complete after 0.088 msecs
[  198.248086] ahci 0000:00:1f.2: setting latency timer to 64
[  198.248109] ehci-pci 0000:00:1a.0: setting latency timer to 64
[  198.248222] ehci-pci 0000:00:1d.0: setting latency timer to 64
[  198.248319] pcieport 0000:00:1c.6: System wakeup disabled by ACPI
[  198.251310] [drm] enabling PCIE gen 2 link speeds, disable with radeon.pcie_gen2=0
[  198.251727] serial 00:02: activated
[  198.253294] [drm] PCIE GART of 512M enabled (table at 0x000000000025D000).
[  198.253396] radeon 0000:01:00.0: WB enabled
[  198.253398] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xffff88032d113c00
[  198.253399] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000040000c0c and cpu addr 0xffff88032d113c0c
[  198.253873] radeon 0000:01:00.0: fence driver on ring 5 use gpu addr 0x000000000005c418 and cpu addr 0xffffc9001189c418
[  198.270138] [drm] ring test on 0 succeeded in 0 usecs
[  198.270200] [drm] ring test on 3 succeeded in 0 usecs
[  198.581079] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  198.581095] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[  198.583586] ata4.00: configured for UDMA/66
[  198.602750] ata2.00: configured for UDMA/133
[  198.607734] ata5: SATA link down (SStatus 0 SControl 300)
[  198.921060] ata6: SATA link down (SStatus 0 SControl 300)
[  199.456226] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  200.476190] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  201.496155] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  202.516121] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  203.536086] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  203.600929] ata1: link is slow to respond, please be patient (ready=0)
[  204.357573] ------------[ cut here ]------------
[  204.357578] WARNING: CPU: 1 PID: 0 at net/sched/sch_generic.c:255 dev_watchdog+0x220/0x230()
[  204.357578] NETDEV WATCHDOG: eth0 (r8169): transmit queue 0 timed out
[  204.357597] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 iptable_raw xt_CT nf_nat_ftp nf_conntrack_ftp nf_conntrack_ipv4 nf_defrag_ipv4 xt_nat nf_nat nf_conntrack tun cn nfsd auth_rpcgss oid_registry exportfs lockd sunrpc ftdi_sio usbserial hid_logitech_dj usbhid fuse usb_storage ehci_pci xhci_hcd ehci_hcd lpc_ich i2c_i801 serio_raw usbcore mfd_core emu10k1_gp usb_common i2c_dev rtc_cmos evdev
[  204.357605] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.11.0-rc2+ #45
[  204.357606] Hardware name: MSI MS-7673/P67A-C45 (MS-7673), BIOS V1.18 02/22/2012
[  204.357608]  0000000000000009 ffffffff81663ceb ffff88033f483e38 ffffffff8103dc6d
[  204.357608]  0000000000000000 ffff88033f483e88 0000000000000001 0000000000000001
[  204.357609]  ffff88032de01428 ffffffff8103dcd7 ffffffff818ae808 ffff880300000030
[  204.357609] Call Trace:
[  204.357612]  <IRQ>  [<ffffffff81663ceb>] ? dump_stack+0x41/0x51
[  204.357615]  [<ffffffff8103dc6d>] ? warn_slowpath_common+0x6d/0x90
[  204.357617]  [<ffffffff8103dcd7>] ? warn_slowpath_fmt+0x47/0x50
[  204.357618]  [<ffffffff8159d6b0>] ? dev_watchdog+0x220/0x230
[  204.357619]  [<ffffffff8159d490>] ? dev_graft_qdisc+0x70/0x70
[  204.357621]  [<ffffffff8104b05c>] ? call_timer_fn.isra.30+0x1c/0x80
[  204.357622]  [<ffffffff8104b239>] ? run_timer_softirq+0x179/0x250
[  204.357625]  [<ffffffff812a9bc8>] ? timerqueue_add+0x58/0xa0
[  204.357626]  [<ffffffff81045026>] ? __do_softirq+0xd6/0x1a0
[  204.357627]  [<ffffffff81045225>] ? irq_exit+0x95/0xa0
[  204.357637]  [<ffffffff810291ab>] ? smp_apic_timer_interrupt+0x3b/0x50
[  204.357638]  [<ffffffff8166b147>] ? apic_timer_interrupt+0x67/0x70
[  204.357641]  <EOI>  [<ffffffff814f4967>] ? cpuidle_enter_state+0x47/0xc0
[  204.357642]  [<ffffffff814f4963>] ? cpuidle_enter_state+0x43/0xc0
[  204.357643]  [<ffffffff814f4a8a>] ? cpuidle_idle_call+0xaa/0x150
[  204.357645]  [<ffffffff8100af05>] ? arch_cpu_idle+0x5/0x20
[  204.357646]  [<ffffffff8107c3b8>] ? cpu_startup_entry+0x78/0x160
[  204.357647] ---[ end trace 361118f69f20cf04 ]---
[  204.556052] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  205.576018] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  206.214201] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  206.232507] ata1.00: configured for UDMA/133
[  206.244238] sd 1:0:0:0: [sdb] Starting disk
[  206.244245] sd 0:0:0:0: [sda] Starting disk
[  206.595993] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  207.615957] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  208.635922] [drm:r600_uvd_init] *ERROR* UVD not responding, trying to reset the VCPU!!!
[  208.655922] [drm:r600_uvd_init] *ERROR* UVD not responding, giving up!!!
[  208.655924] [drm:evergreen_startup] *ERROR* radeon: error initializing UVD (-1).
[  208.655946] [drm] ib test on ring 0 succeeded in 0 usecs
[  208.655967] [drm] ib test on ring 3 succeeded in 1 usecs
[  208.657399] switching from power state:
[  208.657400]  ui class: none
[  208.657401]  internal class: boot 
[  208.657401]  caps: video 
[  208.657402]  uvd    vclk: 0 dclk: 0
[  208.657402]          power level 0    sclk: 77500 mclk: 80000 vddc: 1050 vddci: 0
[  208.657403]          power level 1    sclk: 77500 mclk: 80000 vddc: 1050 vddci: 0
[  208.657403]          power level 2    sclk: 77500 mclk: 80000 vddc: 1050 vddci: 0
[  208.657404]  status: c b 
[  208.657404] switching to power state:
[  208.657404]  ui class: performance
[  208.657405]  internal class: none
[  208.657405]  caps: single_disp video 
[  208.657406]  uvd    vclk: 0 dclk: 0
[  208.657413]          power level 0    sclk: 15700 mclk: 20000 vddc: 1000 vddci: 0
[  208.657414]          power level 1    sclk: 40000 mclk: 80000 vddc: 1000 vddci: 0
[  208.657414]          power level 2    sclk: 77500 mclk: 80000 vddc: 1050 vddci: 0
[  208.657414]  status: r 
[  208.770287] r8169 0000:07:00.0 eth0: link up
[  208.815254] PM: resume of devices complete after 10567.485 msecs
[  208.815424] Restarting tasks ... done.
[  208.823626] r8169 0000:07:00.0 eth0: link up
[  209.841619] nfsd: last server has exited, flushing export cache
[  211.424982] EXT4-fs (sda8): mounted filesystem with ordered data mode. Opts: (null)
[  211.435954] svc: failed to register lockdv1 RPC service (errno 97).
[  211.435980] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  211.435989] NFSD: starting 90-second grace period (net ffffffff81977b00)
[  211.630569] ata1.00: configured for UDMA/133
[  211.630575] ata1: EH complete
[  211.654848] ata2.00: configured for UDMA/133
[  211.654854] ata2: EH complete

--------------040208000807040507050708--
