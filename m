Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaJDRWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 13:22:47 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55332 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaJDRWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 13:22:45 -0400
MIME-Version: 1.0
Date: Sat, 4 Oct 2014 10:22:44 -0700
Message-ID: <CAKx2Y1nRHJ8hkNkDYPQiqNKhgG===p0on4ohXZbx=_Sg599fCQ@mail.gmail.com>
Subject: Re: 3.17.0-rc7 kernel NULL pointer dereference (3ware 9650SE)
From: Kui Zhang <kuizhang@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        aradford@gmail.com, linuxraid@lsi.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally got some more useful traces.


[ 4629.957226] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000018
[ 4629.960539] IP: [<ffffffff814aa260>] swiotlb_unmap_sg_attrs+0x30/0x70
[ 4629.960539] PGD 3e4176067 PUD 3e4177067 PMD 0
[ 4629.960539] Oops: 0000 [#1] SMP
[ 4629.960539] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack serio_raw microcode
[ 4629.960539] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G          I
3.17.0-rc7-00086-gee042ec #20
[ 4629.960539] Hardware name: empty empty/S5393, BIOS V1.05 04/24/2009
[ 4629.960539] task: ffff8804295c3040 ti: ffff8804295cc000 task.ti:
ffff8804295cc000
[ 4629.960539] RIP: 0010:[<ffffffff814aa260>]  [<ffffffff814aa260>]
swiotlb_unmap_sg_attrs+0x30/0x70
[ 4629.960539] RSP: 0018:ffff88043fd83de8  EFLAGS: 00010002
[ 4629.960539] RAX: ffff88042903b898 RBX: 0000000000000000 RCX: 0000000000000001
[ 4629.960539] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88042903b898
[ 4629.960539] RBP: ffff88043fd83e18 R08: 0000000000000000 R09: ffffffff814aa230
[ 4629.960539] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 4629.960539] R13: 0000000000000001 R14: 0000000000000001 R15: ffff88042903b898
[ 4629.960539] FS:  0000000000000000(0000) GS:ffff88043fd80000(0000)
knlGS:0000000000000000
[ 4629.960539] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4629.960539] CR2: 0000000000000018 CR3: 00000003e4175000 CR4: 00000000000407e0
[ 4629.960539] Stack:
[ 4629.960539]  00000000000000f0 ffff88003688c6c0 00000000000000f0
00000000000000f0
[ 4629.960539]  0000000000000000 ffff880036a7c000 ffff88043fd83e28
ffffffff81580cb0
[ 4629.960539]  ffff88043fd83e38 ffffffff815d7cc9 ffff88043fd83ea8
ffffffff815d89e4
[ 4629.960539] Call Trace:
[ 4629.960539]  <IRQ>
[ 4629.960539]
[ 4629.960539]  [<ffffffff81580cb0>] scsi_dma_unmap+0x50/0x70
[ 4629.960539]  [<ffffffff815d7cc9>] twa_unmap_scsi_data+0x29/0x30
[ 4629.960539]  [<ffffffff815d89e4>] twa_interrupt+0x414/0x800
[ 4629.960539]  [<ffffffff810ca004>] handle_irq_event_percpu+0x54/0x1b0
[ 4629.960539]  [<ffffffff810ca19c>] handle_irq_event+0x3c/0x60
[ 4629.960539]  [<ffffffff810ccde7>] handle_fasteoi_irq+0x77/0x130
[ 4629.960539]  [<ffffffff81004ebd>] handle_irq+0x1d/0x30
[ 4629.960539]  [<ffffffff81004c19>] do_IRQ+0x59/0x110
[ 4629.960539]  [<ffffffff818036aa>] common_interrupt+0x6a/0x6a
[ 4629.960539]  <EOI>
[ 4629.960539]
[ 4629.960539]  [<ffffffff8100c597>] ? default_idle+0x17/0xb0
[ 4629.960539]  [<ffffffff8100ce0a>] arch_cpu_idle+0xa/0x10
[ 4629.960539]  [<ffffffff810be259>] cpu_startup_entry+0x2f9/0x330
[ 4629.960539]  [<ffffffff8102da59>] start_secondary+0x1c9/0x240
[ 4629.960539] Code: 57 41 56 41 89 ce 41 55 41 54 53 48 83 ec 08 83
f9 03 74 4c 45 31 e4 85 d2 49 89 ff 41 89 d5 48 89 f3 7e 2d 0f 1f 80
00 00 00 00 <8b> 53 18 44 89 f1 4c 89 ff 48 8b 73 10 41 83 c4 01 e8 8a
ff ff
[ 4629.960539] RIP  [<ffffffff814aa260>] swiotlb_unmap_sg_attrs+0x30/0x70
[ 4629.960539]  RSP <ffff88043fd83de8>
[ 4629.960539] CR2: 0000000000000018



