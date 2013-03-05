Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3CETgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:36:54 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:51838 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3CETgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:36:52 -0500
MIME-Version: 1.0
Date: Tue, 5 Mar 2013 14:36:50 -0500
X-Google-Sender-Auth: yYUEYgsNw4ZEcZp4aWZ_jp7BerM
Message-ID: <CAKb7Uvis1_Rs3nTbq6F8+b2FM0wZLmvV+Qb76a4wSkLWyd35PA@mail.gmail.com>
Subject: nouveau bug in 3.7.9 -- unable to handle kernel paging request
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While using chrome, I got the following. It was able to render the bug
to the screen, so at least something was working (and it also made it
to my logs).

[223614.867297] BUG: unable to handle kernel paging request at ffffc90013a00000
[223614.867372] IP: [<ffffffff812eaf98>] iowrite32+0x12/0x33
[223614.867427] PGD 1a880e067 PUD 1a880f067 PMD 1a2ccf067 PTE 0
[223614.867488] Oops: 0002 [#1] SMP
[223614.867523] Modules linked in: it87 hwmon_vid bridge stp llc
usb_storage nouveau fbcon cfbfillrect cfbimgblt cfbcopyarea bitblit
i2c_algo_bit mxm_wmi softcursor font ttm btusb bluetooth
drm_kms_helper crc16 drm backlight fb fbdev wmi
[223614.867781] CPU 0
[223614.867804] Pid: 18237, comm: chrome Not tainted 3.7.9-gentoo #1
Gigabyte Technology Co., Ltd. EX58-UD3R/EX58-UD3R
[223614.867892] RIP: 0010:[<ffffffff812eaf98>]  [<ffffffff812eaf98>]
iowrite32+0x12/0x33
[223614.867963] RSP: 0018:ffff8800878eb9a8  EFLAGS: 00010292
[223614.868010] RAX: 0000000000000000 RBX: ffff8801252b5180 RCX:
ffff880071b26d20
[223614.868071] RDX: 0000000000000000 RSI: ffffc90013a00000 RDI:
ffffc90013a00000
[223614.868131] RBP: ffff8800878eb9a8 R08: 0000000000000001 R09:
000000000000fffe
[223614.868192] R10: 0000000000000001 R11: ffff8801a3d87f00 R12:
0000000000000000
[223614.868252] R13: 0000000000005004 R14: ffff8801a7395b00 R15:
000000003dde2000
[223614.868314] FS:  00007f34c3bed900(0000) GS:ffff8801afc00000(0000)
knlGS:0000000000000000
[223614.868382] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[223614.868432] CR2: ffffc90013a00000 CR3: 0000000096e04000 CR4:
00000000000007f0
[223614.868493] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[223614.868554] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[223614.868615] Process chrome (pid: 18237, threadinfo
ffff8800878ea000, task ffff880171f8b4f0)
[223614.868684] Stack:
[223614.868704]  ffff8800878eb9b8 ffffffffa014638e ffff8800878eb9c8
ffffffffa0143939
[223614.868779]  ffff8800878eba38 ffffffffa0143bff 00000000000000d0
ffffffffa01d67e0
[223614.868853]  ffff8801a3d87f00 0000000000000000 ffff880071b26d20
0000000000000000
[223614.868927] Call Trace:
[223614.868969]  [<ffffffffa014638e>] nouveau_barobj_wr32+0x16/0x18 [nouveau]
[223614.869039]  [<ffffffffa0143939>] _nouveau_gpuobj_wr32+0x26/0x28 [nouveau]
[223614.869108]  [<ffffffffa0143bff>]
nouveau_gpuobj_create_+0x1fe/0x243 [nouveau]
[223614.869181]  [<ffffffffa0143c81>] _nouveau_gpuobj_ctor+0x3d/0x4b [nouveau]
[223614.869252]  [<ffffffffa0144fb3>] nouveau_object_ctor+0x2b/0x9f [nouveau]
[223614.869322]  [<ffffffffa0143cdd>] nouveau_gpuobj_new+0x4e/0x50 [nouveau]
[223614.869401]  [<ffffffffa015c570>] nouveau_vm_get+0x161/0x26c [nouveau]
[223614.869488]  [<ffffffffa019c26c>] nouveau_bo_vma_add+0x43/0xc2 [nouveau]
[223614.869574]  [<ffffffffa0197e4e>] nouveau_channel_prep+0x156/0x26c [nouveau]
[223614.869664]  [<ffffffffa0197f9d>] nouveau_channel_new+0x39/0x570 [nouveau]
[223614.869753]  [<ffffffffa019df6e>] ? kzalloc.constprop.2+0xe/0x10 [nouveau]
[223614.869842]  [<ffffffffa019e459>]
nouveau_abi16_ioctl_channel_alloc+0x1b4/0x2f4 [nouveau]
[223614.869915]  [<ffffffff8108e607>] ? should_resched+0x9/0x28
[223614.869966]  [<ffffffff8169f1e7>] ? _cond_resched+0xe/0x22
[223614.870024]  [<ffffffffa00237dd>] drm_ioctl+0x2d7/0x39e [drm]
[223614.870105]  [<ffffffffa019e2a5>] ?
nouveau_abi16_ioctl_setparam+0x10/0x10 [nouveau]
[223614.870173]  [<ffffffff814f55a4>] ? fput_light+0xd/0xf
[223614.870220]  [<ffffffff814f8498>] ? sys_recvfrom+0xe1/0xf7
[223614.870270]  [<ffffffff8114578e>] do_vfs_ioctl+0x452/0x493
[223614.870320]  [<ffffffff8114d3bb>] ? fget_light+0x69/0x80
[223614.870368]  [<ffffffff8113948a>] ? fput+0x18/0xb6
[223614.870412]  [<ffffffff8114581b>] sys_ioctl+0x4c/0x71
[223614.870460]  [<ffffffff816a6a9d>] system_call_fastpath+0x1a/0x1f
[223614.870511] Code: eb 15 48 81 fe 00 00 01 00 77 0c 48 c7 c6 27 ed
a4 81 e8 9c ff ff ff 5d c3 55 48 81 fe ff ff 03 00 89 f8 48 89 e5 48
89 f7 76 04 <89> 06 eb 1b 48 81 fe 00 00 01 00 76 06 0f b7 d6 ef eb 0c
48 c7

(gdb) disassemble iowrite32
Dump of assembler code for function iowrite32:
   0xffffffff812eaf86 <+0>:     push   %rbp
   0xffffffff812eaf87 <+1>:     cmp    $0x3ffff,%rsi
   0xffffffff812eaf8e <+8>:     mov    %edi,%eax
   0xffffffff812eaf90 <+10>:    mov    %rsp,%rbp
   0xffffffff812eaf93 <+13>:    mov    %rsi,%rdi
   0xffffffff812eaf96 <+16>:    jbe    0xffffffff812eaf9c <iowrite32+22>
   0xffffffff812eaf98 <+18>:    mov    %eax,(%rsi)  <--- faulting instruction
   0xffffffff812eaf9a <+20>:    jmp    0xffffffff812eafb7 <iowrite32+49>
   0xffffffff812eaf9c <+22>:    cmp    $0x10000,%rsi
   0xffffffff812eafa3 <+29>:    jbe    0xffffffff812eafab <iowrite32+37>
   0xffffffff812eafa5 <+31>:    movzwl %si,%edx
   0xffffffff812eafa8 <+34>:    out    %eax,(%dx)
   0xffffffff812eafa9 <+35>:    jmp    0xffffffff812eafb7 <iowrite32+49>
   0xffffffff812eafab <+37>:    mov    $0xffffffff81a70d6c,%rsi
   0xffffffff812eafb2 <+44>:    callq  0xffffffff812eaf20 <bad_io_access>
   0xffffffff812eafb7 <+49>:    pop    %rbp
   0xffffffff812eafb8 <+50>:    retq

I have the following hardware:
02:00.0 VGA compatible controller [0300]: NVIDIA Corporation G96
[GeForce 9500 GT] [10de:0640] (rev a1) (prog-if 00 [VGA controller])
        Subsystem: Device [196e:0643]
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at f8000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 3: Memory at f6000000 (64-bit, non-prefetchable) [size=32M]
        Region 5: I/O ports at ef00 [size=128]
        [virtual] Expansion ROM at f9000000 [disabled] [size=512K]
        Capabilities: [60] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
                Address: 0000000000000000  Data: 0000
        Capabilities: [78] Express (v1) Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s
<512ns, L1 <4us
                        ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal-
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq-
AuxPwr- TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x16, ASPM L0s
L1, Latency L0 <512ns, L1 <1us
                        ClockPM- Surprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x16, TrErr- Train-
SlotClk+ DLActive- BWMgmt- ABWMgmt-
        Capabilities: [b4] Vendor Specific Information: Len=14 <?>
        Capabilities: [100 v1] Virtual Channel
                Caps:   LPEVC=0 RefClk=100ns PATEntryBits=1
                Arb:    Fixed- WRR32- WRR64- WRR128-
                Ctrl:   ArbSelect=Fixed
                Status: InProgress-
                VC0:    Caps:   PATOffset=00 MaxTimeSlots=1 RejSnoopTrans-
                        Arb:    Fixed- WRR32- WRR64- WRR128- TWRR128- WRR256-
                        Ctrl:   Enable+ ID=0 ArbSelect=Fixed TC/VC=ff
                        Status: NegoPending- InProgress-
        Capabilities: [128 v1] Power Budgeting <?>
        Capabilities: [600 v1] Vendor Specific Information: ID=0001
Rev=1 Len=024 <?>
        Kernel driver in use: nouveau

Note sure what else would be useful... just throwing in some things
that I think could be relevant, from my currently running system:

cat /proc/mtrr
reg00: base=0x000000000 (    0MB), size= 4096MB, count=1: write-back
reg01: base=0x0e0000000 ( 3584MB), size=  512MB, count=1: uncachable
reg02: base=0x0d0000000 ( 3328MB), size=  256MB, count=1: uncachable
reg03: base=0x100000000 ( 4096MB), size= 4096MB, count=1: write-back
reg04: base=0x1c0000000 ( 7168MB), size= 1024MB, count=1: uncachable
reg05: base=0x1b0000000 ( 6912MB), size=  256MB, count=1: uncachable

[    4.055915] nouveau  [  DEVICE][0000:02:00.0] BOOT0  : 0x096000c1
[    4.055918] nouveau  [  DEVICE][0000:02:00.0] Chipset: G96 (NV96)
[    4.055920] nouveau  [  DEVICE][0000:02:00.0] Family : NV50
[    4.056926] nouveau  [   VBIOS][0000:02:00.0] checking PRAMIN for image...
[    4.115127] nouveau  [   VBIOS][0000:02:00.0] ... appears to be valid
[    4.115130] nouveau  [   VBIOS][0000:02:00.0] using image from PRAMIN
[    4.115282] nouveau  [   VBIOS][0000:02:00.0] BIT signature found
[    4.115284] nouveau  [   VBIOS][0000:02:00.0] version 62.94.2a.00
[    4.135865] nouveau  [     MXM][0000:02:00.0] no VBIOS data, nothing to do
[    4.135886] nouveau  [     PFB][0000:02:00.0] RAM type: DDR2
[    4.135890] nouveau  [     PFB][0000:02:00.0] RAM size: 1024 MiB
[    4.160519] [TTM] Zone  kernel: Available graphics memory: 3050224 kiB
[    4.160521] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.160523] [TTM] Initializing pool allocator
[    4.160526] [TTM] Initializing DMA pool allocator
[    4.160538] mtrr: type mismatch for d0000000,10000000 old:
write-back new: write-combining
[    4.160540] nouveau  [     DRM] VRAM: 1024 MiB
[    4.160542] nouveau  [     DRM] GART: 512 MiB
[    4.160545] nouveau  [     DRM] BIT BIOS found
[    4.160547] nouveau  [     DRM] Bios version 62.94.2a.00
[    4.160550] nouveau  [     DRM] TMDS table version 2.0
[    4.160551] nouveau  [     DRM] DCB version 4.0
[    4.160554] nouveau  [     DRM] DCB outp 00: 02000300 00000028
[    4.160556] nouveau  [     DRM] DCB outp 01: 01000302 00020030
[    4.160557] nouveau  [     DRM] DCB outp 02: 04011310 00000028
[    4.160559] nouveau  [     DRM] DCB outp 03: 02011312 00020030
[    4.160561] nouveau  [     DRM] DCB conn 00: 00001030
[    4.160563] nouveau  [     DRM] DCB conn 01: 00002130
[    4.201147] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    4.201150] [drm] No driver support for vblank timestamp query.
[    4.228875] nouveau  [     DRM] 1 available performance level(s)
[    4.228880] nouveau  [     DRM] 3: core 550MHz shader 1375MHz
memory 400MHz fanspeed 100%
[    4.228884] nouveau  [     DRM] c: core 400MHz shader 800MHz memory
499MHz fanspeed 100%
[    4.523097] nouveau  [     DRM] MM: using CRYPT for buffer copies
[    4.619088] nouveau  [     DRM] allocated 1920x1200 fb: 0x70000, bo
ffff8801a734b800
[    4.619160] fbcon: nouveaufb (fb0) is primary device
[    4.643874] Console: switching to colour frame buffer device 240x75
[    4.646756] fb0: nouveaufb frame buffer device
[    4.646759] drm: registered panic notifier
[    4.646775] [drm] Initialized nouveau 1.1.0 20120801 for
0000:02:00.0 on minor 0

[IP-] [  ] www-client/chromium-25.0.1364.97:0
[I-O] [  ] media-libs/mesa-9.0.1:0
[IP-] [  ] x11-drivers/xf86-video-nouveau-1.0.4:0

Let me know if there's anything else that would be useful. This has
only happened once so far. FWIW I run chrome with
--ignore-gpu-blacklist.
