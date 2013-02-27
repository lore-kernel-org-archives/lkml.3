Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620Ab3B0MXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 07:23:16 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60046 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755151Ab3B0MXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 07:23:13 -0500
Date: Wed, 27 Feb 2013 13:23:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sedat Dilek <sedat.dilek@gmail.com>, Tejun Heo <tj@kernel.org>
Cc: Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-watchdog@vger.kernel.org,
        x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [next-20130227] kernel NULL pointer dereference [ watchdog |
 perf related ? ]
Message-ID: <20130227122302.GA5678@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sedat Dilek <sedat.dilek@gmail.com>, Tejun Heo <tj@kernel.org>,
	Wim Van Sebroeck <wim@iguana.be>, Ingo Molnar <mingo@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-watchdog@vger.kernel.org, x86@kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	linux-next <linux-next@vger.kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Andrew Morton <akpm@linux-foundation.org>
References: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 12:13:07PM +0100, Sedat Dilek wrote:
> Hi,
> 
> I have reported this issue several times (first for next-20130223) to
> LKML and Linux-Next MLs but got no answer.
> I am unsure which is the root cause for all this trouble.
> 
> Can someone have a look at this, please?
> 
> [    0.065787] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz
> (fam: 06, model: 2a, stepping: 07)
> [    0.065799] TSC deadline timer enabled
> [    0.065811] Performance Events: PEBS fmt1+, 16-deep LBR,
> SandyBridge events, Intel PMU driver.
> [    0.065822] ... version:                3
> [    0.065824] ... bit width:              48
> [    0.065826] ... generic registers:      4
> [    0.065829] ... value mask:             0000ffffffffffff
> [    0.065831] ... max period:             000000007fffffff
> [    0.065834] ... fixed-purpose events:   3
> [    0.065836] ... event mask:             000000070000000f
> [    0.066888] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [    0.066894] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.066900] PGD 0
> [    0.066903] Oops: 0000 [#1] SMP
> [    0.066906] Modules linked in:
> [    0.066908] CPU 0
> [    0.066912] Pid: 11, comm: watchdog/0 Not tainted
> 3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD.
> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> [    0.066918] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>]
> perf_init_event+0x32/0x100
> [    0.066924] RSP: 0000:ffff880119b59d58  EFLAGS: 00010246
> [    0.066927] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
> [    0.066930] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
> [    0.066933] RBP: ffff880119b59d88 R08: ffff88011fa16fa0 R09: ffffffff810ec0e0
> [    0.066936] R10: ffff88011b012000 R11: 0000000000000000 R12: ffff88011b012000
> [    0.066939] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88011b012000
> [    0.066942] FS:  0000000000000000(0000) GS:ffff88011fa00000(0000)
> knlGS:0000000000000000
> [    0.066946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.066949] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407f0
> [    0.066952] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.066955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.066959] Process watchdog/0 (pid: 11, threadinfo
> ffff880119b58000, task ffff880119b50000)
> [    0.066962] Stack:
> [    0.066964]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000
> ffffffff81c4d760
> [    0.066970]  ffff88011b012000 0000000000000000 ffff880119b59de8
> ffffffff8112a6b8
> [    0.066975]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0
> 0000000000000000
> [    0.066980] Call Trace:
> [    0.066985]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
> [    0.066990]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
> [    0.066995]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
> [    0.066999]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
> [    0.067004]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
> [    0.067009]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
> [    0.067013]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
> [    0.067017]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.067021]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
> [    0.067025]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.067027] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18
> e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00
> 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3
> 48 85
> [    0.067063] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.067067]  RSP <ffff880119b59d58>
> [    0.067069] CR2: 0000000000000000
> [    0.067077] ---[ end trace 3cbbfd94f0f8f035 ]---

Hmm, let's see. Your .config triggers in kvm too, so this is easy to debug:

[ 0.171544] Code: 54 49 89 fc 48 c7 c7 20 7e f5 81 53 48 83 ec 18 e8 74 a9 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 22 f7 e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 e0 7d f5 81 e8 1e 9a 22 00 48 89 c3 48 85 
All code
========
   0:   54                      push   %rsp
   1:   49 89 fc                mov    %rdi,%r12
   4:   48 c7 c7 20 7e f5 81    mov    $0xffffffff81f57e20,%rdi
   b:   53                      push   %rbx
   c:   48 83 ec 18             sub    $0x18,%rsp
  10:   e8 74 a9 f5 ff          callq  0xfffffffffff5a989
  15:   41 8b b4 24 a0 00 00    mov    0xa0(%r12),%esi
  1c:   00 
  1d:   41 89 c5                mov    %eax,%r13d
  20:   48 8b 05 22 f7 e2 00    mov    0xe2f722(%rip),%rax        # 0xe2f749
  27:   89 f2                   mov    %esi,%edx
  29:   30 d2                   xor    %dl,%dl
  2b:*  3b 10                   cmp    (%rax),%edx     <-- trapping instruction
  2d:   74 4a                   je     0x79
  2f:   48 c7 c7 e0 7d f5 81    mov    $0xffffffff81f57de0,%rdi
  36:   e8 1e 9a 22 00          callq  0x229a59
  3b:   48 89 c3                mov    %rax,%rbx
  3e:   48 85 00                test   %rax,(%rax)

struct pmu *perf_init_event(struct perf_event *event)
{
        struct pmu *pmu = NULL;
        int idx;
        int ret;

        idx = srcu_read_lock(&pmus_srcu);