PID: 0      TASK: ffff8804295c3040  CPU: 3   COMMAND: "swapper/3"
 #0 [ffff88043fd839d0] machine_kexec at ffffffff8103484d
 #1 [ffff88043fd83a20] crash_kexec at ffffffff810f3343
 #2 [ffff88043fd83af0] oops_end at ffffffff810063d8
 #3 [ffff88043fd83b20] no_context at ffffffff817f7b91
 #4 [ffff88043fd83b80] __bad_area_nosemaphore at ffffffff817f7f21
 #5 [ffff88043fd83be0] bad_area_nosemaphore at ffffffff817f7f4e
 #6 [ffff88043fd83bf0] __do_page_fault at ffffffff8103b14e
 #7 [ffff88043fd83d00] do_page_fault at ffffffff8103b413
 #8 [ffff88043fd83d30] page_fault at ffffffff818045e2
    [exception RIP: swiotlb_unmap_sg_attrs+48]
    RIP: ffffffff814aa260  RSP: ffff88043fd83de8  RFLAGS: 00010002
    RAX: ffff88042903b898  RBX: 0000000000000000  RCX: 0000000000000001
    RDX: 0000000000000001  RSI: 0000000000000000  RDI: ffff88042903b898
    RBP: ffff88043fd83e18   R8: 0000000000000000   R9: ffffffff814aa230
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000000
    R13: 0000000000000001  R14: 0000000000000001  R15: ffff88042903b898
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff88043fd83e20] scsi_dma_unmap at ffffffff81580cb0
#10 [ffff88043fd83e30] twa_unmap_scsi_data at ffffffff815d7cc9
#11 [ffff88043fd83e40] twa_interrupt at ffffffff815d89e4
#12 [ffff88043fd83eb0] handle_irq_event_percpu at ffffffff810ca004
#13 [ffff88043fd83f00] handle_irq_event at ffffffff810ca19c
#14 [ffff88043fd83f30] handle_fasteoi_irq at ffffffff810ccde7
#15 [ffff88043fd83f50] handle_irq at ffffffff81004ebd
#16 [ffff88043fd83f70] do_IRQ at ffffffff81004c19
--- <IRQ stack> ---
#17 [ffff8804295cfdd8] ret_from_intr at ffffffff818036aa
    [exception RIP: default_idle+23]
    RIP: ffffffff8100c597  RSP: ffff8804295cfe88  RFLAGS: 00000246
    RAX: 0000000000080000  RBX: ffff88043fd8cd40  RCX: 0100000000000000
    RDX: 00000000ffffffed  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff8804295cfe98   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000003
    R13: 0000000000013680  R14: 0000000000000086  R15: ffff88043fd8d760
    ORIG_RAX: ffffffffffffff6e  CS: 0010  SS: 0018
#18 [ffff8804295cfea0] arch_cpu_idle at ffffffff8100ce0a
#19 [ffff8804295cfeb0] cpu_startup_entry at ffffffff810be259
#20 [ffff8804295cff20] start_secondary at ffffffff8102da59




