Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991Ab3B0NIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:08:50 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:62808 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab3B0NIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:08:48 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUVXDfOhztQtrOxyYaHutpx=iVpPGmRT0PzP7045_mjh6w@mail.gmail.com>
References: <CA+icZUUsedHPqZc5jXQ_AqAbfmTMu5WW8CJ+vnHwL69ofw7uTw@mail.gmail.com>
	<20130227122302.GA5678@pd.tnic>
	<CA+icZUVXDfOhztQtrOxyYaHutpx=iVpPGmRT0PzP7045_mjh6w@mail.gmail.com>
Date: Wed, 27 Feb 2013 14:08:40 +0100
Message-ID: <CA+icZUXJb5O7ML-xnQq8Zoa46NmaGZp2Xaqj6fJL+vudPeQTLw@mail.gmail.com>
Subject: Re: [next-20130227] kernel NULL pointer dereference [ watchdog | perf
 related ? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Sedat Dilek <sedat.dilek@gmail.com>,
        Tejun Heo <tj@kernel.org>, Wim Van Sebroeck <wim@iguana.be>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-watchdog@vger.kernel.org, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary=f46d044282c41dc4f504d6b47924
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d044282c41dc4f504d6b47924
Content-Type: text/plain; charset=UTF-8

On Wed, Feb 27, 2013 at 1:51 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Feb 27, 2013 at 1:23 PM, Borislav Petkov <bp@alien8.de> wrote:
>> On Wed, Feb 27, 2013 at 12:13:07PM +0100, Sedat Dilek wrote:
>>> Hi,
>>>
>>> I have reported this issue several times (first for next-20130223) to
>>> LKML and Linux-Next MLs but got no answer.
>>> I am unsure which is the root cause for all this trouble.
>>>
>>> Can someone have a look at this, please?
>>>
>>> [    0.065787] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz
>>> (fam: 06, model: 2a, stepping: 07)
>>> [    0.065799] TSC deadline timer enabled
>>> [    0.065811] Performance Events: PEBS fmt1+, 16-deep LBR,
>>> SandyBridge events, Intel PMU driver.
>>> [    0.065822] ... version:                3
>>> [    0.065824] ... bit width:              48
>>> [    0.065826] ... generic registers:      4
>>> [    0.065829] ... value mask:             0000ffffffffffff
>>> [    0.065831] ... max period:             000000007fffffff
>>> [    0.065834] ... fixed-purpose events:   3
>>> [    0.065836] ... event mask:             000000070000000f
>>> [    0.066888] BUG: unable to handle kernel NULL pointer dereference
>>> at           (null)
>>> [    0.066894] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.066900] PGD 0
>>> [    0.066903] Oops: 0000 [#1] SMP
>>> [    0.066906] Modules linked in:
>>> [    0.066908] CPU 0
>>> [    0.066912] Pid: 11, comm: watchdog/0 Not tainted
>>> 3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD.
>>> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
>>> [    0.066918] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>]
>>> perf_init_event+0x32/0x100
>>> [    0.066924] RSP: 0000:ffff880119b59d58  EFLAGS: 00010246
>>> [    0.066927] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
>>> [    0.066930] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
>>> [    0.066933] RBP: ffff880119b59d88 R08: ffff88011fa16fa0 R09: ffffffff810ec0e0
>>> [    0.066936] R10: ffff88011b012000 R11: 0000000000000000 R12: ffff88011b012000
>>> [    0.066939] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88011b012000
>>> [    0.066942] FS:  0000000000000000(0000) GS:ffff88011fa00000(0000)
>>> knlGS:0000000000000000
>>> [    0.066946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    0.066949] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407f0
>>> [    0.066952] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [    0.066955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [    0.066959] Process watchdog/0 (pid: 11, threadinfo
>>> ffff880119b58000, task ffff880119b50000)
>>> [    0.066962] Stack:
>>> [    0.066964]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000
>>> ffffffff81c4d760
>>> [    0.066970]  ffff88011b012000 0000000000000000 ffff880119b59de8
>>> ffffffff8112a6b8
>>> [    0.066975]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0
>>> 0000000000000000
>>> [    0.066980] Call Trace:
>>> [    0.066985]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
>>> [    0.066990]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
>>> [    0.066995]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
>>> [    0.066999]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
>>> [    0.067004]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
>>> [    0.067009]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
>>> [    0.067013]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
>>> [    0.067017]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.067021]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
>>> [    0.067025]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.067027] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18
>>> e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00
>>> 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3
>>> 48 85
>>> [    0.067063] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.067067]  RSP <ffff880119b59d58>
>>> [    0.067069] CR2: 0000000000000000
>>> [    0.067077] ---[ end trace 3cbbfd94f0f8f035 ]---
>>
>> Hmm, let's see. Your .config triggers in kvm too, so this is easy to debug:
>>
>> [ 0.171544] Code: 54 49 89 fc 48 c7 c7 20 7e f5 81 53 48 83 ec 18 e8 74 a9 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 22 f7 e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 e0 7d f5 81 e8 1e 9a 22 00 48 89 c3 48 85
>> All code
>> ========
>>    0:   54                      push   %rsp
>>    1:   49 89 fc                mov    %rdi,%r12
>>    4:   48 c7 c7 20 7e f5 81    mov    $0xffffffff81f57e20,%rdi
>>    b:   53                      push   %rbx
>>    c:   48 83 ec 18             sub    $0x18,%rsp
>>   10:   e8 74 a9 f5 ff          callq  0xfffffffffff5a989
>>   15:   41 8b b4 24 a0 00 00    mov    0xa0(%r12),%esi
>>   1c:   00
>>   1d:   41 89 c5                mov    %eax,%r13d
>>   20:   48 8b 05 22 f7 e2 00    mov    0xe2f722(%rip),%rax        # 0xe2f749
>>   27:   89 f2                   mov    %esi,%edx
>>   29:   30 d2                   xor    %dl,%dl
>>   2b:*  3b 10                   cmp    (%rax),%edx     <-- trapping instruction
>>   2d:   74 4a                   je     0x79
>>   2f:   48 c7 c7 e0 7d f5 81    mov    $0xffffffff81f57de0,%rdi
>>   36:   e8 1e 9a 22 00          callq  0x229a59
>>   3b:   48 89 c3                mov    %rax,%rbx
>>   3e:   48 85 00                test   %rax,(%rax)
>>
>> struct pmu *perf_init_event(struct perf_event *event)
>> {
>>         struct pmu *pmu = NULL;
>>         int idx;
>>         int ret;
>>
>>         idx = srcu_read_lock(&pmus_srcu);
>>
>>         rcu_read_lock();
>>         pmu = idr_find(&pmu_idr, event->attr.type);
>>
>> ...
>>
>> static inline void *idr_find(struct idr *idr, int id)
>> {
>>         struct idr_layer *hint = rcu_dereference_raw(idr->hint);
>>     86d7:       48 8b 05 00 00 00 00    mov    0x0(%rip),%rax        # 86de <perf_init_event+0x2e>
>>                         86da: R_X86_64_PC32     .bss+0xfc
>>
>>         if ((id & ~IDR_MASK) == hint->prefix)
>>     86de:       89 f2                   mov    %esi,%edx
>>     86e0:       30 d2                   xor    %dl,%dl
>>     86e2:       3b 10                   cmp    (%rax),%edx              <--- trapping insn
>>     86e4:       74 4a                   je     8730 <perf_init_event+0x80>
>>                 return rcu_dereference_raw(hint->ary[id & IDR_MASK]);
>>
>>
>> So 'hint' is NULL as RAX above confirms and we're not supposed to deref
>> NULL things.
>>
>> Looking at 29cf29e1fbb875019713eb55cf27ec35f1e5fa5e, Tejun should
>> probably know. CCed.
>>
>> Leaving in the rest for reference.
>>
>
> Cool analysis!
> I am trying with "Revert "idr: implement lookup hint"" and see if this
> fixes the problem!
>
> - Sedat -
>
> [1] http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commitdiff;h=29cf29e1fbb875019713eb55cf27ec35f1e5fa5e
>

Reverting above commit makes the call-traces go away.
Thanks Borislav for the analysis and hint.

Let's see if Tejun have a fix!

- Sedat -

>>> Full dmesg and my kernel-config are attached!
>>>
>>> Regards,
>>> - Sedat -
>>>
>>> [1] http://marc.info/?l=linux-next&m=136187160914695&w=2
>>
>>> [    0.000000] Initializing cgroup subsys cpuset
>>> [    0.000000] Initializing cgroup subsys cpu
>>> [    0.000000] Linux version 3.8.0-next20130227-1-iniza-small (sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Wed Feb 27 11:46:38 CET 2013
>>> [    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next20130227-1-iniza-small root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
>>> [    0.000000] KERNEL supported cpus:
>>> [    0.000000]   Intel GenuineIntel
>>> [    0.000000]   AMD AuthenticAMD
>>> [    0.000000]   Centaur CentaurHauls
>>> [    0.000000] Disabled fast string operations
>>> [    0.000000] e820: BIOS-provided physical RAM map:
>>> [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
>>> [    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
>>> [    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
>>> [    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000d9c9efff] usable
>>> [    0.000000] BIOS-e820: [mem 0x00000000d9c9f000-0x00000000dae7efff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000dae7f000-0x00000000daf9efff] ACPI NVS
>>> [    0.000000] BIOS-e820: [mem 0x00000000daf9f000-0x00000000daffefff] ACPI data
>>> [    0.000000] BIOS-e820: [mem 0x00000000dafff000-0x00000000daffffff] usable
>>> [    0.000000] BIOS-e820: [mem 0x00000000db000000-0x00000000df9fffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fbffffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fed08000-0x00000000fed08fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fed10000-0x00000000fed19fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x00000000ffd80000-0x00000000ffffffff] reserved
>>> [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000011fdfffff] usable
>>> [    0.000000] NX (Execute Disable) protection: active
>>> [    0.000000] SMBIOS 2.6 present.
>>> [    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 12XK 01/18/2013
>>> [    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
>>> [    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
>>> [    0.000000] No AGP bridge found
>>> [    0.000000] e820: last_pfn = 0x11fe00 max_arch_pfn = 0x400000000
>>> [    0.000000] MTRR default type: uncachable
>>> [    0.000000] MTRR fixed ranges enabled:
>>> [    0.000000]   00000-9FFFF write-back
>>> [    0.000000]   A0000-BFFFF uncachable
>>> [    0.000000]   C0000-FFFFF write-protect
>>> [    0.000000] MTRR variable ranges enabled:
>>> [    0.000000]   0 base 000000000 mask F80000000 write-back
>>> [    0.000000]   1 base 080000000 mask FC0000000 write-back
>>> [    0.000000]   2 base 0C0000000 mask FE0000000 write-back
>>> [    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
>>> [    0.000000]   4 base 0DB000000 mask FFF000000 uncachable
>>> [    0.000000]   5 base 100000000 mask FE0000000 write-back
>>> [    0.000000]   6 base 11FE00000 mask FFFE00000 uncachable
>>> [    0.000000]   7 base 0FFC00000 mask FFFC00000 write-protect
>>> [    0.000000]   8 disabled
>>> [    0.000000]   9 disabled
>>> [    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
>>> [    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
>>> [    0.000000] found SMP MP-table at [mem 0x000f00e0-0x000f00ef] mapped at [ffff8800000f00e0]
>>> [    0.000000] Scanning 1 areas for low memory corruption
>>> [    0.000000] ACPI: RSDP 00000000000f0100 00024 (v02 SECCSD)
>>> [    0.000000] ACPI: XSDT 00000000daffe170 0008C (v01 SECCSD LH43STAR 00000002 PTEC 00000002)
>>> [    0.000000] ACPI: FACP 00000000dafef000 0010C (v05 SECCSD LH43STAR 00000002 PTL  00000002)
>>> [    0.000000] ACPI: DSDT 00000000daff2000 083AC (v02 SECCSD  SNB-CPT 00000000 INTL 20061109)
>>> [    0.000000] ACPI: FACS 00000000daf47000 00040
>>> [    0.000000] ACPI: SLIC 00000000daffd000 00176 (v01 SECCSD LH43STAR 00000002 PTEC 00000001)
>>> [    0.000000] ACPI: SSDT 00000000daffb000 01068 (v01 SECCSD PtidDevc 00001000 INTL 20061109)
>>> [    0.000000] ACPI: ASF! 00000000daff1000 000A5 (v32 SECCSD LH43STAR 00000002 PTL  00000002)
>>> [    0.000000] ACPI: HPET 00000000dafee000 00038 (v01 SECCSD LH43STAR 00000002 PTL  00000002)
>>> [    0.000000] ACPI: APIC 00000000dafed000 00098 (v03 SECCSD LH43STAR 00000002 PTL  00000002)
>>> [    0.000000] ACPI: MCFG 00000000dafec000 0003C (v01 SECCSD LH43STAR 00000002 PTL  00000002)
>>> [    0.000000] ACPI: SSDT 00000000dafeb000 00804 (v01  PmRef  Cpu0Ist 00003000 INTL 20061109)
>>> [    0.000000] ACPI: SSDT 00000000dafea000 00996 (v01  PmRef    CpuPm 00003000 INTL 20061109)
>>> [    0.000000] ACPI: UEFI 00000000dafe9000 0003E (v01 SECCSD LH43STAR 00000002 PTL  00000002)
>>> [    0.000000] ACPI: UEFI 00000000dafe8000 00042 (v01 PTL      COMBUF 00000001 PTL  00000001)
>>> [    0.000000] ACPI: UEFI 00000000dafe7000 0026A (v01 SECCSD LH43STAR 00000002 PTL  00000002)
>>> [    0.000000] ACPI: SSDT 00000000dafe6000 000D0 (v01   Iffs  IffsAsl 00003000 INTL 20061109)
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
>>> [    0.000000] reserving inaccessible SNB gfx pages
>>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>>> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>>> [    0.000000] BRK [0x01f8b000, 0x01f8bfff] PGTABLE
>>> [    0.000000] BRK [0x01f8c000, 0x01f8cfff] PGTABLE
>>> [    0.000000] BRK [0x01f8d000, 0x01f8dfff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0x11fc00000-0x11fdfffff]
>>> [    0.000000]  [mem 0x11fc00000-0x11fdfffff] page 2M
>>> [    0.000000] BRK [0x01f8e000, 0x01f8efff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0x11c000000-0x11fbfffff]
>>> [    0.000000]  [mem 0x11c000000-0x11fbfffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x100000000-0x11bffffff]
>>> [    0.000000]  [mem 0x100000000-0x11bffffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
>>> [    0.000000]  [mem 0x00100000-0x001fffff] page 4k
>>> [    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
>>> [    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
>>> [    0.000000] init_memory_mapping: [mem 0x40200000-0xd9c9efff]
>>> [    0.000000]  [mem 0x40200000-0xd9bfffff] page 2M
>>> [    0.000000]  [mem 0xd9c00000-0xd9c9efff] page 4k
>>> [    0.000000] BRK [0x01f8f000, 0x01f8ffff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
>>> [    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
>>> [    0.000000] RAMDISK: [mem 0x379ae000-0x37ccefff]
>>> [    0.000000] No NUMA configuration found
>>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fdfffff]
>>> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fdfffff]
>>> [    0.000000]   NODE_DATA [mem 0x11fdf8000-0x11fdfbfff]
>>> [    0.000000]  [ffffea0000000000-ffffea00047fffff] PMD -> [ffff88011b400000-ffff88011f3fffff] on node 0
>>> [    0.000000] Zone ranges:
>>> [    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
>>> [    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
>>> [    0.000000]   Normal   [mem 0x100000000-0x11fdfffff]
>>> [    0.000000] Movable zone start for each node
>>> [    0.000000] Early memory node ranges
>>> [    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
>>> [    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
>>> [    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
>>> [    0.000000]   node   0: [mem 0x40200000-0xd9c9efff]
>>> [    0.000000]   node   0: [mem 0xdafff000-0xdaffffff]
>>> [    0.000000]   node   0: [mem 0x100000000-0x11fdfffff]
>>> [    0.000000] On node 0 totalpages: 1021500
>>> [    0.000000]   DMA zone: 64 pages used for memmap
>>> [    0.000000]   DMA zone: 156 pages reserved
>>> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
>>> [    0.000000]   DMA32 zone: 13859 pages used for memmap
>>> [    0.000000]   DMA32 zone: 886944 pages, LIFO batch:31
>>> [    0.000000]   Normal zone: 2040 pages used for memmap
>>> [    0.000000]   Normal zone: 130560 pages, LIFO batch:31
>>> [    0.000000] ACPI: PM-Timer IO Port: 0x408
>>> [    0.000000] ACPI: Local APIC address 0xfee00000
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
>>> [    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x00] disabled)
>>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
>>> [    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
>>> [    0.000000] ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
>>> [    0.000000] IOAPIC[0]: apic_id 14, version 32, address 0xfec00000, GSI 0-23
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
>>> [    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
>>> [    0.000000] ACPI: IRQ0 used by override.
>>> [    0.000000] ACPI: IRQ2 used by override.
>>> [    0.000000] ACPI: IRQ9 used by override.
>>> [    0.000000] Using ACPI (MADT) for SMP configuration information
>>> [    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
>>> [    0.000000] smpboot: Allowing 8 CPUs, 4 hotplug CPUs
>>> [    0.000000] nr_irqs_gsi: 40
>>> [    0.000000] PM: Registered nosave memory: 000000000009d000 - 000000000009e000
>>> [    0.000000] PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
>>> [    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
>>> [    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
>>> [    0.000000] PM: Registered nosave memory: 0000000020000000 - 0000000020200000
>>> [    0.000000] PM: Registered nosave memory: 0000000040000000 - 0000000040200000
>>> [    0.000000] PM: Registered nosave memory: 00000000d9c9f000 - 00000000dae7f000
>>> [    0.000000] PM: Registered nosave memory: 00000000dae7f000 - 00000000daf9f000
>>> [    0.000000] PM: Registered nosave memory: 00000000daf9f000 - 00000000dafff000
>>> [    0.000000] PM: Registered nosave memory: 00000000db000000 - 00000000dfa00000
>>> [    0.000000] PM: Registered nosave memory: 00000000dfa00000 - 00000000f8000000
>>> [    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
>>> [    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
>>> [    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec01000
>>> [    0.000000] PM: Registered nosave memory: 00000000fec01000 - 00000000fed08000
>>> [    0.000000] PM: Registered nosave memory: 00000000fed08000 - 00000000fed09000
>>> [    0.000000] PM: Registered nosave memory: 00000000fed09000 - 00000000fed10000
>>> [    0.000000] PM: Registered nosave memory: 00000000fed10000 - 00000000fed1a000
>>> [    0.000000] PM: Registered nosave memory: 00000000fed1a000 - 00000000fed1c000
>>> [    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
>>> [    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fee00000
>>> [    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
>>> [    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffd80000
>>> [    0.000000] PM: Registered nosave memory: 00000000ffd80000 - 0000000100000000
>>> [    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
>>> [    0.000000] Booting paravirtualized kernel on bare hardware
>>> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
>>> [    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88011fa00000 s85568 r8192 d20928 u262144
>>> [    0.000000] pcpu-alloc: s85568 r8192 d20928 u262144 alloc=1*2097152
>>> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
>>> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1005381
>>> [    0.000000] Policy zone: Normal
>>> [    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.8.0-next20130227-1-iniza-small root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
>>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>>> [    0.000000] __ex_table already sorted, skipping sort
>>> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
>>> [    0.000000] Checking aperture...
>>> [    0.000000] No AGP bridge found
>>> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
>>> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
>>> [    0.000000] Memory: 3933468k/4716544k available (6977k kernel code, 630544k absent, 152532k reserved, 6273k data, 1252k init)
>>> [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
>>> [    0.000000] Hierarchical RCU implementation.
>>> [    0.000000]        RCU dyntick-idle grace-period acceleration is enabled.
>>> [    0.000000]        RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
>>> [    0.000000] NR_IRQS:16640 nr_irqs:744 16
>>> [    0.000000] Console: colour dummy device 80x25
>>> [    0.000000] console [tty0] enabled
>>> [    0.000000] allocated 16777216 bytes of page_cgroup
>>> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
>>> [    0.000000] hpet clockevent registered
>>> [    0.000000] tsc: Fast TSC calibration using PIT
>>> [    0.004000] tsc: Detected 1596.469 MHz processor
>>> [    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.93 BogoMIPS (lpj=6385876)
>>> [    0.000009] pid_max: default: 32768 minimum: 301
>>> [    0.000036] Security Framework initialized
>>> [    0.000050] AppArmor: AppArmor initialized
>>> [    0.000053] Yama: becoming mindful.
>>> [    0.000397] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
>>> [    0.001450] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
>>> [    0.001899] Mount-cache hash table entries: 256
>>> [    0.002097] Initializing cgroup subsys cpuacct
>>> [    0.002102] Initializing cgroup subsys memory
>>> [    0.002112] Initializing cgroup subsys devices
>>> [    0.002115] Initializing cgroup subsys freezer
>>> [    0.002118] Initializing cgroup subsys blkio
>>> [    0.002121] Initializing cgroup subsys perf_event
>>> [    0.002126] Initializing cgroup subsys hugetlb
>>> [    0.002154] Disabled fast string operations
>>> [    0.002158] CPU: Physical Processor ID: 0
>>> [    0.002160] CPU: Processor Core ID: 0
>>> [    0.002166] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>>> [    0.002166] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
>>> [    0.002174] mce: CPU supports 7 MCE banks
>>> [    0.002188] CPU0: Thermal monitoring enabled (TM1)
>>> [    0.002198] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
>>> [    0.002198] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
>>> [    0.002198] tlb_flushall_shift: 5
>>> [    0.002294] Freeing SMP alternatives: 24k freed
>>> [    0.004519] ACPI: Core revision 20130117
>>> [    0.009991] ACPI: All ACPI Tables successfully acquired
>>> [    0.011561] ftrace: allocating 26138 entries in 103 pages
>>> [    0.026124] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>>> [    0.065787] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz (fam: 06, model: 2a, stepping: 07)
>>> [    0.065799] TSC deadline timer enabled
>>> [    0.065811] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
>>> [    0.065822] ... version:                3
>>> [    0.065824] ... bit width:              48
>>> [    0.065826] ... generic registers:      4
>>> [    0.065829] ... value mask:             0000ffffffffffff
>>> [    0.065831] ... max period:             000000007fffffff
>>> [    0.065834] ... fixed-purpose events:   3
>>> [    0.065836] ... event mask:             000000070000000f
>>> [    0.066888] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>> [    0.066894] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.066900] PGD 0
>>> [    0.066903] Oops: 0000 [#1] SMP
>>> [    0.066906] Modules linked in:
>>> [    0.066908] CPU 0
>>> [    0.066912] Pid: 11, comm: watchdog/0 Not tainted 3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
>>> [    0.066918] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.066924] RSP: 0000:ffff880119b59d58  EFLAGS: 00010246
>>> [    0.066927] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
>>> [    0.066930] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
>>> [    0.066933] RBP: ffff880119b59d88 R08: ffff88011fa16fa0 R09: ffffffff810ec0e0
>>> [    0.066936] R10: ffff88011b012000 R11: 0000000000000000 R12: ffff88011b012000
>>> [    0.066939] R13: 0000000000000000 R14: 0000000000000000 R15: ffff88011b012000
>>> [    0.066942] FS:  0000000000000000(0000) GS:ffff88011fa00000(0000) knlGS:0000000000000000
>>> [    0.066946] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    0.066949] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407f0
>>> [    0.066952] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [    0.066955] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [    0.066959] Process watchdog/0 (pid: 11, threadinfo ffff880119b58000, task ffff880119b50000)
>>> [    0.066962] Stack:
>>> [    0.066964]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000 ffffffff81c4d760
>>> [    0.066970]  ffff88011b012000 0000000000000000 ffff880119b59de8 ffffffff8112a6b8
>>> [    0.066975]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
>>> [    0.066980] Call Trace:
>>> [    0.066985]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
>>> [    0.066990]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
>>> [    0.066995]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
>>> [    0.066999]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
>>> [    0.067004]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
>>> [    0.067009]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
>>> [    0.067013]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
>>> [    0.067017]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.067021]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
>>> [    0.067025]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.067027] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85
>>> [    0.067063] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.067067]  RSP <ffff880119b59d58>
>>> [    0.067069] CR2: 0000000000000000
>>> [    0.067077] ---[ end trace 3cbbfd94f0f8f035 ]---
>>> [    0.078194] Disabled fast string operations
>>> [    0.067160] smpboot: Booting Node   0, Processors  #1
>>> [    0.080316] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>> [    0.080332] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.080342] PGD 0
>>> [    0.080347] Oops: 0000 [#2] SMP
>>> [    0.080352] Modules linked in:
>>> [    0.080357] CPU 1
>>> [    0.080363] Pid: 12, comm: watchdog/1 Tainted: G      D      3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
>>> [    0.080374] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.080383] RSP: 0000:ffff880119b79d58  EFLAGS: 00010246
>>> [    0.080388] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
>>> [    0.080394] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
>>> [    0.080399] RBP: ffff880119b79d88 R08: 0000000000000000 R09: ffffffff810ec0e0
>>> [    0.080405] R10: ffff880119b98000 R11: 0000000000017480 R12: ffff880119b98000
>>> [    0.080411] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880119b98000
>>> [    0.080417] FS:  0000000000000000(0000) GS:ffff88011fa40000(0000) knlGS:0000000000000000
>>> [    0.080424] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    0.080428] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407e0
>>> [    0.080433] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [    0.080438] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [    0.080442] Process watchdog/1 (pid: 12, threadinfo ffff880119b78000, task ffff880119b6c590)
>>> [    0.080448] Stack:
>>> [    0.080451]  #2
>>> [    0.080451]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000 ffffffff81c4d760
>>> [    0.080461]  ffff880119b98000 0000000000000001 ffff880119b79de8 ffffffff8112a6b8
>>> [    0.080469]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
>>> [    0.080476] Call Trace:
>>> [    0.080483]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
>>> [    0.080490]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
>>> [    0.080497]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
>>> [    0.080503]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
>>> [    0.080511]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
>>> [    0.080517]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
>>> [    0.080523]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
>>> [    0.080529]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.080536]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
>>> [    0.080541]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.080546] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85
>>> [    0.080598] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.080604]  RSP <ffff880119b79d58>
>>> [    0.080607] CR2: 0000000000000000
>>> [    0.080612] ---[ end trace 3cbbfd94f0f8f036 ]---
>>> [    0.091468] Disabled fast string operations
>>> [    0.093591] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>> [    0.093605] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.093613] PGD 0
>>> [    0.093616] Oops: 0000 [#3] SMP
>>> [    0.093619] Modules linked in:
>>> [    0.093621] CPU 2
>>> [    0.093625] Pid: 17, comm: watchdog/2 Tainted: G      D      3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
>>> [    0.093632] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.093638] RSP: 0000:ffff880119b93d58  EFLAGS: 00010246
>>> [    0.093641] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
>>> [    0.093644] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
>>> [    0.093647] RBP: ffff880119b93d88 R08: 0000000000000000 R09: ffffffff810ec0e0
>>> [    0.093650] R10: ffff880119be0000 R11: 0000000000017480 R12: ffff880119be0000
>>> [    0.093653] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880119be0000
>>> [    0.093656] FS:  0000000000000000(0000) GS:ffff88011fa80000(0000) knlGS:0000000000000000
>>> [    0.093660] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    0.093663] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407e0
>>> [    0.093666] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [    0.093669] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [    0.093673] Process watchdog/2 (pid: 17, threadinfo ffff880119b92000, task ffff880119b84590)
>>> [    0.093676] Stack:
>>> [    0.093678]  ffff88011fa141b0 ffffffff81c4d760
>>> [    0.093680]  #3 0000000000000000 ffffffff81c4d760
>>> [    0.093686]  ffff880119be0000 0000000000000002 ffff880119b93de8 ffffffff8112a6b8
>>> [    0.093691]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
>>> [    0.093697] Call Trace:
>>> [    0.093702]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
>>> [    0.093707]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
>>> [    0.093712]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
>>> [    0.093716]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
>>> [    0.093722]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
>>> [    0.093727]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
>>> [    0.093731]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
>>> [    0.093735]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.093740]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
>>> [    0.093743]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.093746] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85
>>> [    0.093782] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.093786]  RSP <ffff880119b93d58>
>>> [    0.093788] CR2: 0000000000000000
>>> [    0.093792] ---[ end trace 3cbbfd94f0f8f037 ]---
>>> [    0.104707] Disabled fast string operations
>>> [    0.106818] Brought up 4 CPUs
>>> [    0.106827] smpboot: Total of 4 processors activated (12771.75 BogoMIPS)
>>> [    0.106830] BUG: unable to handle kernel NULL pointer dereference at           (null)
>>> [    0.106835] IP: [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.106837] PGD 0
>>> [    0.106839] Oops: 0000 [#4] SMP
>>> [    0.106840] Modules linked in:
>>> [    0.106844] CPU 3
>>> [    0.106844] Pid: 22, comm: watchdog/3 Tainted: G      D      3.8.0-next20130227-1-iniza-small #1 SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH
>>> [    0.106847] RIP: 0010:[<ffffffff8112a292>]  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.106849] RSP: 0000:ffff880119bddd58  EFLAGS: 00010246
>>> [    0.106849] RAX: 0000000000000000 RBX: ffffffff81c4d760 RCX: 0000000000000002
>>> [    0.106850] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff81f56dc0
>>> [    0.106851] RBP: ffff880119bddd88 R08: 0000000000000000 R09: ffffffff810ec0e0
>>> [    0.106851] R10: ffff880119410000 R11: 0000000000017480 R12: ffff880119410000
>>> [    0.106852] R13: 0000000000000000 R14: 0000000000000000 R15: ffff880119410000
>>> [    0.106853] FS:  0000000000000000(0000) GS:ffff88011fac0000(0000) knlGS:0000000000000000
>>> [    0.106854] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [    0.106855] CR2: 0000000000000000 CR3: 0000000001c0d000 CR4: 00000000000407e0
>>> [    0.106856] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> [    0.106857] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> [    0.106858] Process watchdog/3 (pid: 22, threadinfo ffff880119bdc000, task ffff880119bac590)
>>> [    0.106859] Stack:
>>> [    0.106861]  ffff88011fa141b0 ffffffff81c4d760 0000000000000000 ffffffff81c4d760
>>> [    0.106863]  ffff880119410000 0000000000000003 ffff880119bddde8 ffffffff8112a6b8
>>> [    0.106865]  ffff880119b00048 ffff880119b00048 ffffffff810ec0e0 0000000000000000
>>> [    0.106866] Call Trace:
>>> [    0.106869]  [<ffffffff8112a6b8>] perf_event_alloc+0x358/0x490
>>> [    0.106872]  [<ffffffff810ec0e0>] ? touch_nmi_watchdog+0x80/0x80
>>> [    0.106875]  [<ffffffff8112ab1e>] perf_event_create_kernel_counter+0x2e/0xe0
>>> [    0.106877]  [<ffffffff810ec29d>] watchdog_enable+0xfd/0x1e0
>>> [    0.106881]  [<ffffffff810878ec>] smpboot_thread_fn+0x9c/0x170
>>> [    0.106884]  [<ffffffff81087850>] ? lg_global_lock+0x70/0x70
>>> [    0.106887]  [<ffffffff8107fa30>] kthread+0xc0/0xd0
>>> [    0.106889]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.106891]  [<ffffffff816cc36c>] ret_from_fork+0x7c/0xb0
>>> [    0.106893]  [<ffffffff8107f970>] ? flush_kthread_worker+0xb0/0xb0
>>> [    0.106912] Code: 54 49 89 fc 48 c7 c7 c0 6d f5 81 53 48 83 ec 18 e8 e4 a5 f5 ff 41 8b b4 24 a0 00 00 00 41 89 c5 48 8b 05 f2 ca e2 00 89 f2 30 d2 <3b> 10 74 4a 48 c7 c7 80 6d f5 81 e8 ae ab 22 00 48 89 c3 48 85
>>> [    0.106914] RIP  [<ffffffff8112a292>] perf_init_event+0x32/0x100
>>> [    0.106916]  RSP <ffff880119bddd58>
>>> [    0.106916] CR2: 0000000000000000
>>> [    0.106918] ---[ end trace 3cbbfd94f0f8f038 ]---
>>> [    0.110752] devtmpfs: initialized
>>> [    0.111643] EVM: security.selinux
>>> [    0.111646] EVM: security.SMACK64
>>> [    0.111648] EVM: security.capability
>>> [    0.111694] PM: Registering ACPI NVS region [mem 0xdae7f000-0xdaf9efff] (1179648 bytes)
>>> [    0.112433] regulator-dummy: no parameters
>>> [    0.112485] NET: Registered protocol family 16
>>> [    0.112600] ACPI: bus type pci registered
>>> [    0.112662] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
>>> [    0.112668] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
>>> [    0.120122] PCI: Using configuration type 1 for base access
>>> [    0.120981] bio: create slab <bio-0> at 0
>>> [    0.121070] ACPI: Added _OSI(Module Device)
>>> [    0.121074] ACPI: Added _OSI(Processor Device)
>>> [    0.121077] ACPI: Added _OSI(3.0 _SCP Extensions)
>>> [    0.121080] ACPI: Added _OSI(Processor Aggregator Device)
>>> [    0.122612] ACPI: EC: Look up EC in DSDT
>>> [    0.124233] ACPI: Executed 1 blocks of module-level executable AML code
>>> [    0.126557] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
>>> [    0.128396] ACPI: SSDT 00000000dae70718 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
>>> [    0.128804] ACPI: Dynamic OEM Table Load:
>>> [    0.128808] ACPI: SSDT           (null) 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
>>> [    0.129079] ACPI: SSDT 00000000dae71a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
>>> [    0.129511] ACPI: Dynamic OEM Table Load:
>>> [    0.129515] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
>>> [    0.129626] ACPI: SSDT 00000000dae6fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
>>> [    0.130021] ACPI: Dynamic OEM Table Load:
>>> [    0.130025] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
>>> [    0.131452] ACPI: Interpreter enabled
>>> [    0.131460] ACPI: (supports S0 S1ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130117/hwxface-568)
>>> [    0.131478]  S3ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] (20130117/hwxface-568)
>>> [    0.131488]  S5)
>>> [    0.131491] ACPI: Using IOAPIC for interrupt routing
>>> [    0.131529] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>>> [    0.137909] ACPI: Power Resource [FN00] (off)
>>> [    0.137984] ACPI: Power Resource [FN01] (off)
>>> [    0.138056] ACPI: Power Resource [FN02] (off)
>>> [    0.138126] ACPI: Power Resource [FN03] (off)
>>> [    0.138196] ACPI: Power Resource [FN04] (off)
>>> [    0.138792] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
>>> [    0.138957] \_SB_.PCI0:_OSC invalid UUID
>>> [    0.138960] _OSC request data:1 8 1f
>>> [    0.139042] \_SB_.PCI0:_OSC invalid UUID
>>> [    0.139045] _OSC request data:1 1f 1f
>>> [    0.139050] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>>> [    0.139055] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
>>> [    0.139486] PCI host bridge to bus 0000:00
>>> [    0.139491] pci_bus 0000:00: root bus resource [bus 00-3e]
>>> [    0.139495] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
>>> [    0.139499] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
>>> [    0.139502] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
>>> [    0.139506] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
>>> [    0.139509] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
>>> [    0.139520] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
>>> [    0.139619] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
>>> [    0.139633] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf03fffff 64bit]
>>> [    0.139642] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
>>> [    0.139649] pci 0000:00:02.0: reg 20: [io  0x3000-0x303f]
>>> [    0.139762] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
>>> [    0.139789] pci 0000:00:16.0: reg 10: [mem 0xf0705000-0xf070500f 64bit]
>>> [    0.139876] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
>>> [    0.139968] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
>>> [    0.139994] pci 0000:00:1a.0: reg 10: [mem 0xf070a000-0xf070a3ff]
>>> [    0.140099] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
>>> [    0.140160] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
>>> [    0.140180] pci 0000:00:1b.0: reg 10: [mem 0xf0700000-0xf0703fff 64bit]
>>> [    0.140257] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>>> [    0.140288] pci 0000:00:1b.0: System wakeup disabled by ACPI
>>> [    0.140324] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
>>> [    0.140414] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>>> [    0.140447] pci 0000:00:1c.0: System wakeup disabled by ACPI
>>> [    0.140485] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
>>> [    0.140573] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
>>> [    0.140610] pci 0000:00:1c.3: System wakeup disabled by ACPI
>>> [    0.140646] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
>>> [    0.140778] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
>>> [    0.140863] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
>>> [    0.140888] pci 0000:00:1d.0: reg 10: [mem 0xf0709000-0xf07093ff]
>>> [    0.140989] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>>> [    0.141046] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
>>> [    0.141205] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
>>> [    0.141228] pci 0000:00:1f.2: reg 10: [io  0x3088-0x308f]
>>> [    0.141239] pci 0000:00:1f.2: reg 14: [io  0x3094-0x3097]
>>> [    0.141250] pci 0000:00:1f.2: reg 18: [io  0x3080-0x3087]
>>> [    0.141261] pci 0000:00:1f.2: reg 1c: [io  0x3090-0x3093]
>>> [    0.141271] pci 0000:00:1f.2: reg 20: [io  0x3060-0x307f]
>>> [    0.141282] pci 0000:00:1f.2: reg 24: [mem 0xf0708000-0xf07087ff]
>>> [    0.141334] pci 0000:00:1f.2: PME# supported from D3hot
>>> [    0.141398] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
>>> [    0.141418] pci 0000:00:1f.3: reg 10: [mem 0xf0704000-0xf07040ff 64bit]
>>> [    0.141442] pci 0000:00:1f.3: reg 20: [io  0xefa0-0xefbf]
>>> [    0.141734] pci 0000:01:00.0: [8086:0091] type 00 class 0x028000
>>> [    0.141916] pci 0000:01:00.0: reg 10: [mem 0xf0600000-0xf0601fff 64bit]
>>> [    0.142680] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
>>> [    0.142828] pci 0000:01:00.0: System wakeup disabled by ACPI
>>> [    0.148170] pci 0000:00:1c.0: PCI bridge to [bus 01]
>>> [    0.148179] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
>>> [    0.148326] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
>>> [    0.148398] pci 0000:02:00.0: reg 10: [io  0x2000-0x20ff]
>>> [    0.148521] pci 0000:02:00.0: reg 18: [mem 0xf0404000-0xf0404fff 64bit pref]
>>> [    0.148598] pci 0000:02:00.0: reg 20: [mem 0xf0400000-0xf0403fff 64bit pref]
>>> [    0.148935] pci 0000:02:00.0: supports D1 D2
>>> [    0.148938] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
>>> [    0.149057] pci 0000:02:00.0: System wakeup disabled by ACPI
>>> [    0.156090] pci 0000:00:1c.3: PCI bridge to [bus 02]
>>> [    0.156104] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
>>> [    0.156129] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
>>> [    0.156271] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
>>> [    0.156311] pci 0000:03:00.0: reg 10: [mem 0xf0500000-0xf0507fff 64bit]
>>> [    0.156510] pci 0000:03:00.0: PME# supported from D3hot D3cold
>>> [    0.164085] pci 0000:00:1c.4: PCI bridge to [bus 03]
>>> [    0.164104] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
>>> [    0.164144] ACPI _OSC control for PCIe not granted, disabling ASPM
>>> [    0.164856] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
>>> [    0.164917] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>>> [    0.164978] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
>>> [    0.165036] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
>>> [    0.165096] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
>>> [    0.165154] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>>> [    0.165214] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
>>> [    0.165271] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
>>> [    0.165767] ACPI: Enabled 4 GPEs in block 00 to 3F
>>> [    0.165776] acpi root: \_SB_.PCI0 notify handler is installed
>>> [    0.165833] Found 1 acpi root devices
>>> [    0.165873] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
>>> [    0.166009] ACPI: No dock devices found.
>>> [    0.166090] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
>>> [    0.166097] vgaarb: loaded
>>> [    0.166099] vgaarb: bridge control possible 0000:00:02.0
>>> [    0.166252] SCSI subsystem initialized
>>> [    0.166255] ACPI: bus type scsi registered
>>> [    0.166301] libata version 3.00 loaded.
>>> [    0.166317] ACPI: bus type usb registered
>>> [    0.166336] usbcore: registered new interface driver usbfs
>>> [    0.166345] usbcore: registered new interface driver hub
>>> [    0.166369] usbcore: registered new device driver usb
>>> [    0.166452] PCI: Using ACPI for IRQ routing
>>> [    0.168127] PCI: pci_cache_line_size set to 64 bytes
>>> [    0.168230] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
>>> [    0.168234] e820: reserve RAM buffer [mem 0xd9c9f000-0xdbffffff]
>>> [    0.168237] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
>>> [    0.168240] e820: reserve RAM buffer [mem 0x11fe00000-0x11fffffff]
>>> [    0.168323] NetLabel: Initializing
>>> [    0.168326] NetLabel:  domain hash size = 128
>>> [    0.168329] NetLabel:  protocols = UNLABELED CIPSOv4
>>> [    0.168341] NetLabel:  unlabeled traffic allowed by default
>>> [    0.168395] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
>>> [    0.168403] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
>>> [    0.171416] Switching to clocksource hpet
>>> [    0.176468] AppArmor: AppArmor Filesystem Enabled
>>> [    0.176497] pnp: PnP ACPI init
>>> [    0.176510] ACPI: bus type pnp registered
>>> [    0.176745] pnp 00:00: [dma 4]
>>> [    0.176847] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
>>> [    0.176869] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
>>> [    0.176958] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
>>> [    0.176995] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
>>> [    0.177038] system 00:04: [io  0x0680-0x069f] has been reserved
>>> [    0.177043] system 00:04: [io  0x1000-0x100f] has been reserved
>>> [    0.177046] system 00:04: [io  0x5000-0x5003] has been reserved
>>> [    0.177050] system 00:04: [io  0xffff] has been reserved
>>> [    0.177053] system 00:04: [io  0x0400-0x0453] has been reserved
>>> [    0.177056] system 00:04: [io  0x0458-0x047f] has been reserved
>>> [    0.177060] system 00:04: [io  0x0500-0x057f] has been reserved
>>> [    0.177063] system 00:04: [io  0x0a00-0x0a0f] has been reserved
>>> [    0.177067] system 00:04: [io  0x164e-0x164f] has been reserved
>>> [    0.177070] system 00:04: [io  0x5000-0x500f] could not be reserved
>>> [    0.177075] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
>>> [    0.177102] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
>>> [    0.177147] system 00:06: [io  0x0454-0x0457] has been reserved
>>> [    0.177152] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
>>> [    0.177184] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
>>> [    0.177227] pnp 00:08: Plug and Play ACPI device, IDs ETD0b00 SYN0002 PNP0f13 (active)
>>> [    0.177387] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
>>> [    0.177392] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
>>> [    0.177396] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
>>> [    0.177399] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
>>> [    0.177403] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
>>> [    0.177406] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
>>> [    0.177412] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
>>> [    0.177416] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
>>> [    0.177420] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
>>> [    0.177424] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
>>> [    0.177428] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
>>> [    0.177779] pnp 00:0a: can't evaluate _CRS: 12311
>>> [    0.177879] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
>>> [    0.177906] pnp: PnP ACPI: found 11 devices
>>> [    0.177909] ACPI: ACPI bus type pnp unregistered
>>> [    0.184420] pci 0000:00:1c.0: PCI bridge to [bus 01]
>>> [    0.184430] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
>>> [    0.184443] pci 0000:00:1c.3: PCI bridge to [bus 02]
>>> [    0.184448] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
>>> [    0.184459] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
>>> [    0.184468] pci 0000:00:1c.4: PCI bridge to [bus 03]
>>> [    0.184476] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
>>> [    0.184631] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
>>> [    0.184635] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
>>> [    0.184638] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
>>> [    0.184642] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
>>> [    0.184645] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
>>> [    0.184649] pci_bus 0000:01: resource 1 [mem 0xf0600000-0xf06fffff]
>>> [    0.184652] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
>>> [    0.184656] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
>>> [    0.184660] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
>>> [    0.184694] NET: Registered protocol family 2
>>> [    0.184843] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
>>> [    0.184996] TCP bind hash table entries: 32768 (order: 7, 524288 bytes)
>>> [    0.185097] TCP: Hash tables configured (established 32768 bind 32768)
>>> [    0.185128] TCP: reno registered
>>> [    0.185139] UDP hash table entries: 2048 (order: 4, 65536 bytes)
>>> [    0.185159] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
>>> [    0.185228] NET: Registered protocol family 1
>>> [    0.185243] pci 0000:00:02.0: Boot video device
>>> [    0.185596] PCI: CLS 64 bytes, default 64
>>> [    0.185635] Trying to unpack rootfs image as initramfs...
>>> [    0.250180] Freeing initrd memory: 3204k freed
>>> [    0.250863] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>>> [    0.250872] software IO TLB [mem 0xd5c9f000-0xd9c9f000] (64MB) mapped at [ffff8800d5c9f000-ffff8800d9c9efff]
>>> [    0.251084] Scanning for low memory corruption every 60 seconds
>>> [    0.251320] Initialise system trusted keyring
>>> [    0.251364] audit: initializing netlink socket (disabled)
>>> [    0.251395] type=2000 audit(1361966129.248:1): initialized
>>> [    0.282361] bounce pool size: 64 pages
>>> [    0.282373] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>>> [    0.283721] VFS: Disk quotas dquot_6.5.2
>>> [    0.283762] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>>> [    0.284208] fuse init (API version 7.21)
>>> [    0.284277] msgmni has been set to 7688
>>> [    0.284734] Key type asymmetric registered
>>> [    0.284740] Asymmetric key parser 'x509' registered
>>> [    0.284780] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
>>> [    0.284812] io scheduler noop registered
>>> [    0.284816] io scheduler deadline registered (default)
>>> [    0.284823] io scheduler cfq registered
>>> [    0.285032] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>>> [    0.285047] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>> [    0.285087] intel_idle: MWAIT substates: 0x21120
>>> [    0.285090] intel_idle: v0.4 model 0x2A
>>> [    0.285092] intel_idle: lapic_timer_reliable_states 0xffffffff
>>> [    0.285529] ACPI: AC Adapter [ADP1] (on-line)
>>> [    0.285591] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
>>> [    0.285609] ACPI: Lid Switch [LID0]
>>> [    0.285644] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
>>> [    0.285651] ACPI: Power Button [PWRB]
>>> [    0.285680] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
>>> [    0.285685] ACPI: Power Button [PWRF]
>>> [    0.285734] ACPI: Fan [FAN0] (off)
>>> [    0.285758] ACPI: Fan [FAN1] (off)
>>> [    0.285780] ACPI: Fan [FAN2] (off)
>>> [    0.285806] ACPI: Fan [FAN3] (off)
>>> [    0.285827] ACPI: Fan [FAN4] (off)
>>> [    0.285872] ACPI: Requesting acpi_cpufreq
>>> [    0.289998] thermal LNXTHERM:00: registered as thermal_zone0
>>> [    0.290003] ACPI: Thermal Zone [TZ00] (63 C)
>>> [    0.290193] thermal LNXTHERM:01: registered as thermal_zone1
>>> [    0.290197] ACPI: Thermal Zone [TZ01] (30 C)
>>> [    0.290223] GHES: HEST is not enabled!
>>> [    0.290355] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
>>> [    0.293139] Linux agpgart interface v0.103
>>> [    0.294238] brd: module loaded
>>> [    0.294802] loop: module loaded
>>> [    0.294893] ahci 0000:00:1f.2: version 3.0
>>> [    0.295021] ahci 0000:00:1f.2: irq 40 for MSI/MSI-X
>>> [    0.295064] ahci: SSS flag set, parallel bus scan disabled
>>> [    0.295122] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
>>> [    0.295128] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst
>>> [    0.295136] ahci 0000:00:1f.2: setting latency timer to 64
>>> [    0.295723] ACPI: Battery Slot [BAT1] (battery present)
>>> [    0.315646] scsi0 : ahci
>>> [    0.315725] scsi1 : ahci
>>> [    0.315785] scsi2 : ahci
>>> [    0.315841] scsi3 : ahci
>>> [    0.315897] scsi4 : ahci
>>> [    0.315956] scsi5 : ahci
>>> [    0.315988] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708100 irq 40
>>> [    0.315994] ata2: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708180 irq 40
>>> [    0.315997] ata3: DUMMY
>>> [    0.316001] ata4: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708280 irq 40
>>> [    0.316006] ata5: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708300 irq 40
>>> [    0.316009] ata6: DUMMY
>>> [    0.316250] libphy: Fixed MDIO Bus: probed
>>> [    0.316322] tun: Universal TUN/TAP device driver, 1.6
>>> [    0.316325] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
>>> [    0.316378] PPP generic driver version 2.4.2
>>> [    0.316433] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>>> [    0.316437] ehci-pci: EHCI PCI platform driver
>>> [    0.316516] ehci-pci 0000:00:1a.0: setting latency timer to 64
>>> [    0.316522] ehci-pci 0000:00:1a.0: EHCI Host Controller
>>> [    0.316529] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
>>> [    0.316546] ehci-pci 0000:00:1a.0: debug port 2
>>> [    0.320435] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
>>> [    0.320454] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf070a000
>>> [    0.331331] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
>>> [    0.331358] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    0.331362] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.331366] usb usb1: Product: EHCI Host Controller
>>> [    0.331369] usb usb1: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small ehci_hcd
>>> [    0.331373] usb usb1: SerialNumber: 0000:00:1a.0
>>> [    0.331496] hub 1-0:1.0: USB hub found
>>> [    0.331502] hub 1-0:1.0: 2 ports detected
>>> [    0.331624] ehci-pci 0000:00:1d.0: setting latency timer to 64
>>> [    0.331630] ehci-pci 0000:00:1d.0: EHCI Host Controller
>>> [    0.331636] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
>>> [    0.331652] ehci-pci 0000:00:1d.0: debug port 2
>>> [    0.335559] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
>>> [    0.335576] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf0709000
>>> [    0.347324] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>>> [    0.347355] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    0.347359] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.347363] usb usb2: Product: EHCI Host Controller
>>> [    0.347366] usb usb2: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small ehci_hcd
>>> [    0.347370] usb usb2: SerialNumber: 0000:00:1d.0
>>> [    0.347475] hub 2-0:1.0: USB hub found
>>> [    0.347480] hub 2-0:1.0: 2 ports detected
>>> [    0.347541] ehci-platform: EHCI generic platform driver
>>> [    0.347550] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>>> [    0.347565] uhci_hcd: USB Universal Host Controller Interface driver
>>> [    0.347633] xhci_hcd 0000:03:00.0: xHCI Host Controller
>>> [    0.347639] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
>>> [    0.357325] xhci_hcd 0000:03:00.0: irq 16, io mem 0xf0500000
>>> [    0.357394] xhci_hcd 0000:03:00.0: irq 41 for MSI/MSI-X
>>> [    0.357401] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
>>> [    0.357408] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
>>> [    0.357415] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
>>> [    0.357424] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
>>> [    0.357532] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    0.357536] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.357540] usb usb3: Product: xHCI Host Controller
>>> [    0.357543] usb usb3: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small xhci_hcd
>>> [    0.357547] usb usb3: SerialNumber: 0000:03:00.0
>>> [    0.357616] xHCI xhci_add_endpoint called for root hub
>>> [    0.357620] xHCI xhci_check_bandwidth called for root hub
>>> [    0.357643] hub 3-0:1.0: USB hub found
>>> [    0.357654] hub 3-0:1.0: 2 ports detected
>>> [    0.357711] xhci_hcd 0000:03:00.0: xHCI Host Controller
>>> [    0.357716] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
>>> [    0.357752] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
>>> [    0.357756] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.357760] usb usb4: Product: xHCI Host Controller
>>> [    0.357763] usb usb4: Manufacturer: Linux 3.8.0-next20130227-1-iniza-small xhci_hcd
>>> [    0.357767] usb usb4: SerialNumber: 0000:03:00.0
>>> [    0.357825] xHCI xhci_add_endpoint called for root hub
>>> [    0.357828] xHCI xhci_check_bandwidth called for root hub
>>> [    0.357847] hub 4-0:1.0: USB hub found
>>> [    0.357856] hub 4-0:1.0: 2 ports detected
>>> [    0.357993] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:EPAD] at 0x60,0x64 irq 1,12
>>> [    0.365250] serio: i8042 KBD port at 0x60,0x64 irq 1
>>> [    0.365258] serio: i8042 AUX port at 0x60,0x64 irq 12
>>> [    0.365372] mousedev: PS/2 mouse device common for all mice
>>> [    0.365754] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
>>> [    0.365785] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
>>> [    0.365844] device-mapper: uevent: version 1.0.3
>>> [    0.365911] device-mapper: ioctl: 4.24.0-ioctl (2013-01-15) initialised: dm-devel@redhat.com
>>> [    0.365925] Intel P-state driver initializing.
>>> [    0.365943] Intel pstate controlling: cpu 0
>>> [    0.365961] Intel pstate controlling: cpu 1
>>> [    0.365977] Intel pstate controlling: cpu 2
>>> [    0.365990] Intel pstate controlling: cpu 3
>>> [    0.366090] cpuidle: using governor ladder
>>> [    0.366198] cpuidle: using governor menu
>>> [    0.366204] ledtrig-cpu: registered to indicate activity on CPUs
>>> [    0.366207] EFI Variables Facility v0.08 2004-May-17
>>> [    0.366328] ashmem: initialized
>>> [    0.366436] TCP: cubic registered
>>> [    0.366528] NET: Registered protocol family 10
>>> [    0.366690] NET: Registered protocol family 17
>>> [    0.366702] Key type dns_resolver registered
>>> [    0.366945] PM: Hibernation image not present or could not be loaded.
>>> [    0.366949] Loading compiled-in X.509 certificates
>>> [    0.368006] Loaded X.509 cert 'Magrathea: Glacier signing key: 25f3fa297967d1c843028ae60b1618d1f11e8b4a'
>>> [    0.368019] registered taskstats version 1
>>> [    0.370457] Key type trusted registered
>>> [    0.372904] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
>>> [    0.374198] Key type encrypted registered
>>> [    0.379807] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
>>> [    0.379821] EDD information not available.
>>> [    0.635232] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [    0.636511] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
>>> [    0.636532] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>> [    0.637898] ata1.00: configured for UDMA/133
>>> [    0.638373] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54505 GG2O PQ: 0 ANSI: 5
>>> [    0.638759] sd 0:0:0:0: Attached scsi generic sg0 type 0
>>> [    0.638767] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
>>> [    0.638776] sd 0:0:0:0: [sda] 4096-byte physical blocks
>>> [    0.639009] sd 0:0:0:0: [sda] Write Protect is off
>>> [    0.639022] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>> [    0.639202] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>> [    0.643174] usb 1-1: new high-speed USB device number 2 using ehci-pci
>>> [    0.655363]  sda: sda1 sda2 sda3
>>> [    0.656561] sd 0:0:0:0: [sda] Attached SCSI disk
>>> [    0.775682] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
>>> [    0.775701] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    0.776136] hub 1-1:1.0: USB hub found
>>> [    0.776397] hub 1-1:1.0: 6 ports detected
>>> [    0.887050] usb 2-1: new high-speed USB device number 2 using ehci-pci
>>> [    0.955009] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [    0.955585] ata2.00: ATA-8: SanDisk iSSD P4 16GB, SSD 9.14, max UDMA/133
>>> [    0.955605] ata2.00: 31277232 sectors, multi 1: LBA48
>>> [    0.956258] ata2.00: configured for UDMA/133
>>> [    0.956727] scsi 1:0:0:0: Direct-Access     ATA      SanDisk iSSD P4  SSD  PQ: 0 ANSI: 5
>>> [    0.957078] sd 1:0:0:0: Attached scsi generic sg1 type 0
>>> [    0.957117] sd 1:0:0:0: [sdb] 31277232 512-byte logical blocks: (16.0 GB/14.9 GiB)
>>> [    0.957561] sd 1:0:0:0: [sdb] Write Protect is off
>>> [    0.957578] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>>> [    0.957807] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>> [    0.958851]  sdb: sdb1 sdb2
>>> [    0.959564] sd 1:0:0:0: [sdb] Attached SCSI disk
>>> [    1.019274] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
>>> [    1.019295] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    1.019803] hub 2-1:1.0: USB hub found
>>> [    1.019900] hub 2-1:1.0: 6 ports detected
>>> [    1.090991] usb 1-1.2: new low-speed USB device number 3 using ehci-pci
>>> [    1.189133] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
>>> [    1.189153] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>> [    1.189165] usb 1-1.2: Product: USB-PS/2 Optical Mouse
>>> [    1.189172] usb 1-1.2: Manufacturer: Logitech
>>> [    1.246792] tsc: Refined TSC clocksource calibration: 1596.373 MHz
>>> [    1.246815] Switching to clocksource tsc
>>> [    1.258878] usb 1-1.4: new high-speed USB device number 4 using ehci-pci
>>> [    1.274775] ata4: SATA link down (SStatus 0 SControl 300)
>>> [    1.511002] usb 1-1.4: New USB device found, idVendor=2232, idProduct=1018
>>> [    1.511022] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>> [    1.511033] usb 1-1.4: Product: WebCam SC-13HDL11431N
>>> [    1.511041] usb 1-1.4: Manufacturer: 123
>>> [    1.594549] ata5: SATA link down (SStatus 0 SControl 300)
>>> [    1.597325] Freeing unused kernel memory: 1252k freed
>>> [    1.597710] Write protecting the kernel read-only data: 12288k
>>> [    1.605281] Freeing unused kernel memory: 1204k freed
>>> [    1.609820] Freeing unused kernel memory: 1104k freed
>>> [    1.646706] udevd[120]: starting version 175
>>> [    1.689068] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
>>> [    1.689398] r8169 0000:02:00.0: irq 46 for MSI/MSI-X
>>> [    1.689966] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000666000, e8:03:9a:36:17:a9, XID 0c900800 IRQ 46
>>> [    1.689978] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
>>> [    1.693405] hidraw: raw HID events driver (C) Jiri Kosina
>>> [    1.700716] usbcore: registered new interface driver usbhid
>>> [    1.700726] usbhid: USB HID core driver
>>> [    1.754478] usb 2-1.5: new full-speed USB device number 3 using ehci-pci
>>> [    1.755770] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
>>> [    1.755944] hid-generic 0003:046D:C00E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.2/input0
>>> [    1.850176] usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
>>> [    1.850204] usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    2.506456] EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: (null)
>>> [   25.247407] Adding 262140k swap on /host/ubuntu/disks/swap.disk.  Priority:-1 extents:1 across:262140k
>>> [   25.269391] EXT4-fs (loop0): re-mounted. Opts: errors=remount-ro
>>> [   25.284955] udevd[599]: starting version 175
>>> [   25.406818] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130117/utaddress-251)
>>> [   25.406828] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   25.406834] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
>>> [   25.406838] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   25.406840] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
>>> [   25.406845] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   25.406847] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130117/utaddress-251)
>>> [   25.406851] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   25.406853] lpc_ich: Resource conflict(s) found affecting gpio_ich
>>> [   25.698835] mei 0000:00:16.0: setting latency timer to 64
>>> [   25.698918] mei 0000:00:16.0: irq 47 for MSI/MSI-X
>>> [   25.773719] Bluetooth: Core ver 2.16
>>> [   25.773740] NET: Registered protocol family 31
>>> [   25.773742] Bluetooth: HCI device and connection manager initialized
>>> [   25.773751] Bluetooth: HCI socket layer initialized
>>> [   25.773755] Bluetooth: L2CAP socket layer initialized
>>> [   25.773770] Bluetooth: SCO socket layer initialized
>>> [   25.868459] lp: driver loaded but no devices found
>>> [   25.933043] wmi: Mapper loaded
>>> [   25.935824] samsung_laptop: detected SABI interface: SwSmi@
>>> [   25.935829] samsung_laptop: Backlight controlled by ACPI video driver
>>> [   26.011782] Linux video capture interface: v2.00
>>> [   26.013652] cfg80211: Calling CRDA to update world regulatory domain
>>> [   26.023551] usbcore: registered new interface driver btusb
>>> [   26.035421] cfg80211: World regulatory domain updated:
>>> [   26.035426] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>> [   26.035429] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> [   26.035431] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>> [   26.035434] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>> [   26.035436] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> [   26.035438] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> [   26.073528] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x28
>>> [   26.283433] Bluetooth: RFCOMM TTY layer initialized
>>> [   26.283448] Bluetooth: RFCOMM socket layer initialized
>>> [   26.283450] Bluetooth: RFCOMM ver 1.11
>>> [   26.328213] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>>> [   26.328218] Bluetooth: BNEP filters: protocol multicast
>>> [   26.328227] Bluetooth: BNEP socket layer initialized
>>> [   26.334762] type=1400 audit(1361962555.347:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=783 comm="apparmor_parser"
>>> [   26.334835] type=1400 audit(1361962555.347:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=783 comm="apparmor_parser"
>>> [   26.334896] type=1400 audit(1361962555.347:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=783 comm="apparmor_parser"
>>> [   26.335569] type=1400 audit(1361962555.347:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=688 comm="apparmor_parser"
>>> [   26.335623] type=1400 audit(1361962555.347:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=688 comm="apparmor_parser"
>>> [   26.335665] type=1400 audit(1361962555.347:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=688 comm="apparmor_parser"
>>> [   26.370321] init: failsafe main process (935) killed by TERM signal
>>> [   26.527436] ppdev: user-space parallel port driver
>>> [   26.661985] [drm] Initialized drm 1.1.0 20060810
>>> [   26.676763] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x28
>>> [   26.679380] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x28
>>> [   26.688580] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x28
>>> [   26.691620] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>>> [   26.967752] Intel(R) Wireless WiFi driver for Linux, in-tree:d
>>> [   26.967756] Copyright(c) 2003-2013 Intel Corporation
>>> [   26.968181] iwlwifi 0000:01:00.0: irq 48 for MSI/MSI-X
>>> [   26.968640] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1
>>> [   27.279901] type=1400 audit(1361962556.291:8): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1052 comm="apparmor_parser"
>>> [   27.280023] type=1400 audit(1361962556.291:9): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=1052 comm="apparmor_parser"
>>> [   27.309023] uvcvideo: Found UVC 1.00 device WebCam SC-13HDL11431N (2232:1018)
>>> [   27.331351] input: WebCam SC-13HDL11431N as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input5
>>> [   27.331442] usbcore: registered new interface driver uvcvideo
>>> [   27.331445] USB Video Class driver (1.1.1)
>>> [   27.421856] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x450f00)
>>> [   27.436940] psmouse serio1: elantech: Synaptics capabilities query result 0x08, 0x17, 0x0c.
>>> [   27.514459] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input6
>>> [   27.584689] [drm] Memory usable by graphics device = 2048M
>>> [   27.584699] i915 0000:00:02.0: setting latency timer to 64
>>> [   27.639750] i915 0000:00:02.0: irq 49 for MSI/MSI-X
>>> [   27.639767] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>>> [   27.639769] [drm] Driver supports precise vblank timestamp query.
>>> [   27.639815] type=1400 audit(1361962556.651:10): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1077 comm="apparmor_parser"
>>> [   27.639836] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
>>> [   27.650965] [drm] Wrong MCH_SSKPD value: 0x16040307
>>> [   27.650969] [drm] This can cause pipe underruns and display issues.
>>> [   27.650971] [drm] Please upgrade your BIOS to fix this.
>>> [   27.666268] fbcon: inteldrmfb (fb0) is primary device
>>> [   27.706167] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
>>> [   27.706169] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
>>> [   27.706170] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
>>> [   27.706171] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TESTMODE enabled
>>> [   27.706173] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P disabled
>>> [   27.706175] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6230 AGN, REV=0xB0
>>> [   27.706227] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
>>> [   27.808223] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
>>> [   27.821278] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
>>> [   27.838245] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
>>> [   28.033463] type=1400 audit(1361962557.047:11): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1078 comm="apparmor_parser"
>>> [   28.216525] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
>>> [   28.223155] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
>>> [   28.416827] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> [   28.476537] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
>>> [   28.483166] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
>>> [   28.627398] Console: switching to colour frame buffer device 170x48
>>> [   28.631954] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
>>> [   28.631957] i915 0000:00:02.0: registered panic notifier
>>> [   28.644643] acpi device:32: registered as cooling_device9
>>> [   28.644898] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
>>> [   28.645076] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input7
>>> [   28.646945] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>>> [   28.647319] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
>>> [   28.682854] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> [   28.703060] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
>>> [   28.707420] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
>>> [   28.707594] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
>>> [   28.767390] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
>>> [   34.458348] audit_printk_skb: 21 callbacks suppressed
>>> [   34.458352] type=1400 audit(1361962563.475:19): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=1079 comm="apparmor_parser"
>>> [   34.458945] type=1400 audit(1361962563.475:20): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince//launchpad_integration" pid=1079 comm="apparmor_parser"
>>> [   34.459117] type=1400 audit(1361962563.475:21): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince//sanitized_helper" pid=1079 comm="apparmor_parser"
>>> [   34.459710] type=1400 audit(1361962563.479:22): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=1079 comm="apparmor_parser"
>>> [   34.460112] type=1400 audit(1361962563.479:23): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer//launchpad_integration" pid=1079 comm="apparmor_parser"
>>> [   34.460288] type=1400 audit(1361962563.479:24): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer//sanitized_helper" pid=1079 comm="apparmor_parser"
>>> [   34.460639] type=1400 audit(1361962563.479:25): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=1079 comm="apparmor_parser"
>>> [   34.460901] type=1400 audit(1361962563.479:26): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer//sanitized_helper" pid=1079 comm="apparmor_parser"
>>> [   34.572969] init: alsa-restore main process (1207) terminated with status 99
>>> [   34.857028] wlan0: authenticate with 00:04:0e:e4:00:3d
>>> [   34.864996] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
>>> [   34.866876] wlan0: authenticated
>>> [   34.866898] iwlwifi 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
>>> [   34.866901] iwlwifi 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
>>> [   34.870896] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
>>> [   34.874557] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
>>> [   34.882447] wlan0: associated
>>> [   34.882467] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>>> [   35.047985] init: plymouth-stop pre-start process (1446) terminated with status 1
>>> [   50.222130] usb 2-1.5: USB disconnect, device number 3
>>> [   63.855615] firefox[2291]: segfault at 7fab5ea66548 ip 00007fab5ea47362 sp 00007fffc1b3ab38 error 7 in libGL.so.1.2.0[7fab5ea47000+7c000]
>>
>>
>>
>> --
>> Regards/Gruss,
>>     Boris.
>>
>> Sent from a fat crate under my desk. Formatting is fine.
>> --

--f46d044282c41dc4f504d6b47924
Content-Type: text/plain; charset=US-ASCII; 
	name="dmesg_3.8.0-next20130227-3-iniza-small.txt"
Content-Disposition: attachment; 
	filename="dmesg_3.8.0-next20130227-3-iniza-small.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdoi1ow41

WyAgICAwLjAwMDAwMF0gSW5pdGlhbGl6aW5nIGNncm91cCBzdWJzeXMgY3B1c2V0ClsgICAgMC4w
MDAwMDBdIEluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIGNwdQpbICAgIDAuMDAwMDAwXSBMaW51
eCB2ZXJzaW9uIDMuOC4wLW5leHQyMDEzMDIyNy0zLWluaXphLXNtYWxsIChzZWRhdC5kaWxla0Bn
bWFpbC5jb21AZmFtYm94KSAoZ2NjIHZlcnNpb24gNC42LjMgKFVidW50dS9MaW5hcm8gNC42LjMt
MXVidW50dTUpICkgIzEgU01QIFdlZCBGZWIgMjcgMTM6NTg6MzEgQ0VUIDIwMTMKWyAgICAwLjAw
MDAwMF0gQ29tbWFuZCBsaW5lOiBCT09UX0lNQUdFPS9ib290L3ZtbGludXotMy44LjAtbmV4dDIw
MTMwMjI3LTMtaW5pemEtc21hbGwgcm9vdD1VVUlEPTAwMUFBREE2MUFBRDk5NjQgbG9vcD0vdWJ1
bnR1L2Rpc2tzL3Jvb3QuZGlzayBybwpbICAgIDAuMDAwMDAwXSBLRVJORUwgc3VwcG9ydGVkIGNw
dXM6ClsgICAgMC4wMDAwMDBdICAgSW50ZWwgR2VudWluZUludGVsClsgICAgMC4wMDAwMDBdICAg
QU1EIEF1dGhlbnRpY0FNRApbICAgIDAuMDAwMDAwXSAgIENlbnRhdXIgQ2VudGF1ckhhdWxzClsg
ICAgMC4wMDAwMDBdIERpc2FibGVkIGZhc3Qgc3RyaW5nIG9wZXJhdGlvbnMKWyAgICAwLjAwMDAw
MF0gZTgyMDogQklPUy1wcm92aWRlZCBwaHlzaWNhbCBSQU0gbWFwOgpbICAgIDAuMDAwMDAwXSBC
SU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDAwMDAwMDAwLTB4MDAwMDAwMDAwMDA5ZDdmZl0gdXNh
YmxlClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwMDAwOWQ4MDAtMHgw
MDAwMDAwMDAwMDlmZmZmXSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0g
MHgwMDAwMDAwMDAwMGUwMDAwLTB4MDAwMDAwMDAwMDBmZmZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAw
MDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDAwMDEwMDAwMC0weDAwMDAwMDAwMWZmZmZm
ZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDIwMDAw
MDAwLTB4MDAwMDAwMDAyMDFmZmZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIw
OiBbbWVtIDB4MDAwMDAwMDAyMDIwMDAwMC0weDAwMDAwMDAwM2ZmZmZmZmZdIHVzYWJsZQpbICAg
IDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMDQwMDAwMDAwLTB4MDAwMDAwMDA0
MDFmZmZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAw
MDA0MDIwMDAwMC0weDAwMDAwMDAwZDljOWVmZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSBCSU9T
LWU4MjA6IFttZW0gMHgwMDAwMDAwMGQ5YzlmMDAwLTB4MDAwMDAwMDBkYWU3ZWZmZl0gcmVzZXJ2
ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBkYWU3ZjAwMC0weDAw
MDAwMDAwZGFmOWVmZmZdIEFDUEkgTlZTClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAw
eDAwMDAwMDAwZGFmOWYwMDAtMHgwMDAwMDAwMGRhZmZlZmZmXSBBQ1BJIGRhdGEKWyAgICAwLjAw
MDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBkYWZmZjAwMC0weDAwMDAwMDAwZGFmZmZm
ZmZdIHVzYWJsZQpbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAwMDAwMGRiMDAw
MDAwLTB4MDAwMDAwMDBkZjlmZmZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gQklPUy1lODIw
OiBbbWVtIDB4MDAwMDAwMDBmODAwMDAwMC0weDAwMDAwMDAwZmJmZmZmZmZdIHJlc2VydmVkClsg
ICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwZmVjMDAwMDAtMHgwMDAwMDAw
MGZlYzAwZmZmXSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFttZW0gMHgwMDAw
MDAwMGZlZDA4MDAwLTB4MDAwMDAwMDBmZWQwOGZmZl0gcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0g
QklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBmZWQxMDAwMC0weDAwMDAwMDAwZmVkMTlmZmZdIHJl
c2VydmVkClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAwZmVkMWMwMDAt
MHgwMDAwMDAwMGZlZDFmZmZmXSByZXNlcnZlZApbICAgIDAuMDAwMDAwXSBCSU9TLWU4MjA6IFtt
ZW0gMHgwMDAwMDAwMGZlZTAwMDAwLTB4MDAwMDAwMDBmZWUwMGZmZl0gcmVzZXJ2ZWQKWyAgICAw
LjAwMDAwMF0gQklPUy1lODIwOiBbbWVtIDB4MDAwMDAwMDBmZmQ4MDAwMC0weDAwMDAwMDAwZmZm
ZmZmZmZdIHJlc2VydmVkClsgICAgMC4wMDAwMDBdIEJJT1MtZTgyMDogW21lbSAweDAwMDAwMDAx
MDAwMDAwMDAtMHgwMDAwMDAwMTFmZGZmZmZmXSB1c2FibGUKWyAgICAwLjAwMDAwMF0gTlggKEV4
ZWN1dGUgRGlzYWJsZSkgcHJvdGVjdGlvbjogYWN0aXZlClsgICAgMC4wMDAwMDBdIFNNQklPUyAy
LjYgcHJlc2VudC4KWyAgICAwLjAwMDAwMF0gRE1JOiBTQU1TVU5HIEVMRUNUUk9OSUNTIENPLiwg
TFRELiA1MzBVM0JJLzUzMFU0QkkvNTMwVTRCSC81MzBVM0JJLzUzMFU0QkkvNTMwVTRCSCwgQklP
UyAxMlhLIDAxLzE4LzIwMTMKWyAgICAwLjAwMDAwMF0gZTgyMDogdXBkYXRlIFttZW0gMHgwMDAw
MDAwMC0weDAwMDAwZmZmXSB1c2FibGUgPT0+IHJlc2VydmVkClsgICAgMC4wMDAwMDBdIGU4MjA6
IHJlbW92ZSBbbWVtIDB4MDAwYTAwMDAtMHgwMDBmZmZmZl0gdXNhYmxlClsgICAgMC4wMDAwMDBd
IE5vIEFHUCBicmlkZ2UgZm91bmQKWyAgICAwLjAwMDAwMF0gZTgyMDogbGFzdF9wZm4gPSAweDEx
ZmUwMCBtYXhfYXJjaF9wZm4gPSAweDQwMDAwMDAwMApbICAgIDAuMDAwMDAwXSBNVFJSIGRlZmF1
bHQgdHlwZTogdW5jYWNoYWJsZQpbICAgIDAuMDAwMDAwXSBNVFJSIGZpeGVkIHJhbmdlcyBlbmFi
bGVkOgpbICAgIDAuMDAwMDAwXSAgIDAwMDAwLTlGRkZGIHdyaXRlLWJhY2sKWyAgICAwLjAwMDAw
MF0gICBBMDAwMC1CRkZGRiB1bmNhY2hhYmxlClsgICAgMC4wMDAwMDBdICAgQzAwMDAtRkZGRkYg
d3JpdGUtcHJvdGVjdApbICAgIDAuMDAwMDAwXSBNVFJSIHZhcmlhYmxlIHJhbmdlcyBlbmFibGVk
OgpbICAgIDAuMDAwMDAwXSAgIDAgYmFzZSAwMDAwMDAwMDAgbWFzayBGODAwMDAwMDAgd3JpdGUt
YmFjawpbICAgIDAuMDAwMDAwXSAgIDEgYmFzZSAwODAwMDAwMDAgbWFzayBGQzAwMDAwMDAgd3Jp
dGUtYmFjawpbICAgIDAuMDAwMDAwXSAgIDIgYmFzZSAwQzAwMDAwMDAgbWFzayBGRTAwMDAwMDAg
d3JpdGUtYmFjawpbICAgIDAuMDAwMDAwXSAgIDMgYmFzZSAwREMwMDAwMDAgbWFzayBGRkMwMDAw
MDAgdW5jYWNoYWJsZQpbICAgIDAuMDAwMDAwXSAgIDQgYmFzZSAwREIwMDAwMDAgbWFzayBGRkYw
MDAwMDAgdW5jYWNoYWJsZQpbICAgIDAuMDAwMDAwXSAgIDUgYmFzZSAxMDAwMDAwMDAgbWFzayBG
RTAwMDAwMDAgd3JpdGUtYmFjawpbICAgIDAuMDAwMDAwXSAgIDYgYmFzZSAxMUZFMDAwMDAgbWFz
ayBGRkZFMDAwMDAgdW5jYWNoYWJsZQpbICAgIDAuMDAwMDAwXSAgIDcgYmFzZSAwRkZDMDAwMDAg
bWFzayBGRkZDMDAwMDAgd3JpdGUtcHJvdGVjdApbICAgIDAuMDAwMDAwXSAgIDggZGlzYWJsZWQK
WyAgICAwLjAwMDAwMF0gICA5IGRpc2FibGVkClsgICAgMC4wMDAwMDBdIHg4NiBQQVQgZW5hYmxl
ZDogY3B1IDAsIG9sZCAweDcwNDA2MDAwNzA0MDYsIG5ldyAweDcwMTA2MDAwNzAxMDYKWyAgICAw
LjAwMDAwMF0gZTgyMDogbGFzdF9wZm4gPSAweGRiMDAwIG1heF9hcmNoX3BmbiA9IDB4NDAwMDAw
MDAwClsgICAgMC4wMDAwMDBdIGZvdW5kIFNNUCBNUC10YWJsZSBhdCBbbWVtIDB4MDAwZjAwZTAt
MHgwMDBmMDBlZl0gbWFwcGVkIGF0IFtmZmZmODgwMDAwMGYwMGUwXQpbICAgIDAuMDAwMDAwXSBT
Y2FubmluZyAxIGFyZWFzIGZvciBsb3cgbWVtb3J5IGNvcnJ1cHRpb24KWyAgICAwLjAwMDAwMF0g
QUNQSTogUlNEUCAwMDAwMDAwMDAwMGYwMTAwIDAwMDI0ICh2MDIgU0VDQ1NEKQpbICAgIDAuMDAw
MDAwXSBBQ1BJOiBYU0RUIDAwMDAwMDAwZGFmZmUxNzAgMDAwOEMgKHYwMSBTRUNDU0QgTEg0M1NU
QVIgMDAwMDAwMDIgUFRFQyAwMDAwMDAwMikKWyAgICAwLjAwMDAwMF0gQUNQSTogRkFDUCAwMDAw
MDAwMGRhZmVmMDAwIDAwMTBDICh2MDUgU0VDQ1NEIExINDNTVEFSIDAwMDAwMDAyIFBUTCAgMDAw
MDAwMDIpClsgICAgMC4wMDAwMDBdIEFDUEk6IERTRFQgMDAwMDAwMDBkYWZmMjAwMCAwODNBQyAo
djAyIFNFQ0NTRCAgU05CLUNQVCAwMDAwMDAwMCBJTlRMIDIwMDYxMTA5KQpbICAgIDAuMDAwMDAw
XSBBQ1BJOiBGQUNTIDAwMDAwMDAwZGFmNDcwMDAgMDAwNDAKWyAgICAwLjAwMDAwMF0gQUNQSTog
U0xJQyAwMDAwMDAwMGRhZmZkMDAwIDAwMTc2ICh2MDEgU0VDQ1NEIExINDNTVEFSIDAwMDAwMDAy
IFBURUMgMDAwMDAwMDEpClsgICAgMC4wMDAwMDBdIEFDUEk6IFNTRFQgMDAwMDAwMDBkYWZmYjAw
MCAwMTA2OCAodjAxIFNFQ0NTRCBQdGlkRGV2YyAwMDAwMTAwMCBJTlRMIDIwMDYxMTA5KQpbICAg
IDAuMDAwMDAwXSBBQ1BJOiBBU0YhIDAwMDAwMDAwZGFmZjEwMDAgMDAwQTUgKHYzMiBTRUNDU0Qg
TEg0M1NUQVIgMDAwMDAwMDIgUFRMICAwMDAwMDAwMikKWyAgICAwLjAwMDAwMF0gQUNQSTogSFBF
VCAwMDAwMDAwMGRhZmVlMDAwIDAwMDM4ICh2MDEgU0VDQ1NEIExINDNTVEFSIDAwMDAwMDAyIFBU
TCAgMDAwMDAwMDIpClsgICAgMC4wMDAwMDBdIEFDUEk6IEFQSUMgMDAwMDAwMDBkYWZlZDAwMCAw
MDA5OCAodjAzIFNFQ0NTRCBMSDQzU1RBUiAwMDAwMDAwMiBQVEwgIDAwMDAwMDAyKQpbICAgIDAu
MDAwMDAwXSBBQ1BJOiBNQ0ZHIDAwMDAwMDAwZGFmZWMwMDAgMDAwM0MgKHYwMSBTRUNDU0QgTEg0
M1NUQVIgMDAwMDAwMDIgUFRMICAwMDAwMDAwMikKWyAgICAwLjAwMDAwMF0gQUNQSTogU1NEVCAw
MDAwMDAwMGRhZmViMDAwIDAwODA0ICh2MDEgIFBtUmVmICBDcHUwSXN0IDAwMDAzMDAwIElOVEwg
MjAwNjExMDkpClsgICAgMC4wMDAwMDBdIEFDUEk6IFNTRFQgMDAwMDAwMDBkYWZlYTAwMCAwMDk5
NiAodjAxICBQbVJlZiAgICBDcHVQbSAwMDAwMzAwMCBJTlRMIDIwMDYxMTA5KQpbICAgIDAuMDAw
MDAwXSBBQ1BJOiBVRUZJIDAwMDAwMDAwZGFmZTkwMDAgMDAwM0UgKHYwMSBTRUNDU0QgTEg0M1NU
QVIgMDAwMDAwMDIgUFRMICAwMDAwMDAwMikKWyAgICAwLjAwMDAwMF0gQUNQSTogVUVGSSAwMDAw
MDAwMGRhZmU4MDAwIDAwMDQyICh2MDEgUFRMICAgICAgQ09NQlVGIDAwMDAwMDAxIFBUTCAgMDAw
MDAwMDEpClsgICAgMC4wMDAwMDBdIEFDUEk6IFVFRkkgMDAwMDAwMDBkYWZlNzAwMCAwMDI2QSAo
djAxIFNFQ0NTRCBMSDQzU1RBUiAwMDAwMDAwMiBQVEwgIDAwMDAwMDAyKQpbICAgIDAuMDAwMDAw
XSBBQ1BJOiBTU0RUIDAwMDAwMDAwZGFmZTYwMDAgMDAwRDAgKHYwMSAgIElmZnMgIElmZnNBc2wg
MDAwMDMwMDAgSU5UTCAyMDA2MTEwOSkKWyAgICAwLjAwMDAwMF0gQUNQSTogTG9jYWwgQVBJQyBh
ZGRyZXNzIDB4ZmVlMDAwMDAKWyAgICAwLjAwMDAwMF0gQmFzZSBtZW1vcnkgdHJhbXBvbGluZSBh
dCBbZmZmZjg4MDAwMDA5NzAwMF0gOTcwMDAgc2l6ZSAyNDU3NgpbICAgIDAuMDAwMDAwXSByZXNl
cnZpbmcgaW5hY2Nlc3NpYmxlIFNOQiBnZnggcGFnZXMKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1v
cnlfbWFwcGluZzogW21lbSAweDAwMDAwMDAwLTB4MDAwZmZmZmZdClsgICAgMC4wMDAwMDBdICBb
bWVtIDB4MDAwMDAwMDAtMHgwMDBmZmZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSBCUksgWzB4
MDFmOGIwMDAsIDB4MDFmOGJmZmZdIFBHVEFCTEUKWyAgICAwLjAwMDAwMF0gQlJLIFsweDAxZjhj
MDAwLCAweDAxZjhjZmZmXSBQR1RBQkxFClsgICAgMC4wMDAwMDBdIEJSSyBbMHgwMWY4ZDAwMCwg
MHgwMWY4ZGZmZl0gUEdUQUJMRQpbICAgIDAuMDAwMDAwXSBpbml0X21lbW9yeV9tYXBwaW5nOiBb
bWVtIDB4MTFmYzAwMDAwLTB4MTFmZGZmZmZmXQpbICAgIDAuMDAwMDAwXSAgW21lbSAweDExZmMw
MDAwMC0weDExZmRmZmZmZl0gcGFnZSAyTQpbICAgIDAuMDAwMDAwXSBCUksgWzB4MDFmOGUwMDAs
IDB4MDFmOGVmZmZdIFBHVEFCTEUKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGluZzog
W21lbSAweDExYzAwMDAwMC0weDExZmJmZmZmZl0KWyAgICAwLjAwMDAwMF0gIFttZW0gMHgxMWMw
MDAwMDAtMHgxMWZiZmZmZmZdIHBhZ2UgMk0KWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFw
cGluZzogW21lbSAweDEwMDAwMDAwMC0weDExYmZmZmZmZl0KWyAgICAwLjAwMDAwMF0gIFttZW0g
MHgxMDAwMDAwMDAtMHgxMWJmZmZmZmZdIHBhZ2UgMk0KWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1v
cnlfbWFwcGluZzogW21lbSAweDAwMTAwMDAwLTB4MWZmZmZmZmZdClsgICAgMC4wMDAwMDBdICBb
bWVtIDB4MDAxMDAwMDAtMHgwMDFmZmZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSAgW21lbSAw
eDAwMjAwMDAwLTB4MWZmZmZmZmZdIHBhZ2UgMk0KWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlf
bWFwcGluZzogW21lbSAweDIwMjAwMDAwLTB4M2ZmZmZmZmZdClsgICAgMC4wMDAwMDBdICBbbWVt
IDB4MjAyMDAwMDAtMHgzZmZmZmZmZl0gcGFnZSAyTQpbICAgIDAuMDAwMDAwXSBpbml0X21lbW9y
eV9tYXBwaW5nOiBbbWVtIDB4NDAyMDAwMDAtMHhkOWM5ZWZmZl0KWyAgICAwLjAwMDAwMF0gIFtt
ZW0gMHg0MDIwMDAwMC0weGQ5YmZmZmZmXSBwYWdlIDJNClsgICAgMC4wMDAwMDBdICBbbWVtIDB4
ZDljMDAwMDAtMHhkOWM5ZWZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSBCUksgWzB4MDFmOGYw
MDAsIDB4MDFmOGZmZmZdIFBHVEFCTEUKWyAgICAwLjAwMDAwMF0gaW5pdF9tZW1vcnlfbWFwcGlu
ZzogW21lbSAweGRhZmZmMDAwLTB4ZGFmZmZmZmZdClsgICAgMC4wMDAwMDBdICBbbWVtIDB4ZGFm
ZmYwMDAtMHhkYWZmZmZmZl0gcGFnZSA0awpbICAgIDAuMDAwMDAwXSBSQU1ESVNLOiBbbWVtIDB4
Mzc5YWUwMDAtMHgzN2NjZWZmZl0KWyAgICAwLjAwMDAwMF0gTm8gTlVNQSBjb25maWd1cmF0aW9u
IGZvdW5kClsgICAgMC4wMDAwMDBdIEZha2luZyBhIG5vZGUgYXQgW21lbSAweDAwMDAwMDAwMDAw
MDAwMDAtMHgwMDAwMDAwMTFmZGZmZmZmXQpbICAgIDAuMDAwMDAwXSBJbml0bWVtIHNldHVwIG5v
ZGUgMCBbbWVtIDB4MDAwMDAwMDAtMHgxMWZkZmZmZmZdClsgICAgMC4wMDAwMDBdICAgTk9ERV9E
QVRBIFttZW0gMHgxMWZkZjgwMDAtMHgxMWZkZmJmZmZdClsgICAgMC4wMDAwMDBdICBbZmZmZmVh
MDAwMDAwMDAwMC1mZmZmZWEwMDA0N2ZmZmZmXSBQTUQgLT4gW2ZmZmY4ODAxMWI0MDAwMDAtZmZm
Zjg4MDExZjNmZmZmZl0gb24gbm9kZSAwClsgICAgMC4wMDAwMDBdIFpvbmUgcmFuZ2VzOgpbICAg
IDAuMDAwMDAwXSAgIERNQSAgICAgIFttZW0gMHgwMDAwMTAwMC0weDAwZmZmZmZmXQpbICAgIDAu
MDAwMDAwXSAgIERNQTMyICAgIFttZW0gMHgwMTAwMDAwMC0weGZmZmZmZmZmXQpbICAgIDAuMDAw
MDAwXSAgIE5vcm1hbCAgIFttZW0gMHgxMDAwMDAwMDAtMHgxMWZkZmZmZmZdClsgICAgMC4wMDAw
MDBdIE1vdmFibGUgem9uZSBzdGFydCBmb3IgZWFjaCBub2RlClsgICAgMC4wMDAwMDBdIEVhcmx5
IG1lbW9yeSBub2RlIHJhbmdlcwpbICAgIDAuMDAwMDAwXSAgIG5vZGUgICAwOiBbbWVtIDB4MDAw
MDEwMDAtMHgwMDA5Y2ZmZl0KWyAgICAwLjAwMDAwMF0gICBub2RlICAgMDogW21lbSAweDAwMTAw
MDAwLTB4MWZmZmZmZmZdClsgICAgMC4wMDAwMDBdICAgbm9kZSAgIDA6IFttZW0gMHgyMDIwMDAw
MC0weDNmZmZmZmZmXQpbICAgIDAuMDAwMDAwXSAgIG5vZGUgICAwOiBbbWVtIDB4NDAyMDAwMDAt
MHhkOWM5ZWZmZl0KWyAgICAwLjAwMDAwMF0gICBub2RlICAgMDogW21lbSAweGRhZmZmMDAwLTB4
ZGFmZmZmZmZdClsgICAgMC4wMDAwMDBdICAgbm9kZSAgIDA6IFttZW0gMHgxMDAwMDAwMDAtMHgx
MWZkZmZmZmZdClsgICAgMC4wMDAwMDBdIE9uIG5vZGUgMCB0b3RhbHBhZ2VzOiAxMDIxNTAwClsg
ICAgMC4wMDAwMDBdICAgRE1BIHpvbmU6IDY0IHBhZ2VzIHVzZWQgZm9yIG1lbW1hcApbICAgIDAu
MDAwMDAwXSAgIERNQSB6b25lOiAxNTYgcGFnZXMgcmVzZXJ2ZWQKWyAgICAwLjAwMDAwMF0gICBE
TUEgem9uZTogMzk5NiBwYWdlcywgTElGTyBiYXRjaDowClsgICAgMC4wMDAwMDBdICAgRE1BMzIg
em9uZTogMTM4NTkgcGFnZXMgdXNlZCBmb3IgbWVtbWFwClsgICAgMC4wMDAwMDBdICAgRE1BMzIg
em9uZTogODg2OTQ0IHBhZ2VzLCBMSUZPIGJhdGNoOjMxClsgICAgMC4wMDAwMDBdICAgTm9ybWFs
IHpvbmU6IDIwNDAgcGFnZXMgdXNlZCBmb3IgbWVtbWFwClsgICAgMC4wMDAwMDBdICAgTm9ybWFs
IHpvbmU6IDEzMDU2MCBwYWdlcywgTElGTyBiYXRjaDozMQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBQ
TS1UaW1lciBJTyBQb3J0OiAweDQwOApbICAgIDAuMDAwMDAwXSBBQ1BJOiBMb2NhbCBBUElDIGFk
ZHJlc3MgMHhmZWUwMDAwMApbICAgIDAuMDAwMDAwXSBBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDAx
XSBsYXBpY19pZFsweDAwXSBlbmFibGVkKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBMQVBJQyAoYWNw
aV9pZFsweDAyXSBsYXBpY19pZFsweDAxXSBlbmFibGVkKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBM
QVBJQyAoYWNwaV9pZFsweDAzXSBsYXBpY19pZFsweDAyXSBlbmFibGVkKQpbICAgIDAuMDAwMDAw
XSBBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDA0XSBsYXBpY19pZFsweDAzXSBlbmFibGVkKQpbICAg
IDAuMDAwMDAwXSBBQ1BJOiBMQVBJQyAoYWNwaV9pZFsweDA1XSBsYXBpY19pZFsweDAwXSBkaXNh
YmxlZCkKWyAgICAwLjAwMDAwMF0gQUNQSTogTEFQSUMgKGFjcGlfaWRbMHgwNl0gbGFwaWNfaWRb
MHgwMF0gZGlzYWJsZWQpClsgICAgMC4wMDAwMDBdIEFDUEk6IExBUElDIChhY3BpX2lkWzB4MDdd
IGxhcGljX2lkWzB4MDBdIGRpc2FibGVkKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBMQVBJQyAoYWNw
aV9pZFsweDA4XSBsYXBpY19pZFsweDAwXSBkaXNhYmxlZCkKWyAgICAwLjAwMDAwMF0gQUNQSTog
TEFQSUNfTk1JIChhY3BpX2lkWzB4MDBdIGhpZ2ggZWRnZSBsaW50WzB4MV0pClsgICAgMC4wMDAw
MDBdIEFDUEk6IExBUElDX05NSSAoYWNwaV9pZFsweDAxXSBoaWdoIGVkZ2UgbGludFsweDFdKQpb
ICAgIDAuMDAwMDAwXSBBQ1BJOiBJT0FQSUMgKGlkWzB4MGVdIGFkZHJlc3NbMHhmZWMwMDAwMF0g
Z3NpX2Jhc2VbMF0pClsgICAgMC4wMDAwMDBdIElPQVBJQ1swXTogYXBpY19pZCAxNCwgdmVyc2lv
biAzMiwgYWRkcmVzcyAweGZlYzAwMDAwLCBHU0kgMC0yMwpbICAgIDAuMDAwMDAwXSBBQ1BJOiBJ
TlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSAwIGdsb2JhbF9pcnEgMiBkZmwgZGZsKQpbICAgIDAu
MDAwMDAwXSBBQ1BJOiBJTlRfU1JDX09WUiAoYnVzIDAgYnVzX2lycSA5IGdsb2JhbF9pcnEgOSBo
aWdoIGxldmVsKQpbICAgIDAuMDAwMDAwXSBBQ1BJOiBJUlEwIHVzZWQgYnkgb3ZlcnJpZGUuClsg
ICAgMC4wMDAwMDBdIEFDUEk6IElSUTIgdXNlZCBieSBvdmVycmlkZS4KWyAgICAwLjAwMDAwMF0g
QUNQSTogSVJROSB1c2VkIGJ5IG92ZXJyaWRlLgpbICAgIDAuMDAwMDAwXSBVc2luZyBBQ1BJIChN
QURUKSBmb3IgU01QIGNvbmZpZ3VyYXRpb24gaW5mb3JtYXRpb24KWyAgICAwLjAwMDAwMF0gQUNQ
STogSFBFVCBpZDogMHg4MDg2YTMwMSBiYXNlOiAweGZlZDAwMDAwClsgICAgMC4wMDAwMDBdIHNt
cGJvb3Q6IEFsbG93aW5nIDggQ1BVcywgNCBob3RwbHVnIENQVXMKWyAgICAwLjAwMDAwMF0gbnJf
aXJxc19nc2k6IDQwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6
IDAwMDAwMDAwMDAwOWQwMDAgLSAwMDAwMDAwMDAwMDllMDAwClsgICAgMC4wMDAwMDBdIFBNOiBS
ZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwMDAwOWUwMDAgLSAwMDAwMDAwMDAwMGEw
MDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAw
MDAwYTAwMDAgLSAwMDAwMDAwMDAwMGUwMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVk
IG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwMDAwZTAwMDAgLSAwMDAwMDAwMDAwMTAwMDAwClsgICAg
MC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwMjAwMDAwMDAg
LSAwMDAwMDAwMDIwMjAwMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBt
ZW1vcnk6IDAwMDAwMDAwNDAwMDAwMDAgLSAwMDAwMDAwMDQwMjAwMDAwClsgICAgMC4wMDAwMDBd
IFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZDljOWYwMDAgLSAwMDAwMDAw
MGRhZTdmMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAw
MDAwMDAwZGFlN2YwMDAgLSAwMDAwMDAwMGRhZjlmMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdp
c3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZGFmOWYwMDAgLSAwMDAwMDAwMGRhZmZmMDAw
ClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZGIw
MDAwMDAgLSAwMDAwMDAwMGRmYTAwMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5v
c2F2ZSBtZW1vcnk6IDAwMDAwMDAwZGZhMDAwMDAgLSAwMDAwMDAwMGY4MDAwMDAwClsgICAgMC4w
MDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZjgwMDAwMDAgLSAw
MDAwMDAwMGZjMDAwMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1v
cnk6IDAwMDAwMDAwZmMwMDAwMDAgLSAwMDAwMDAwMGZlYzAwMDAwClsgICAgMC4wMDAwMDBdIFBN
OiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVjMDAwMDAgLSAwMDAwMDAwMGZl
YzAxMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAw
MDAwZmVjMDEwMDAgLSAwMDAwMDAwMGZlZDA4MDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3Rl
cmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVkMDgwMDAgLSAwMDAwMDAwMGZlZDA5MDAwClsg
ICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVkMDkw
MDAgLSAwMDAwMDAwMGZlZDEwMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2
ZSBtZW1vcnk6IDAwMDAwMDAwZmVkMTAwMDAgLSAwMDAwMDAwMGZlZDFhMDAwClsgICAgMC4wMDAw
MDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVkMWEwMDAgLSAwMDAw
MDAwMGZlZDFjMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6
IDAwMDAwMDAwZmVkMWMwMDAgLSAwMDAwMDAwMGZlZDIwMDAwClsgICAgMC4wMDAwMDBdIFBNOiBS
ZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVkMjAwMDAgLSAwMDAwMDAwMGZlZTAw
MDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAw
ZmVlMDAwMDAgLSAwMDAwMDAwMGZlZTAxMDAwClsgICAgMC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVk
IG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmVlMDEwMDAgLSAwMDAwMDAwMGZmZDgwMDAwClsgICAg
MC4wMDAwMDBdIFBNOiBSZWdpc3RlcmVkIG5vc2F2ZSBtZW1vcnk6IDAwMDAwMDAwZmZkODAwMDAg
LSAwMDAwMDAwMTAwMDAwMDAwClsgICAgMC4wMDAwMDBdIGU4MjA6IFttZW0gMHhkZmEwMDAwMC0w
eGY3ZmZmZmZmXSBhdmFpbGFibGUgZm9yIFBDSSBkZXZpY2VzClsgICAgMC4wMDAwMDBdIEJvb3Rp
bmcgcGFyYXZpcnR1YWxpemVkIGtlcm5lbCBvbiBiYXJlIGhhcmR3YXJlClsgICAgMC4wMDAwMDBd
IHNldHVwX3BlcmNwdTogTlJfQ1BVUzoyNTYgbnJfY3B1bWFza19iaXRzOjI1NiBucl9jcHVfaWRz
OjggbnJfbm9kZV9pZHM6MQpbICAgIDAuMDAwMDAwXSBQRVJDUFU6IEVtYmVkZGVkIDI4IHBhZ2Vz
L2NwdSBAZmZmZjg4MDExZmEwMDAwMCBzODU1NjggcjgxOTIgZDIwOTI4IHUyNjIxNDQKWyAgICAw
LjAwMDAwMF0gcGNwdS1hbGxvYzogczg1NTY4IHI4MTkyIGQyMDkyOCB1MjYyMTQ0IGFsbG9jPTEq
MjA5NzE1MgpbICAgIDAuMDAwMDAwXSBwY3B1LWFsbG9jOiBbMF0gMCAxIDIgMyA0IDUgNiA3IApb
ICAgIDAuMDAwMDAwXSBCdWlsdCAxIHpvbmVsaXN0cyBpbiBOb2RlIG9yZGVyLCBtb2JpbGl0eSBn
cm91cGluZyBvbi4gIFRvdGFsIHBhZ2VzOiAxMDA1MzgxClsgICAgMC4wMDAwMDBdIFBvbGljeSB6
b25lOiBOb3JtYWwKWyAgICAwLjAwMDAwMF0gS2VybmVsIGNvbW1hbmQgbGluZTogQk9PVF9JTUFH
RT0vYm9vdC92bWxpbnV6LTMuOC4wLW5leHQyMDEzMDIyNy0zLWluaXphLXNtYWxsIHJvb3Q9VVVJ
RD0wMDFBQURBNjFBQUQ5OTY0IGxvb3A9L3VidW50dS9kaXNrcy9yb290LmRpc2sgcm8KWyAgICAw
LjAwMDAwMF0gUElEIGhhc2ggdGFibGUgZW50cmllczogNDA5NiAob3JkZXI6IDMsIDMyNzY4IGJ5
dGVzKQpbICAgIDAuMDAwMDAwXSBfX2V4X3RhYmxlIGFscmVhZHkgc29ydGVkLCBza2lwcGluZyBz
b3J0ClsgICAgMC4wMDAwMDBdIHhzYXZlOiBlbmFibGVkIHhzdGF0ZV9idiAweDcsIGNudHh0IHNp
emUgMHgzNDAKWyAgICAwLjAwMDAwMF0gQ2hlY2tpbmcgYXBlcnR1cmUuLi4KWyAgICAwLjAwMDAw
MF0gTm8gQUdQIGJyaWRnZSBmb3VuZApbICAgIDAuMDAwMDAwXSBDYWxnYXJ5OiBkZXRlY3Rpbmcg
Q2FsZ2FyeSB2aWEgQklPUyBFQkRBIGFyZWEKWyAgICAwLjAwMDAwMF0gQ2FsZ2FyeTogVW5hYmxl
IHRvIGxvY2F0ZSBSaW8gR3JhbmRlIHRhYmxlIGluIEVCREEgLSBiYWlsaW5nIQpbICAgIDAuMDAw
MDAwXSBNZW1vcnk6IDM5MzM0NjhrLzQ3MTY1NDRrIGF2YWlsYWJsZSAoNjk3Nmsga2VybmVsIGNv
ZGUsIDYzMDU0NGsgYWJzZW50LCAxNTI1MzJrIHJlc2VydmVkLCA2Mjc0ayBkYXRhLCAxMjUyayBp
bml0KQpbICAgIDAuMDAwMDAwXSBTTFVCOiBIV2FsaWduPTY0LCBPcmRlcj0wLTMsIE1pbk9iamVj
dHM9MCwgQ1BVcz04LCBOb2Rlcz0xClsgICAgMC4wMDAwMDBdIEhpZXJhcmNoaWNhbCBSQ1UgaW1w
bGVtZW50YXRpb24uClsgICAgMC4wMDAwMDBdIAlSQ1UgZHludGljay1pZGxlIGdyYWNlLXBlcmlv
ZCBhY2NlbGVyYXRpb24gaXMgZW5hYmxlZC4KWyAgICAwLjAwMDAwMF0gCVJDVSByZXN0cmljdGlu
ZyBDUFVzIGZyb20gTlJfQ1BVUz0yNTYgdG8gbnJfY3B1X2lkcz04LgpbICAgIDAuMDAwMDAwXSBO
Ul9JUlFTOjE2NjQwIG5yX2lycXM6NzQ0IDE2ClsgICAgMC4wMDAwMDBdIENvbnNvbGU6IGNvbG91
ciBkdW1teSBkZXZpY2UgODB4MjUKWyAgICAwLjAwMDAwMF0gY29uc29sZSBbdHR5MF0gZW5hYmxl
ZApbICAgIDAuMDAwMDAwXSBhbGxvY2F0ZWQgMTY3NzcyMTYgYnl0ZXMgb2YgcGFnZV9jZ3JvdXAK
WyAgICAwLjAwMDAwMF0gcGxlYXNlIHRyeSAnY2dyb3VwX2Rpc2FibGU9bWVtb3J5JyBvcHRpb24g
aWYgeW91IGRvbid0IHdhbnQgbWVtb3J5IGNncm91cHMKWyAgICAwLjAwMDAwMF0gaHBldCBjbG9j
a2V2ZW50IHJlZ2lzdGVyZWQKWyAgICAwLjAwMDAwMF0gdHNjOiBGYXN0IFRTQyBjYWxpYnJhdGlv
biB1c2luZyBQSVQKWyAgICAwLjAwNDAwMF0gdHNjOiBEZXRlY3RlZCAxNTk2LjQ3NyBNSHogcHJv
Y2Vzc29yClsgICAgMC4wMDAwMDJdIENhbGlicmF0aW5nIGRlbGF5IGxvb3AgKHNraXBwZWQpLCB2
YWx1ZSBjYWxjdWxhdGVkIHVzaW5nIHRpbWVyIGZyZXF1ZW5jeS4uIDMxOTIuOTUgQm9nb01JUFMg
KGxwaj02Mzg1OTA4KQpbICAgIDAuMDAwMDA5XSBwaWRfbWF4OiBkZWZhdWx0OiAzMjc2OCBtaW5p
bXVtOiAzMDEKWyAgICAwLjAwMDAzNl0gU2VjdXJpdHkgRnJhbWV3b3JrIGluaXRpYWxpemVkClsg
ICAgMC4wMDAwNTBdIEFwcEFybW9yOiBBcHBBcm1vciBpbml0aWFsaXplZApbICAgIDAuMDAwMDUz
XSBZYW1hOiBiZWNvbWluZyBtaW5kZnVsLgpbICAgIDAuMDAwNDAwXSBEZW50cnkgY2FjaGUgaGFz
aCB0YWJsZSBlbnRyaWVzOiA1MjQyODggKG9yZGVyOiAxMCwgNDE5NDMwNCBieXRlcykKWyAgICAw
LjAwMTQ1M10gSW5vZGUtY2FjaGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAyNjIxNDQgKG9yZGVyOiA5
LCAyMDk3MTUyIGJ5dGVzKQpbICAgIDAuMDAxOTAxXSBNb3VudC1jYWNoZSBoYXNoIHRhYmxlIGVu
dHJpZXM6IDI1NgpbICAgIDAuMDAyMDk2XSBJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBjcHVh
Y2N0ClsgICAgMC4wMDIxMDJdIEluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIG1lbW9yeQpbICAg
IDAuMDAyMTEyXSBJbml0aWFsaXppbmcgY2dyb3VwIHN1YnN5cyBkZXZpY2VzClsgICAgMC4wMDIx
MTVdIEluaXRpYWxpemluZyBjZ3JvdXAgc3Vic3lzIGZyZWV6ZXIKWyAgICAwLjAwMjExOF0gSW5p
dGlhbGl6aW5nIGNncm91cCBzdWJzeXMgYmxraW8KWyAgICAwLjAwMjEyMV0gSW5pdGlhbGl6aW5n
IGNncm91cCBzdWJzeXMgcGVyZl9ldmVudApbICAgIDAuMDAyMTI1XSBJbml0aWFsaXppbmcgY2dy
b3VwIHN1YnN5cyBodWdldGxiClsgICAgMC4wMDIxNTNdIERpc2FibGVkIGZhc3Qgc3RyaW5nIG9w
ZXJhdGlvbnMKWyAgICAwLjAwMjE1N10gQ1BVOiBQaHlzaWNhbCBQcm9jZXNzb3IgSUQ6IDAKWyAg
ICAwLjAwMjE1OV0gQ1BVOiBQcm9jZXNzb3IgQ29yZSBJRDogMApbICAgIDAuMDAyMTY2XSBFTkVS
R1lfUEVSRl9CSUFTOiBTZXQgdG8gJ25vcm1hbCcsIHdhcyAncGVyZm9ybWFuY2UnClsgICAgMC4w
MDIxNjZdIEVORVJHWV9QRVJGX0JJQVM6IFZpZXcgYW5kIHVwZGF0ZSB3aXRoIHg4Nl9lbmVyZ3lf
cGVyZl9wb2xpY3koOCkKWyAgICAwLjAwMjE3Ml0gbWNlOiBDUFUgc3VwcG9ydHMgNyBNQ0UgYmFu
a3MKWyAgICAwLjAwMjE4N10gQ1BVMDogVGhlcm1hbCBtb25pdG9yaW5nIGVuYWJsZWQgKFRNMSkK
WyAgICAwLjAwMjE5OF0gTGFzdCBsZXZlbCBpVExCIGVudHJpZXM6IDRLQiA1MTIsIDJNQiAwLCA0
TUIgMApbICAgIDAuMDAyMTk4XSBMYXN0IGxldmVsIGRUTEIgZW50cmllczogNEtCIDUxMiwgMk1C
IDMyLCA0TUIgMzIKWyAgICAwLjAwMjE5OF0gdGxiX2ZsdXNoYWxsX3NoaWZ0OiA1ClsgICAgMC4w
MDIyOTNdIEZyZWVpbmcgU01QIGFsdGVybmF0aXZlczogMjRrIGZyZWVkClsgICAgMC4wMDQ1MTBd
IEFDUEk6IENvcmUgcmV2aXNpb24gMjAxMzAxMTcKWyAgICAwLjAwOTk2N10gQUNQSTogQWxsIEFD
UEkgVGFibGVzIHN1Y2Nlc3NmdWxseSBhY3F1aXJlZApbICAgIDAuMDExNDc1XSBmdHJhY2U6IGFs
bG9jYXRpbmcgMjYxMzcgZW50cmllcyBpbiAxMDMgcGFnZXMKWyAgICAwLjAyNjE0Nl0gLi5USU1F
UjogdmVjdG9yPTB4MzAgYXBpYzE9MCBwaW4xPTIgYXBpYzI9LTEgcGluMj0tMQpbICAgIDAuMDY1
ODEwXSBzbXBib290OiBDUFUwOiBJbnRlbChSKSBDb3JlKFRNKSBpNS0yNDY3TSBDUFUgQCAxLjYw
R0h6IChmYW06IDA2LCBtb2RlbDogMmEsIHN0ZXBwaW5nOiAwNykKWyAgICAwLjA2NTgyMV0gVFND
IGRlYWRsaW5lIHRpbWVyIGVuYWJsZWQKWyAgICAwLjA2NTgzM10gUGVyZm9ybWFuY2UgRXZlbnRz
OiBQRUJTIGZtdDErLCAxNi1kZWVwIExCUiwgU2FuZHlCcmlkZ2UgZXZlbnRzLCBJbnRlbCBQTVUg
ZHJpdmVyLgpbICAgIDAuMDY1ODQ0XSAuLi4gdmVyc2lvbjogICAgICAgICAgICAgICAgMwpbICAg
IDAuMDY1ODQ2XSAuLi4gYml0IHdpZHRoOiAgICAgICAgICAgICAgNDgKWyAgICAwLjA2NTg0OF0g
Li4uIGdlbmVyaWMgcmVnaXN0ZXJzOiAgICAgIDQKWyAgICAwLjA2NTg1MF0gLi4uIHZhbHVlIG1h
c2s6ICAgICAgICAgICAgIDAwMDBmZmZmZmZmZmZmZmYKWyAgICAwLjA2NTg1M10gLi4uIG1heCBw
ZXJpb2Q6ICAgICAgICAgICAgIDAwMDAwMDAwN2ZmZmZmZmYKWyAgICAwLjA2NTg1NV0gLi4uIGZp
eGVkLXB1cnBvc2UgZXZlbnRzOiAgIDMKWyAgICAwLjA2NTg1OF0gLi4uIGV2ZW50IG1hc2s6ICAg
ICAgICAgICAgIDAwMDAwMDA3MDAwMDAwMGYKWyAgICAwLjA3Nzk5OV0gRGlzYWJsZWQgZmFzdCBz
dHJpbmcgb3BlcmF0aW9ucwpbICAgIDAuMDgwMjEwXSBOTUkgd2F0Y2hkb2c6IGVuYWJsZWQgb24g
YWxsIENQVXMsIHBlcm1hbmVudGx5IGNvbnN1bWVzIG9uZSBody1QTVUgY291bnRlci4KWyAgICAw
LjA5MTI1Ml0gRGlzYWJsZWQgZmFzdCBzdHJpbmcgb3BlcmF0aW9ucwpbICAgIDAuMTA0NDg4XSBE
aXNhYmxlZCBmYXN0IHN0cmluZyBvcGVyYXRpb25zClsgICAgMC4wNjY5NjddIHNtcGJvb3Q6IEJv
b3RpbmcgTm9kZSAgIDAsIFByb2Nlc3NvcnMgICMxICMyICMzClsgICAgMC4xMDY2MDZdIEJyb3Vn
aHQgdXAgNCBDUFVzClsgICAgMC4xMDY2MTRdIHNtcGJvb3Q6IFRvdGFsIG9mIDQgcHJvY2Vzc29y
cyBhY3RpdmF0ZWQgKDEyNzcxLjgxIEJvZ29NSVBTKQpbICAgIDAuMTEwNDE0XSBkZXZ0bXBmczog
aW5pdGlhbGl6ZWQKWyAgICAwLjExMTMwNF0gRVZNOiBzZWN1cml0eS5zZWxpbnV4ClsgICAgMC4x
MTEzMDddIEVWTTogc2VjdXJpdHkuU01BQ0s2NApbICAgIDAuMTExMzA5XSBFVk06IHNlY3VyaXR5
LmNhcGFiaWxpdHkKWyAgICAwLjExMTM1NV0gUE06IFJlZ2lzdGVyaW5nIEFDUEkgTlZTIHJlZ2lv
biBbbWVtIDB4ZGFlN2YwMDAtMHhkYWY5ZWZmZl0gKDExNzk2NDggYnl0ZXMpClsgICAgMC4xMTIx
MDhdIHJlZ3VsYXRvci1kdW1teTogbm8gcGFyYW1ldGVycwpbICAgIDAuMTEyMTYwXSBORVQ6IFJl
Z2lzdGVyZWQgcHJvdG9jb2wgZmFtaWx5IDE2ClsgICAgMC4xMTIyNzZdIEFDUEk6IGJ1cyB0eXBl
IHBjaSByZWdpc3RlcmVkClsgICAgMC4xMTIzNDBdIFBDSTogTU1DT05GSUcgZm9yIGRvbWFpbiAw
MDAwIFtidXMgMDAtM2ZdIGF0IFttZW0gMHhmODAwMDAwMC0weGZiZmZmZmZmXSAoYmFzZSAweGY4
MDAwMDAwKQpbICAgIDAuMTEyMzQ2XSBQQ0k6IE1NQ09ORklHIGF0IFttZW0gMHhmODAwMDAwMC0w
eGZiZmZmZmZmXSByZXNlcnZlZCBpbiBFODIwClsgICAgMC4xMTk3OThdIFBDSTogVXNpbmcgY29u
ZmlndXJhdGlvbiB0eXBlIDEgZm9yIGJhc2UgYWNjZXNzClsgICAgMC4xMjA2NjNdIGJpbzogY3Jl
YXRlIHNsYWIgPGJpby0wPiBhdCAwClsgICAgMC4xMjA3NTFdIEFDUEk6IEFkZGVkIF9PU0koTW9k
dWxlIERldmljZSkKWyAgICAwLjEyMDc1NV0gQUNQSTogQWRkZWQgX09TSShQcm9jZXNzb3IgRGV2
aWNlKQpbICAgIDAuMTIwNzU4XSBBQ1BJOiBBZGRlZCBfT1NJKDMuMCBfU0NQIEV4dGVuc2lvbnMp
ClsgICAgMC4xMjA3NjBdIEFDUEk6IEFkZGVkIF9PU0koUHJvY2Vzc29yIEFnZ3JlZ2F0b3IgRGV2
aWNlKQpbICAgIDAuMTIyMjk1XSBBQ1BJOiBFQzogTG9vayB1cCBFQyBpbiBEU0RUClsgICAgMC4x
MjM5MThdIEFDUEk6IEV4ZWN1dGVkIDEgYmxvY2tzIG9mIG1vZHVsZS1sZXZlbCBleGVjdXRhYmxl
IEFNTCBjb2RlClsgICAgMC4xMjYyMzddIFtGaXJtd2FyZSBCdWddOiBBQ1BJOiBCSU9TIF9PU0ko
TGludXgpIHF1ZXJ5IGlnbm9yZWQKWyAgICAwLjEyNzQyNV0gQUNQSTogU1NEVCAwMDAwMDAwMGRh
ZTcwNzE4IDAwNjg4ICh2MDEgIFBtUmVmICBDcHUwQ3N0IDAwMDAzMDAxIElOVEwgMjAwNjExMDkp
ClsgICAgMC4xMjc4MjNdIEFDUEk6IER5bmFtaWMgT0VNIFRhYmxlIExvYWQ6ClsgICAgMC4xMjc4
MjddIEFDUEk6IFNTRFQgICAgICAgICAgIChudWxsKSAwMDY4OCAodjAxICBQbVJlZiAgQ3B1MENz
dCAwMDAwMzAwMSBJTlRMIDIwMDYxMTA5KQpbICAgIDAuMTI4MDg0XSBBQ1BJOiBTU0RUIDAwMDAw
MDAwZGFlNzFhOTggMDAzMDMgKHYwMSAgUG1SZWYgICAgQXBJc3QgMDAwMDMwMDAgSU5UTCAyMDA2
MTEwOSkKWyAgICAwLjEyODUwOV0gQUNQSTogRHluYW1pYyBPRU0gVGFibGUgTG9hZDoKWyAgICAw
LjEyODUxM10gQUNQSTogU1NEVCAgICAgICAgICAgKG51bGwpIDAwMzAzICh2MDEgIFBtUmVmICAg
IEFwSXN0IDAwMDAzMDAwIElOVEwgMjAwNjExMDkpClsgICAgMC4xMjg2MThdIEFDUEk6IFNTRFQg
MDAwMDAwMDBkYWU2ZmQ5OCAwMDExOSAodjAxICBQbVJlZiAgICBBcENzdCAwMDAwMzAwMCBJTlRM
IDIwMDYxMTA5KQpbICAgIDAuMTI5MDA1XSBBQ1BJOiBEeW5hbWljIE9FTSBUYWJsZSBMb2FkOgpb
ICAgIDAuMTI5MDA4XSBBQ1BJOiBTU0RUICAgICAgICAgICAobnVsbCkgMDAxMTkgKHYwMSAgUG1S
ZWYgICAgQXBDc3QgMDAwMDMwMDAgSU5UTCAyMDA2MTEwOSkKWyAgICAwLjEzMDQzMl0gQUNQSTog
SW50ZXJwcmV0ZXIgZW5hYmxlZApbICAgIDAuMTMwNDQwXSBBQ1BJOiAoc3VwcG9ydHMgUzAgUzFB
Q1BJIEV4Y2VwdGlvbjogQUVfTk9UX0ZPVU5ELCBXaGlsZSBldmFsdWF0aW5nIFNsZWVwIFN0YXRl
IFtcX1MyX10gKDIwMTMwMTE3L2h3eGZhY2UtNTY4KQpbICAgIDAuMTMwNDU3XSAgUzMgUzQgUzUp
ClsgICAgMC4xMzA0NjddIEFDUEk6IFVzaW5nIElPQVBJQyBmb3IgaW50ZXJydXB0IHJvdXRpbmcK
WyAgICAwLjEzMDUwMV0gUENJOiBVc2luZyBob3N0IGJyaWRnZSB3aW5kb3dzIGZyb20gQUNQSTsg
aWYgbmVjZXNzYXJ5LCB1c2UgInBjaT1ub2NycyIgYW5kIHJlcG9ydCBhIGJ1ZwpbICAgIDAuMTM2
ODkyXSBBQ1BJOiBQb3dlciBSZXNvdXJjZSBbRk4wMF0gKG9mZikKWyAgICAwLjEzNjk2OF0gQUNQ
STogUG93ZXIgUmVzb3VyY2UgW0ZOMDFdIChvZmYpClsgICAgMC4xMzcwNDFdIEFDUEk6IFBvd2Vy
IFJlc291cmNlIFtGTjAyXSAob2ZmKQpbICAgIDAuMTM3MTEyXSBBQ1BJOiBQb3dlciBSZXNvdXJj
ZSBbRk4wM10gKG9mZikKWyAgICAwLjEzNzE4NV0gQUNQSTogUG93ZXIgUmVzb3VyY2UgW0ZOMDRd
IChvZmYpClsgICAgMC4xMzc3NzFdIEFDUEk6IFBDSSBSb290IEJyaWRnZSBbUENJMF0gKGRvbWFp
biAwMDAwIFtidXMgMDAtM2VdKQpbICAgIDAuMTM3OTM1XSBcX1NCXy5QQ0kwOl9PU0MgaW52YWxp
ZCBVVUlEClsgICAgMC4xMzc5MzddIF9PU0MgcmVxdWVzdCBkYXRhOjEgOCAxZiAKWyAgICAwLjEz
ODAxNl0gXF9TQl8uUENJMDpfT1NDIGludmFsaWQgVVVJRApbICAgIDAuMTM4MDE3XSBfT1NDIHJl
cXVlc3QgZGF0YToxIDFmIDFmIApbICAgIDAuMTM4MDIxXSBhY3BpIFBOUDBBMDg6MDA6IEFDUEkg
X09TQyBzdXBwb3J0IG5vdGlmaWNhdGlvbiBmYWlsZWQsIGRpc2FibGluZyBQQ0llIEFTUE0KWyAg
ICAwLjEzODAyNl0gYWNwaSBQTlAwQTA4OjAwOiBVbmFibGUgdG8gcmVxdWVzdCBfT1NDIGNvbnRy
b2wgKF9PU0Mgc3VwcG9ydCBtYXNrOiAweDA4KQpbICAgIDAuMTM4NDYwXSBQQ0kgaG9zdCBicmlk
Z2UgdG8gYnVzIDAwMDA6MDAKWyAgICAwLjEzODQ2NV0gcGNpX2J1cyAwMDAwOjAwOiByb290IGJ1
cyByZXNvdXJjZSBbYnVzIDAwLTNlXQpbICAgIDAuMTM4NDY5XSBwY2lfYnVzIDAwMDA6MDA6IHJv
b3QgYnVzIHJlc291cmNlIFtpbyAgMHgwMDAwLTB4MGNmN10KWyAgICAwLjEzODQ3Ml0gcGNpX2J1
cyAwMDAwOjAwOiByb290IGJ1cyByZXNvdXJjZSBbaW8gIDB4MGQwMC0weGZmZmZdClsgICAgMC4x
Mzg0NzZdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweDAwMGEwMDAw
LTB4MDAwYmZmZmZdClsgICAgMC4xMzg0ODBdIHBjaV9idXMgMDAwMDowMDogcm9vdCBidXMgcmVz
b3VyY2UgW21lbSAweGRmYTAwMDAwLTB4ZmVhZmZmZmZdClsgICAgMC4xMzg0ODNdIHBjaV9idXMg
MDAwMDowMDogcm9vdCBidXMgcmVzb3VyY2UgW21lbSAweGZlZDQwMDAwLTB4ZmVkNDRmZmZdClsg
ICAgMC4xMzg0OTVdIHBjaSAwMDAwOjAwOjAwLjA6IFs4MDg2OjAxMDRdIHR5cGUgMDAgY2xhc3Mg
MHgwNjAwMDAKWyAgICAwLjEzODU5MV0gcGNpIDAwMDA6MDA6MDIuMDogWzgwODY6MDExNl0gdHlw
ZSAwMCBjbGFzcyAweDAzMDAwMApbICAgIDAuMTM4NjA0XSBwY2kgMDAwMDowMDowMi4wOiByZWcg
MTA6IFttZW0gMHhmMDAwMDAwMC0weGYwM2ZmZmZmIDY0Yml0XQpbICAgIDAuMTM4NjExXSBwY2kg
MDAwMDowMDowMi4wOiByZWcgMTg6IFttZW0gMHhlMDAwMDAwMC0weGVmZmZmZmZmIDY0Yml0IHBy
ZWZdClsgICAgMC4xMzg2MTddIHBjaSAwMDAwOjAwOjAyLjA6IHJlZyAyMDogW2lvICAweDMwMDAt
MHgzMDNmXQpbICAgIDAuMTM4NzI4XSBwY2kgMDAwMDowMDoxNi4wOiBbODA4NjoxYzNhXSB0eXBl
IDAwIGNsYXNzIDB4MDc4MDAwClsgICAgMC4xMzg3NTRdIHBjaSAwMDAwOjAwOjE2LjA6IHJlZyAx
MDogW21lbSAweGYwNzA1MDAwLTB4ZjA3MDUwMGYgNjRiaXRdClsgICAgMC4xMzg4MzhdIHBjaSAw
MDAwOjAwOjE2LjA6IFBNRSMgc3VwcG9ydGVkIGZyb20gRDAgRDNob3QgRDNjb2xkClsgICAgMC4x
Mzg5MjldIHBjaSAwMDAwOjAwOjFhLjA6IFs4MDg2OjFjMmRdIHR5cGUgMDAgY2xhc3MgMHgwYzAz
MjAKWyAgICAwLjEzODk1M10gcGNpIDAwMDA6MDA6MWEuMDogcmVnIDEwOiBbbWVtIDB4ZjA3MGEw
MDAtMHhmMDcwYTNmZl0KWyAgICAwLjEzOTA1Ml0gcGNpIDAwMDA6MDA6MWEuMDogUE1FIyBzdXBw
b3J0ZWQgZnJvbSBEMCBEM2hvdCBEM2NvbGQKWyAgICAwLjEzOTExN10gcGNpIDAwMDA6MDA6MWIu
MDogWzgwODY6MWMyMF0gdHlwZSAwMCBjbGFzcyAweDA0MDMwMApbICAgIDAuMTM5MTM1XSBwY2kg
MDAwMDowMDoxYi4wOiByZWcgMTA6IFttZW0gMHhmMDcwMDAwMC0weGYwNzAzZmZmIDY0Yml0XQpb
ICAgIDAuMTM5MjExXSBwY2kgMDAwMDowMDoxYi4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQz
aG90IEQzY29sZApbICAgIDAuMTM5MjQyXSBwY2kgMDAwMDowMDoxYi4wOiBTeXN0ZW0gd2FrZXVw
IGRpc2FibGVkIGJ5IEFDUEkKWyAgICAwLjEzOTI3OV0gcGNpIDAwMDA6MDA6MWMuMDogWzgwODY6
MWMxMF0gdHlwZSAwMSBjbGFzcyAweDA2MDQwMApbICAgIDAuMTM5MzY2XSBwY2kgMDAwMDowMDox
Yy4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDAuMTM5Mzk4XSBw
Y2kgMDAwMDowMDoxYy4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgICAwLjEz
OTQzNl0gcGNpIDAwMDA6MDA6MWMuMzogWzgwODY6MWMxNl0gdHlwZSAwMSBjbGFzcyAweDA2MDQw
MApbICAgIDAuMTM5NTIyXSBwY2kgMDAwMDowMDoxYy4zOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQw
IEQzaG90IEQzY29sZApbICAgIDAuMTM5NTU4XSBwY2kgMDAwMDowMDoxYy4zOiBTeXN0ZW0gd2Fr
ZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgICAwLjEzOTU5Nl0gcGNpIDAwMDA6MDA6MWMuNDogWzgw
ODY6MWMxOF0gdHlwZSAwMSBjbGFzcyAweDA2MDQwMApbICAgIDAuMTM5NzI3XSBwY2kgMDAwMDow
MDoxYy40OiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDAuMTM5ODEw
XSBwY2kgMDAwMDowMDoxZC4wOiBbODA4NjoxYzI2XSB0eXBlIDAwIGNsYXNzIDB4MGMwMzIwClsg
ICAgMC4xMzk4MzRdIHBjaSAwMDAwOjAwOjFkLjA6IHJlZyAxMDogW21lbSAweGYwNzA5MDAwLTB4
ZjA3MDkzZmZdClsgICAgMC4xMzk5MzJdIHBjaSAwMDAwOjAwOjFkLjA6IFBNRSMgc3VwcG9ydGVk
IGZyb20gRDAgRDNob3QgRDNjb2xkClsgICAgMC4xMzk5ODldIHBjaSAwMDAwOjAwOjFmLjA6IFs4
MDg2OjFjNDldIHR5cGUgMDAgY2xhc3MgMHgwNjAxMDAKWyAgICAwLjE0MDE0NV0gcGNpIDAwMDA6
MDA6MWYuMjogWzgwODY6MWMwM10gdHlwZSAwMCBjbGFzcyAweDAxMDYwMQpbICAgIDAuMTQwMTY3
XSBwY2kgMDAwMDowMDoxZi4yOiByZWcgMTA6IFtpbyAgMHgzMDg4LTB4MzA4Zl0KWyAgICAwLjE0
MDE3Nl0gcGNpIDAwMDA6MDA6MWYuMjogcmVnIDE0OiBbaW8gIDB4MzA5NC0weDMwOTddClsgICAg
MC4xNDAxODVdIHBjaSAwMDAwOjAwOjFmLjI6IHJlZyAxODogW2lvICAweDMwODAtMHgzMDg3XQpb
ICAgIDAuMTQwMTk0XSBwY2kgMDAwMDowMDoxZi4yOiByZWcgMWM6IFtpbyAgMHgzMDkwLTB4MzA5
M10KWyAgICAwLjE0MDIwM10gcGNpIDAwMDA6MDA6MWYuMjogcmVnIDIwOiBbaW8gIDB4MzA2MC0w
eDMwN2ZdClsgICAgMC4xNDAyMTNdIHBjaSAwMDAwOjAwOjFmLjI6IHJlZyAyNDogW21lbSAweGYw
NzA4MDAwLTB4ZjA3MDg3ZmZdClsgICAgMC4xNDAyNjNdIHBjaSAwMDAwOjAwOjFmLjI6IFBNRSMg
c3VwcG9ydGVkIGZyb20gRDNob3QKWyAgICAwLjE0MDMyNV0gcGNpIDAwMDA6MDA6MWYuMzogWzgw
ODY6MWMyMl0gdHlwZSAwMCBjbGFzcyAweDBjMDUwMApbICAgIDAuMTQwMzQ0XSBwY2kgMDAwMDow
MDoxZi4zOiByZWcgMTA6IFttZW0gMHhmMDcwNDAwMC0weGYwNzA0MGZmIDY0Yml0XQpbICAgIDAu
MTQwMzY3XSBwY2kgMDAwMDowMDoxZi4zOiByZWcgMjA6IFtpbyAgMHhlZmEwLTB4ZWZiZl0KWyAg
ICAwLjE0MDY2MF0gcGNpIDAwMDA6MDE6MDAuMDogWzgwODY6MDA5MV0gdHlwZSAwMCBjbGFzcyAw
eDAyODAwMApbICAgIDAuMTQwODA5XSBwY2kgMDAwMDowMTowMC4wOiByZWcgMTA6IFttZW0gMHhm
MDYwMDAwMC0weGYwNjAxZmZmIDY0Yml0XQpbICAgIDAuMTQxNTE5XSBwY2kgMDAwMDowMTowMC4w
OiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQwIEQzaG90IEQzY29sZApbICAgIDAuMTQxNjY0XSBwY2kg
MDAwMDowMTowMC4wOiBTeXN0ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgICAwLjE0NzIy
NF0gcGNpIDAwMDA6MDA6MWMuMDogUENJIGJyaWRnZSB0byBbYnVzIDAxXQpbICAgIDAuMTQ3MjMz
XSBwY2kgMDAwMDowMDoxYy4wOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGYwNjAwMDAwLTB4ZjA2
ZmZmZmZdClsgICAgMC4xNDczNzVdIHBjaSAwMDAwOjAyOjAwLjA6IFsxMGVjOjgxNjhdIHR5cGUg
MDAgY2xhc3MgMHgwMjAwMDAKWyAgICAwLjE0NzQ0MF0gcGNpIDAwMDA6MDI6MDAuMDogcmVnIDEw
OiBbaW8gIDB4MjAwMC0weDIwZmZdClsgICAgMC4xNDc1NTddIHBjaSAwMDAwOjAyOjAwLjA6IHJl
ZyAxODogW21lbSAweGYwNDA0MDAwLTB4ZjA0MDRmZmYgNjRiaXQgcHJlZl0KWyAgICAwLjE0NzYz
M10gcGNpIDAwMDA6MDI6MDAuMDogcmVnIDIwOiBbbWVtIDB4ZjA0MDAwMDAtMHhmMDQwM2ZmZiA2
NGJpdCBwcmVmXQpbICAgIDAuMTQ3OTY4XSBwY2kgMDAwMDowMjowMC4wOiBzdXBwb3J0cyBEMSBE
MgpbICAgIDAuMTQ3OTcwXSBwY2kgMDAwMDowMjowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQw
IEQxIEQyIEQzaG90IEQzY29sZApbICAgIDAuMTQ4MDgzXSBwY2kgMDAwMDowMjowMC4wOiBTeXN0
ZW0gd2FrZXVwIGRpc2FibGVkIGJ5IEFDUEkKWyAgICAwLjE1NTE1N10gcGNpIDAwMDA6MDA6MWMu
MzogUENJIGJyaWRnZSB0byBbYnVzIDAyXQpbICAgIDAuMTU1MTcyXSBwY2kgMDAwMDowMDoxYy4z
OiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDIwMDAtMHgyZmZmXQpbICAgIDAuMTU1MTk1XSBwY2kg
MDAwMDowMDoxYy4zOiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGYwNDAwMDAwLTB4ZjA0ZmZmZmYg
NjRiaXQgcHJlZl0KWyAgICAwLjE1NTMzNF0gcGNpIDAwMDA6MDM6MDAuMDogWzFiMjE6MTA0Ml0g
dHlwZSAwMCBjbGFzcyAweDBjMDMzMApbICAgIDAuMTU1MzcyXSBwY2kgMDAwMDowMzowMC4wOiBy
ZWcgMTA6IFttZW0gMHhmMDUwMDAwMC0weGYwNTA3ZmZmIDY0Yml0XQpbICAgIDAuMTU1NTY5XSBw
Y2kgMDAwMDowMzowMC4wOiBQTUUjIHN1cHBvcnRlZCBmcm9tIEQzaG90IEQzY29sZApbICAgIDAu
MTYzMTUyXSBwY2kgMDAwMDowMDoxYy40OiBQQ0kgYnJpZGdlIHRvIFtidXMgMDNdClsgICAgMC4x
NjMxNzJdIHBjaSAwMDAwOjAwOjFjLjQ6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjA1MDAwMDAt
MHhmMDVmZmZmZl0KWyAgICAwLjE2MzIwOV0gQUNQSSBfT1NDIGNvbnRyb2wgZm9yIFBDSWUgbm90
IGdyYW50ZWQsIGRpc2FibGluZyBBU1BNClsgICAgMC4xNjM4NzFdIEFDUEk6IFBDSSBJbnRlcnJ1
cHQgTGluayBbTE5LQV0gKElSUXMgMSAzIDQgNSA2IDEwICoxMSAxMiAxNCAxNSkKWyAgICAwLjE2
MzkzM10gQUNQSTogUENJIEludGVycnVwdCBMaW5rIFtMTktCXSAoSVJRcyAxIDMgNCA1IDYgMTAg
MTEgMTIgMTQgMTUpICowLCBkaXNhYmxlZC4KWyAgICAwLjE2Mzk5NF0gQUNQSTogUENJIEludGVy
cnVwdCBMaW5rIFtMTktDXSAoSVJRcyAxIDMgNCA1IDYgKjEwIDExIDEyIDE0IDE1KQpbICAgIDAu
MTY0MDUyXSBBQ1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0RdIChJUlFzIDEgMyA0IDUgNiAq
MTAgMTEgMTIgMTQgMTUpClsgICAgMC4xNjQxMTBdIEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBb
TE5LRV0gKElSUXMgMSAzIDQgNSA2IDEwIDExIDEyIDE0IDE1KSAqOQpbICAgIDAuMTY0MTY5XSBB
Q1BJOiBQQ0kgSW50ZXJydXB0IExpbmsgW0xOS0ZdIChJUlFzIDEgMyA0IDUgNiAxMCAxMSAxMiAx
NCAxNSkgKjAsIGRpc2FibGVkLgpbICAgIDAuMTY0MjI4XSBBQ1BJOiBQQ0kgSW50ZXJydXB0IExp
bmsgW0xOS0ddIChJUlFzIDEgMyA0IDUgNiAxMCAqMTEgMTIgMTQgMTUpClsgICAgMC4xNjQyODZd
IEFDUEk6IFBDSSBJbnRlcnJ1cHQgTGluayBbTE5LSF0gKElSUXMgMSAzIDQgNSA2IDEwIDExIDEy
IDE0IDE1KSAqOQpbICAgIDAuMTY0Nzc5XSBBQ1BJOiBFbmFibGVkIDQgR1BFcyBpbiBibG9jayAw
MCB0byAzRgpbICAgIDAuMTY0Nzg5XSBhY3BpIHJvb3Q6IFxfU0JfLlBDSTAgbm90aWZ5IGhhbmRs
ZXIgaXMgaW5zdGFsbGVkClsgICAgMC4xNjQ4NDVdIEZvdW5kIDEgYWNwaSByb290IGRldmljZXMK
WyAgICAwLjE2NDg4M10gQUNQSTogRUM6IEdQRSA9IDB4MTcsIEkvTzogY29tbWFuZC9zdGF0dXMg
PSAweDY2LCBkYXRhID0gMHg2MgpbICAgIDAuMTY1MDE3XSBBQ1BJOiBObyBkb2NrIGRldmljZXMg
Zm91bmQuClsgICAgMC4xNjUwOTVdIHZnYWFyYjogZGV2aWNlIGFkZGVkOiBQQ0k6MDAwMDowMDow
Mi4wLGRlY29kZXM9aW8rbWVtLG93bnM9aW8rbWVtLGxvY2tzPW5vbmUKWyAgICAwLjE2NTEwMl0g
dmdhYXJiOiBsb2FkZWQKWyAgICAwLjE2NTEwNF0gdmdhYXJiOiBicmlkZ2UgY29udHJvbCBwb3Nz
aWJsZSAwMDAwOjAwOjAyLjAKWyAgICAwLjE2NTI1Nl0gU0NTSSBzdWJzeXN0ZW0gaW5pdGlhbGl6
ZWQKWyAgICAwLjE2NTI1OV0gQUNQSTogYnVzIHR5cGUgc2NzaSByZWdpc3RlcmVkClsgICAgMC4x
NjUzMDVdIGxpYmF0YSB2ZXJzaW9uIDMuMDAgbG9hZGVkLgpbICAgIDAuMTY1MzIwXSBBQ1BJOiBi
dXMgdHlwZSB1c2IgcmVnaXN0ZXJlZApbICAgIDAuMTY1MzM4XSB1c2Jjb3JlOiByZWdpc3RlcmVk
IG5ldyBpbnRlcmZhY2UgZHJpdmVyIHVzYmZzClsgICAgMC4xNjUzNDddIHVzYmNvcmU6IHJlZ2lz
dGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgaHViClsgICAgMC4xNjUzNzJdIHVzYmNvcmU6IHJl
Z2lzdGVyZWQgbmV3IGRldmljZSBkcml2ZXIgdXNiClsgICAgMC4xNjU0NTZdIFBDSTogVXNpbmcg
QUNQSSBmb3IgSVJRIHJvdXRpbmcKWyAgICAwLjE2NzEyOV0gUENJOiBwY2lfY2FjaGVfbGluZV9z
aXplIHNldCB0byA2NCBieXRlcwpbICAgIDAuMTY3MjM0XSBlODIwOiByZXNlcnZlIFJBTSBidWZm
ZXIgW21lbSAweDAwMDlkODAwLTB4MDAwOWZmZmZdClsgICAgMC4xNjcyMzZdIGU4MjA6IHJlc2Vy
dmUgUkFNIGJ1ZmZlciBbbWVtIDB4ZDljOWYwMDAtMHhkYmZmZmZmZl0KWyAgICAwLjE2NzIzN10g
ZTgyMDogcmVzZXJ2ZSBSQU0gYnVmZmVyIFttZW0gMHhkYjAwMDAwMC0weGRiZmZmZmZmXQpbICAg
IDAuMTY3MjM5XSBlODIwOiByZXNlcnZlIFJBTSBidWZmZXIgW21lbSAweDExZmUwMDAwMC0weDEx
ZmZmZmZmZl0KWyAgICAwLjE2NzMyMV0gTmV0TGFiZWw6IEluaXRpYWxpemluZwpbICAgIDAuMTY3
MzI0XSBOZXRMYWJlbDogIGRvbWFpbiBoYXNoIHNpemUgPSAxMjgKWyAgICAwLjE2NzMyNl0gTmV0
TGFiZWw6ICBwcm90b2NvbHMgPSBVTkxBQkVMRUQgQ0lQU092NApbICAgIDAuMTY3MzM5XSBOZXRM
YWJlbDogIHVubGFiZWxlZCB0cmFmZmljIGFsbG93ZWQgYnkgZGVmYXVsdApbICAgIDAuMTY3Mzkz
XSBocGV0MDogYXQgTU1JTyAweGZlZDAwMDAwLCBJUlFzIDIsIDgsIDAsIDAsIDAsIDAsIDAsIDAK
WyAgICAwLjE2NzQwMV0gaHBldDA6IDggY29tcGFyYXRvcnMsIDY0LWJpdCAxNC4zMTgxODAgTUh6
IGNvdW50ZXIKWyAgICAwLjE2OTQxM10gU3dpdGNoaW5nIHRvIGNsb2Nrc291cmNlIGhwZXQKWyAg
ICAwLjE3NDQ3MV0gQXBwQXJtb3I6IEFwcEFybW9yIEZpbGVzeXN0ZW0gRW5hYmxlZApbICAgIDAu
MTc0NTAwXSBwbnA6IFBuUCBBQ1BJIGluaXQKWyAgICAwLjE3NDUxMl0gQUNQSTogYnVzIHR5cGUg
cG5wIHJlZ2lzdGVyZWQKWyAgICAwLjE3NDc1NV0gcG5wIDAwOjAwOiBbZG1hIDRdClsgICAgMC4x
NzQ4NTZdIHBucCAwMDowMDogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDAyMDAg
KGFjdGl2ZSkKWyAgICAwLjE3NDg3Nl0gcG5wIDAwOjAxOiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2
aWNlLCBJRHMgSU5UMDgwMCAoYWN0aXZlKQpbICAgIDAuMTc0OTY0XSBwbnAgMDA6MDI6IFBsdWcg
YW5kIFBsYXkgQUNQSSBkZXZpY2UsIElEcyBQTlAwMTAzIChhY3RpdmUpClsgICAgMC4xNzUwMDBd
IHBucCAwMDowMzogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDBjMDQgKGFjdGl2
ZSkKWyAgICAwLjE3NTA0M10gc3lzdGVtIDAwOjA0OiBbaW8gIDB4MDY4MC0weDA2OWZdIGhhcyBi
ZWVuIHJlc2VydmVkClsgICAgMC4xNzUwNDhdIHN5c3RlbSAwMDowNDogW2lvICAweDEwMDAtMHgx
MDBmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuMTc1MDUxXSBzeXN0ZW0gMDA6MDQ6IFtpbyAg
MHg1MDAwLTB4NTAwM10gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTA1NV0gc3lzdGVtIDAw
OjA0OiBbaW8gIDB4ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTA1OV0gc3lzdGVt
IDAwOjA0OiBbaW8gIDB4MDQwMC0weDA0NTNdIGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC4xNzUw
NjNdIHN5c3RlbSAwMDowNDogW2lvICAweDA0NTgtMHgwNDdmXSBoYXMgYmVlbiByZXNlcnZlZApb
ICAgIDAuMTc1MDY2XSBzeXN0ZW0gMDA6MDQ6IFtpbyAgMHgwNTAwLTB4MDU3Zl0gaGFzIGJlZW4g
cmVzZXJ2ZWQKWyAgICAwLjE3NTA3MF0gc3lzdGVtIDAwOjA0OiBbaW8gIDB4MGEwMC0weDBhMGZd
IGhhcyBiZWVuIHJlc2VydmVkClsgICAgMC4xNzUwNzRdIHN5c3RlbSAwMDowNDogW2lvICAweDE2
NGUtMHgxNjRmXSBoYXMgYmVlbiByZXNlcnZlZApbICAgIDAuMTc1MDc4XSBzeXN0ZW0gMDA6MDQ6
IFtpbyAgMHg1MDAwLTB4NTAwZl0gY291bGQgbm90IGJlIHJlc2VydmVkClsgICAgMC4xNzUwODJd
IHN5c3RlbSAwMDowNDogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwgSURzIFBOUDBjMDIgKGFj
dGl2ZSkKWyAgICAwLjE3NTEwN10gcG5wIDAwOjA1OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNl
LCBJRHMgUE5QMGIwMCAoYWN0aXZlKQpbICAgIDAuMTc1MTUxXSBzeXN0ZW0gMDA6MDY6IFtpbyAg
MHgwNDU0LTB4MDQ1N10gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTE1N10gc3lzdGVtIDAw
OjA2OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgSU5UM2YwZCBQTlAwYzAyIChhY3Rp
dmUpClsgICAgMC4xNzUxODhdIHBucCAwMDowNzogUGx1ZyBhbmQgUGxheSBBQ1BJIGRldmljZSwg
SURzIFBOUDAzMDMgKGFjdGl2ZSkKWyAgICAwLjE3NTIzMF0gcG5wIDAwOjA4OiBQbHVnIGFuZCBQ
bGF5IEFDUEkgZGV2aWNlLCBJRHMgRVREMGIwMCBTWU4wMDAyIFBOUDBmMTMgKGFjdGl2ZSkKWyAg
ICAwLjE3NTM4OV0gc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZmVkMWMwMDAtMHhmZWQxZmZmZl0gaGFz
IGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTM5NF0gc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZmVkMTAw
MDAtMHhmZWQxN2ZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTM5OF0gc3lzdGVtIDAw
OjA5OiBbbWVtIDB4ZmVkMTgwMDAtMHhmZWQxOGZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAw
LjE3NTQwMl0gc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZmVkMTkwMDAtMHhmZWQxOWZmZl0gaGFzIGJl
ZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTQwNl0gc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZjgwMDAwMDAt
MHhmYmZmZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTQxMF0gc3lzdGVtIDAwOjA5
OiBbbWVtIDB4ZmVkMjAwMDAtMHhmZWQzZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3
NTQxNl0gc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZmVkOTAwMDAtMHhmZWQ5M2ZmZl0gaGFzIGJlZW4g
cmVzZXJ2ZWQKWyAgICAwLjE3NTQyMF0gc3lzdGVtIDAwOjA5OiBbbWVtIDB4ZmVkNDUwMDAtMHhm
ZWQ4ZmZmZl0gaGFzIGJlZW4gcmVzZXJ2ZWQKWyAgICAwLjE3NTQyNF0gc3lzdGVtIDAwOjA5OiBb
bWVtIDB4ZmYwMDAwMDAtMHhmZmZmZmZmZl0gY291bGQgbm90IGJlIHJlc2VydmVkClsgICAgMC4x
NzU0MjhdIHN5c3RlbSAwMDowOTogW21lbSAweGZlZTAwMDAwLTB4ZmVlZmZmZmZdIGNvdWxkIG5v
dCBiZSByZXNlcnZlZApbICAgIDAuMTc1NDMyXSBzeXN0ZW0gMDA6MDk6IFBsdWcgYW5kIFBsYXkg
QUNQSSBkZXZpY2UsIElEcyBQTlAwYzAyIChhY3RpdmUpClsgICAgMC4xNzU4MTJdIHBucCAwMDow
YTogY2FuJ3QgZXZhbHVhdGUgX0NSUzogMTIzMTEKWyAgICAwLjE3NTg5NV0gc3lzdGVtIDAwOjBh
OiBQbHVnIGFuZCBQbGF5IEFDUEkgZGV2aWNlLCBJRHMgUE5QMGMwMSAoYWN0aXZlKQpbICAgIDAu
MTc1OTIwXSBwbnA6IFBuUCBBQ1BJOiBmb3VuZCAxMSBkZXZpY2VzClsgICAgMC4xNzU5MjNdIEFD
UEk6IEFDUEkgYnVzIHR5cGUgcG5wIHVucmVnaXN0ZXJlZApbICAgIDAuMTgyNDM1XSBwY2kgMDAw
MDowMDoxYy4wOiBQQ0kgYnJpZGdlIHRvIFtidXMgMDFdClsgICAgMC4xODI0NDVdIHBjaSAwMDAw
OjAwOjFjLjA6ICAgYnJpZGdlIHdpbmRvdyBbbWVtIDB4ZjA2MDAwMDAtMHhmMDZmZmZmZl0KWyAg
ICAwLjE4MjQ1N10gcGNpIDAwMDA6MDA6MWMuMzogUENJIGJyaWRnZSB0byBbYnVzIDAyXQpbICAg
IDAuMTgyNDYzXSBwY2kgMDAwMDowMDoxYy4zOiAgIGJyaWRnZSB3aW5kb3cgW2lvICAweDIwMDAt
MHgyZmZmXQpbICAgIDAuMTgyNDczXSBwY2kgMDAwMDowMDoxYy4zOiAgIGJyaWRnZSB3aW5kb3cg
W21lbSAweGYwNDAwMDAwLTB4ZjA0ZmZmZmYgNjRiaXQgcHJlZl0KWyAgICAwLjE4MjQ4M10gcGNp
IDAwMDA6MDA6MWMuNDogUENJIGJyaWRnZSB0byBbYnVzIDAzXQpbICAgIDAuMTgyNDkwXSBwY2kg
MDAwMDowMDoxYy40OiAgIGJyaWRnZSB3aW5kb3cgW21lbSAweGYwNTAwMDAwLTB4ZjA1ZmZmZmZd
ClsgICAgMC4xODI2NDJdIHBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgNCBbaW8gIDB4MDAwMC0w
eDBjZjddClsgICAgMC4xODI2NDVdIHBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgNSBbaW8gIDB4
MGQwMC0weGZmZmZdClsgICAgMC4xODI2NDddIHBjaV9idXMgMDAwMDowMDogcmVzb3VyY2UgNiBb
bWVtIDB4MDAwYTAwMDAtMHgwMDBiZmZmZl0KWyAgICAwLjE4MjY0OV0gcGNpX2J1cyAwMDAwOjAw
OiByZXNvdXJjZSA3IFttZW0gMHhkZmEwMDAwMC0weGZlYWZmZmZmXQpbICAgIDAuMTgyNjUxXSBw
Y2lfYnVzIDAwMDA6MDA6IHJlc291cmNlIDggW21lbSAweGZlZDQwMDAwLTB4ZmVkNDRmZmZdClsg
ICAgMC4xODI2NTNdIHBjaV9idXMgMDAwMDowMTogcmVzb3VyY2UgMSBbbWVtIDB4ZjA2MDAwMDAt
MHhmMDZmZmZmZl0KWyAgICAwLjE4MjY1NV0gcGNpX2J1cyAwMDAwOjAyOiByZXNvdXJjZSAwIFtp
byAgMHgyMDAwLTB4MmZmZl0KWyAgICAwLjE4MjY1N10gcGNpX2J1cyAwMDAwOjAyOiByZXNvdXJj
ZSAyIFttZW0gMHhmMDQwMDAwMC0weGYwNGZmZmZmIDY0Yml0IHByZWZdClsgICAgMC4xODI2NTld
IHBjaV9idXMgMDAwMDowMzogcmVzb3VyY2UgMSBbbWVtIDB4ZjA1MDAwMDAtMHhmMDVmZmZmZl0K
WyAgICAwLjE4MjY5Ml0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAyClsgICAgMC4x
ODI4NDBdIFRDUCBlc3RhYmxpc2hlZCBoYXNoIHRhYmxlIGVudHJpZXM6IDMyNzY4IChvcmRlcjog
NywgNTI0Mjg4IGJ5dGVzKQpbICAgIDAuMTgyOTkzXSBUQ1AgYmluZCBoYXNoIHRhYmxlIGVudHJp
ZXM6IDMyNzY4IChvcmRlcjogNywgNTI0Mjg4IGJ5dGVzKQpbICAgIDAuMTgzMDkyXSBUQ1A6IEhh
c2ggdGFibGVzIGNvbmZpZ3VyZWQgKGVzdGFibGlzaGVkIDMyNzY4IGJpbmQgMzI3NjgpClsgICAg
MC4xODMxMjddIFRDUDogcmVubyByZWdpc3RlcmVkClsgICAgMC4xODMxMzddIFVEUCBoYXNoIHRh
YmxlIGVudHJpZXM6IDIwNDggKG9yZGVyOiA0LCA2NTUzNiBieXRlcykKWyAgICAwLjE4MzE1OF0g
VURQLUxpdGUgaGFzaCB0YWJsZSBlbnRyaWVzOiAyMDQ4IChvcmRlcjogNCwgNjU1MzYgYnl0ZXMp
ClsgICAgMC4xODMyMjddIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkgMQpbICAgIDAu
MTgzMjQxXSBwY2kgMDAwMDowMDowMi4wOiBCb290IHZpZGVvIGRldmljZQpbICAgIDAuMTgzNTkw
XSBQQ0k6IENMUyA2NCBieXRlcywgZGVmYXVsdCA2NApbICAgIDAuMTgzNjI4XSBUcnlpbmcgdG8g
dW5wYWNrIHJvb3RmcyBpbWFnZSBhcyBpbml0cmFtZnMuLi4KWyAgICAwLjI0Nzk4MF0gRnJlZWlu
ZyBpbml0cmQgbWVtb3J5OiAzMjA0ayBmcmVlZApbICAgIDAuMjQ4NjY4XSBQQ0ktRE1BOiBVc2lu
ZyBzb2Z0d2FyZSBib3VuY2UgYnVmZmVyaW5nIGZvciBJTyAoU1dJT1RMQikKWyAgICAwLjI0ODY3
N10gc29mdHdhcmUgSU8gVExCIFttZW0gMHhkNWM5ZjAwMC0weGQ5YzlmMDAwXSAoNjRNQikgbWFw
cGVkIGF0IFtmZmZmODgwMGQ1YzlmMDAwLWZmZmY4ODAwZDljOWVmZmZdClsgICAgMC4yNDg4ODhd
IFNjYW5uaW5nIGZvciBsb3cgbWVtb3J5IGNvcnJ1cHRpb24gZXZlcnkgNjAgc2Vjb25kcwpbICAg
IDAuMjQ5MTAyXSBJbml0aWFsaXNlIHN5c3RlbSB0cnVzdGVkIGtleXJpbmcKWyAgICAwLjI0OTE0
NV0gYXVkaXQ6IGluaXRpYWxpemluZyBuZXRsaW5rIHNvY2tldCAoZGlzYWJsZWQpClsgICAgMC4y
NDkxNTZdIHR5cGU9MjAwMCBhdWRpdCgxMzYxOTczODE5LjI0NDoxKTogaW5pdGlhbGl6ZWQKWyAg
ICAwLjI4MTc4MF0gYm91bmNlIHBvb2wgc2l6ZTogNjQgcGFnZXMKWyAgICAwLjI4MTc5MV0gSHVn
ZVRMQiByZWdpc3RlcmVkIDIgTUIgcGFnZSBzaXplLCBwcmUtYWxsb2NhdGVkIDAgcGFnZXMKWyAg
ICAwLjI4MzEyNl0gVkZTOiBEaXNrIHF1b3RhcyBkcXVvdF82LjUuMgpbICAgIDAuMjgzMTY1XSBE
cXVvdC1jYWNoZSBoYXNoIHRhYmxlIGVudHJpZXM6IDUxMiAob3JkZXIgMCwgNDA5NiBieXRlcykK
WyAgICAwLjI4MzYxMl0gZnVzZSBpbml0IChBUEkgdmVyc2lvbiA3LjIxKQpbICAgIDAuMjgzNjg4
XSBtc2dtbmkgaGFzIGJlZW4gc2V0IHRvIDc2ODgKWyAgICAwLjI4NDE0MV0gS2V5IHR5cGUgYXN5
bW1ldHJpYyByZWdpc3RlcmVkClsgICAgMC4yODQxNDZdIEFzeW1tZXRyaWMga2V5IHBhcnNlciAn
eDUwOScgcmVnaXN0ZXJlZApbICAgIDAuMjg0MTc3XSBCbG9jayBsYXllciBTQ1NJIGdlbmVyaWMg
KGJzZykgZHJpdmVyIHZlcnNpb24gMC40IGxvYWRlZCAobWFqb3IgMjUyKQpbICAgIDAuMjg0MjA5
XSBpbyBzY2hlZHVsZXIgbm9vcCByZWdpc3RlcmVkClsgICAgMC4yODQyMTRdIGlvIHNjaGVkdWxl
ciBkZWFkbGluZSByZWdpc3RlcmVkIChkZWZhdWx0KQpbICAgIDAuMjg0MjIwXSBpbyBzY2hlZHVs
ZXIgY2ZxIHJlZ2lzdGVyZWQKWyAgICAwLjI4NDQyNF0gcGNpX2hvdHBsdWc6IFBDSSBIb3QgUGx1
ZyBQQ0kgQ29yZSB2ZXJzaW9uOiAwLjUKWyAgICAwLjI4NDQzOV0gcGNpZWhwOiBQQ0kgRXhwcmVz
cyBIb3QgUGx1ZyBDb250cm9sbGVyIERyaXZlciB2ZXJzaW9uOiAwLjQKWyAgICAwLjI4NDQ3OV0g
aW50ZWxfaWRsZTogTVdBSVQgc3Vic3RhdGVzOiAweDIxMTIwClsgICAgMC4yODQ0ODBdIGludGVs
X2lkbGU6IHYwLjQgbW9kZWwgMHgyQQpbICAgIDAuMjg0NDgxXSBpbnRlbF9pZGxlOiBsYXBpY190
aW1lcl9yZWxpYWJsZV9zdGF0ZXMgMHhmZmZmZmZmZgpbICAgIDAuMjg0OTAxXSBBQ1BJOiBBQyBB
ZGFwdGVyIFtBRFAxXSAob24tbGluZSkKWyAgICAwLjI4NDk4N10gaW5wdXQ6IExpZCBTd2l0Y2gg
YXMgL2RldmljZXMvTE5YU1lTVE06MDAvTE5YU1lCVVM6MDAvUE5QMEMwRDowMC9pbnB1dC9pbnB1
dDAKWyAgICAwLjI4NTEwNV0gQUNQSTogTGlkIFN3aXRjaCBbTElEMF0KWyAgICAwLjI4NTE1MF0g
aW5wdXQ6IFBvd2VyIEJ1dHRvbiBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9MTlhTWUJVUzowMC9Q
TlAwQzBDOjAwL2lucHV0L2lucHV0MQpbICAgIDAuMjg1MTU3XSBBQ1BJOiBQb3dlciBCdXR0b24g
W1BXUkJdClsgICAgMC4yODUxOTBdIGlucHV0OiBQb3dlciBCdXR0b24gYXMgL2RldmljZXMvTE5Y
U1lTVE06MDAvTE5YUFdSQk46MDAvaW5wdXQvaW5wdXQyClsgICAgMC4yODUxOTVdIEFDUEk6IFBv
d2VyIEJ1dHRvbiBbUFdSRl0KWyAgICAwLjI4NTMxMF0gQUNQSTogRmFuIFtGQU4wXSAob2ZmKQpb
ICAgIDAuMjg1MzM4XSBBQ1BJOiBGYW4gW0ZBTjFdIChvZmYpClsgICAgMC4yODUzOTFdIEFDUEk6
IEZhbiBbRkFOMl0gKG9mZikKWyAgICAwLjI4NTQzMF0gQUNQSTogRmFuIFtGQU4zXSAob2ZmKQpb
ICAgIDAuMjg1NDU0XSBBQ1BJOiBGYW4gW0ZBTjRdIChvZmYpClsgICAgMC4yODU0OTldIEFDUEk6
IFJlcXVlc3RpbmcgYWNwaV9jcHVmcmVxClsgICAgMC4yODk4MjddIHRoZXJtYWwgTE5YVEhFUk06
MDA6IHJlZ2lzdGVyZWQgYXMgdGhlcm1hbF96b25lMApbICAgIDAuMjg5ODMzXSBBQ1BJOiBUaGVy
bWFsIFpvbmUgW1RaMDBdICg2OSBDKQpbICAgIDAuMjkwMDIwXSB0aGVybWFsIExOWFRIRVJNOjAx
OiByZWdpc3RlcmVkIGFzIHRoZXJtYWxfem9uZTEKWyAgICAwLjI5MDAyNF0gQUNQSTogVGhlcm1h
bCBab25lIFtUWjAxXSAoMzAgQykKWyAgICAwLjI5MDA0OF0gR0hFUzogSEVTVCBpcyBub3QgZW5h
YmxlZCEKWyAgICAwLjI5MDE1M10gU2VyaWFsOiA4MjUwLzE2NTUwIGRyaXZlciwgMzIgcG9ydHMs
IElSUSBzaGFyaW5nIGVuYWJsZWQKWyAgICAwLjI5MjcwNV0gTGludXggYWdwZ2FydCBpbnRlcmZh
Y2UgdjAuMTAzClsgICAgMC4yOTM5NTZdIGJyZDogbW9kdWxlIGxvYWRlZApbICAgIDAuMjk0NTAz
XSBsb29wOiBtb2R1bGUgbG9hZGVkClsgICAgMC4yOTQ1OTZdIGFoY2kgMDAwMDowMDoxZi4yOiB2
ZXJzaW9uIDMuMApbICAgIDAuMjk0NzIwXSBhaGNpIDAwMDA6MDA6MWYuMjogaXJxIDQwIGZvciBN
U0kvTVNJLVgKWyAgICAwLjI5NDc2Ml0gYWhjaTogU1NTIGZsYWcgc2V0LCBwYXJhbGxlbCBidXMg
c2NhbiBkaXNhYmxlZApbICAgIDAuMjk1MTAyXSBBQ1BJOiBCYXR0ZXJ5IFNsb3QgW0JBVDFdIChi
YXR0ZXJ5IHByZXNlbnQpClsgICAgMC4zMDkzNTldIGFoY2kgMDAwMDowMDoxZi4yOiBBSENJIDAw
MDEuMDMwMCAzMiBzbG90cyA2IHBvcnRzIDYgR2JwcyAweDFiIGltcGwgU0FUQSBtb2RlClsgICAg
MC4zMDkzNjZdIGFoY2kgMDAwMDowMDoxZi4yOiBmbGFnczogNjRiaXQgbmNxIHNudGYgaWxjayBz
dGFnIHBtIGxlZCBjbG8gcGlvIHNsdW0gcGFydCBlbXMgc3hzIGFwc3QgClsgICAgMC4zMDkzNzRd
IGFoY2kgMDAwMDowMDoxZi4yOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKWyAgICAwLjMz
MzYyOF0gc2NzaTAgOiBhaGNpClsgICAgMC4zMzM3MTFdIHNjc2kxIDogYWhjaQpbICAgIDAuMzMz
NzczXSBzY3NpMiA6IGFoY2kKWyAgICAwLjMzMzgzMV0gc2NzaTMgOiBhaGNpClsgICAgMC4zMzM4
OTFdIHNjc2k0IDogYWhjaQpbICAgIDAuMzMzOTQ4XSBzY3NpNSA6IGFoY2kKWyAgICAwLjMzMzk4
NF0gYXRhMTogU0FUQSBtYXggVURNQS8xMzMgYWJhciBtMjA0OEAweGYwNzA4MDAwIHBvcnQgMHhm
MDcwODEwMCBpcnEgNDAKWyAgICAwLjMzMzk5MF0gYXRhMjogU0FUQSBtYXggVURNQS8xMzMgYWJh
ciBtMjA0OEAweGYwNzA4MDAwIHBvcnQgMHhmMDcwODE4MCBpcnEgNDAKWyAgICAwLjMzMzk5NF0g
YXRhMzogRFVNTVkKWyAgICAwLjMzMzk5OF0gYXRhNDogU0FUQSBtYXggVURNQS8xMzMgYWJhciBt
MjA0OEAweGYwNzA4MDAwIHBvcnQgMHhmMDcwODI4MCBpcnEgNDAKWyAgICAwLjMzNDAwM10gYXRh
NTogU0FUQSBtYXggVURNQS8xMzMgYWJhciBtMjA0OEAweGYwNzA4MDAwIHBvcnQgMHhmMDcwODMw
MCBpcnEgNDAKWyAgICAwLjMzNDAwNl0gYXRhNjogRFVNTVkKWyAgICAwLjMzNDI0OV0gbGlicGh5
OiBGaXhlZCBNRElPIEJ1czogcHJvYmVkClsgICAgMC4zMzQzMThdIHR1bjogVW5pdmVyc2FsIFRV
Ti9UQVAgZGV2aWNlIGRyaXZlciwgMS42ClsgICAgMC4zMzQzMjFdIHR1bjogKEMpIDE5OTktMjAw
NCBNYXggS3Jhc255YW5za3kgPG1heGtAcXVhbGNvbW0uY29tPgpbICAgIDAuMzM0Mzc1XSBQUFAg
Z2VuZXJpYyBkcml2ZXIgdmVyc2lvbiAyLjQuMgpbICAgIDAuMzM0NDI3XSBlaGNpX2hjZDogVVNC
IDIuMCAnRW5oYW5jZWQnIEhvc3QgQ29udHJvbGxlciAoRUhDSSkgRHJpdmVyClsgICAgMC4zMzQ0
MzFdIGVoY2ktcGNpOiBFSENJIFBDSSBwbGF0Zm9ybSBkcml2ZXIKWyAgICAwLjMzNDUxMV0gZWhj
aS1wY2kgMDAwMDowMDoxYS4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKWyAgICAwLjMz
NDUxNl0gZWhjaS1wY2kgMDAwMDowMDoxYS4wOiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDAu
MzM0NTIzXSBlaGNpLXBjaSAwMDAwOjAwOjFhLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFz
c2lnbmVkIGJ1cyBudW1iZXIgMQpbICAgIDAuMzM0NTQxXSBlaGNpLXBjaSAwMDAwOjAwOjFhLjA6
IGRlYnVnIHBvcnQgMgpbICAgIDAuMzM4NDQzXSBlaGNpLXBjaSAwMDAwOjAwOjFhLjA6IGNhY2hl
IGxpbmUgc2l6ZSBvZiA2NCBpcyBub3Qgc3VwcG9ydGVkClsgICAgMC4zMzg0NjBdIGVoY2ktcGNp
IDAwMDA6MDA6MWEuMDogaXJxIDE2LCBpbyBtZW0gMHhmMDcwYTAwMApbICAgIDAuMzQ5MzE2XSBl
aGNpLXBjaSAwMDAwOjAwOjFhLjA6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwClsgICAgMC4z
NDkzNDRdIHVzYiB1c2IxOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQ
cm9kdWN0PTAwMDIKWyAgICAwLjM0OTM0OF0gdXNiIHVzYjE6IE5ldyBVU0IgZGV2aWNlIHN0cmlu
Z3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsgICAgMC4zNDkzNTNdIHVzYiB1
c2IxOiBQcm9kdWN0OiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDAuMzQ5MzU2XSB1c2IgdXNi
MTogTWFudWZhY3R1cmVyOiBMaW51eCAzLjguMC1uZXh0MjAxMzAyMjctMy1pbml6YS1zbWFsbCBl
aGNpX2hjZApbICAgIDAuMzQ5MzYwXSB1c2IgdXNiMTogU2VyaWFsTnVtYmVyOiAwMDAwOjAwOjFh
LjAKWyAgICAwLjM0OTQ3N10gaHViIDEtMDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICAwLjM0OTQ4
Nl0gaHViIDEtMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKWyAgICAwLjM0OTYxMF0gZWhjaS1wY2kg
MDAwMDowMDoxZC4wOiBzZXR0aW5nIGxhdGVuY3kgdGltZXIgdG8gNjQKWyAgICAwLjM0OTYxNF0g
ZWhjaS1wY2kgMDAwMDowMDoxZC4wOiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDAuMzQ5NjIz
XSBlaGNpLXBjaSAwMDAwOjAwOjFkLjA6IG5ldyBVU0IgYnVzIHJlZ2lzdGVyZWQsIGFzc2lnbmVk
IGJ1cyBudW1iZXIgMgpbICAgIDAuMzQ5NjM4XSBlaGNpLXBjaSAwMDAwOjAwOjFkLjA6IGRlYnVn
IHBvcnQgMgpbICAgIDAuMzUzNTQwXSBlaGNpLXBjaSAwMDAwOjAwOjFkLjA6IGNhY2hlIGxpbmUg
c2l6ZSBvZiA2NCBpcyBub3Qgc3VwcG9ydGVkClsgICAgMC4zNTM1NTRdIGVoY2ktcGNpIDAwMDA6
MDA6MWQuMDogaXJxIDIzLCBpbyBtZW0gMHhmMDcwOTAwMApbICAgIDAuMzY1MzA4XSBlaGNpLXBj
aSAwMDAwOjAwOjFkLjA6IFVTQiAyLjAgc3RhcnRlZCwgRUhDSSAxLjAwClsgICAgMC4zNjUzMzZd
IHVzYiB1c2IyOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0
PTAwMDIKWyAgICAwLjM2NTM0MF0gdXNiIHVzYjI6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1m
cj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsgICAgMC4zNjUzNDRdIHVzYiB1c2IyOiBQ
cm9kdWN0OiBFSENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDAuMzY1MzQ3XSB1c2IgdXNiMjogTWFu
dWZhY3R1cmVyOiBMaW51eCAzLjguMC1uZXh0MjAxMzAyMjctMy1pbml6YS1zbWFsbCBlaGNpX2hj
ZApbICAgIDAuMzY1MzUxXSB1c2IgdXNiMjogU2VyaWFsTnVtYmVyOiAwMDAwOjAwOjFkLjAKWyAg
ICAwLjM2NTQ1Nl0gaHViIDItMDoxLjA6IFVTQiBodWIgZm91bmQKWyAgICAwLjM2NTQ2Ml0gaHVi
IDItMDoxLjA6IDIgcG9ydHMgZGV0ZWN0ZWQKWyAgICAwLjM2NTUyNV0gZWhjaS1wbGF0Zm9ybTog
RUhDSSBnZW5lcmljIHBsYXRmb3JtIGRyaXZlcgpbICAgIDAuMzY1NTM0XSBvaGNpX2hjZDogVVNC
IDEuMSAnT3BlbicgSG9zdCBDb250cm9sbGVyIChPSENJKSBEcml2ZXIKWyAgICAwLjM2NTU0OF0g
dWhjaV9oY2Q6IFVTQiBVbml2ZXJzYWwgSG9zdCBDb250cm9sbGVyIEludGVyZmFjZSBkcml2ZXIK
WyAgICAwLjM2NTYxNl0geGhjaV9oY2QgMDAwMDowMzowMC4wOiB4SENJIEhvc3QgQ29udHJvbGxl
cgpbICAgIDAuMzY1NjIzXSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6IG5ldyBVU0IgYnVzIHJlZ2lz
dGVyZWQsIGFzc2lnbmVkIGJ1cyBudW1iZXIgMwpbICAgIDAuMzc1MzA5XSB4aGNpX2hjZCAwMDAw
OjAzOjAwLjA6IGlycSAxNiwgaW8gbWVtIDB4ZjA1MDAwMDAKWyAgICAwLjM3NTM3OF0geGhjaV9o
Y2QgMDAwMDowMzowMC4wOiBpcnEgNDEgZm9yIE1TSS9NU0ktWApbICAgIDAuMzc1Mzg1XSB4aGNp
X2hjZCAwMDAwOjAzOjAwLjA6IGlycSA0MiBmb3IgTVNJL01TSS1YClsgICAgMC4zNzUzOTBdIHho
Y2lfaGNkIDAwMDA6MDM6MDAuMDogaXJxIDQzIGZvciBNU0kvTVNJLVgKWyAgICAwLjM3NTM5Nl0g
eGhjaV9oY2QgMDAwMDowMzowMC4wOiBpcnEgNDQgZm9yIE1TSS9NU0ktWApbICAgIDAuMzc1NDAx
XSB4aGNpX2hjZCAwMDAwOjAzOjAwLjA6IGlycSA0NSBmb3IgTVNJL01TSS1YClsgICAgMC4zNzU1
MTBdIHVzYiB1c2IzOiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRWZW5kb3I9MWQ2YiwgaWRQcm9k
dWN0PTAwMDIKWyAgICAwLjM3NTUxNF0gdXNiIHVzYjM6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6
IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsgICAgMC4zNzU1MTldIHVzYiB1c2Iz
OiBQcm9kdWN0OiB4SENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDAuMzc1NTIyXSB1c2IgdXNiMzog
TWFudWZhY3R1cmVyOiBMaW51eCAzLjguMC1uZXh0MjAxMzAyMjctMy1pbml6YS1zbWFsbCB4aGNp
X2hjZApbICAgIDAuMzc1NTI2XSB1c2IgdXNiMzogU2VyaWFsTnVtYmVyOiAwMDAwOjAzOjAwLjAK
WyAgICAwLjM3NTYwMl0geEhDSSB4aGNpX2FkZF9lbmRwb2ludCBjYWxsZWQgZm9yIHJvb3QgaHVi
ClsgICAgMC4zNzU2MDRdIHhIQ0kgeGhjaV9jaGVja19iYW5kd2lkdGggY2FsbGVkIGZvciByb290
IGh1YgpbICAgIDAuMzc1NjMyXSBodWIgMy0wOjEuMDogVVNCIGh1YiBmb3VuZApbICAgIDAuMzc1
NjQxXSBodWIgMy0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZApbICAgIDAuMzc1Njk4XSB4aGNpX2hj
ZCAwMDAwOjAzOjAwLjA6IHhIQ0kgSG9zdCBDb250cm9sbGVyClsgICAgMC4zNzU3MDVdIHhoY2lf
aGNkIDAwMDA6MDM6MDAuMDogbmV3IFVTQiBidXMgcmVnaXN0ZXJlZCwgYXNzaWduZWQgYnVzIG51
bWJlciA0ClsgICAgMC4zNzU3NDBdIHVzYiB1c2I0OiBOZXcgVVNCIGRldmljZSBmb3VuZCwgaWRW
ZW5kb3I9MWQ2YiwgaWRQcm9kdWN0PTAwMDMKWyAgICAwLjM3NTc0NF0gdXNiIHVzYjQ6IE5ldyBV
U0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0xClsgICAg
MC4zNzU3NDhdIHVzYiB1c2I0OiBQcm9kdWN0OiB4SENJIEhvc3QgQ29udHJvbGxlcgpbICAgIDAu
Mzc1NzUyXSB1c2IgdXNiNDogTWFudWZhY3R1cmVyOiBMaW51eCAzLjguMC1uZXh0MjAxMzAyMjct
My1pbml6YS1zbWFsbCB4aGNpX2hjZApbICAgIDAuMzc1NzU2XSB1c2IgdXNiNDogU2VyaWFsTnVt
YmVyOiAwMDAwOjAzOjAwLjAKWyAgICAwLjM3NTgxOV0geEhDSSB4aGNpX2FkZF9lbmRwb2ludCBj
YWxsZWQgZm9yIHJvb3QgaHViClsgICAgMC4zNzU4MjFdIHhIQ0kgeGhjaV9jaGVja19iYW5kd2lk
dGggY2FsbGVkIGZvciByb290IGh1YgpbICAgIDAuMzc1ODM3XSBodWIgNC0wOjEuMDogVVNCIGh1
YiBmb3VuZApbICAgIDAuMzc1ODQ2XSBodWIgNC0wOjEuMDogMiBwb3J0cyBkZXRlY3RlZApbICAg
IDAuMzc1OTg1XSBpODA0MjogUE5QOiBQUy8yIENvbnRyb2xsZXIgW1BOUDAzMDM6UFMySyxQTlAw
ZjEzOkVQQURdIGF0IDB4NjAsMHg2NCBpcnEgMSwxMgpbICAgIDAuMzgzMDM4XSBzZXJpbzogaTgw
NDIgS0JEIHBvcnQgYXQgMHg2MCwweDY0IGlycSAxClsgICAgMC4zODMwNDZdIHNlcmlvOiBpODA0
MiBBVVggcG9ydCBhdCAweDYwLDB4NjQgaXJxIDEyClsgICAgMC4zODMxNDRdIG1vdXNlZGV2OiBQ
Uy8yIG1vdXNlIGRldmljZSBjb21tb24gZm9yIGFsbCBtaWNlClsgICAgMC4zODM1OTddIHJ0Y19j
bW9zIDAwOjA1OiBydGMgY29yZTogcmVnaXN0ZXJlZCBydGNfY21vcyBhcyBydGMwClsgICAgMC4z
ODM2MjldIHJ0Y19jbW9zIDAwOjA1OiBhbGFybXMgdXAgdG8gb25lIG1vbnRoLCB5M2ssIDI0MiBi
eXRlcyBudnJhbSwgaHBldCBpcnFzClsgICAgMC4zODM2OTNdIGRldmljZS1tYXBwZXI6IHVldmVu
dDogdmVyc2lvbiAxLjAuMwpbICAgIDAuMzgzNzQ2XSBkZXZpY2UtbWFwcGVyOiBpb2N0bDogNC4y
NC4wLWlvY3RsICgyMDEzLTAxLTE1KSBpbml0aWFsaXNlZDogZG0tZGV2ZWxAcmVkaGF0LmNvbQpb
ICAgIDAuMzgzNzU1XSBJbnRlbCBQLXN0YXRlIGRyaXZlciBpbml0aWFsaXppbmcuClsgICAgMC4z
ODM3NzBdIEludGVsIHBzdGF0ZSBjb250cm9sbGluZzogY3B1IDAKWyAgICAwLjM4Mzc4Nl0gSW50
ZWwgcHN0YXRlIGNvbnRyb2xsaW5nOiBjcHUgMQpbICAgIDAuMzgzODAwXSBJbnRlbCBwc3RhdGUg
Y29udHJvbGxpbmc6IGNwdSAyClsgICAgMC4zODM4MTRdIEludGVsIHBzdGF0ZSBjb250cm9sbGlu
ZzogY3B1IDMKWyAgICAwLjM4MzkxN10gY3B1aWRsZTogdXNpbmcgZ292ZXJub3IgbGFkZGVyClsg
ICAgMC4zODQwMjZdIGNwdWlkbGU6IHVzaW5nIGdvdmVybm9yIG1lbnUKWyAgICAwLjM4NDAzMl0g
bGVkdHJpZy1jcHU6IHJlZ2lzdGVyZWQgdG8gaW5kaWNhdGUgYWN0aXZpdHkgb24gQ1BVcwpbICAg
IDAuMzg0MDM1XSBFRkkgVmFyaWFibGVzIEZhY2lsaXR5IHYwLjA4IDIwMDQtTWF5LTE3ClsgICAg
MC4zODQxNDRdIGFzaG1lbTogaW5pdGlhbGl6ZWQKWyAgICAwLjM4NDI2OF0gVENQOiBjdWJpYyBy
ZWdpc3RlcmVkClsgICAgMC4zODQzNTBdIE5FVDogUmVnaXN0ZXJlZCBwcm90b2NvbCBmYW1pbHkg
MTAKWyAgICAwLjM4NDUwOV0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAxNwpbICAg
IDAuMzg0NTIwXSBLZXkgdHlwZSBkbnNfcmVzb2x2ZXIgcmVnaXN0ZXJlZApbICAgIDAuMzg0OTE0
XSBQTTogSGliZXJuYXRpb24gaW1hZ2Ugbm90IHByZXNlbnQgb3IgY291bGQgbm90IGJlIGxvYWRl
ZC4KWyAgICAwLjM4NDkxNl0gTG9hZGluZyBjb21waWxlZC1pbiBYLjUwOSBjZXJ0aWZpY2F0ZXMK
WyAgICAwLjM4NjI3OF0gTG9hZGVkIFguNTA5IGNlcnQgJ01hZ3JhdGhlYTogR2xhY2llciBzaWdu
aW5nIGtleTogNjliZjZhNTViZjE1NWIwOGQ0YzFkZDU0MjQ4OTZkNDgwOTMxZjVmYicKWyAgICAw
LjM4NjI5NV0gcmVnaXN0ZXJlZCB0YXNrc3RhdHMgdmVyc2lvbiAxClsgICAgMC4zODkwMDFdIEtl
eSB0eXBlIHRydXN0ZWQgcmVnaXN0ZXJlZApbICAgIDAuMzkyNDEwXSBpbnB1dDogQVQgVHJhbnNs
YXRlZCBTZXQgMiBrZXlib2FyZCBhcyAvZGV2aWNlcy9wbGF0Zm9ybS9pODA0Mi9zZXJpbzAvaW5w
dXQvaW5wdXQzClsgICAgMC4zOTM5MThdIEtleSB0eXBlIGVuY3J5cHRlZCByZWdpc3RlcmVkClsg
ICAgMC4zOTc5MTFdIEJJT1MgRUREIGZhY2lsaXR5IHYwLjE2IDIwMDQtSnVuLTI1LCAwIGRldmlj
ZXMgZm91bmQKWyAgICAwLjM5NzkyNF0gRUREIGluZm9ybWF0aW9uIG5vdCBhdmFpbGFibGUuClsg
ICAgMC42NTMyMTddIGF0YTE6IFNBVEEgbGluayB1cCAzLjAgR2JwcyAoU1N0YXR1cyAxMjMgU0Nv
bnRyb2wgMzAwKQpbICAgIDAuNjU0NTA1XSBhdGExLjAwOiBBVEEtODogSGl0YWNoaSBIVFM1NDUw
NTBBN0UzODAsIEdHMk9BNkMwLCBtYXggVURNQS8xMzMKWyAgICAwLjY1NDUyNV0gYXRhMS4wMDog
OTc2NzczMTY4IHNlY3RvcnMsIG11bHRpIDE2OiBMQkE0OCBOQ1EgKGRlcHRoIDMxLzMyKSwgQUEK
WyAgICAwLjY1NTkxMV0gYXRhMS4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMKWyAgICAwLjY1
NjM5MV0gc2NzaSAwOjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICBBVEEgICAgICBIaXRhY2hpIEhU
UzU0NTA1IEdHMk8gUFE6IDAgQU5TSTogNQpbICAgIDAuNjU2NzU4XSBzZCAwOjA6MDowOiBBdHRh
Y2hlZCBzY3NpIGdlbmVyaWMgc2cwIHR5cGUgMApbICAgIDAuNjU2NzkyXSBzZCAwOjA6MDowOiBb
c2RhXSA5NzY3NzMxNjggNTEyLWJ5dGUgbG9naWNhbCBibG9ja3M6ICg1MDAgR0IvNDY1IEdpQikK
WyAgICAwLjY1NjgxOF0gc2QgMDowOjA6MDogW3NkYV0gNDA5Ni1ieXRlIHBoeXNpY2FsIGJsb2Nr
cwpbICAgIDAuNjU3MTIzXSBzZCAwOjA6MDowOiBbc2RhXSBXcml0ZSBQcm90ZWN0IGlzIG9mZgpb
ICAgIDAuNjU3MTQxXSBzZCAwOjA6MDowOiBbc2RhXSBNb2RlIFNlbnNlOiAwMCAzYSAwMCAwMApb
ICAgIDAuNjU3MjYxXSBzZCAwOjA6MDowOiBbc2RhXSBXcml0ZSBjYWNoZTogZW5hYmxlZCwgcmVh
ZCBjYWNoZTogZW5hYmxlZCwgZG9lc24ndCBzdXBwb3J0IERQTyBvciBGVUEKWyAgICAwLjY2MTE1
Nl0gdXNiIDEtMTogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMiB1c2luZyBlaGNp
LXBjaQpbICAgIDAuNjY1MjAxXSAgc2RhOiBzZGExIHNkYTIgc2RhMwpbICAgIDAuNjY2NjU4XSBz
ZCAwOjA6MDowOiBbc2RhXSBBdHRhY2hlZCBTQ1NJIGRpc2sKWyAgICAwLjc5MzQ5M10gdXNiIDEt
MTogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9yPTgwODcsIGlkUHJvZHVjdD0wMDI0Clsg
ICAgMC43OTM1MTJdIHVzYiAxLTE6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0wLCBQcm9k
dWN0PTAsIFNlcmlhbE51bWJlcj0wClsgICAgMC43OTQwNzRdIGh1YiAxLTE6MS4wOiBVU0IgaHVi
IGZvdW5kClsgICAgMC43OTQyNTldIGh1YiAxLTE6MS4wOiA2IHBvcnRzIGRldGVjdGVkClsgICAg
MC45MDUwNDRdIHVzYiAyLTE6IG5ldyBoaWdoLXNwZWVkIFVTQiBkZXZpY2UgbnVtYmVyIDIgdXNp
bmcgZWhjaS1wY2kKWyAgICAwLjk3Mjk5MV0gYXRhMjogU0FUQSBsaW5rIHVwIDMuMCBHYnBzIChT
U3RhdHVzIDEyMyBTQ29udHJvbCAzMDApClsgICAgMC45NzM2MDVdIGF0YTIuMDA6IEFUQS04OiBT
YW5EaXNrIGlTU0QgUDQgMTZHQiwgU1NEIDkuMTQsIG1heCBVRE1BLzEzMwpbICAgIDAuOTczNjI0
XSBhdGEyLjAwOiAzMTI3NzIzMiBzZWN0b3JzLCBtdWx0aSAxOiBMQkE0OCAKWyAgICAwLjk3NDI5
MV0gYXRhMi4wMDogY29uZmlndXJlZCBmb3IgVURNQS8xMzMKWyAgICAwLjk3NDc1MV0gc2NzaSAx
OjA6MDowOiBEaXJlY3QtQWNjZXNzICAgICBBVEEgICAgICBTYW5EaXNrIGlTU0QgUDQgIFNTRCAg
UFE6IDAgQU5TSTogNQpbICAgIDAuOTc1MTQxXSBzZCAxOjA6MDowOiBBdHRhY2hlZCBzY3NpIGdl
bmVyaWMgc2cxIHR5cGUgMApbICAgIDAuOTc1MjMyXSBzZCAxOjA6MDowOiBbc2RiXSAzMTI3NzIz
MiA1MTItYnl0ZSBsb2dpY2FsIGJsb2NrczogKDE2LjAgR0IvMTQuOSBHaUIpClsgICAgMC45NzU4
NjRdIHNkIDE6MDowOjA6IFtzZGJdIFdyaXRlIFByb3RlY3QgaXMgb2ZmClsgICAgMC45NzU4ODJd
IHNkIDE6MDowOjA6IFtzZGJdIE1vZGUgU2Vuc2U6IDAwIDNhIDAwIDAwClsgICAgMC45NzYxMTdd
IHNkIDE6MDowOjA6IFtzZGJdIFdyaXRlIGNhY2hlOiBlbmFibGVkLCByZWFkIGNhY2hlOiBlbmFi
bGVkLCBkb2Vzbid0IHN1cHBvcnQgRFBPIG9yIEZVQQpbICAgIDAuOTc3MDMzXSAgc2RiOiBzZGIx
IHNkYjIKWyAgICAwLjk3Nzc5OF0gc2QgMTowOjA6MDogW3NkYl0gQXR0YWNoZWQgU0NTSSBkaXNr
ClsgICAgMS4wMzczMDRdIHVzYiAyLTE6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj04
MDg3LCBpZFByb2R1Y3Q9MDAyNApbICAgIDEuMDM3MzI0XSB1c2IgMi0xOiBOZXcgVVNCIGRldmlj
ZSBzdHJpbmdzOiBNZnI9MCwgUHJvZHVjdD0wLCBTZXJpYWxOdW1iZXI9MApbICAgIDEuMDM3ODk4
XSBodWIgMi0xOjEuMDogVVNCIGh1YiBmb3VuZApbICAgIDEuMDM4MDk0XSBodWIgMi0xOjEuMDog
NiBwb3J0cyBkZXRlY3RlZApbICAgIDEuMTA5MDA2XSB1c2IgMS0xLjI6IG5ldyBsb3ctc3BlZWQg
VVNCIGRldmljZSBudW1iZXIgMyB1c2luZyBlaGNpLXBjaQpbICAgIDEuMjA3MTE4XSB1c2IgMS0x
LjI6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0wNDZkLCBpZFByb2R1Y3Q9YzAwZQpb
ICAgIDEuMjA3MTM5XSB1c2IgMS0xLjI6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0xLCBQ
cm9kdWN0PTIsIFNlcmlhbE51bWJlcj0wClsgICAgMS4yMDcxNTNdIHVzYiAxLTEuMjogUHJvZHVj
dDogVVNCLVBTLzIgT3B0aWNhbCBNb3VzZQpbICAgIDEuMjA3MTYzXSB1c2IgMS0xLjI6IE1hbnVm
YWN0dXJlcjogTG9naXRlY2gKWyAgICAxLjI0NDc5MF0gdHNjOiBSZWZpbmVkIFRTQyBjbG9ja3Nv
dXJjZSBjYWxpYnJhdGlvbjogMTU5Ni4zNzYgTUh6ClsgICAgMS4yNDQ4MTRdIFN3aXRjaGluZyB0
byBjbG9ja3NvdXJjZSB0c2MKWyAgICAxLjI3NjkyNF0gdXNiIDEtMS40OiBuZXcgaGlnaC1zcGVl
ZCBVU0IgZGV2aWNlIG51bWJlciA0IHVzaW5nIGVoY2ktcGNpClsgICAgMS4yOTI3NDRdIGF0YTQ6
IFNBVEEgbGluayBkb3duIChTU3RhdHVzIDAgU0NvbnRyb2wgMzAwKQpbICAgIDEuNTI5MDQ0XSB1
c2IgMS0xLjQ6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj0yMjMyLCBpZFByb2R1Y3Q9
MTAxOApbICAgIDEuNTI5MDY1XSB1c2IgMS0xLjQ6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1m
cj0xLCBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0wClsgICAgMS41MjkwNzhdIHVzYiAxLTEuNDog
UHJvZHVjdDogV2ViQ2FtIFNDLTEzSERMMTE0MzFOClsgICAgMS41MjkwODhdIHVzYiAxLTEuNDog
TWFudWZhY3R1cmVyOiAxMjMKWyAgICAxLjYxMjUzM10gYXRhNTogU0FUQSBsaW5rIGRvd24gKFNT
dGF0dXMgMCBTQ29udHJvbCAzMDApClsgICAgMS42MTUzNzNdIEZyZWVpbmcgdW51c2VkIGtlcm5l
bCBtZW1vcnk6IDEyNTJrIGZyZWVkClsgICAgMS42MTU3NTRdIFdyaXRlIHByb3RlY3RpbmcgdGhl
IGtlcm5lbCByZWFkLW9ubHkgZGF0YTogMTIyODhrClsgICAgMS42MjMyNzVdIEZyZWVpbmcgdW51
c2VkIGtlcm5lbCBtZW1vcnk6IDEyMDRrIGZyZWVkClsgICAgMS42Mjk1MTJdIEZyZWVpbmcgdW51
c2VkIGtlcm5lbCBtZW1vcnk6IDExMDRrIGZyZWVkClsgICAgMS42NjYyMzBdIHVkZXZkWzEyMF06
IHN0YXJ0aW5nIHZlcnNpb24gMTc1ClsgICAgMS43MTEyNzZdIGhpZHJhdzogcmF3IEhJRCBldmVu
dHMgZHJpdmVyIChDKSBKaXJpIEtvc2luYQpbICAgIDEuNzE3NDY1XSByODE2OSBHaWdhYml0IEV0
aGVybmV0IGRyaXZlciAyLjNMSy1OQVBJIGxvYWRlZApbICAgIDEuNzE3ODg4XSByODE2OSAwMDAw
OjAyOjAwLjA6IGlycSA0NiBmb3IgTVNJL01TSS1YClsgICAgMS43MTgyMTldIHI4MTY5IDAwMDA6
MDI6MDAuMCBldGgwOiBSVEw4MTY4ZXZsLzgxMTFldmwgYXQgMHhmZmZmYzkwMDAwNjY2MDAwLCBl
ODowMzo5YTozNjoxNzphOSwgWElEIDBjOTAwODAwIElSUSA0NgpbICAgIDEuNzE4MjMyXSByODE2
OSAwMDAwOjAyOjAwLjAgZXRoMDoganVtYm8gZmVhdHVyZXMgW2ZyYW1lczogOTIwMCBieXRlcywg
dHggY2hlY2tzdW1taW5nOiBrb10KWyAgICAxLjcyMjg2M10gdXNiY29yZTogcmVnaXN0ZXJlZCBu
ZXcgaW50ZXJmYWNlIGRyaXZlciB1c2JoaWQKWyAgICAxLjcyMjg3NF0gdXNiaGlkOiBVU0IgSElE
IGNvcmUgZHJpdmVyClsgICAgMS43NzExNjldIGlucHV0OiBMb2dpdGVjaCBVU0ItUFMvMiBPcHRp
Y2FsIE1vdXNlIGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxYS4wL3VzYjEvMS0xLzEt
MS4yLzEtMS4yOjEuMC9pbnB1dC9pbnB1dDQKWyAgICAxLjc3MTI4Nl0gaGlkLWdlbmVyaWMgMDAw
MzowNDZEOkMwMEUuMDAwMTogaW5wdXQsaGlkcmF3MDogVVNCIEhJRCB2MS4xMCBNb3VzZSBbTG9n
aXRlY2ggVVNCLVBTLzIgT3B0aWNhbCBNb3VzZV0gb24gdXNiLTAwMDA6MDA6MWEuMC0xLjIvaW5w
dXQwClsgICAgMS43NzI0MDRdIHVzYiAyLTEuNTogbmV3IGZ1bGwtc3BlZWQgVVNCIGRldmljZSBu
dW1iZXIgMyB1c2luZyBlaGNpLXBjaQpbICAgIDEuODY4MzEzXSB1c2IgMi0xLjU6IE5ldyBVU0Ig
ZGV2aWNlIGZvdW5kLCBpZFZlbmRvcj04MDg2LCBpZFByb2R1Y3Q9MDE4OQpbICAgIDEuODY4MzM2
XSB1c2IgMi0xLjU6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0wLCBQcm9kdWN0PTAsIFNl
cmlhbE51bWJlcj0wClsgICAgMi42MDUzMjldIEVYVDQtZnMgKGxvb3AwKTogbW91bnRlZCBmaWxl
c3lzdGVtIHdpdGggb3JkZXJlZCBkYXRhIG1vZGUuIE9wdHM6IChudWxsKQpbICAgMjUuNDMxODE1
XSBBZGRpbmcgMjYyMTQwayBzd2FwIG9uIC9ob3N0L3VidW50dS9kaXNrcy9zd2FwLmRpc2suICBQ
cmlvcml0eTotMSBleHRlbnRzOjEgYWNyb3NzOjI2MjE0MGsgClsgICAyNS40NDU4MzVdIEVYVDQt
ZnMgKGxvb3AwKTogcmUtbW91bnRlZC4gT3B0czogZXJyb3JzPXJlbW91bnQtcm8KWyAgIDI1LjQ3
OTk5N10gdWRldmRbNTgzXTogc3RhcnRpbmcgdmVyc2lvbiAxNzUKWyAgIDI1Ljc4OTU2M10gQUNQ
SSBXYXJuaW5nOiAweDAwMDAwMDAwMDAwMDA0MjgtMHgwMDAwMDAwMDAwMDAwNDJmIFN5c3RlbUlP
IGNvbmZsaWN0cyB3aXRoIFJlZ2lvbiBcUE1JTyAxICgyMDEzMDExNy91dGFkZHJlc3MtMjUxKQpb
ICAgMjUuNzg5NTc0XSBBQ1BJOiBJZiBhbiBBQ1BJIGRyaXZlciBpcyBhdmFpbGFibGUgZm9yIHRo
aXMgZGV2aWNlLCB5b3Ugc2hvdWxkIHVzZSBpdCBpbnN0ZWFkIG9mIHRoZSBuYXRpdmUgZHJpdmVy
ClsgICAyNS43ODk1NzldIEFDUEkgV2FybmluZzogMHgwMDAwMDAwMDAwMDAwNTQwLTB4MDAwMDAw
MDAwMDAwMDU0ZiBTeXN0ZW1JTyBjb25mbGljdHMgd2l0aCBSZWdpb24gXEdQSU8gMSAoMjAxMzAx
MTcvdXRhZGRyZXNzLTI1MSkKWyAgIDI1Ljc4OTU4NF0gQUNQSTogSWYgYW4gQUNQSSBkcml2ZXIg
aXMgYXZhaWxhYmxlIGZvciB0aGlzIGRldmljZSwgeW91IHNob3VsZCB1c2UgaXQgaW5zdGVhZCBv
ZiB0aGUgbmF0aXZlIGRyaXZlcgpbICAgMjUuNzg5NTg3XSBBQ1BJIFdhcm5pbmc6IDB4MDAwMDAw
MDAwMDAwMDUzMC0weDAwMDAwMDAwMDAwMDA1M2YgU3lzdGVtSU8gY29uZmxpY3RzIHdpdGggUmVn
aW9uIFxHUElPIDEgKDIwMTMwMTE3L3V0YWRkcmVzcy0yNTEpClsgICAyNS43ODk1OTFdIEFDUEk6
IElmIGFuIEFDUEkgZHJpdmVyIGlzIGF2YWlsYWJsZSBmb3IgdGhpcyBkZXZpY2UsIHlvdSBzaG91
bGQgdXNlIGl0IGluc3RlYWQgb2YgdGhlIG5hdGl2ZSBkcml2ZXIKWyAgIDI1Ljc4OTU5M10gQUNQ
SSBXYXJuaW5nOiAweDAwMDAwMDAwMDAwMDA1MDAtMHgwMDAwMDAwMDAwMDAwNTJmIFN5c3RlbUlP
IGNvbmZsaWN0cyB3aXRoIFJlZ2lvbiBcR1BJTyAxICgyMDEzMDExNy91dGFkZHJlc3MtMjUxKQpb
ICAgMjUuNzg5NTk3XSBBQ1BJOiBJZiBhbiBBQ1BJIGRyaXZlciBpcyBhdmFpbGFibGUgZm9yIHRo
aXMgZGV2aWNlLCB5b3Ugc2hvdWxkIHVzZSBpdCBpbnN0ZWFkIG9mIHRoZSBuYXRpdmUgZHJpdmVy
ClsgICAyNS43ODk1OTldIGxwY19pY2g6IFJlc291cmNlIGNvbmZsaWN0KHMpIGZvdW5kIGFmZmVj
dGluZyBncGlvX2ljaApbICAgMjUuOTU4NDYzXSBtZWkgMDAwMDowMDoxNi4wOiBzZXR0aW5nIGxh
dGVuY3kgdGltZXIgdG8gNjQKWyAgIDI1Ljk1ODU0Ml0gbWVpIDAwMDA6MDA6MTYuMDogaXJxIDQ3
IGZvciBNU0kvTVNJLVgKWyAgIDI1Ljk3MDI4NV0gd21pOiBNYXBwZXIgbG9hZGVkClsgICAyNi4w
Mzg0ODFdIHNhbXN1bmdfbGFwdG9wOiBkZXRlY3RlZCBTQUJJIGludGVyZmFjZTogU3dTbWlAClsg
ICAyNi4wMzg0ODVdIHNhbXN1bmdfbGFwdG9wOiBCYWNrbGlnaHQgY29udHJvbGxlZCBieSBBQ1BJ
IHZpZGVvIGRyaXZlcgpbICAgMjYuMTcxMTYwXSBCbHVldG9vdGg6IENvcmUgdmVyIDIuMTYKWyAg
IDI2LjE3MTE4Nl0gTkVUOiBSZWdpc3RlcmVkIHByb3RvY29sIGZhbWlseSAzMQpbICAgMjYuMTcx
MTg5XSBCbHVldG9vdGg6IEhDSSBkZXZpY2UgYW5kIGNvbm5lY3Rpb24gbWFuYWdlciBpbml0aWFs
aXplZApbICAgMjYuMTcxMTk5XSBCbHVldG9vdGg6IEhDSSBzb2NrZXQgbGF5ZXIgaW5pdGlhbGl6
ZWQKWyAgIDI2LjE3MTIwMl0gQmx1ZXRvb3RoOiBMMkNBUCBzb2NrZXQgbGF5ZXIgaW5pdGlhbGl6
ZWQKWyAgIDI2LjE3MTIwOV0gQmx1ZXRvb3RoOiBTQ08gc29ja2V0IGxheWVyIGluaXRpYWxpemVk
ClsgICAyNi40NDg0NzVdIGxwOiBkcml2ZXIgbG9hZGVkIGJ1dCBubyBkZXZpY2VzIGZvdW5kClsg
ICAyNi40NzcxMzVdIHR5cGU9MTQwMCBhdWRpdCgxMzYxOTcwMjQ1LjQ5MjoyKTogYXBwYXJtb3I9
IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9maWxlX2xvYWQiIG5hbWU9Ii9zYmluL2RoY2xpZW50IiBw
aWQ9Njk1IGNvbW09ImFwcGFybW9yX3BhcnNlciIKWyAgIDI2LjQ3NzE0NF0gdHlwZT0xNDAwIGF1
ZGl0KDEzNjE5NzAyNDUuNDkyOjMpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2Zp
bGVfcmVwbGFjZSIgbmFtZT0iL3NiaW4vZGhjbGllbnQiIHBpZD03NjcgY29tbT0iYXBwYXJtb3Jf
cGFyc2VyIgpbICAgMjYuNDc3NjQ4XSB0eXBlPTE0MDAgYXVkaXQoMTM2MTk3MDI0NS40OTI6NCk6
IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2FkIiBuYW1lPSIvdXNyL2xp
Yi9OZXR3b3JrTWFuYWdlci9ubS1kaGNwLWNsaWVudC5hY3Rpb24iIHBpZD02OTUgY29tbT0iYXBw
YXJtb3JfcGFyc2VyIgpbICAgMjYuNDc3NjU1XSB0eXBlPTE0MDAgYXVkaXQoMTM2MTk3MDI0NS40
OTI6NSk6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9yZXBsYWNlIiBuYW1l
PSIvdXNyL2xpYi9OZXR3b3JrTWFuYWdlci9ubS1kaGNwLWNsaWVudC5hY3Rpb24iIHBpZD03Njcg
Y29tbT0iYXBwYXJtb3JfcGFyc2VyIgpbICAgMjYuNDc3OTQyXSB0eXBlPTE0MDAgYXVkaXQoMTM2
MTk3MDI0NS40OTI6Nik6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9sb2Fk
IiBuYW1lPSIvdXNyL2xpYi9jb25ubWFuL3NjcmlwdHMvZGhjbGllbnQtc2NyaXB0IiBwaWQ9Njk1
IGNvbW09ImFwcGFybW9yX3BhcnNlciIKWyAgIDI2LjQ3Nzk1MF0gdHlwZT0xNDAwIGF1ZGl0KDEz
NjE5NzAyNDUuNDkyOjcpOiBhcHBhcm1vcj0iU1RBVFVTIiBvcGVyYXRpb249InByb2ZpbGVfcmVw
bGFjZSIgbmFtZT0iL3Vzci9saWIvY29ubm1hbi9zY3JpcHRzL2RoY2xpZW50LXNjcmlwdCIgcGlk
PTc2NyBjb21tPSJhcHBhcm1vcl9wYXJzZXIiClsgICAyNi40ODAzMzFdIExpbnV4IHZpZGVvIGNh
cHR1cmUgaW50ZXJmYWNlOiB2Mi4wMApbICAgMjYuNDk5NzMwXSBtaWNyb2NvZGU6IENQVTAgc2ln
PTB4MjA2YTcsIHBmPTB4MTAsIHJldmlzaW9uPTB4MjgKWyAgIDI2LjY2OTgzN10gaW5pdDogZmFp
bHNhZmUgbWFpbiBwcm9jZXNzICg4OTUpIGtpbGxlZCBieSBURVJNIHNpZ25hbApbICAgMjYuNzAy
MTQ5XSBtaWNyb2NvZGU6IENQVTEgc2lnPTB4MjA2YTcsIHBmPTB4MTAsIHJldmlzaW9uPTB4MjgK
WyAgIDI2LjcwMzczNl0gbWljcm9jb2RlOiBDUFUyIHNpZz0weDIwNmE3LCBwZj0weDEwLCByZXZp
c2lvbj0weDI4ClsgICAyNi43MDUxNjVdIG1pY3JvY29kZTogQ1BVMyBzaWc9MHgyMDZhNywgcGY9
MHgxMCwgcmV2aXNpb249MHgyOApbICAgMjYuNzA2NzE0XSBtaWNyb2NvZGU6IE1pY3JvY29kZSBV
cGRhdGUgRHJpdmVyOiB2Mi4wMCA8dGlncmFuQGFpdmF6aWFuLmZzbmV0LmNvLnVrPiwgUGV0ZXIg
T3J1YmEKWyAgIDI2LjcxMjEzNl0gY2ZnODAyMTE6IENhbGxpbmcgQ1JEQSB0byB1cGRhdGUgd29y
bGQgcmVndWxhdG9yeSBkb21haW4KWyAgIDI2LjcxNzE3N10gY2ZnODAyMTE6IFdvcmxkIHJlZ3Vs
YXRvcnkgZG9tYWluIHVwZGF0ZWQ6ClsgICAyNi43MTcxODFdIGNmZzgwMjExOiAgIChzdGFydF9m
cmVxIC0gZW5kX2ZyZXEgQCBiYW5kd2lkdGgpLCAobWF4X2FudGVubmFfZ2FpbiwgbWF4X2VpcnAp
ClsgICAyNi43MTcxODNdIGNmZzgwMjExOiAgICgyNDAyMDAwIEtIeiAtIDI0NzIwMDAgS0h6IEAg
NDAwMDAgS0h6KSwgKDMwMCBtQmksIDIwMDAgbUJtKQpbICAgMjYuNzE3MTg1XSBjZmc4MDIxMTog
ICAoMjQ1NzAwMCBLSHogLSAyNDgyMDAwIEtIeiBAIDIwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAw
IG1CbSkKWyAgIDI2LjcxNzE4Nl0gY2ZnODAyMTE6ICAgKDI0NzQwMDAgS0h6IC0gMjQ5NDAwMCBL
SHogQCAyMDAwMCBLSHopLCAoMzAwIG1CaSwgMjAwMCBtQm0pClsgICAyNi43MTcxODhdIGNmZzgw
MjExOiAgICg1MTcwMDAwIEtIeiAtIDUyNTAwMDAgS0h6IEAgNDAwMDAgS0h6KSwgKDMwMCBtQmks
IDIwMDAgbUJtKQpbICAgMjYuNzE3MTg5XSBjZmc4MDIxMTogICAoNTczNTAwMCBLSHogLSA1ODM1
MDAwIEtIeiBAIDQwMDAwIEtIeiksICgzMDAgbUJpLCAyMDAwIG1CbSkKWyAgIDI2LjczNTI5MV0g
dXNiY29yZTogcmVnaXN0ZXJlZCBuZXcgaW50ZXJmYWNlIGRyaXZlciBidHVzYgpbICAgMjYuODA0
NjI1XSB0eXBlPTE0MDAgYXVkaXQoMTM2MTk3MDI0NS44MTY6OCk6IGFwcGFybW9yPSJTVEFUVVMi
IG9wZXJhdGlvbj0icHJvZmlsZV9yZXBsYWNlIiBuYW1lPSIvc2Jpbi9kaGNsaWVudCIgcGlkPTEw
MTQgY29tbT0iYXBwYXJtb3JfcGFyc2VyIgpbICAgMjYuODA1MTUwXSB0eXBlPTE0MDAgYXVkaXQo
MTM2MTk3MDI0NS44MTY6OSk6IGFwcGFybW9yPSJTVEFUVVMiIG9wZXJhdGlvbj0icHJvZmlsZV9y
ZXBsYWNlIiBuYW1lPSIvdXNyL2xpYi9OZXR3b3JrTWFuYWdlci9ubS1kaGNwLWNsaWVudC5hY3Rp
b24iIHBpZD0xMDE0IGNvbW09ImFwcGFybW9yX3BhcnNlciIKWyAgIDI2LjgwNTQ1M10gdHlwZT0x
NDAwIGF1ZGl0KDEzNjE5NzAyNDUuODE2OjEwKTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9u
PSJwcm9maWxlX3JlcGxhY2UiIG5hbWU9Ii91c3IvbGliL2Nvbm5tYW4vc2NyaXB0cy9kaGNsaWVu
dC1zY3JpcHQiIHBpZD0xMDE0IGNvbW09ImFwcGFybW9yX3BhcnNlciIKWyAgIDI2LjkyMzYyNV0g
Qmx1ZXRvb3RoOiBCTkVQIChFdGhlcm5ldCBFbXVsYXRpb24pIHZlciAxLjMKWyAgIDI2LjkyMzYz
MF0gQmx1ZXRvb3RoOiBCTkVQIGZpbHRlcnM6IHByb3RvY29sIG11bHRpY2FzdApbICAgMjYuOTIz
NjM4XSBCbHVldG9vdGg6IEJORVAgc29ja2V0IGxheWVyIGluaXRpYWxpemVkClsgICAyNi45MzE3
OThdIEJsdWV0b290aDogUkZDT01NIFRUWSBsYXllciBpbml0aWFsaXplZApbICAgMjYuOTMxODEy
XSBCbHVldG9vdGg6IFJGQ09NTSBzb2NrZXQgbGF5ZXIgaW5pdGlhbGl6ZWQKWyAgIDI2LjkzMTgx
NF0gQmx1ZXRvb3RoOiBSRkNPTU0gdmVyIDEuMTEKWyAgIDI3LjA1NzU5MV0gdHlwZT0xNDAwIGF1
ZGl0KDEzNjE5NzAyNDYuMDcyOjExKTogYXBwYXJtb3I9IlNUQVRVUyIgb3BlcmF0aW9uPSJwcm9m
aWxlX2xvYWQiIG5hbWU9Ii91c3IvbGliL2xpZ2h0ZG0vbGlnaHRkbS9saWdodGRtLWd1ZXN0LXNl
c3Npb24td3JhcHBlciIgcGlkPTEwMTMgY29tbT0iYXBwYXJtb3JfcGFyc2VyIgpbICAgMjcuMTAy
NDM4XSBwcGRldjogdXNlci1zcGFjZSBwYXJhbGxlbCBwb3J0IGRyaXZlcgpbICAgMjcuMTA3OTQ0
XSBbZHJtXSBJbml0aWFsaXplZCBkcm0gMS4xLjAgMjAwNjA4MTAKWyAgIDI3LjQ0NTg5M10gSW50
ZWwoUikgV2lyZWxlc3MgV2lGaSBkcml2ZXIgZm9yIExpbnV4LCBpbi10cmVlOmQKWyAgIDI3LjQ0
NTg5OF0gQ29weXJpZ2h0KGMpIDIwMDMtMjAxMyBJbnRlbCBDb3Jwb3JhdGlvbgpbICAgMjcuNDQ2
MjY2XSBpd2x3aWZpIDAwMDA6MDE6MDAuMDogaXJxIDQ4IGZvciBNU0kvTVNJLVgKWyAgIDI3LjQ0
NjY5Nl0gaXdsd2lmaSAwMDAwOjAxOjAwLjA6IGxvYWRlZCBmaXJtd2FyZSB2ZXJzaW9uIDE4LjE2
OC42LjEKWyAgIDI3LjQ2NTUyOF0gdXZjdmlkZW86IEZvdW5kIFVWQyAxLjAwIGRldmljZSBXZWJD
YW0gU0MtMTNIREwxMTQzMU4gKDIyMzI6MTAxOCkKWyAgIDI3LjQ4NDkwNF0gaW5wdXQ6IFdlYkNh
bSBTQy0xM0hETDExNDMxTiBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWEuMC91c2Ix
LzEtMS8xLTEuNC8xLTEuNDoxLjAvaW5wdXQvaW5wdXQ1ClsgICAyNy40ODUwMzldIHVzYmNvcmU6
IHJlZ2lzdGVyZWQgbmV3IGludGVyZmFjZSBkcml2ZXIgdXZjdmlkZW8KWyAgIDI3LjQ4NTA0M10g
VVNCIFZpZGVvIENsYXNzIGRyaXZlciAoMS4xLjEpClsgICAyNy42NDIwMzBdIGluaXQ6IGFsc2Et
cmVzdG9yZSBtYWluIHByb2Nlc3MgKDExMDQpIHRlcm1pbmF0ZWQgd2l0aCBzdGF0dXMgMTkKWyAg
IDI3LjY1MDc5M10gcHNtb3VzZSBzZXJpbzE6IGVsYW50ZWNoOiBhc3N1bWluZyBoYXJkd2FyZSB2
ZXJzaW9uIDMgKHdpdGggZmlybXdhcmUgdmVyc2lvbiAweDQ1MGYwMCkKWyAgIDI3LjY2MTMzOF0g
W2RybV0gTWVtb3J5IHVzYWJsZSBieSBncmFwaGljcyBkZXZpY2UgPSAyMDQ4TQpbICAgMjcuNjYx
MzUwXSBpOTE1IDAwMDA6MDA6MDIuMDogc2V0dGluZyBsYXRlbmN5IHRpbWVyIHRvIDY0ClsgICAy
Ny42NjU4OThdIHBzbW91c2Ugc2VyaW8xOiBlbGFudGVjaDogU3luYXB0aWNzIGNhcGFiaWxpdGll
cyBxdWVyeSByZXN1bHQgMHgwOCwgMHgxNywgMHgwYy4KWyAgIDI3LjcwNTI0OV0gaTkxNSAwMDAw
OjAwOjAyLjA6IGlycSA0OSBmb3IgTVNJL01TSS1YClsgICAyNy43MDUyNjBdIFtkcm1dIFN1cHBv
cnRzIHZibGFuayB0aW1lc3RhbXAgY2FjaGluZyBSZXYgMSAoMTAuMTAuMjAxMCkuClsgICAyNy43
MDUyNjFdIFtkcm1dIERyaXZlciBzdXBwb3J0cyBwcmVjaXNlIHZibGFuayB0aW1lc3RhbXAgcXVl
cnkuClsgICAyNy43MDUzMjJdIHZnYWFyYjogZGV2aWNlIGNoYW5nZWQgZGVjb2RlczogUENJOjAw
MDA6MDA6MDIuMCxvbGRkZWNvZGVzPWlvK21lbSxkZWNvZGVzPWlvK21lbTpvd25zPWlvK21lbQpb
ICAgMjcuNzE1MzcwXSBbZHJtXSBXcm9uZyBNQ0hfU1NLUEQgdmFsdWU6IDB4MTYwNDAzMDcKWyAg
IDI3LjcxNTM3NF0gW2RybV0gVGhpcyBjYW4gY2F1c2UgcGlwZSB1bmRlcnJ1bnMgYW5kIGRpc3Bs
YXkgaXNzdWVzLgpbICAgMjcuNzE1Mzc1XSBbZHJtXSBQbGVhc2UgdXBncmFkZSB5b3VyIEJJT1Mg
dG8gZml4IHRoaXMuClsgICAyNy43MzIzNzJdIGZiY29uOiBpbnRlbGRybWZiIChmYjApIGlzIHBy
aW1hcnkgZGV2aWNlClsgICAyNy43NDEzODhdIGlucHV0OiBFVFBTLzIgRWxhbnRlY2ggVG91Y2hw
YWQgYXMgL2RldmljZXMvcGxhdGZvcm0vaTgwNDIvc2VyaW8xL2lucHV0L2lucHV0NgpbICAgMjcu
NzQ5Njc4XSBpd2x3aWZpIDAwMDA6MDE6MDAuMDogQ09ORklHX0lXTFdJRklfREVCVUcgZW5hYmxl
ZApbICAgMjcuNzQ5NjgwXSBpd2x3aWZpIDAwMDA6MDE6MDAuMDogQ09ORklHX0lXTFdJRklfREVC
VUdGUyBlbmFibGVkClsgICAyNy43NDk2ODFdIGl3bHdpZmkgMDAwMDowMTowMC4wOiBDT05GSUdf
SVdMV0lGSV9ERVZJQ0VfVFJBQ0lORyBlbmFibGVkClsgICAyNy43NDk2ODJdIGl3bHdpZmkgMDAw
MDowMTowMC4wOiBDT05GSUdfSVdMV0lGSV9ERVZJQ0VfVEVTVE1PREUgZW5hYmxlZApbICAgMjcu
NzQ5NjgzXSBpd2x3aWZpIDAwMDA6MDE6MDAuMDogQ09ORklHX0lXTFdJRklfUDJQIGRpc2FibGVk
ClsgICAyNy43NDk2ODVdIGl3bHdpZmkgMDAwMDowMTowMC4wOiBEZXRlY3RlZCBJbnRlbChSKSBD
ZW50cmlubyhSKSBBZHZhbmNlZC1OIDYyMzAgQUdOLCBSRVY9MHhCMApbICAgMjcuNzQ5NzM0XSBp
d2x3aWZpIDAwMDA6MDE6MDAuMDogTDEgRW5hYmxlZDsgRGlzYWJsaW5nIEwwUwpbICAgMjcuNzk0
Nzc4XSBpZWVlODAyMTEgcGh5MDogU2VsZWN0ZWQgcmF0ZSBjb250cm9sIGFsZ29yaXRobSAnaXds
LWFnbi1ycycKWyAgIDI3LjgwNDE4M10gaXdsd2lmaSAwMDAwOjAxOjAwLjA6IEwxIEVuYWJsZWQ7
IERpc2FibGluZyBMMFMKWyAgIDI3LjgxMDgxMV0gaXdsd2lmaSAwMDAwOjAxOjAwLjA6IFJhZGlv
IHR5cGU9MHgxLTB4Mi0weDAKWyAgIDI4LjE4NzE1NV0gaXdsd2lmaSAwMDAwOjAxOjAwLjA6IEwx
IEVuYWJsZWQ7IERpc2FibGluZyBMMFMKWyAgIDI4LjE5MzgwNF0gaXdsd2lmaSAwMDAwOjAxOjAw
LjA6IFJhZGlvIHR5cGU9MHgxLTB4Mi0weDAKWyAgIDI4LjQwMjA0M10gSVB2NjogQUREUkNPTkYo
TkVUREVWX1VQKTogd2xhbjA6IGxpbmsgaXMgbm90IHJlYWR5ClsgICAyOC40MjcxMThdIGl3bHdp
ZmkgMDAwMDowMTowMC4wOiBMMSBFbmFibGVkOyBEaXNhYmxpbmcgTDBTClsgICAyOC40MzM4MDZd
IGl3bHdpZmkgMDAwMDowMTowMC4wOiBSYWRpbyB0eXBlPTB4MS0weDItMHgwClsgICAyOC42MzI0
MjFdIElQdjY6IEFERFJDT05GKE5FVERFVl9VUCk6IHdsYW4wOiBsaW5rIGlzIG5vdCByZWFkeQpb
ICAgMjguNzM3NDkwXSBDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29sb3VyIGZyYW1lIGJ1ZmZlciBk
ZXZpY2UgMTcweDQ4ClsgICAyOC43NDM5MjNdIGk5MTUgMDAwMDowMDowMi4wOiBmYjA6IGludGVs
ZHJtZmIgZnJhbWUgYnVmZmVyIGRldmljZQpbICAgMjguNzQzOTI2XSBpOTE1IDAwMDA6MDA6MDIu
MDogcmVnaXN0ZXJlZCBwYW5pYyBub3RpZmllcgpbICAgMjguNzU0NDQ5XSBhY3BpIGRldmljZToz
MjogcmVnaXN0ZXJlZCBhcyBjb29saW5nX2RldmljZTkKWyAgIDI4Ljc1NDc1NV0gQUNQSTogVmlk
ZW8gRGV2aWNlIFtHRlgwXSAobXVsdGktaGVhZDogeWVzICByb206IG5vICBwb3N0OiBubykKWyAg
IDI4Ljc1NDgyNF0gaW5wdXQ6IFZpZGVvIEJ1cyBhcyAvZGV2aWNlcy9MTlhTWVNUTTowMC9MTlhT
WUJVUzowMC9QTlAwQTA4OjAwL0xOWFZJREVPOjAwL2lucHV0L2lucHV0NwpbICAgMjguNzU1MDQw
XSBbZHJtXSBJbml0aWFsaXplZCBpOTE1IDEuNi4wIDIwMDgwNzMwIGZvciAwMDAwOjAwOjAyLjAg
b24gbWlub3IgMApbICAgMjguNzU1Mjc4XSBzbmRfaGRhX2ludGVsIDAwMDA6MDA6MWIuMDogaXJx
IDUwIGZvciBNU0kvTVNJLVgKWyAgIDI4Ljc4MTgzNV0gaW5pdDogcGx5bW91dGgtc3BsYXNoIG1h
aW4gcHJvY2VzcyAoMTM4MSkgdGVybWluYXRlZCB3aXRoIHN0YXR1cyAxClsgICAyOC43ODMyMjNd
IGlucHV0OiBIREEgSW50ZWwgUENIIEhETUkvRFAscGNtPTMgYXMgL2RldmljZXMvcGNpMDAwMDow
MC8wMDAwOjAwOjFiLjAvc291bmQvY2FyZDAvaW5wdXQ4ClsgICAyOC43ODM0NTRdIGlucHV0OiBI
REEgSW50ZWwgUENIIE1pYyBhcyAvZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MWIuMC9zb3Vu
ZC9jYXJkMC9pbnB1dDkKWyAgIDI4Ljc4MzU3Nl0gaW5wdXQ6IEhEQSBJbnRlbCBQQ0ggSGVhZHBo
b25lIGFzIC9kZXZpY2VzL3BjaTAwMDA6MDAvMDAwMDowMDoxYi4wL3NvdW5kL2NhcmQwL2lucHV0
MTAKWyAgIDI4LjgwMTQyMF0gW2RybV0gRW5hYmxpbmcgUkM2IHN0YXRlczogUkM2IG9uLCBSQzZw
IG9mZiwgUkM2cHAgb2ZmClsgICAzNC44ODI5OTZdIHdsYW4wOiBhdXRoZW50aWNhdGUgd2l0aCAw
MDowNDowZTplNDowMDozZApbICAgMzQuODkzODAxXSB3bGFuMDogc2VuZCBhdXRoIHRvIDAwOjA0
OjBlOmU0OjAwOjNkICh0cnkgMS8zKQpbICAgMzQuODk1NTk5XSB3bGFuMDogYXV0aGVudGljYXRl
ZApbICAgMzQuODk1NjUwXSBpd2x3aWZpIDAwMDA6MDE6MDAuMCB3bGFuMDogZGlzYWJsaW5nIEhU
IGFzIFdNTS9Rb1MgaXMgbm90IHN1cHBvcnRlZCBieSB0aGUgQVAKWyAgIDM0Ljg5NTY1N10gaXds
d2lmaSAwMDAwOjAxOjAwLjAgd2xhbjA6IGRpc2FibGluZyBWSFQgYXMgV01NL1FvUyBpcyBub3Qg
c3VwcG9ydGVkIGJ5IHRoZSBBUApbICAgMzQuODk2OTU5XSB3bGFuMDogYXNzb2NpYXRlIHdpdGgg
MDA6MDQ6MGU6ZTQ6MDA6M2QgKHRyeSAxLzMpClsgICAzNC45MDA2NDhdIHdsYW4wOiBSWCBBc3Nv
Y1Jlc3AgZnJvbSAwMDowNDowZTplNDowMDozZCAoY2FwYWI9MHg0MTEgc3RhdHVzPTAgYWlkPTEp
ClsgICAzNC45MDc3MjldIHdsYW4wOiBhc3NvY2lhdGVkClsgICAzNC45MDc3NzVdIElQdjY6IEFE
RFJDT05GKE5FVERFVl9DSEFOR0UpOiB3bGFuMDogbGluayBiZWNvbWVzIHJlYWR5ClsgIDEwOS41
ODk3NzddIHVzYiAyLTEuNTogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgMwo=
--f46d044282c41dc4f504d6b47924
Content-Type: application/octet-stream; 
	name="3.8.0-next20130227-3-iniza-small.patch"
Content-Disposition: attachment; 
	filename="3.8.0-next20130227-3-iniza-small.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hdoi1luf0

U2VkYXQgRGlsZWsgKDcpOgogICAgICBrYnVpbGQ6IGRlYi1wa2c6IFRyeSB0byBkZXRlcm1pbmUg
ZGlzdHJpYnV0aW9uCiAgICAgIGtidWlsZDogZGViLXBrZzogQnVtcCB5ZWFyIGluIGRlYmlhbi9j
b3B5cmlnaHQgZmlsZQogICAgICBrYnVpbGQ6IGRlYi1wa2c6IFVwZGF0ZSBnaXQgcmVwb3NpdG9y
eSBVUkwgaW4gZGViaWFuL2NvcHlyaWdodCBmaWxlCiAgICAgIE1lcmdlIHRhZyAnbmV4dC0yMDEz
MDIyNycgb2YgZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvLi4uL25leHQvbGludXgtbmV4dCBpbnRvIExp
bnV4LU5leHQtdjIwMTMwMjI3CiAgICAgIFJldmVydCAiaWRyOiBpbXBsZW1lbnQgbG9va3VwIGhp
bnQiCiAgICAgIE1lcmdlIGJyYW5jaCAnZGViLXBrZy1maXhlcycgaW50byAzLjguMC1uZXh0MjAx
MzAyMjctMy1pbml6YS1zbWFsbAogICAgICBNZXJnZSBicmFuY2ggJ2lkci1uZXh0LWZpeGVzJyBp
bnRvIDMuOC4wLW5leHQyMDEzMDIyNy0zLWluaXphLXNtYWxsCgogaW5jbHVkZS9saW51eC9pZHIu
aCAgICAgIHwgMjUgKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogbGliL2lkci5jICAgICAgICAg
ICAgICAgIHwgMzggKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0KIHNjcmlw
dHMvcGFja2FnZS9idWlsZGRlYiB8IDE5ICsrKysrKysrKysrKysrKystLS0KIDMgZmlsZXMgY2hh
bmdlZCwgMzkgaW5zZXJ0aW9ucygrKSwgNDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9saW51eC9pZHIuaCBiL2luY2x1ZGUvbGludXgvaWRyLmgKaW5kZXggYWVkMmEwYy4uN2Ix
YzVjNiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51eC9pZHIuaAorKysgYi9pbmNsdWRlL2xpbnV4
L2lkci5oCkBAIC0zNyw3ICszNyw2IEBAIHN0cnVjdCBpZHJfbGF5ZXIgewogfTsKIAogc3RydWN0
IGlkciB7Ci0Jc3RydWN0IGlkcl9sYXllciBfX3JjdQkqaGludDsJLyogdGhlIGxhc3QgbGF5ZXIg
YWxsb2NhdGVkIGZyb20gKi8KIAlzdHJ1Y3QgaWRyX2xheWVyIF9fcmN1CSp0b3A7CiAJc3RydWN0
IGlkcl9sYXllcgkqaWRfZnJlZTsKIAlpbnQJCQlsYXllcnM7CS8qIG9ubHkgdmFsaWQgdy9vIGNv
bmN1cnJlbnQgY2hhbmdlcyAqLwpAQCAtNzIsNyArNzEsNyBAQCBzdHJ1Y3QgaWRyIHsKICAqIFRo
aXMgaXMgd2hhdCB3ZSBleHBvcnQuCiAgKi8KIAotdm9pZCAqaWRyX2ZpbmRfc2xvd3BhdGgoc3Ry
dWN0IGlkciAqaWRwLCBpbnQgaWQpOwordm9pZCAqaWRyX2ZpbmQoc3RydWN0IGlkciAqaWRwLCBp
bnQgaWQpOwogaW50IGlkcl9wcmVfZ2V0KHN0cnVjdCBpZHIgKmlkcCwgZ2ZwX3QgZ2ZwX21hc2sp
OwogaW50IGlkcl9nZXRfbmV3X2Fib3ZlKHN0cnVjdCBpZHIgKmlkcCwgdm9pZCAqcHRyLCBpbnQg
c3RhcnRpbmdfaWQsIGludCAqaWQpOwogdm9pZCBpZHJfcHJlbG9hZChnZnBfdCBnZnBfbWFzayk7
CkBAIC05OCwyOCArOTcsNiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgaWRyX3ByZWxvYWRfZW5kKHZv
aWQpCiB9CiAKIC8qKgotICogaWRyX2ZpbmQgLSByZXR1cm4gcG9pbnRlciBmb3IgZ2l2ZW4gaWQK
LSAqIEBpZHA6IGlkciBoYW5kbGUKLSAqIEBpZDogbG9va3VwIGtleQotICoKLSAqIFJldHVybiB0
aGUgcG9pbnRlciBnaXZlbiB0aGUgaWQgaXQgaGFzIGJlZW4gcmVnaXN0ZXJlZCB3aXRoLiAgQSAl
TlVMTAotICogcmV0dXJuIGluZGljYXRlcyB0aGF0IEBpZCBpcyBub3QgdmFsaWQgb3IgeW91IHBh
c3NlZCAlTlVMTCBpbgotICogaWRyX2dldF9uZXcoKS4KLSAqCi0gKiBUaGlzIGZ1bmN0aW9uIGNh
biBiZSBjYWxsZWQgdW5kZXIgcmN1X3JlYWRfbG9jaygpLCBnaXZlbiB0aGF0IHRoZSBsZWFmCi0g
KiBwb2ludGVycyBsaWZldGltZXMgYXJlIGNvcnJlY3RseSBtYW5hZ2VkLgotICovCi1zdGF0aWMg
aW5saW5lIHZvaWQgKmlkcl9maW5kKHN0cnVjdCBpZHIgKmlkciwgaW50IGlkKQotewotCXN0cnVj
dCBpZHJfbGF5ZXIgKmhpbnQgPSByY3VfZGVyZWZlcmVuY2VfcmF3KGlkci0+aGludCk7Ci0KLQlp
ZiAoKGlkICYgfklEUl9NQVNLKSA9PSBoaW50LT5wcmVmaXgpCi0JCXJldHVybiByY3VfZGVyZWZl
cmVuY2VfcmF3KGhpbnQtPmFyeVtpZCAmIElEUl9NQVNLXSk7Ci0KLQlyZXR1cm4gaWRyX2ZpbmRf
c2xvd3BhdGgoaWRyLCBpZCk7Ci19Ci0KLS8qKgogICogaWRyX2dldF9uZXcgLSBhbGxvY2F0ZSBu
ZXcgaWRyIGVudHJ5CiAgKiBAaWRwOiBpZHIgaGFuZGxlCiAgKiBAcHRyOiBwb2ludGVyIHlvdSB3
YW50IGFzc29jaWF0ZWQgd2l0aCB0aGUgaWQKZGlmZiAtLWdpdCBhL2xpYi9pZHIuYyBiL2xpYi9p
ZHIuYwppbmRleCA1Yzc3MmRjLi41Y2Q2MDI5IDEwMDY0NAotLS0gYS9saWIvaWRyLmMKKysrIGIv
bGliL2lkci5jCkBAIC0xMzcsMTAgKzEzNyw4IEBAIHN0YXRpYyB2b2lkIGlkcl9sYXllcl9yY3Vf
ZnJlZShzdHJ1Y3QgcmN1X2hlYWQgKmhlYWQpCiAJa21lbV9jYWNoZV9mcmVlKGlkcl9sYXllcl9j
YWNoZSwgbGF5ZXIpOwogfQogCi1zdGF0aWMgaW5saW5lIHZvaWQgZnJlZV9sYXllcihzdHJ1Y3Qg
aWRyICppZHIsIHN0cnVjdCBpZHJfbGF5ZXIgKnApCitzdGF0aWMgaW5saW5lIHZvaWQgZnJlZV9s
YXllcihzdHJ1Y3QgaWRyX2xheWVyICpwKQogewotCWlmIChpZHItPmhpbnQgPT0gcCkKLQkJUkNV
X0lOSVRfUE9JTlRFUihpZHItPmhpbnQsIE5VTEwpOwogCWNhbGxfcmN1KCZwLT5yY3VfaGVhZCwg
aWRyX2xheWVyX3JjdV9mcmVlKTsKIH0KIApAQCAtMzY1LDEyICszNjMsOCBAQCBidWlsZF91cDoK
ICAqIEBpZCBhbmQgQHBhIGFyZSBmcm9tIGEgc3VjY2Vzc2Z1bCBhbGxvY2F0aW9uIGZyb20gaWRy
X2dldF9lbXB0eV9zbG90KCkuCiAgKiBJbnN0YWxsIHRoZSB1c2VyIHBvaW50ZXIgQHB0ciBhbmQg
bWFyayB0aGUgc2xvdCBmdWxsLgogICovCi1zdGF0aWMgdm9pZCBpZHJfZmlsbF9zbG90KHN0cnVj
dCBpZHIgKmlkciwgdm9pZCAqcHRyLCBpbnQgaWQsCi0JCQkgIHN0cnVjdCBpZHJfbGF5ZXIgKipw
YSkKK3N0YXRpYyB2b2lkIGlkcl9maWxsX3Nsb3Qodm9pZCAqcHRyLCBpbnQgaWQsIHN0cnVjdCBp
ZHJfbGF5ZXIgKipwYSkKIHsKLQkvKiB1cGRhdGUgaGludCB1c2VkIGZvciBsb29rdXAsIGNsZWFy
ZWQgZnJvbSBmcmVlX2xheWVyKCkgKi8KLQlyY3VfYXNzaWduX3BvaW50ZXIoaWRyLT5oaW50LCBw
YVswXSk7Ci0KIAlyY3VfYXNzaWduX3BvaW50ZXIocGFbMF0tPmFyeVtpZCAmIElEUl9NQVNLXSwg
KHN0cnVjdCBpZHJfbGF5ZXIgKilwdHIpOwogCXBhWzBdLT5jb3VudCsrOwogCWlkcl9tYXJrX2Z1
bGwocGEsIGlkKTsKQEAgLTQwMyw3ICszOTcsNyBAQCBpbnQgaWRyX2dldF9uZXdfYWJvdmUoc3Ry
dWN0IGlkciAqaWRwLCB2b2lkICpwdHIsIGludCBzdGFydGluZ19pZCwgaW50ICppZCkKIAlpZiAo
cnYgPCAwKQogCQlyZXR1cm4gcnYgPT0gLUVOT01FTSA/IC1FQUdBSU4gOiBydjsKIAotCWlkcl9m
aWxsX3Nsb3QoaWRwLCBwdHIsIHJ2LCBwYSk7CisJaWRyX2ZpbGxfc2xvdChwdHIsIHJ2LCBwYSk7
CiAJKmlkID0gcnY7CiAJcmV0dXJuIDA7CiB9CkBAIC01MTAsNyArNTA0LDcgQEAgaW50IGlkcl9h
bGxvYyhzdHJ1Y3QgaWRyICppZHIsIHZvaWQgKnB0ciwgaW50IHN0YXJ0LCBpbnQgZW5kLCBnZnBf
dCBnZnBfbWFzaykKIAlpZiAodW5saWtlbHkoaWQgPiBtYXgpKQogCQlyZXR1cm4gLUVOT1NQQzsK
IAotCWlkcl9maWxsX3Nsb3QoaWRyLCBwdHIsIGlkLCBwYSk7CisJaWRyX2ZpbGxfc2xvdChwdHIs
IGlkLCBwYSk7CiAJcmV0dXJuIGlkOwogfQogRVhQT1JUX1NZTUJPTF9HUEwoaWRyX2FsbG9jKTsK
QEAgLTU0NywxNCArNTQxLDE0IEBAIHN0YXRpYyB2b2lkIHN1Yl9yZW1vdmUoc3RydWN0IGlkciAq
aWRwLCBpbnQgc2hpZnQsIGludCBpZCkKIAkJdG9fZnJlZSA9IE5VTEw7CiAJCXdoaWxlKCpwYWEg
JiYgISAtLSgoKipwYWEpLT5jb3VudCkpewogCQkJaWYgKHRvX2ZyZWUpCi0JCQkJZnJlZV9sYXll
cihpZHAsIHRvX2ZyZWUpOworCQkJCWZyZWVfbGF5ZXIodG9fZnJlZSk7CiAJCQl0b19mcmVlID0g
KipwYWE7CiAJCQkqKnBhYS0tID0gTlVMTDsKIAkJfQogCQlpZiAoISpwYWEpCiAJCQlpZHAtPmxh
eWVycyA9IDA7CiAJCWlmICh0b19mcmVlKQotCQkJZnJlZV9sYXllcihpZHAsIHRvX2ZyZWUpOwor
CQkJZnJlZV9sYXllcih0b19mcmVlKTsKIAl9IGVsc2UKIAkJaWRyX3JlbW92ZV93YXJuaW5nKGlk
KTsKIH0KQEAgLTU4Nyw3ICs1ODEsNyBAQCB2b2lkIGlkcl9yZW1vdmUoc3RydWN0IGlkciAqaWRw
LCBpbnQgaWQpCiAJCS0taWRwLT5sYXllcnM7CiAJCXRvX2ZyZWUtPmNvdW50ID0gMDsKIAkJYml0
bWFwX2NsZWFyKHRvX2ZyZWUtPmJpdG1hcCwgMCwgSURSX1NJWkUpOwotCQlmcmVlX2xheWVyKGlk
cCwgdG9fZnJlZSk7CisJCWZyZWVfbGF5ZXIodG9fZnJlZSk7CiAJfQogCXdoaWxlIChpZHAtPmlk
X2ZyZWVfY250ID49IE1BWF9JRFJfRlJFRSkgewogCQlwID0gZ2V0X2Zyb21fZnJlZV9saXN0KGlk
cCk7CkBAIC02MjgsNyArNjIyLDcgQEAgdm9pZCBfX2lkcl9yZW1vdmVfYWxsKHN0cnVjdCBpZHIg
KmlkcCkKIAkJLyogR2V0IHRoZSBoaWdoZXN0IGJpdCB0aGF0IHRoZSBhYm92ZSBhZGQgY2hhbmdl
ZCBmcm9tIDAtPjEuICovCiAJCXdoaWxlIChuIDwgZmxzKGlkIF4gYnRfbWFzaykpIHsKIAkJCWlm
IChwKQotCQkJCWZyZWVfbGF5ZXIoaWRwLCBwKTsKKwkJCQlmcmVlX2xheWVyKHApOwogCQkJbiAr
PSBJRFJfQklUUzsKIAkJCXAgPSAqLS1wYWE7CiAJCX0KQEAgLTY2MSw3ICs2NTUsMTkgQEAgdm9p
ZCBpZHJfZGVzdHJveShzdHJ1Y3QgaWRyICppZHApCiB9CiBFWFBPUlRfU1lNQk9MKGlkcl9kZXN0
cm95KTsKIAotdm9pZCAqaWRyX2ZpbmRfc2xvd3BhdGgoc3RydWN0IGlkciAqaWRwLCBpbnQgaWQp
CisvKioKKyAqIGlkcl9maW5kIC0gcmV0dXJuIHBvaW50ZXIgZm9yIGdpdmVuIGlkCisgKiBAaWRw
OiBpZHIgaGFuZGxlCisgKiBAaWQ6IGxvb2t1cCBrZXkKKyAqCisgKiBSZXR1cm4gdGhlIHBvaW50
ZXIgZ2l2ZW4gdGhlIGlkIGl0IGhhcyBiZWVuIHJlZ2lzdGVyZWQgd2l0aC4gIEEgJU5VTEwKKyAq
IHJldHVybiBpbmRpY2F0ZXMgdGhhdCBAaWQgaXMgbm90IHZhbGlkIG9yIHlvdSBwYXNzZWQgJU5V
TEwgaW4KKyAqIGlkcl9nZXRfbmV3KCkuCisgKgorICogVGhpcyBmdW5jdGlvbiBjYW4gYmUgY2Fs
bGVkIHVuZGVyIHJjdV9yZWFkX2xvY2soKSwgZ2l2ZW4gdGhhdCB0aGUgbGVhZgorICogcG9pbnRl
cnMgbGlmZXRpbWVzIGFyZSBjb3JyZWN0bHkgbWFuYWdlZC4KKyAqLwordm9pZCAqaWRyX2ZpbmQo
c3RydWN0IGlkciAqaWRwLCBpbnQgaWQpCiB7CiAJaW50IG47CiAJc3RydWN0IGlkcl9sYXllciAq
cDsKQEAgLTY4NSw3ICs2OTEsNyBAQCB2b2lkICppZHJfZmluZF9zbG93cGF0aChzdHJ1Y3QgaWRy
ICppZHAsIGludCBpZCkKIAl9CiAJcmV0dXJuKCh2b2lkICopcCk7CiB9Ci1FWFBPUlRfU1lNQk9M
KGlkcl9maW5kX3Nsb3dwYXRoKTsKK0VYUE9SVF9TWU1CT0woaWRyX2ZpbmQpOwogCiAvKioKICAq
IGlkcl9mb3JfZWFjaCAtIGl0ZXJhdGUgdGhyb3VnaCBhbGwgc3RvcmVkIHBvaW50ZXJzCmRpZmYg
LS1naXQgYS9zY3JpcHRzL3BhY2thZ2UvYnVpbGRkZWIgYi9zY3JpcHRzL3BhY2thZ2UvYnVpbGRk
ZWIKaW5kZXggYWNiODY1MC4uN2Q3YzlkOCAxMDA2NDQKLS0tIGEvc2NyaXB0cy9wYWNrYWdlL2J1
aWxkZGViCisrKyBiL3NjcmlwdHMvcGFja2FnZS9idWlsZGRlYgpAQCAtMTcyLDkgKzE3MiwyMiBA
QCBlbHNlCiBmaQogbWFpbnRhaW5lcj0iJG5hbWUgPCRlbWFpbD4iCiAKKyMgVHJ5IHRvIGRldGVy
bWluZSBkaXN0cmlidXRpb24KK2lmIFsgLWUgJCh3aGljaCBsc2JfcmVsZWFzZSkgXTsgdGhlbgor
ICAgICAgIGNvZGVuYW1lPSQobHNiX3JlbGVhc2UgLS1jb2RlbmFtZSAtLXNob3J0KQorICAgICAg
IGlmIFsgIiRjb2RlbmFtZSIgIT0gIiIgXTsgdGhlbgorCQlkaXN0cmlidXRpb249JGNvZGVuYW1l
CisgICAgICAgZWxzZQorCQlkaXN0cmlidXRpb249IlVOUkVMRUFTRUQiCisJCWVjaG8gIldBUk5J
Tkc6IFRoZSBkaXN0cmlidXRpb24gY291bGQgTk9UIGJlIGRldGVybWluZWQhIgorICAgICAgIGZp
CitlbHNlCisgICAgICAgZWNobyAiSElOVDogSW5zdGFsbCBsc2JfcmVsZWFzZSBiaW5hcnksIHRo
aXMgaGVscHMgdG8gaWRlbnRpZnkgeW91ciBkaXN0cmlidXRpb24hIgorZmkKKwogIyBHZW5lcmF0
ZSBhIHNpbXBsZSBjaGFuZ2Vsb2cgdGVtcGxhdGUKIGNhdCA8PEVPRiA+IGRlYmlhbi9jaGFuZ2Vs
b2cKLWxpbnV4LXVwc3RyZWFtICgkcGFja2FnZXZlcnNpb24pIHVuc3RhYmxlOyB1cmdlbmN5PWxv
dworbGludXgtdXBzdHJlYW0gKCRwYWNrYWdldmVyc2lvbikgJGRpc3RyaWJ1dGlvbjsgdXJnZW5j
eT1sb3cKIAogICAqIEN1c3RvbSBidWlsdCBMaW51eCBrZXJuZWwuCiAKQEAgLTE4OCwxMCArMjAx
LDEwIEBAIFRoaXMgaXMgYSBwYWNrYWNrZWQgdXBzdHJlYW0gdmVyc2lvbiBvZiB0aGUgTGludXgg
a2VybmVsLgogVGhlIHNvdXJjZXMgbWF5IGJlIGZvdW5kIGF0IG1vc3QgTGludXggZnRwIHNpdGVz
LCBpbmNsdWRpbmc6CiBmdHA6Ly9mdHAua2VybmVsLm9yZy9wdWIvbGludXgva2VybmVsCiAKLUNv
cHlyaWdodDogMTk5MSAtIDIwMDkgTGludXMgVG9ydmFsZHMgYW5kIG90aGVycy4KK0NvcHlyaWdo
dDogMTk5MSAtIDIwMTMgTGludXMgVG9ydmFsZHMgYW5kIG90aGVycy4KIAogVGhlIGdpdCByZXBv
c2l0b3J5IGZvciBtYWlubGluZSBrZXJuZWwgZGV2ZWxvcG1lbnQgaXMgYXQ6Ci1naXQ6Ly9naXQu
a2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXgtMi42Lmdp
dAorZ2l0Oi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRz
L2xpbnV4LmdpdAogCiAgICAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4g
cmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKICAgICBpdCB1bmRlciB0aGUgdGVybXMgb2Yg
dGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQo=
--f46d044282c41dc4f504d6b47924--