        rcu_read_lock();
        pmu = idr_find(&pmu_idr, event->attr.type);

...

static inline void *idr_find(struct idr *idr, int id)
{
	struct idr_layer *hint = rcu_dereference_raw(idr->hint);
    86d7:	48 8b 05 00 00 00 00 	mov    0x0(%rip),%rax        # 86de <perf_init_event+0x2e>
			86da: R_X86_64_PC32	.bss+0xfc

	if ((id & ~IDR_MASK) == hint->prefix)
    86de:	89 f2                	mov    %esi,%edx
    86e0:	30 d2                	xor    %dl,%dl
    86e2:	3b 10                	cmp    (%rax),%edx		<--- trapping insn
    86e4:	74 4a                	je     8730 <perf_init_event+0x80>
		return rcu_dereference_raw(hint->ary[id & IDR_MASK]);


So 'hint' is NULL as RAX above confirms and we're not supposed to deref
NULL things.

Looking at 29cf29e1fbb875019713eb55cf27ec35f1e5fa5e, Tejun should
probably know. CCed.

Leaving in the rest for reference.

> Full dmesg and my kernel-config are attached!
> 
> Regards,
> - Sedat -
> 
> [1] http://marc.info/?l=linux-next&m=136187160914695&w=2

> [    0.000000] Initializing cgroup subsys cpuset
> [    0.000000] Initializing cgroup subsys cpu
> [    0.000000] Linux version 3.8.0-next20130227-1-iniza-small (sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Wed Feb 27 11:46:38 CET 2013
> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next20130227-1-iniza-small root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
> [    0.000000] KERNEL supported cpus:
> [    0.000000]   Intel GenuineIntel
> [    0.000000]   AMD AuthenticAMD
> [    0.000000]   Centaur CentaurHauls
> [    0.000000] Disabled fast string operations
> [    0.000000] e820: BIOS-provided physical RAM map:
> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
> [    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000d9c9efff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000d9c9f000-0x00000000dae7efff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000dae7f000-0x00000000daf9efff] ACPI NVS
> [    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
> [    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
> [    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
> [    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fdfffff] usable
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] SMBIOS 2.6 present.
> [    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 12XK 01/18/2013
> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
> [    0.000000] No AGP bridge found
> [    0.000000] e820: last_pfn = 0x11fe00 max_arch_pfn = 0x400000000
> [    0.000000] MTRR default type: uncachable
> [    0.000000] MTRR fixed ranges enabled:
> [    0.000000]   00000-9FFFF write-back
> [    0.000000]   A0000-BFFFF uncachable
> [    0.000000]   C0000-FFFFF write-protect
> [    0.000000] MTRR variable ranges enabled:
> [    0.000000]   0 base 000000000 mask F80000000 write-back
> [    0.000000]   1 base 080000000 mask FC0000000 write-back
> [    0.000000]   2 base 0C0000000 mask FE0000000 write-back
> [    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
> [    0.000000]   4 base 0DB000000 mask FFF000000 uncachable
> [    0.000000]   5 base 100000000 mask FE0000000 write-back
> [    0.000000]   6 base 11FE00000 mask FFFE00000 uncachable
> [    0.000000]   7 base 0FFC00000 mask FFFC00000 write-protect
> [    0.000000]   8 disabled
> [    0.000000]   9 disabled
> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
> [    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
> [    0.000000] found SMP MP-table at [mem 0x000f00e0-0x000f00ef] mapped at [ffff8800000f00e0]
> [    0.000000] Scanning 1 areas for low memory corruption
> [    0.000000] ACPI: RSDP 00000000000f0100 00024 (v02 SECCSD)
> [    0.000000] ACPI: XSDT 00000000daffe170 0008C (v01 SECCSD LH43STAR 00000002 PTEC 00000002)
> [    0.000000] ACPI: FACP 00000000dafef000 0010C (v05 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: DSDT 00000000daff2000 083AC (v02 SECCSD  SNB-CPT 00000000 INTL 20061109)
> [    0.000000] ACPI: FACS 00000000daf47000 00040
> [    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 SECCSD LH43STAR 00000002 PTEC 00000001)
> [    0.000000] ACPI: SSDT 00000000daffb000 01068 (v01 SECCSD PtidDevc 00001000 INTL 20061109)
> [    0.000000] ACPI: ASF! 00000000daff1000 000A5 (v32 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: HPET 00000000dafee000 00038 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: APIC 00000000dafed000 00098 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: MCFG 00000000dafec000 0003C (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: SSDT 00000000dafeb000 00804 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
> [    0.000000] ACPI: SSDT 00000000dafea000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
> [    0.000000] ACPI: UEFI 00000000dafe9000 0003E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: UEFI 00000000dafe8000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
> [    0.000000] ACPI: UEFI 00000000dafe7000 0026A (v01 SECCSD LH43STAR 00000002 PTL  00000002)
> [    0.000000] ACPI: SSDT 00000000dafe6000 000D0 (v01   Iffs  IffsAsl 00003000 INTL 20061109)
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
> [    0.000000] reserving inaccessible SNB gfx pages
> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
> [    0.000000] BRK [0x01f8b000, 0x01f8bfff] PGTABLE
> [    0.000000] BRK [0x01f8c000, 0x01f8cfff] PGTABLE
> [    0.000000] BRK [0x01f8d000, 0x01f8dfff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x11fc00000-0x11fdfffff]
> [    0.000000]  [mem 0x11fc00000-0x11fdfffff] page 2M
> [    0.000000] BRK [0x01f8e000, 0x01f8efff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fbfffff]
> [    0.000000]  [mem 0x11c000000-0x11fbfffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
> [    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
> [    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
> [    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
> [    0.000000] init_memory_mapping: [mem 0x40200000-0xd9c9efff]
> [    0.000000]  [mem 0x40200000-0xd9bfffff] page 2M
> [    0.000000]  [mem 0xd9c00000-0xd9c9efff] page 4k
> [    0.000000] BRK [0x01f8f000, 0x01f8ffff] PGTABLE
> [    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
> [    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
> [    0.000000] RAMDISK: [mem 0x379ae000-0x37ccefff]
> [    0.000000] No NUMA configuration found
> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fdfffff]
> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fdfffff]
> [    0.000000]   NODE_DATA [mem 0x11fdf8000-0x11fdfbfff]
> [    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b400000-ffff88011f3fffff] on node 0
> [    0.000000] Zone ranges:
> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
> [    0.000000]   Normal   [mem 0x100000000-0x11fdfffff]
> [    0.000000] Movable zone start for each node
> [    0.000000] Early memory node ranges
> [    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
> [    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
> [    0.000000]   node   0: [mem 0x40200000-0xd9c9efff]
> [    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
> [    0.000000]   node   0: [mem 0x100000000-0x11fdfffff]
> [    0.000000] On node 0 totalpages: 1021500
> [    0.000000]   DMA zone: 64 pages used for memmap
> [    0.000000]   DMA zone: 156 pages reserved
> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
> [    0.000000]   DMA32 zone: 13859 pages used for memmap
> [    0.000000]   DMA32 zone: 886944 pages, LIFO batch:31
> [    0.000000]   Normal zone: 2040 pages used for memmap
> [    0.000000]   Normal zone: 130560 pages, LIFO batch:31
> [    0.000000] ACPI: PM-Timer IO Port: 0x408
> [    0.000000] ACPI: Local APIC address 0xfee00000
> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
> [    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> [    0.000000] ACPI: IRQ0 used by override.
> [    0.000000] ACPI: IRQ2 used by override.
> [    0.000000] ACPI: IRQ9 used by override.
> [    0.000000] Using ACPI (MADT) for SMP configuration information
> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 40
> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
> [    0.000000] PM: Registered nosave memory: 00000000d9c9f000 - 00000000dae7f000
> [    0.000000] PM: Registered nosave memory: 00000000dae7f000 - 00000000daf9f000
> [    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
> [    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
> [    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
> [    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
> [    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
> [    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
> [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
> [    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
> [    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
> [    0.000000] Booting paravirtualized kernel on bare hardware
> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011fa00000 s85568 r8192 d20928 u262144
> [    0.000000] pcpu-alloc: s85568 r8192 d20928 u262144 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1005381
> [    0.000000] Policy zone: Normal
> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next20130227-1-iniza-small root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
> [    0.000000] __ex_table already sorted, skipping sort
> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
> [    0.000000] Checking aperture...
> [    0.000000] No AGP bridge found
> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> [    0.000000] Memory: 3933468k/4716544k available (6977k kernel code, 630544k absent, 152532k reserved, 6273k data, 1252k init)
> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
> [    0.000000] Hierarchical RCU implementation.
> [    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
> [    0.000000] 	RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
> [    0.000000] NR_IRQS:16640 nr_irqs:744 16
> [    0.000000] Console: colour dummy device 80x25
> [    0.000000] console [tty0] enabled
> [    0.000000] allocated 16777216 bytes of page_cgroup
> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
> [    0.000000] hpet clockevent registered
> [    0.000000] tsc: Fast TSC calibration using PIT
> [    0.004000] tsc: Detected 1596.469 MHz processor
> [    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.93 BogoMIPS (lpj=6385876)
> [    0.000009] pid_max: default: 32768 minimum: 301
> [    0.000036] Security Framework initialized
> [    0.000050] AppArmor: AppArmor initialized
> [    0.000053] Yama: becoming mindful.
> [    0.000397] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
> [    0.001450] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
> [    0.001899] Mount-cache hash table entries: 256
> [    0.002097] Initializing cgroup subsys cpuacct
> [    0.002102] Initializing cgroup subsys memory
> [    0.002112] Initializing cgroup subsys devices
> [    0.002115] Initializing cgroup subsys freezer
> [    0.002118] Initializing cgroup subsys blkio
> [    0.002121] Initializing cgroup subsys perf_event
> [    0.002126] Initializing cgroup subsys hugetlb
> [    0.002154] Disabled fast string operations
> [    0.002158] CPU: Physical Processor ID: 0
> [    0.002160] CPU: Processor Core ID: 0
> [    0.002166] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [    0.002166] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
> [    0.002174] mce: CPU supports 7 MCE banks
> [    0.002188] CPU0: Thermal monitoring enabled (TM1)
> [    0.002198] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
> [    0.002198] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
> [    0.002198] tlb_flushall_shift: 5
> [    0.002294] Freeing SMP alternatives: 24k freed
> [    0.004519] ACPI: Core revision 20130117
> [    0.009991] ACPI: All ACPI Tables successfully acquired
> [    0.011561] ftrace: allocating 26138 entries in 103 pages
> [    0.026124] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
> [    0.065787] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz (fam: 06, model: 2a, stepping: 07)
> [    0.065799] TSC deadline timer enabled
> [    0.065811] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
> [    0.065822] ... version:                3
> [    0.065824] ... bit width:              48
> [    0.065826] ... generic registers:      4
> [    0.065829] ... value mask:             0000ffffffffffff
> [    0.065831] ... max period:             000000007fffffff
> [    0.065834] ... fixed-purpose events:   3
> [    0.065836] ... event mask:             000000070000000f
> [    0.066888] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.066894] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.066900] PGD 0 
> [    0.066903] Oops: 0000 [#1] SMP 
> [    0.066906] Modules linked in:
> [    0.066908] CPU 0 
> [    0.066912] Pid: 11, comm: watchdog/0 Not tainted 3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> [    0.066918] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.066924] RSP: 0000:ffff880119b59d58  EFLAGS: 00010246
> [    0.066927] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
> [    0.066930] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
> [    0.066933] RBP: ffff880119b59d88 R08: ffff88011fa16fa0 R09: ffffffff810ec0e0
> [    0.066936] R10: ffff88011b012000 R11: 0000000000000000 R12: ffff88011b012000
> [    0.066939] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88011b012000
> [    0.066942] FS:  0000000000000000(0000) GS:ffff88011fa00000(0000) knlGS:0000000000000000
> [    0.066946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.066949] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407f0
> [    0.066952] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.066955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.066959] Process watchdog/0 (pid: 11, threadinfo ffff880119b58000, task ffff880119b50000)
> [    0.066962] Stack:
> [    0.066964]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000 ffffffff81c4d760
> [    0.066970]  ffff88011b012000 0000000000000000 ffff880119b59de8 ffffffff8112a6b8
> [    0.066975]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
> [    0.066980] Call Trace:
> [    0.066985]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
> [    0.066990]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
> [    0.066995]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
> [    0.066999]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
> [    0.067004]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
> [    0.067009]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
> [    0.067013]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
> [    0.067017]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.067021]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
> [    0.067025]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.067027] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85 
> [    0.067063] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.067067]  RSP <ffff880119b59d58>
> [    0.067069] CR2: 0000000000000000
> [    0.067077] ---[ end trace 3cbbfd94f0f8f035 ]---
> [    0.078194] Disabled fast string operations
> [    0.067160] smpboot: Booting Node   0, Processors  #1
> [    0.080316] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.080332] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.080342] PGD 0 
> [    0.080347] Oops: 0000 [#2] SMP 
> [    0.080352] Modules linked in:
> [    0.080357] CPU 1 
> [    0.080363] Pid: 12, comm: watchdog/1 Tainted: G      D      3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> [    0.080374] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.080383] RSP: 0000:ffff880119b79d58  EFLAGS: 00010246
> [    0.080388] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
> [    0.080394] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
> [    0.080399] RBP: ffff880119b79d88 R08: 0000000000000000 R09: ffffffff810ec0e0
> [    0.080405] R10: ffff880119b98000 R11: 0000000000017480 R12: ffff880119b98000
> [    0.080411] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880119b98000
> [    0.080417] FS:  0000000000000000(0000) GS:ffff88011fa40000(0000) knlGS:0000000000000000
> [    0.080424] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.080428] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407e0
> [    0.080433] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.080438] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.080442] Process watchdog/1 (pid: 12, threadinfo ffff880119b78000, task ffff880119b6c590)
> [    0.080448] Stack:
> [    0.080451]  #2
> [    0.080451]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000 ffffffff81c4d760
> [    0.080461]  ffff880119b98000 0000000000000001 ffff880119b79de8 ffffffff8112a6b8
> [    0.080469]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
> [    0.080476] Call Trace:
> [    0.080483]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
> [    0.080490]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
> [    0.080497]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
> [    0.080503]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
> [    0.080511]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
> [    0.080517]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
> [    0.080523]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
> [    0.080529]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.080536]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
> [    0.080541]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.080546] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85 
> [    0.080598] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.080604]  RSP <ffff880119b79d58>
> [    0.080607] CR2: 0000000000000000
> [    0.080612] ---[ end trace 3cbbfd94f0f8f036 ]---
> [    0.091468] Disabled fast string operations
> [    0.093591] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.093605] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.093613] PGD 0 
> [    0.093616] Oops: 0000 [#3] SMP 
> [    0.093619] Modules linked in:
> [    0.093621] CPU 2 
> [    0.093625] Pid: 17, comm: watchdog/2 Tainted: G      D      3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> [    0.093632] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.093638] RSP: 0000:ffff880119b93d58  EFLAGS: 00010246
> [    0.093641] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
> [    0.093644] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
> [    0.093647] RBP: ffff880119b93d88 R08: 0000000000000000 R09: ffffffff810ec0e0
> [    0.093650] R10: ffff880119be0000 R11: 0000000000017480 R12: ffff880119be0000
> [    0.093653] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880119be0000
> [    0.093656] FS:  0000000000000000(0000) GS:ffff88011fa80000(0000) knlGS:0000000000000000
> [    0.093660] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.093663] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407e0
> [    0.093666] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.093669] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.093673] Process watchdog/2 (pid: 17, threadinfo ffff880119b92000, task ffff880119b84590)
> [    0.093676] Stack:
> [    0.093678]  ffff88011fa141b0 ffffffff81c4d760
> [    0.093680]  #3 0000000000000000 ffffffff81c4d760
> [    0.093686]  ffff880119be0000 0000000000000002 ffff880119b93de8 ffffffff8112a6b8
> [    0.093691]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
> [    0.093697] Call Trace:
> [    0.093702]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
> [    0.093707]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
> [    0.093712]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
> [    0.093716]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
> [    0.093722]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
> [    0.093727]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
> [    0.093731]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
> [    0.093735]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.093740]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
> [    0.093743]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.093746] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85 
> [    0.093782] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.093786]  RSP <ffff880119b93d58>
> [    0.093788] CR2: 0000000000000000
> [    0.093792] ---[ end trace 3cbbfd94f0f8f037 ]---
> [    0.104707] Disabled fast string operations
> [    0.106818] Brought up 4 CPUs
> [    0.106827] smpboot: Total of 4 processors activated (12771.75 BogoMIPS)
> [    0.106830] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.106835] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.106837] PGD 0 
> [    0.106839] Oops: 0000 [#4] SMP 
> [    0.106840] Modules linked in:
> [    0.106844] CPU 3 
> [    0.106844] Pid: 22, comm: watchdog/3 Tainted: G      D      3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
> [    0.106847] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.106849] RSP: 0000:ffff880119bddd58  EFLAGS: 00010246
> [    0.106849] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
> [    0.106850] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
> [    0.106851] RBP: ffff880119bddd88 R08: 0000000000000000 R09: ffffffff810ec0e0
> [    0.106851] R10: ffff880119410000 R11: 0000000000017480 R12: ffff880119410000
> [    0.106852] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880119410000
> [    0.106853] FS:  0000000000000000(0000) GS:ffff88011fac0000(0000) knlGS:0000000000000000
> [    0.106854] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    0.106855] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407e0
> [    0.106856] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.106857] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.106858] Process watchdog/3 (pid: 22, threadinfo ffff880119bdc000, task ffff880119bac590)
> [    0.106859] Stack:
> [    0.106861]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000 ffffffff81c4d760
> [    0.106863]  ffff880119410000 0000000000000003 ffff880119bddde8 ffffffff8112a6b8
> [    0.106865]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
> [    0.106866] Call Trace:
> [    0.106869]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
> [    0.106872]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
> [    0.106875]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
> [    0.106877]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
> [    0.106881]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
> [    0.106884]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
> [    0.106887]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
> [    0.106889]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.106891]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
> [    0.106893]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
> [    0.106912] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85 
> [    0.106914] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
> [    0.106916]  RSP <ffff880119bddd58>
> [    0.106916] CR2: 0000000000000000
> [    0.106918] ---[ end trace 3cbbfd94f0f8f038 ]---
> [    0.110752] devtmpfs: initialized
> [    0.111643] EVM: security.selinux
> [    0.111646] EVM: security.SMACK64
> [    0.111648] EVM: security.capability
> [    0.111694] PM: Registering ACPI NVS region [mem 0xdae7f000-0xdaf9efff] (1179648 bytes)
> [    0.112433] regulator-dummy: no parameters
> [    0.112485] NET: Registered protocol family 16
> [    0.112600] ACPI: bus type pci registered
> [    0.112662] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
> [    0.112668] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
> [    0.120122] PCI: Using configuration type 1 for base access
> [    0.120981] bio: create slab <bio-0> at 0
> [    0.121070] ACPI: Added _OSI(Module Device)
> [    0.121074] ACPI: Added _OSI(Processor Device)
> [    0.121077] ACPI: Added _OSI(3.0 _SCP Extensions)
> [    0.121080] ACPI: Added _OSI(Processor Aggregator Device)
> [    0.122612] ACPI: EC: Look up EC in DSDT
> [    0.124233] ACPI: Executed 1 blocks of module-level executable AML code
> [    0.126557] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> [    0.128396] ACPI: SSDT 00000000dae70718 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.128804] ACPI: Dynamic OEM Table Load:
> [    0.128808] ACPI: SSDT           (null) 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
> [    0.129079] ACPI: SSDT 00000000dae71a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.129511] ACPI: Dynamic OEM Table Load:
> [    0.129515] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
> [    0.129626] ACPI: SSDT 00000000dae6fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.130021] ACPI: Dynamic OEM Table Load:
> [    0.130025] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
> [    0.131452] ACPI: Interpreter enabled
> [    0.131460] ACPI: (supports S0 S1ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
> [    0.131478]  S3ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20130117/hwxface-568)
> [    0.131488]  S5)
> [    0.131491] ACPI: Using IOAPIC for interrupt routing
> [    0.131529] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
> [    0.137909] ACPI: Power Resource [FN00] (off)
> [    0.137984] ACPI: Power Resource [FN01] (off)
> [    0.138056] ACPI: Power Resource [FN02] (off)
> [    0.138126] ACPI: Power Resource [FN03] (off)
> [    0.138196] ACPI: Power Resource [FN04] (off)
> [    0.138792] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
> [    0.138957] \_SB_.PCI0:_OSC invalid UUID
> [    0.138960] _OSC request data:1 8 1f 
> [    0.139042] \_SB_.PCI0:_OSC invalid UUID
> [    0.139045] _OSC request data:1 1f 1f 
> [    0.139050] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
> [    0.139055] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
> [    0.139486] PCI host bridge to bus 0000:00
> [    0.139491] pci_bus 0000:00: root bus resource [bus 00-3e]
> [    0.139495] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
> [    0.139499] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
> [    0.139502] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
> [    0.139506] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
> [    0.139509] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
> [    0.139520] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
> [    0.139619] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
> [    0.139633] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
> [    0.139642] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
> [    0.139649] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
> [    0.139762] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
> [    0.139789] pci 0000:00:16.0: reg 10: [mem 0xf0705000-0xf070500f 64bit]
> [    0.139876] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
> [    0.139968] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
> [    0.139994] pci 0000:00:1a.0: reg 10: [mem 0xf070a000-0xf070a3ff]
> [    0.140099] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
> [    0.140160] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
> [    0.140180] pci 0000:00:1b.0: reg 10: [mem 0xf0700000-0xf0703fff 64bit]
> [    0.140257] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [    0.140288] pci 0000:00:1b.0: System wakeup disabled by ACPI
> [    0.140324] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
> [    0.140414] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [    0.140447] pci 0000:00:1c.0: System wakeup disabled by ACPI
> [    0.140485] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
> [    0.140573] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
> [    0.140610] pci 0000:00:1c.3: System wakeup disabled by ACPI
> [    0.140646] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
> [    0.140778] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [    0.140863] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
> [    0.140888] pci 0000:00:1d.0: reg 10: [mem 0xf0709000-0xf07093ff]
> [    0.140989] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [    0.141046] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
> [    0.141205] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
> [    0.141228] pci 0000:00:1f.2: reg 10: [io  0x3088-0x308f]
> [    0.141239] pci 0000:00:1f.2: reg 14: [io  0x3094-0x3097]
> [    0.141250] pci 0000:00:1f.2: reg 18: [io  0x3080-0x3087]
> [    0.141261] pci 0000:00:1f.2: reg 1c: [io  0x3090-0x3093]
> [    0.141271] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
> [    0.141282] pci 0000:00:1f.2: reg 24: [mem 0xf0708000-0xf07087ff]
> [    0.141334] pci 0000:00:1f.2: PME# supported from D3hot
> [    0.141398] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
> [    0.141418] pci 0000:00:1f.3: reg 10: [mem 0xf0704000-0xf07040ff 64bit]
> [    0.141442] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
> [    0.141734] pci 0000:01:00.0: [8086:0091] type 00 class 0x028000
> [    0.141916] pci 0000:01:00.0: reg 10: [mem 0xf0600000-0xf0601fff 64bit]
> [    0.142680] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
> [    0.142828] pci 0000:01:00.0: System wakeup disabled by ACPI
> [    0.148170] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.148179] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
> [    0.148326] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
> [    0.148398] pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
> [    0.148521] pci 0000:02:00.0: reg 18: [mem 0xf0404000-0xf0404fff 64bit pref]
> [    0.148598] pci 0000:02:00.0: reg 20: [mem 0xf0400000-0xf0403fff 64bit pref]
> [    0.148935] pci 0000:02:00.0: supports D1 D2
> [    0.148938] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
> [    0.149057] pci 0000:02:00.0: System wakeup disabled by ACPI
> [    0.156090] pci 0000:00:1c.3: PCI bridge to [bus 02]
> [    0.156104] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.156129] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.156271] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
> [    0.156311] pci 0000:03:00.0: reg 10: [mem 0xf0500000-0xf0507fff 64bit]
> [    0.156510] pci 0000:03:00.0: PME# supported from D3hot D3cold
> [    0.164085] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.164104] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
> [    0.164144] ACPI _OSC control for PCIe not granted, disabling ASPM
> [    0.164856] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
> [    0.164917] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.164978] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
> [    0.165036] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
> [    0.165096] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
> [    0.165154] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
> [    0.165214] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
> [    0.165271] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
> [    0.165767] ACPI: Enabled 4 GPEs in block 00 to 3F
> [    0.165776] acpi root: \_SB_.PCI0 notify handler is installed
> [    0.165833] Found 1 acpi root devices
> [    0.165873] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> [    0.166009] ACPI: No dock devices found.
> [    0.166090] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
> [    0.166097] vgaarb: loaded
> [    0.166099] vgaarb: bridge control possible 0000:00:02.0
> [    0.166252] SCSI subsystem initialized
> [    0.166255] ACPI: bus type scsi registered
> [    0.166301] libata version 3.00 loaded.
> [    0.166317] ACPI: bus type usb registered
> [    0.166336] usbcore: registered new interface driver usbfs
> [    0.166345] usbcore: registered new interface driver hub
> [    0.166369] usbcore: registered new device driver usb
> [    0.166452] PCI: Using ACPI for IRQ routing
> [    0.168127] PCI: pci_cache_line_size set to 64 bytes
> [    0.168230] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
> [    0.168234] e820: reserve RAM buffer [mem 0xd9c9f000-0xdbffffff]
> [    0.168237] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
> [    0.168240] e820: reserve RAM buffer [mem 0x11fe00000-0x11fffffff]
> [    0.168323] NetLabel: Initializing
> [    0.168326] NetLabel:  domain hash size = 128
> [    0.168329] NetLabel:  protocols = UNLABELED CIPSOv4
> [    0.168341] NetLabel:  unlabeled traffic allowed by default
> [    0.168395] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [    0.168403] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
> [    0.171416] Switching to clocksource hpet
> [    0.176468] AppArmor: AppArmor Filesystem Enabled
> [    0.176497] pnp: PnP ACPI init
> [    0.176510] ACPI: bus type pnp registered
> [    0.176745] pnp 00:00: [dma 4]
> [    0.176847] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
> [    0.176869] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
> [    0.176958] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
> [    0.176995] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
> [    0.177038] system 00:04: [io  0x0680-0x069f] has been reserved
> [    0.177043] system 00:04: [io  0x1000-0x100f] has been reserved
> [    0.177046] system 00:04: [io  0x5000-0x5003] has been reserved
> [    0.177050] system 00:04: [io  0xffff] has been reserved
> [    0.177053] system 00:04: [io  0x0400-0x0453] has been reserved
> [    0.177056] system 00:04: [io  0x0458-0x047f] has been reserved
> [    0.177060] system 00:04: [io  0x0500-0x057f] has been reserved
> [    0.177063] system 00:04: [io  0x0a00-0x0a0f] has been reserved
> [    0.177067] system 00:04: [io  0x164e-0x164f] has been reserved
> [    0.177070] system 00:04: [io  0x5000-0x500f] could not be reserved
> [    0.177075] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.177102] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
> [    0.177147] system 00:06: [io  0x0454-0x0457] has been reserved
> [    0.177152] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
> [    0.177184] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
> [    0.177227] pnp 00:08: Plug and Play ACPI device, IDs ETD0b00 SYN0002 PNP0f13 (active)
> [    0.177387] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
> [    0.177392] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
> [    0.177396] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
> [    0.177399] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
> [    0.177403] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
> [    0.177406] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
> [    0.177412] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
> [    0.177416] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
> [    0.177420] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
> [    0.177424] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
> [    0.177428] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> [    0.177779] pnp 00:0a: can't evaluate _CRS: 12311
> [    0.177879] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
> [    0.177906] pnp: PnP ACPI: found 11 devices
> [    0.177909] ACPI: ACPI bus type pnp unregistered
> [    0.184420] pci 0000:00:1c.0: PCI bridge to [bus 01]
> [    0.184430] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
> [    0.184443] pci 0000:00:1c.3: PCI bridge to [bus 02]
> [    0.184448] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
> [    0.184459] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.184468] pci 0000:00:1c.4: PCI bridge to [bus 03]
> [    0.184476] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
> [    0.184631] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
> [    0.184635] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
> [    0.184638] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
> [    0.184642] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
> [    0.184645] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
> [    0.184649] pci_bus 0000:01: resource 1 [mem 0xf0600000-0xf06fffff]
> [    0.184652] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
> [    0.184656] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
> [    0.184660] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
> [    0.184694] NET: Registered protocol family 2
> [    0.184843] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
> [    0.184996] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
> [    0.185097] TCP: Hash tables configured (established 32768 bind 32768)
> [    0.185128] TCP: reno registered
> [    0.185139] UDP hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.185159] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
> [    0.185228] NET: Registered protocol family 1
> [    0.185243] pci 0000:00:02.0: Boot video device
> [    0.185596] PCI: CLS 64 bytes, default 64
> [    0.185635] Trying to unpack rootfs image as initramfs...
> [    0.250180] Freeing initrd memory: 3204k freed
> [    0.250863] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [    0.250872] software IO TLB [mem 0xd5c9f000-0xd9c9f000] (64MB) mapped at [ffff8800d5c9f000-ffff8800d9c9efff]
> [    0.251084] Scanning for low memory corruption every 60 seconds
> [    0.251320] Initialise system trusted keyring
> [    0.251364] audit: initializing netlink socket (disabled)
> [    0.251395] type=2000 audit(1361966129.248:1): initialized
> [    0.282361] bounce pool size: 64 pages
> [    0.282373] HugeTLB registered 2 MB page size, pre-allocated 0 pages
> [    0.283721] VFS: Disk quotas dquot_6.5.2
> [    0.283762] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
> [    0.284208] fuse init (API version 7.21)
> [    0.284277] msgmni has been set to 7688
> [    0.284734] Key type asymmetric registered
> [    0.284740] Asymmetric key parser 'x509' registered
> [    0.284780] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> [    0.284812] io scheduler noop registered
> [    0.284816] io scheduler deadline registered (default)
> [    0.284823] io scheduler cfq registered
> [    0.285032] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [    0.285047] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> [    0.285087] intel_idle: MWAIT substates: 0x21120
> [    0.285090] intel_idle: v0.4 model 0x2A
> [    0.285092] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.285529] ACPI: AC Adapter [ADP1] (on-line)
> [    0.285591] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
> [    0.285609] ACPI: Lid Switch [LID0]
> [    0.285644] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
> [    0.285651] ACPI: Power Button [PWRB]
> [    0.285680] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
> [    0.285685] ACPI: Power Button [PWRF]
> [    0.285734] ACPI: Fan [FAN0] (off)
> [    0.285758] ACPI: Fan [FAN1] (off)
> [    0.285780] ACPI: Fan [FAN2] (off)
> [    0.285806] ACPI: Fan [FAN3] (off)
> [    0.285827] ACPI: Fan [FAN4] (off)
> [    0.285872] ACPI: Requesting acpi_cpufreq
> [    0.289998] thermal LNXTHERM:00: registered as thermal_zone0
> [    0.290003] ACPI: Thermal Zone [TZ00] (63 C)
> [    0.290193] thermal LNXTHERM:01: registered as thermal_zone1
> [    0.290197] ACPI: Thermal Zone [TZ01] (30 C)
> [    0.290223] GHES: HEST is not enabled!
> [    0.290355] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    0.293139] Linux agpgart interface v0.103
> [    0.294238] brd: module loaded
> [    0.294802] loop: module loaded
> [    0.294893] ahci 0000:00:1f.2: version 3.0
> [    0.295021] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
> [    0.295064] ahci: SSS flag set, parallel bus scan disabled
> [    0.295122] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
> [    0.295128] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst 
> [    0.295136] ahci 0000:00:1f.2: setting latency timer to 64
> [    0.295723] ACPI: Battery Slot [BAT1] (battery present)
> [    0.315646] scsi0 : ahci
> [    0.315725] scsi1 : ahci
> [    0.315785] scsi2 : ahci
> [    0.315841] scsi3 : ahci
> [    0.315897] scsi4 : ahci
> [    0.315956] scsi5 : ahci
> [    0.315988] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708100 irq 40
> [    0.315994] ata2: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708180 irq 40
> [    0.315997] ata3: DUMMY
> [    0.316001] ata4: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708280 irq 40
> [    0.316006] ata5: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708300 irq 40
> [    0.316009] ata6: DUMMY
> [    0.316250] libphy: Fixed MDIO Bus: probed
> [    0.316322] tun: Universal TUN/TAP device driver, 1.6
> [    0.316325] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [    0.316378] PPP generic driver version 2.4.2
> [    0.316433] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> [    0.316437] ehci-pci: EHCI PCI platform driver
> [    0.316516] ehci-pci 0000:00:1a.0: setting latency timer to 64
> [    0.316522] ehci-pci 0000:00:1a.0: EHCI Host Controller
> [    0.316529] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
> [    0.316546] ehci-pci 0000:00:1a.0: debug port 2
> [    0.320435] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
> [    0.320454] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf070a000
> [    0.331331] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
> [    0.331358] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.331362] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.331366] usb usb1: Product: EHCI Host Controller
> [    0.331369] usb usb1: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small ehci_hcd
> [    0.331373] usb usb1: SerialNumber: 0000:00:1a.0
> [    0.331496] hub 1-0:1.0: USB hub found
> [    0.331502] hub 1-0:1.0: 2 ports detected
> [    0.331624] ehci-pci 0000:00:1d.0: setting latency timer to 64
> [    0.331630] ehci-pci 0000:00:1d.0: EHCI Host Controller
> [    0.331636] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
> [    0.331652] ehci-pci 0000:00:1d.0: debug port 2
> [    0.335559] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
> [    0.335576] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf0709000
> [    0.347324] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
> [    0.347355] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.347359] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.347363] usb usb2: Product: EHCI Host Controller
> [    0.347366] usb usb2: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small ehci_hcd
> [    0.347370] usb usb2: SerialNumber: 0000:00:1d.0
> [    0.347475] hub 2-0:1.0: USB hub found
> [    0.347480] hub 2-0:1.0: 2 ports detected
> [    0.347541] ehci-platform: EHCI generic platform driver
> [    0.347550] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> [    0.347565] uhci_hcd: USB Universal Host Controller Interface driver
> [    0.347633] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.347639] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
> [    0.357325] xhci_hcd 0000:03:00.0: irq 16, io mem 0xf0500000
> [    0.357394] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
> [    0.357401] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
> [    0.357408] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
> [    0.357415] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
> [    0.357424] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
> [    0.357532] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
> [    0.357536] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.357540] usb usb3: Product: xHCI Host Controller
> [    0.357543] usb usb3: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small xhci_hcd
> [    0.357547] usb usb3: SerialNumber: 0000:03:00.0
> [    0.357616] xHCI xhci_add_endpoint called for root hub
> [    0.357620] xHCI xhci_check_bandwidth called for root hub
> [    0.357643] hub 3-0:1.0: USB hub found
> [    0.357654] hub 3-0:1.0: 2 ports detected
> [    0.357711] xhci_hcd 0000:03:00.0: xHCI Host Controller
> [    0.357716] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
> [    0.357752] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
> [    0.357756] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> [    0.357760] usb usb4: Product: xHCI Host Controller
> [    0.357763] usb usb4: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small xhci_hcd
> [    0.357767] usb usb4: SerialNumber: 0000:03:00.0
> [    0.357825] xHCI xhci_add_endpoint called for root hub
> [    0.357828] xHCI xhci_check_bandwidth called for root hub
> [    0.357847] hub 4-0:1.0: USB hub found
> [    0.357856] hub 4-0:1.0: 2 ports detected
> [    0.357993] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:EPAD] at 0x60,0x64 irq 1,12
> [    0.365250] serio: i8042 KBD port at 0x60,0x64 irq 1
> [    0.365258] serio: i8042 AUX port at 0x60,0x64 irq 12
> [    0.365372] mousedev: PS/2 mouse device common for all mice
> [    0.365754] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
> [    0.365785] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
> [    0.365844] device-mapper: uevent: version 1.0.3
> [    0.365911] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
> [    0.365925] Intel P-state driver initializing.
> [    0.365943] Intel pstate controlling: cpu 0
> [    0.365961] Intel pstate controlling: cpu 1
> [    0.365977] Intel pstate controlling: cpu 2
> [    0.365990] Intel pstate controlling: cpu 3
> [    0.366090] cpuidle: using governor ladder
> [    0.366198] cpuidle: using governor menu
> [    0.366204] ledtrig-cpu: registered to indicate activity on CPUs
> [    0.366207] EFI Variables Facility v0.08 2004-May-17
> [    0.366328] ashmem: initialized
> [    0.366436] TCP: cubic registered
> [    0.366528] NET: Registered protocol family 10
> [    0.366690] NET: Registered protocol family 17
> [    0.366702] Key type dns_resolver registered
> [    0.366945] PM: Hibernation image not present or could not be loaded.
> [    0.366949] Loading compiled-in X.509 certificates
> [    0.368006] Loaded X.509 cert 'Magrathea: Glacier signing key: 25f3fa297967d1c843028ae60b1618d1f11e8b4a'
> [    0.368019] registered taskstats version 1
> [    0.370457] Key type trusted registered
> [    0.372904] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> [    0.374198] Key type encrypted registered
> [    0.379807] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
> [    0.379821] EDD information not available.
> [    0.635232] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    0.636511] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
> [    0.636532] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
> [    0.637898] ata1.00: configured for UDMA/133
> [    0.638373] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54505 GG2O PQ: 0 ANSI: 5
> [    0.638759] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [    0.638767] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> [    0.638776] sd 0:0:0:0: [sda] 4096-byte physical blocks
> [    0.639009] sd 0:0:0:0: [sda] Write Protect is off
> [    0.639022] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [    0.639202] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.643174] usb 1-1: new high-speed USB device number 2 using ehci-pci
> [    0.655363]  sda: sda1 sda2 sda3
> [    0.656561] sd 0:0:0:0: [sda] Attached SCSI disk
> [    0.775682] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
> [    0.775701] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    0.776136] hub 1-1:1.0: USB hub found
> [    0.776397] hub 1-1:1.0: 6 ports detected
> [    0.887050] usb 2-1: new high-speed USB device number 2 using ehci-pci
> [    0.955009] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [    0.955585] ata2.00: ATA-8: SanDisk iSSD P4 16GB, SSD 9.14, max UDMA/133
> [    0.955605] ata2.00: 31277232 sectors, multi 1: LBA48 
> [    0.956258] ata2.00: configured for UDMA/133
> [    0.956727] scsi 1:0:0:0: Direct-Access     ATA      SanDisk iSSD P4  SSD  PQ: 0 ANSI: 5
> [    0.957078] sd 1:0:0:0: Attached scsi generic sg1 type 0
> [    0.957117] sd 1:0:0:0: [sdb] 31277232 512-byte logical blocks: (16.0 GB/14.9 GiB)
> [    0.957561] sd 1:0:0:0: [sdb] Write Protect is off
> [    0.957578] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [    0.957807] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> [    0.958851]  sdb: sdb1 sdb2
> [    0.959564] sd 1:0:0:0: [sdb] Attached SCSI disk
> [    1.019274] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
> [    1.019295] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    1.019803] hub 2-1:1.0: USB hub found
> [    1.019900] hub 2-1:1.0: 6 ports detected
> [    1.090991] usb 1-1.2: new low-speed USB device number 3 using ehci-pci
> [    1.189133] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
> [    1.189153] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.189165] usb 1-1.2: Product: USB-PS/2 Optical Mouse
> [    1.189172] usb 1-1.2: Manufacturer: Logitech
> [    1.246792] tsc: Refined TSC clocksource calibration: 1596.373 MHz
> [    1.246815] Switching to clocksource tsc
> [    1.258878] usb 1-1.4: new high-speed USB device number 4 using ehci-pci
> [    1.274775] ata4: SATA link down (SStatus 0 SControl 300)
> [    1.511002] usb 1-1.4: New USB device found, idVendor=2232, idProduct=1018
> [    1.511022] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> [    1.511033] usb 1-1.4: Product: WebCam SC-13HDL11431N
> [    1.511041] usb 1-1.4: Manufacturer: 123
> [    1.594549] ata5: SATA link down (SStatus 0 SControl 300)
> [    1.597325] Freeing unused kernel memory: 1252k freed
> [    1.597710] Write protecting the kernel read-only data: 12288k
> [    1.605281] Freeing unused kernel memory: 1204k freed
> [    1.609820] Freeing unused kernel memory: 1104k freed
> [    1.646706] udevd[120]: starting version 175
> [    1.689068] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
> [    1.689398] r8169 0000:02:00.0: irq 46 for MSI/MSI-X
> [    1.689966] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000666000, e8:03:9a:36:17:a9, XID 0c900800 IRQ 46
> [    1.689978] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
> [    1.693405] hidraw: raw HID events driver (C) Jiri Kosina
> [    1.700716] usbcore: registered new interface driver usbhid
> [    1.700726] usbhid: USB HID core driver
> [    1.754478] usb 2-1.5: new full-speed USB device number 3 using ehci-pci
> [    1.755770] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
> [    1.755944] hid-generic 0003:046D:C00E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.2/input0
> [    1.850176] usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
> [    1.850204] usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
> [    2.506456] EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: (null)
> [   25.247407] Adding 262140k swap on /host/ubuntu/disks/swap.disk.  Priority:-1 extents:1 across:262140k 
> [   25.269391] EXT4-fs (loop0): re-mounted. Opts: errors=remount-ro
> [   25.284955] udevd[599]: starting version 175
> [   25.406818] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130117/utaddress-251)
> [   25.406828] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   25.406834] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
> [   25.406838] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   25.406840] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
> [   25.406845] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   25.406847] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
> [   25.406851] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
> [   25.406853] lpc_ich: Resource conflict(s) found affecting gpio_ich
> [   25.698835] mei 0000:00:16.0: setting latency timer to 64
> [   25.698918] mei 0000:00:16.0: irq 47 for MSI/MSI-X
> [   25.773719] Bluetooth: Core ver 2.16
> [   25.773740] NET: Registered protocol family 31
> [   25.773742] Bluetooth: HCI device and connection manager initialized
> [   25.773751] Bluetooth: HCI socket layer initialized
> [   25.773755] Bluetooth: L2CAP socket layer initialized
> [   25.773770] Bluetooth: SCO socket layer initialized
> [   25.868459] lp: driver loaded but no devices found
> [   25.933043] wmi: Mapper loaded
> [   25.935824] samsung_laptop: detected SABI interface: SwSmi@
> [   25.935829] samsung_laptop: Backlight controlled by ACPI video driver
> [   26.011782] Linux video capture interface: v2.00
> [   26.013652] cfg80211: Calling CRDA to update world regulatory domain
> [   26.023551] usbcore: registered new interface driver btusb
> [   26.035421] cfg80211: World regulatory domain updated:
> [   26.035426] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> [   26.035429] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   26.035431] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   26.035434] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [   26.035436] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   26.035438] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [   26.073528] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x28
> [   26.283433] Bluetooth: RFCOMM TTY layer initialized
> [   26.283448] Bluetooth: RFCOMM socket layer initialized
> [   26.283450] Bluetooth: RFCOMM ver 1.11
> [   26.328213] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> [   26.328218] Bluetooth: BNEP filters: protocol multicast
> [   26.328227] Bluetooth: BNEP socket layer initialized
> [   26.334762] type=1400 audit(1361962555.347:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=783 comm="apparmor_parser"
> [   26.334835] type=1400 audit(1361962555.347:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=783 comm="apparmor_parser"
> [   26.334896] type=1400 audit(1361962555.347:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=783 comm="apparmor_parser"
> [   26.335569] type=1400 audit(1361962555.347:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=688 comm="apparmor_parser"
> [   26.335623] type=1400 audit(1361962555.347:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=688 comm="apparmor_parser"
> [   26.335665] type=1400 audit(1361962555.347:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=688 comm="apparmor_parser"
> [   26.370321] init: failsafe main process (935) killed by TERM signal
> [   26.527436] ppdev: user-space parallel port driver
> [   26.661985] [drm] Initialized drm 1.1.0 20060810
> [   26.676763] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x28
> [   26.679380] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x28
> [   26.688580] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x28
> [   26.691620] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> [   26.967752] Intel(R) Wireless WiFi driver for Linux, in-tree:d
> [   26.967756] Copyright(c) 2003-2013 Intel Corporation
> [   26.968181] iwlwifi 0000:01:00.0: irq 48 for MSI/MSI-X
> [   26.968640] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1
> [   27.279901] type=1400 audit(1361962556.291:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1052 comm="apparmor_parser"
> [   27.280023] type=1400 audit(1361962556.291:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=1052 comm="apparmor_parser"
> [   27.309023] uvcvideo: Found UVC 1.00 device WebCam SC-13HDL11431N (2232:1018)
> [   27.331351] input: WebCam SC-13HDL11431N as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input5
> [   27.331442] usbcore: registered new interface driver uvcvideo
> [   27.331445] USB Video Class driver (1.1.1)
> [   27.421856] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x450f00)
> [   27.436940] psmouse serio1: elantech: Synaptics capabilities query result 0x08, 0x17, 0x0c.
> [   27.514459] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input6
> [   27.584689] [drm] Memory usable by graphics device = 2048M
> [   27.584699] i915 0000:00:02.0: setting latency timer to 64
> [   27.639750] i915 0000:00:02.0: irq 49 for MSI/MSI-X
> [   27.639767] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [   27.639769] [drm] Driver supports precise vblank timestamp query.
> [   27.639815] type=1400 audit(1361962556.651:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1077 comm="apparmor_parser"
> [   27.639836] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
> [   27.650965] [drm] Wrong MCH_SSKPD value: 0x16040307
> [   27.650969] [drm] This can cause pipe underruns and display issues.
> [   27.650971] [drm] Please upgrade your BIOS to fix this.
> [   27.666268] fbcon: inteldrmfb (fb0) is primary device
> [   27.706167] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [   27.706169] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [   27.706170] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
> [   27.706171] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
> [   27.706173] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P disabled
> [   27.706175] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6230 AGN, REV=0xB0
> [   27.706227] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   27.808223] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
> [   27.821278] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   27.838245] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [   28.033463] type=1400 audit(1361962557.047:11): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1078 comm="apparmor_parser"
> [   28.216525] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   28.223155] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [   28.416827] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   28.476537] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   28.483166] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
> [   28.627398] Console: switching to colour frame buffer device 170x48
> [   28.631954] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
> [   28.631957] i915 0000:00:02.0: registered panic notifier
> [   28.644643] acpi device:32: registered as cooling_device9
> [   28.644898] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
> [   28.645076] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input7
> [   28.646945] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> [   28.647319] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
> [   28.682854] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [   28.703060] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
> [   28.707420] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
> [   28.707594] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
> [   28.767390] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
> [   34.458348] audit_printk_skb: 21 callbacks suppressed
> [   34.458352] type=1400 audit(1361962563.475:19): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=1079 comm="apparmor_parser"
> [   34.458945] type=1400 audit(1361962563.475:20): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince//launchpad_integration" pid=1079 comm="apparmor_parser"
> [   34.459117] type=1400 audit(1361962563.475:21): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince//sanitized_helper" pid=1079 comm="apparmor_parser"
> [   34.459710] type=1400 audit(1361962563.479:22): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=1079 comm="apparmor_parser"
> [   34.460112] type=1400 audit(1361962563.479:23): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer//launchpad_integration" pid=1079 comm="apparmor_parser"
> [   34.460288] type=1400 audit(1361962563.479:24): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer//sanitized_helper" pid=1079 comm="apparmor_parser"
> [   34.460639] type=1400 audit(1361962563.479:25): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=1079 comm="apparmor_parser"
> [   34.460901] type=1400 audit(1361962563.479:26): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer//sanitized_helper" pid=1079 comm="apparmor_parser"
> [   34.572969] init: alsa-restore main process (1207) terminated with status 99
> [   34.857028] wlan0: authenticate with 00:04:0e:e4:00:3d
> [   34.864996] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
> [   34.866876] wlan0: authenticated
> [   34.866898] iwlwifi 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
> [   34.866901] iwlwifi 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
> [   34.870896] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
> [   34.874557] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
> [   34.882447] wlan0: associated
> [   34.882467] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> [   35.047985] init: plymouth-stop pre-start process (1446) terminated with status 1
> [   50.222130] usb 2-1.5: USB disconnect, device number 3
> [   63.855615] firefox[2291]: segfault at 7fab5ea66548 ip 00007fab5ea47362 sp 00007fffc1b3ab38 error 7 in libGL.so.1.2.0[7fab5ea47000+7c000]



-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