[ 2044.906427] BUG: unable to handle kernel NULL pointer dereference
at 0000000000000018
[ 2044.909740] IP: [<ffffffff814aa260>] swiotlb_unmap_sg_attrs+0x30/0x70
[ 2044.909740] PGD 40f598067 PUD 4120b0067 PMD 0
[ 2044.909740] Oops: 0000 [#1] SMP
[ 2044.909740] Modules linked in: nf_conntrack_ipv4 nf_defrag_ipv4
xt_conntrack nf_conntrack serio_raw microcode
[ 2044.909740] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G          I
3.17.0-rc7-00086-gee042ec #20
[ 2044.909740] Hardware name: empty empty/S5393, BIOS V1.05 04/24/2009
[ 2044.909740] task: ffff8804295c1820 ti: ffff8804295c8000 task.ti:
ffff8804295c8000
[ 2044.909740] RIP: 0010:[<ffffffff814aa260>]  [<ffffffff814aa260>]
swiotlb_unmap_sg_attrs+0x30/0x70
[ 2044.909740] RSP: 0018:ffff88043fd03de8  EFLAGS: 00010002
[ 2044.909740] RAX: ffff88042919b098 RBX: 0000000000000000 RCX: 0000000000000002
[ 2044.909740] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88042919b098
[ 2044.909740] RBP: ffff88043fd03e18 R08: 0000000000000000 R09: ffffffff814aa230
[ 2044.909740] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[ 2044.909740] R13: 0000000000000001 R14: 0000000000000002 R15: ffff88042919b098
[ 2044.909740] FS:  0000000000000000(0000) GS:ffff88043fd00000(0000)
knlGS:0000000000000000
[ 2044.909740] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2044.909740] CR2: 0000000000000018 CR3: 0000000425733000 CR4: 00000000000407e0
[ 2044.909740] Stack:
[ 2044.909740]  0000000000000002 ffff880036ac46c0 0000000000000002
0000000000000002
[ 2044.909740]  0000000000000000 ffff880036a40800 ffff88043fd03e28
ffffffff81580cb0
[ 2044.909740]  ffff88043fd03e38 ffffffff815d7cc9 ffff88043fd03ea8
ffffffff815d89e4
[ 2044.909740] Call Trace:
[ 2044.909740]  <IRQ>
[ 2044.909740]
[ 2044.909740]  [<ffffffff81580cb0>] scsi_dma_unmap+0x50/0x70
[ 2044.909740]  [<ffffffff815d7cc9>] twa_unmap_scsi_data+0x29/0x30
[ 2044.909740]  [<ffffffff815d89e4>] twa_interrupt+0x414/0x800
[ 2044.909740]  [<ffffffff810d6f2b>] ? get_next_timer_interrupt+0x1bb/0x250
[ 2044.909740]  [<ffffffff810ca004>] handle_irq_event_percpu+0x54/0x1b0
[ 2044.909740]  [<ffffffff810ca19c>] handle_irq_event+0x3c/0x60
[ 2044.909740]  [<ffffffff810ccde7>] handle_fasteoi_irq+0x77/0x130
[ 2044.909740]  [<ffffffff81004ebd>] handle_irq+0x1d/0x30
[ 2044.909740]  [<ffffffff81004c19>] do_IRQ+0x59/0x110
[ 2044.909740]  [<ffffffff818036aa>] common_interrupt+0x6a/0x6a
[ 2044.909740]  <EOI>
[ 2044.909740]
[ 2044.909740]  [<ffffffff8100c597>] ? default_idle+0x17/0xb0
[ 2044.909740]  [<ffffffff8100ce0a>] arch_cpu_idle+0xa/0x10
[ 2044.909740]  [<ffffffff810be259>] cpu_startup_entry+0x2f9/0x330
[ 2044.909740]  [<ffffffff8102da59>] start_secondary+0x1c9/0x240
[ 2044.909740] Code: 57 41 56 41 89 ce 41 55 41 54 53 48 83 ec 08 83
f9 03 74 4c 45 31 e4 85 d2 49 89 ff 41 89 d5 48 89 f3 7e 2d 0f 1f 80
00 00 00 00 <8b> 53 18 44 89 f1 4c 89 ff 48 8b 73 10 41 83 c4 01 e8 8a
ff ff
[ 2044.909740] RIP  [<ffffffff814aa260>] swiotlb_unmap_sg_attrs+0x30/0x70
[ 2044.909740]  RSP <ffff88043fd03de8>
[ 2044.909740] CR2: 0000000000000018



PID: 0      TASK: ffff8804295c1820  CPU: 2   COMMAND: "swapper/2"
 #0 [ffff88043fd039d0] machine_kexec at ffffffff8103484d
 #1 [ffff88043fd03a20] crash_kexec at ffffffff810f3343
 #2 [ffff88043fd03af0] oops_end at ffffffff810063d8
 #3 [ffff88043fd03b20] no_context at ffffffff817f7b91
 #4 [ffff88043fd03b80] __bad_area_nosemaphore at ffffffff817f7f21
 #5 [ffff88043fd03be0] bad_area_nosemaphore at ffffffff817f7f4e
 #6 [ffff88043fd03bf0] __do_page_fault at ffffffff8103b14e
 #7 [ffff88043fd03d00] do_page_fault at ffffffff8103b413
 #8 [ffff88043fd03d30] page_fault at ffffffff818045e2
    [exception RIP: swiotlb_unmap_sg_attrs+48]
    RIP: ffffffff814aa260  RSP: ffff88043fd03de8  RFLAGS: 00010002
    RAX: ffff88042919b098  RBX: 0000000000000000  RCX: 0000000000000002
    RDX: 0000000000000001  RSI: 0000000000000000  RDI: ffff88042919b098
    RBP: ffff88043fd03e18   R8: 0000000000000000   R9: ffffffff814aa230
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000000
    R13: 0000000000000001  R14: 0000000000000002  R15: ffff88042919b098
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
 #9 [ffff88043fd03e20] scsi_dma_unmap at ffffffff81580cb0
#10 [ffff88043fd03e30] twa_unmap_scsi_data at ffffffff815d7cc9
#11 [ffff88043fd03e40] twa_interrupt at ffffffff815d89e4
#12 [ffff88043fd03eb0] handle_irq_event_percpu at ffffffff810ca004
#13 [ffff88043fd03f00] handle_irq_event at ffffffff810ca19c
#14 [ffff88043fd03f30] handle_fasteoi_irq at ffffffff810ccde7
#15 [ffff88043fd03f50] handle_irq at ffffffff81004ebd
#16 [ffff88043fd03f70] do_IRQ at ffffffff81004c19
--- <IRQ stack> ---
#17 [ffff8804295cbdd8] ret_from_intr at ffffffff818036aa
    [exception RIP: default_idle+23]
    RIP: ffffffff8100c597  RSP: ffff8804295cbe88  RFLAGS: 00000246
    RAX: 0000000000080000  RBX: ffff88043fd0cd40  RCX: 0100000000000000
    RDX: 00000000ffffffed  RSI: 0000000000000000  RDI: 0000000000000000
    RBP: ffff8804295cbe98   R8: 0000000000000000   R9: 0000000000000000
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000002
    R13: 0000000000013680  R14: 0000000000000086  R15: ffff88043fd0d760
    ORIG_RAX: ffffffffffffff6e  CS: 0010  SS: 0018
#18 [ffff8804295cbea0] arch_cpu_idle at ffffffff8100ce0a
#19 [ffff8804295cbeb0] cpu_startup_entry at ffffffff810be259
#20 [ffff8804295cbf20] start_secondary at ffffffff8102da59





05:00.0 RAID bus controller: 3ware Inc 9650SE SATA-II RAID PCIe (rev 01)
Subsystem: 3ware Inc 9650SE SATA-II RAID PCIe
Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
Latency: 0, Cache Line Size: 64 bytes
Interrupt: pin A routed to IRQ 16
Region 0: Memory at da000000 (64-bit, prefetchable) [size=32M]
Region 2: Memory at dc400000 (64-bit, non-prefetchable) [size=4K]
Region 4: I/O ports at 3000 [size=256]
[virtual] Expansion ROM at dc420000 [disabled] [size=128K]
Capabilities: [40] Power Management version 2
Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
Address: 0000000000000000  Data: 0000
Capabilities: [70] Express (v1) Legacy Endpoint, MSI 00
DevCap: MaxPayload 512 bytes, PhantFunc 0, Latency L0s <128ns, L1 <2us
ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
DevCtl: Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
MaxPayload 128 bytes, MaxReadReq 512 bytes
DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
LnkCap: Port #0, Speed 2.5GT/s, Width x8, ASPM L0s L1, Latency L0
<512ns, L1 <64us
ClockPM- Surprise- LLActRep+ BwNot-
LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk-
ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
LnkSta: Speed 2.5GT/s, Width x8, TrErr- Train- SlotClk- DLActive+
BWMgmt- ABWMgmt-
Kernel driver in use: 3w-9xxx


Driver Version = 2.26.02.014
Model = 9650SE-24M8
Available Memory = 448MB
Firmware Version = FE9X 4.10.00.027
Bios Version = BE9X 4.08.00.004
Boot Loader Version = BL9X 3.08.00.001


Thanks
Kui.Z




On Wed, Oct 1, 2014 at 12:30 PM, Kui Zhang <kuizhang@gmail.com> wrote:
> Hello,
>
> We have been getting NULL pointer dereference error, with 3.17.0-rc7,
> built from commit aad7fb916a10f1065ad23de0c80a4a04bcba8437
>
> I don't know how to reproduce this. It seem to happen during high io
> load (sometimes). I got follow via usb a serial console, not sure if
> trace is complete.
>
>
> [12660.20467[12660.205958] kworker/u8:5    D ffff8803b3123020     0
> 23992      2 0x00000000
> [12660.206000] Workqueue: btrfs-endio-write btrfs_endio_write_helper
> [12660.206035]  ffff8803ad30fb18 0000000000000002 ffff8803ad30fa78
> ffff8803b3123020
> [12660.206117]  ffff8803ad30ffd8 0000000000004000 ffff8800b1a00000
> ffff8803b3123020
> [12660.206183]  ffff88035d346000 0000000000000000 ffff8803ad30fa78
> ffff8800927a6940
> [12660.206244] Call Trace:
> [12660.206277]  [<ffffffff8137c1aa>] ? btrfs_leaf_free_space+0x5a/0xc0
> [12660[12772.061906] BTRFS info (device sda2): The free space cache
> file (914857394176) is invalid. skip it
> [12772.061906]
> [12772.113733] BTRFS info (device sda2): The free space cache file
> (1032968994816) is invalid. skip it
> [12772.113733]
> [17981.856115] perf interrupt took too long (4994 > 4960), lowering
> kernel.perf_event_max_sample_rate to 25200
> [27826.446614] EXT4-fs (md0): mounting ext3 file system using the ext4 subsystem
> [27826.580071] EXT4-fs (md0): mounted filesystem with ordered data
> mode. Opts: (null)
> [50418.016235] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000018
> [50418.016321] IP: [<ffffffff8149e080>] swiotlb_unmap_sg_attrs+0x30/0x70
> [50418.016368] PGD 1f5dd4067 PUD 346dd3067 PMD 0
> [50418.016403] Oops: 0000 [#1] SMP
> [50418.016435] Modules linked in: cpuid nf_conntrack_ipv4
> nf_defrag_ipv4 xt_conntrack nf_conntrack serio_raw microcode
> [50418.016512] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G          I
> 3.17.0-rc7-backup5001 #11
> [50418.016567] Hardware name: empty empty/S5393, BIOS V1.05 04/24/2009
> [50418.016601] task: ffff880429568000 t[    0.000000] Initializing
> cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Initializing cgroup subsys cpuacct
>
>
> Anything I can due to narrow down the problem ?
>
>
> Thanks
> Kui.Z
