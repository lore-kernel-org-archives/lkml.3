Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab3GYKF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 06:05:28 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:51256 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3GYKFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 06:05:22 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXX1-kz9QbY5CpU1UDU8trxgfJSS6ZnUpx9ieq5FnVNSQ@mail.gmail.com>
References: <CA+icZUVHkYd6xcGe7v-zA8=f+vTF1eF2JszvFPfqzJwE34_2ig@mail.gmail.com>
	<87ehanx9bx.fsf@intel.com>
	<CA+icZUXX1-kz9QbY5CpU1UDU8trxgfJSS6ZnUpx9ieq5FnVNSQ@mail.gmail.com>
Date: Thu, 25 Jul 2013 12:05:19 +0200
Message-ID: <CA+icZUWOwKH+oF4Ekrkk3pUCjz4Rc361kzdsKjb04WzsEtWPYA@mail.gmail.com>
Subject: Re: [Intel-gfx] linux-next: Tree for Jul 25 [ call-trace: drm |
 drm-intel related? ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, DRI <dri-devel@lists.freedesktop.org>,
        linux-next@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 12:02 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Thu, Jul 25, 2013 at 11:44 AM, Jani Nikula
> <jani.nikula@linux.intel.com> wrote:
>> On Thu, 25 Jul 2013, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Thu, Jul 25, 2013 at 7:12 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>> Hi all,
>>>>
>>>> Changes since 20130724:
>>>>
>>>> Removed tree:
>>>>         arm-dt (at maintainer's request)
>>>>
>>>> The wireless-next tree lost its build failure and gained a conflict
>>>> against Linus' tree.
>>>>
>>>> The tty tree lost its build failure.
>>>>
>>>> The staging tree gained a build failure for which I disabled a driver.
>>>>
>>>> ----------------------------------------------------------------------------
>>>>
>>>
>>> [ CCing drm and drm-intel folks ]
>>>
>>> With today's next-20130725 I see the following:
>>
>> Use of dev_priv->gt_lock in I915_WRITE through
>> intel_disable_gt_powersave before spin lock init, caused by
>>
>> commit 181d1b9e31c668259d3798c521672afb8edd355c
>> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Date:   Sun Jul 21 13:16:24 2013 +0200
>>
>>     drm/i915: fix up gt init sequence fallout
>>
>
> Ah, cool.
>
> I assumed/tested "drm/i915: fix the racy object accounting", but this
> does not fix it.
> Will try with yours.
>

Sorry, Jani.

next-20130725 ships the patch you pointed, too.

- Sedat -

[1] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/?id=next-20130725&qt=grep&q=drm%2Fi915%3A+fix+up+gt+init+sequence+fallout
[2] http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=181d1b9e31c668259d3798c521672afb8edd355c

> - Sedat -
>
> [1] cgit.freedesktop.org/~danvet/drm-intel/patch/?id=190426c5a60659533b9361b7e0ba083bd5434c80
>
>> Daniel, how about just doing this (untested):
>>
>> Cheers,
>> Jani.
>>
>>
>> From a6b46053ba07d2e129691fd24ad2e43a1d8dfd10 Mon Sep 17 00:00:00 2001
>> From: Jani Nikula <jani.nikula@intel.com>
>> Date: Thu, 25 Jul 2013 12:40:31 +0300
>> Subject: [PATCH] drm/i915: initialize gt_lock early with other spin locks
>> Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
>> Cc: Jani Nikula <jani.nikula@intel.com>
>>
>> commit 181d1b9e31c668259d3798c521672afb8edd355c
>> Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>> Date:   Sun Jul 21 13:16:24 2013 +0200
>>
>>     drm/i915: fix up gt init sequence fallout
>>
>> moved dev_priv->gt_lock initialization after use. Do the initialization
>> much earlier with other spin lock initializations.
>>
>> Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
>> Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>> ---
>>  drivers/gpu/drm/i915/i915_dma.c |    1 +
>>  drivers/gpu/drm/i915/intel_pm.c |    2 --
>>  2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
>> index 67ec54f..b064a5a 100644
>> --- a/drivers/gpu/drm/i915/i915_dma.c
>> +++ b/drivers/gpu/drm/i915/i915_dma.c
>> @@ -1496,6 +1496,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>>         dev_priv->info = info;
>>
>>         spin_lock_init(&dev_priv->irq_lock);
>> +       spin_lock_init(&dev_priv->gt_lock);
>>         spin_lock_init(&dev_priv->gpu_error.lock);
>>         spin_lock_init(&dev_priv->rps.lock);
>>         spin_lock_init(&dev_priv->backlight.lock);
>> diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
>> index 6a347f5..51a2a60 100644
>> --- a/drivers/gpu/drm/i915/intel_pm.c
>> +++ b/drivers/gpu/drm/i915/intel_pm.c
>> @@ -5497,8 +5497,6 @@ void intel_gt_init(struct drm_device *dev)
>>  {
>>         struct drm_i915_private *dev_priv = dev->dev_private;
>>
>> -       spin_lock_init(&dev_priv->gt_lock);
>> -
>>         if (IS_VALLEYVIEW(dev)) {
>>                 dev_priv->gt.force_wake_get = vlv_force_wake_get;
>>                 dev_priv->gt.force_wake_put = vlv_force_wake_put;
>> --
>> 1.7.9.5
>>
>>
>>
>>>
>>> [   17.122627] [drm] Memory usable by graphics device = 2048M
>>> [   17.122639] i915 0000:00:02.0: setting latency timer to 64
>>> [   17.164740] BUG: spinlock bad magic on CPU#3, modprobe/635
>>> [   17.164797]  lock: 0xffff8800bc534040, .magic: 00000000, .owner:
>>> <none>/-1, .owner_cpu: 0
>>> [   17.164856] CPU: 3 PID: 635 Comm: modprobe Not tainted
>>> 3.11.0-rc2-next20130725-1-iniza-small #1
>>> [   17.164914] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
>>> 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
>>> [   17.164977]  0000000000000000 ffff8800c0fa1738 ffffffff816ddfc9
>>> 0000000000000007
>>> [   17.165101]  ffff8800bc534040 ffff8800c0fa1758 ffffffff816de065
>>> ffff8800bc534040
>>> [   17.165222]  ffffffff81a5f497 ffff8800c0fa1778 ffffffff816de08b
>>> ffff8800bc534040
>>> [   17.165345] Call Trace:
>>> [   17.165386]  [<ffffffff816ddfc9>] dump_stack+0x46/0x58
>>> [   17.165428]  [<ffffffff816de065>] spin_dump+0x8a/0x8f
>>> [   17.165469]  [<ffffffff816de08b>] spin_bug+0x21/0x26
>>> [   17.165511]  [<ffffffff813787c4>] do_raw_spin_lock+0x84/0x120
>>> [   17.165554]  [<ffffffff816e6db4>] _raw_spin_lock_irqsave+0x24/0x30
>>> [   17.165620]  [<ffffffffa037a456>] i915_write32+0x36/0x150 [i915]
>>> [   17.165690]  [<ffffffffa03cf4c5>]
>>> intel_disable_gt_powersave+0xf5/0x360 [i915]
>>> [   17.165768]  [<ffffffffa03d1129>] intel_gt_sanitize+0x49/0xb0 [i915]
>>> [   17.165827]  [<ffffffffa037dd68>] i915_driver_load+0x638/0xed0 [i915]
>>> [   17.165886]  [<ffffffffa01b4b91>] drm_get_pci_dev+0x181/0x2a0 [drm]
>>> [   17.165929]  [<ffffffff813788fd>] ? do_raw_spin_unlock+0x5d/0xb0
>>> [   17.165987]  [<ffffffffa03796f6>] i915_pci_probe+0x36/0x70 [i915]
>>> [   17.166031]  [<ffffffff813973ab>] local_pci_probe+0x4b/0x80
>>> [   17.166073]  [<ffffffff81398c81>] pci_device_probe+0x101/0x120
>>> [   17.166115]  [<ffffffff8147599b>] driver_probe_device+0x7b/0x240
>>> [   17.166158]  [<ffffffff81475c0b>] __driver_attach+0xab/0xb0
>>> [   17.166200]  [<ffffffff81475b60>] ? driver_probe_device+0x240/0x240
>>> [   17.166244]  [<ffffffff81473c7e>] bus_for_each_dev+0x5e/0x90
>>> [   17.166286]  [<ffffffff8147549e>] driver_attach+0x1e/0x20
>>> [   17.166330]  [<ffffffff81474f94>] bus_add_driver+0x104/0x270
>>> [   17.166372]  [<ffffffff8147616d>] driver_register+0x7d/0x160
>>> [   17.166415]  [<ffffffff81397c04>] __pci_register_driver+0x64/0x70
>>> [   17.166460]  [<ffffffffa0446000>] ? 0xffffffffa0445fff
>>> [   17.166510]  [<ffffffffa01b4dca>] drm_pci_init+0x11a/0x130 [drm]
>>> [   17.166553]  [<ffffffffa0446000>] ? 0xffffffffa0445fff
>>> [   17.166610]  [<ffffffffa0446066>] i915_init+0x66/0x68 [i915]
>>> [   17.166652]  [<ffffffff8100207e>] do_one_initcall+0x4e/0x180
>>> [   17.166696]  [<ffffffff81058453>] ? set_memory_nx+0x43/0x50
>>> [   17.166742]  [<ffffffff810d111c>] load_module+0x209c/0x25b0
>>> [   17.166784]  [<ffffffff810cdd40>] ? show_initstate+0x50/0x50
>>> [   17.166827]  [<ffffffff810d16dc>] SyS_init_module+0xac/0xd0
>>> [   17.166871]  [<ffffffff816efdef>] tracesys+0xe1/0xe6
>>> [   17.167649] i915 0000:00:02.0: irq 49 for MSI/MSI-X
>>> [   17.167709] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>>> [   17.167753] [drm] Driver supports precise vblank timestamp query.
>>>
>>> I can't say what is the root cause and when it occured for the 1st
>>> time (my last Linux-next release was next-20130709).
>>>
>>> Please, see also attached kernel-config and full dmesg.
>>>
>>> - Sedat -
>>> [    0.000000] Initializing cgroup subsys cpuset
>>> [    0.000000] Initializing cgroup subsys cpu
>>> [    0.000000] Initializing cgroup subsys cpuacct
>>> [    0.000000] Linux version 3.11.0-rc2-next20130725-1-iniza-small (sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Thu Jul 25 09:03:18 CEST 2013
>>> [    0.000000] Command line: BOOT_IMAGE=/vmlinuz.next root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
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
>>> [    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
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
>>> [    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
>>> [    0.000000] reserving inaccessible SNB gfx pages
>>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
>>> [    0.000000]  [mem 0x00000000-0x000fffff] page 4k
>>> [    0.000000] BRK [0x0204c000, 0x0204cfff] PGTABLE
>>> [    0.000000] BRK [0x0204d000, 0x0204dfff] PGTABLE
>>> [    0.000000] BRK [0x0204e000, 0x0204efff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0x11fc00000-0x11fdfffff]
>>> [    0.000000]  [mem 0x11fc00000-0x11fdfffff] page 2M
>>> [    0.000000] BRK [0x0204f000, 0x0204ffff] PGTABLE
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
>>> [    0.000000] BRK [0x02050000, 0x02050fff] PGTABLE
>>> [    0.000000] init_memory_mapping: [mem 0xdafff000-0xdaffffff]
>>> [    0.000000]  [mem 0xdafff000-0xdaffffff] page 4k
>>> [    0.000000] RAMDISK: [mem 0x37962000-0x37ca8fff]
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
>>> [    0.000000] No NUMA configuration found
>>> [    0.000000] Faking a node at [mem 0x0000000000000000-0x000000011fdfffff]
>>> [    0.000000] Initmem setup node 0 [mem 0x00000000-0x11fdfffff]
>>> [    0.000000]   NODE_DATA [mem 0x11fdf7000-0x11fdfbfff]
>>> [    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff88011b400000-ffff88011edfffff] on node 0
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
>>> [    0.000000]   DMA zone: 56 pages used for memmap
>>> [    0.000000]   DMA zone: 156 pages reserved
>>> [    0.000000]   DMA zone: 3996 pages, LIFO batch:0
>>> [    0.000000]   DMA32 zone: 12127 pages used for memmap
>>> [    0.000000]   DMA32 zone: 886944 pages, LIFO batch:31
>>> [    0.000000]   Normal zone: 1785 pages used for memmap
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
>>> [    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xd9c9f000-0xdae7efff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xdae7f000-0xdaf9efff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xdaf9f000-0xdaffefff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdf9fffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xf7ffffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xf8000000-0xfbffffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfc000000-0xfebfffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfed07fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed19fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed1a000-0xfed1bfff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfedfffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xffd7ffff]
>>> [    0.000000] PM: Registered nosave memory: [mem 0xffd80000-0xffffffff]
>>> [    0.000000] e820: [mem 0xdfa00000-0xf7ffffff] available for PCI devices
>>> [    0.000000] Booting paravirtualized kernel on bare hardware
>>> [    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids:8 nr_node_ids:1
>>> [    0.000000] PERCPU: Embedded 29 pages/cpu @ffff88011fa00000 s87552 r8192 d23040 u262144
>>> [    0.000000] pcpu-alloc: s87552 r8192 d23040 u262144 alloc=1*2097152
>>> [    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
>>> [    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1007376
>>> [    0.000000] Policy zone: Normal
>>> [    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz.next root=UUID=001AADA61AAD9964 loop=/ubuntu/disks/root.disk ro
>>> [    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
>>> [    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
>>> [    0.000000] Checking aperture...
>>> [    0.000000] No AGP bridge found
>>> [    0.000000] Calgary: detecting Calgary via BIOS EBDA area
>>> [    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
>>> [    0.000000] Memory: 3938460K/4086000K available (7119K kernel code, 1044K rwdata, 3132K rodata, 1332K init, 1984K bss, 147540K reserved)
>>> [    0.000000] Hierarchical RCU implementation.
>>> [    0.000000]        RCU restricting CPUs from NR_CPUS=256 to nr_cpu_ids=8.
>>> [    0.000000] NR_IRQS:16640 nr_irqs:744 16
>>> [    0.000000] Console: colour VGA+ 80x25
>>> [    0.000000] console [tty0] enabled
>>> [    0.000000] allocated 16777216 bytes of page_cgroup
>>> [    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
>>> [    0.000000] ODEBUG: 0 of 0 active objects replaced
>>> [    0.000000] hpet clockevent registered
>>> [    0.000000] tsc: Fast TSC calibration using PIT
>>> [    0.004000] tsc: Detected 1596.337 MHz processor
>>> [    0.000003] Calibrating delay loop (skipped), value calculated using timer frequency.. 3192.67 BogoMIPS (lpj=6385348)
>>> [    0.000080] pid_max: default: 32768 minimum: 301
>>> [    0.000246] Security Framework initialized
>>> [    0.000303] AppArmor: AppArmor initialized
>>> [    0.000339] Yama: becoming mindful.
>>> [    0.000747] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
>>> [    0.001855] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
>>> [    0.002357] Mount-cache hash table entries: 256
>>> [    0.002910] Initializing cgroup subsys memory
>>> [    0.003007] Initializing cgroup subsys devices
>>> [    0.003046] Initializing cgroup subsys freezer
>>> [    0.003083] Initializing cgroup subsys blkio
>>> [    0.003120] Initializing cgroup subsys perf_event
>>> [    0.003160] Initializing cgroup subsys hugetlb
>>> [    0.003247] Disabled fast string operations
>>> [    0.003284] CPU: Physical Processor ID: 0
>>> [    0.003321] CPU: Processor Core ID: 0
>>> [    0.003360] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
>>> [    0.003360] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
>>> [    0.003426] mce: CPU supports 7 MCE banks
>>> [    0.003477] CPU0: Thermal monitoring enabled (TM1)
>>> [    0.003523] Last level iTLB entries: 4KB 512, 2MB 0, 4MB 0
>>> [    0.003523] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32
>>> [    0.003523] tlb_flushall_shift: 5
>>> [    0.003694] Freeing SMP alternatives memory: 24K (ffffffff81e54000 - ffffffff81e5a000)
>>> [    0.004778] ACPI: Core revision 20130626
>>> [    0.015639] ACPI: All ACPI Tables successfully acquired
>>> [    0.029610] ftrace: allocating 27066 entries in 106 pages
>>> [    0.045179] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>>> [    0.084876] smpboot: CPU0: Intel(R) Core(TM) i5-2467M CPU @ 1.60GHz (fam: 06, model: 2a, stepping: 07)
>>> [    0.085491] TSC deadline timer enabled
>>> [    0.085504] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
>>> [    0.085652] ... version:                3
>>> [    0.085688] ... bit width:              48
>>> [    0.085724] ... generic registers:      4
>>> [    0.085760] ... value mask:             0000ffffffffffff
>>> [    0.085798] ... max period:             0000ffffffffffff
>>> [    0.085836] ... fixed-purpose events:   3
>>> [    0.085872] ... event mask:             000000070000000f
>>> [    0.098996] Disabled fast string operations
>>> [    0.102181] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
>>> [    0.113860] Disabled fast string operations
>>> [    0.127571] Disabled fast string operations
>>> [    0.087924] smpboot: Booting Node   0, Processors  #1 #2 #3
>>> [    0.129706] Brought up 4 CPUs
>>> [    0.129811] smpboot: Total of 4 processors activated (12770.69 BogoMIPS)
>>> [    0.133914] devtmpfs: initialized
>>> [    0.135965] EVM: security.selinux
>>> [    0.136000] EVM: security.SMACK64
>>> [    0.136035] EVM: security.capability
>>> [    0.136158] PM: Registering ACPI NVS region [mem 0xdae7f000-0xdaf9efff] (1179648 bytes)
>>> [    0.137696] regulator-dummy: no parameters
>>> [    0.137887] NET: Registered protocol family 16
>>> [    0.138227] cpuidle: using governor ladder
>>> [    0.138264] cpuidle: using governor menu
>>> [    0.138340] ACPI: bus type PCI registered
>>> [    0.138490] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
>>> [    0.138549] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
>>> [    0.145348] PCI: Using configuration type 1 for base access
>>> [    0.148758] bio: create slab <bio-0> at 0
>>> [    0.149215] ACPI: Added _OSI(Module Device)
>>> [    0.149252] ACPI: Added _OSI(Processor Device)
>>> [    0.149289] ACPI: Added _OSI(3.0 _SCP Extensions)
>>> [    0.149327] ACPI: Added _OSI(Processor Aggregator Device)
>>> [    0.151126] ACPI: EC: Look up EC in DSDT
>>> [    0.177559] ACPI: Executed 1 blocks of module-level executable AML code
>>> [    0.183608] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
>>> [    0.195266] ACPI: SSDT 00000000dae70718 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
>>> [    0.195853] ACPI: Dynamic OEM Table Load:
>>> [    0.195923] ACPI: SSDT           (null) 00688 (v01  PmRef  Cpu0Cst 00003001 INTL 20061109)
>>> [    0.205996] ACPI: SSDT 00000000dae71a98 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
>>> [    0.206663] ACPI: Dynamic OEM Table Load:
>>> [    0.206733] ACPI: SSDT           (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20061109)
>>> [    0.217891] ACPI: SSDT 00000000dae6fd98 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
>>> [    0.218450] ACPI: Dynamic OEM Table Load:
>>> [    0.218519] ACPI: SSDT           (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20061109)
>>> [    0.231935] ACPI: Interpreter enabled
>>> [    0.231986] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20130626/hwxface-571)
>>> [    0.232095] ACPI: (supports S0 S1 S3 S4 S5)
>>> [    0.232132] ACPI: Using IOAPIC for interrupt routing
>>> [    0.232225] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
>>> [    0.232510] ACPI: No dock devices found.
>>> [    0.256150] ACPI: Power Resource [FN00] (off)
>>> [    0.256373] ACPI: Power Resource [FN01] (off)
>>> [    0.256590] ACPI: Power Resource [FN02] (off)
>>> [    0.256805] ACPI: Power Resource [FN03] (off)
>>> [    0.257025] ACPI: Power Resource [FN04] (off)
>>> [    0.258209] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
>>> [    0.258584] \_SB_.PCI0:_OSC invalid UUID
>>> [    0.258586] _OSC request data:1 8 0
>>> [    0.259557] PCI host bridge to bus 0000:00
>>> [    0.259596] pci_bus 0000:00: root bus resource [bus 00-3e]
>>> [    0.259636] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
>>> [    0.259677] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
>>> [    0.259718] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
>>> [    0.259758] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xfeafffff]
>>> [    0.259800] pci_bus 0000:00: root bus resource [mem 0xfed40000-0xfed44fff]
>>> [    0.259857] pci 0000:00:00.0: [8086:0104] type 00 class 0x060000
>>> [    0.260010] pci 0000:00:02.0: [8086:0116] type 00 class 0x030000
>>> [    0.260023] pci 0000:00:02.0: reg 0x10: [mem 0xf0000000-0xf03fffff 64bit]
>>> [    0.260030] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
>>> [    0.260036] pci 0000:00:02.0: reg 0x20: [io  0x3000-0x303f]
>>> [    0.260213] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
>>> [    0.260239] pci 0000:00:16.0: reg 0x10: [mem 0xf0705000-0xf070500f 64bit]
>>> [    0.260325] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
>>> [    0.260481] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
>>> [    0.260506] pci 0000:00:1a.0: reg 0x10: [mem 0xf070a000-0xf070a3ff]
>>> [    0.260606] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
>>> [    0.260712] pci 0000:00:1b.0: [8086:1c20] type 00 class 0x040300
>>> [    0.260731] pci 0000:00:1b.0: reg 0x10: [mem 0xf0700000-0xf0703fff 64bit]
>>> [    0.260809] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
>>> [    0.260855] pci 0000:00:1b.0: System wakeup disabled by ACPI
>>> [    0.260961] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
>>> [    0.261052] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
>>> [    0.261100] pci 0000:00:1c.0: System wakeup disabled by ACPI
>>> [    0.261209] pci 0000:00:1c.3: [8086:1c16] type 01 class 0x060400
>>> [    0.261299] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
>>> [    0.261361] pci 0000:00:1c.3: System wakeup disabled by ACPI
>>> [    0.261466] pci 0000:00:1c.4: [8086:1c18] type 01 class 0x060400
>>> [    0.261558] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
>>> [    0.261685] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
>>> [    0.261715] pci 0000:00:1d.0: reg 0x10: [mem 0xf0709000-0xf07093ff]
>>> [    0.261816] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
>>> [    0.261921] pci 0000:00:1f.0: [8086:1c49] type 00 class 0x060100
>>> [    0.262116] pci 0000:00:1f.2: [8086:1c03] type 00 class 0x010601
>>> [    0.262139] pci 0000:00:1f.2: reg 0x10: [io  0x3088-0x308f]
>>> [    0.262149] pci 0000:00:1f.2: reg 0x14: [io  0x3094-0x3097]
>>> [    0.262159] pci 0000:00:1f.2: reg 0x18: [io  0x3080-0x3087]
>>> [    0.262169] pci 0000:00:1f.2: reg 0x1c: [io  0x3090-0x3093]
>>> [    0.262178] pci 0000:00:1f.2: reg 0x20: [io  0x3060-0x307f]
>>> [    0.262189] pci 0000:00:1f.2: reg 0x24: [mem 0xf0708000-0xf07087ff]
>>> [    0.262240] pci 0000:00:1f.2: PME# supported from D3hot
>>> [    0.262356] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
>>> [    0.262376] pci 0000:00:1f.3: reg 0x10: [mem 0xf0704000-0xf07040ff 64bit]
>>> [    0.262400] pci 0000:00:1f.3: reg 0x20: [io  0xefa0-0xefbf]
>>> [    0.262768] pci 0000:01:00.0: [8086:0091] type 00 class 0x028000
>>> [    0.262934] pci 0000:01:00.0: reg 0x10: [mem 0xf0600000-0xf0601fff 64bit]
>>> [    0.263672] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
>>> [    0.263843] pci 0000:01:00.0: System wakeup disabled by ACPI
>>> [    0.269839] pci 0000:00:1c.0: PCI bridge to [bus 01]
>>> [    0.269883] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
>>> [    0.270061] pci 0000:02:00.0: [10ec:8168] type 00 class 0x020000
>>> [    0.270127] pci 0000:02:00.0: reg 0x10: [io  0x2000-0x20ff]
>>> [    0.270250] pci 0000:02:00.0: reg 0x18: [mem 0xf0404000-0xf0404fff 64bit pref]
>>> [    0.270326] pci 0000:02:00.0: reg 0x20: [mem 0xf0400000-0xf0403fff 64bit pref]
>>> [    0.270664] pci 0000:02:00.0: supports D1 D2
>>> [    0.270666] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
>>> [    0.270789] pci 0000:02:00.0: System wakeup disabled by ACPI
>>> [    0.277773] pci 0000:00:1c.3: PCI bridge to [bus 02]
>>> [    0.277835] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
>>> [    0.277844] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
>>> [    0.277969] pci 0000:03:00.0: [1b21:1042] type 00 class 0x0c0330
>>> [    0.278007] pci 0000:03:00.0: reg 0x10: [mem 0xf0500000-0xf0507fff 64bit]
>>> [    0.278206] pci 0000:03:00.0: PME# supported from D3hot D3cold
>>> [    0.285744] pci 0000:00:1c.4: PCI bridge to [bus 03]
>>> [    0.285821] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
>>> [    0.286004] \_SB_.PCI0:_OSC invalid UUID
>>> [    0.286005] _OSC request data:1 1f 0
>>> [    0.286010] acpi PNP0A08:00: ACPI _OSC support notification failed, disabling PCIe ASPM
>>> [    0.286066] acpi PNP0A08:00: Unable to request _OSC control (_OSC support mask: 0x08)
>>> [    0.287020] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 10 *11 12 14 15)
>>> [    0.287369] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>>> [    0.287763] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *10 11 12 14 15)
>>> [    0.288109] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 *10 11 12 14 15)
>>> [    0.288456] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
>>> [    0.288828] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 10 11 12 14 15) *0, disabled.
>>> [    0.289220] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 10 *11 12 14 15)
>>> [    0.289570] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 10 11 12 14 15) *9
>>> [    0.290423] ACPI: Enabled 4 GPEs in block 00 to 3F
>>> [    0.290500] ACPI: \_SB_.PCI0: notify handler is installed
>>> [    0.290562] Found 1 acpi root devices
>>> [    0.290632] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
>>> [    0.290990] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
>>> [    0.291049] vgaarb: loaded
>>> [    0.291082] vgaarb: bridge control possible 0000:00:02.0
>>> [    0.291796] SCSI subsystem initialized
>>> [    0.291834] ACPI: bus type ATA registered
>>> [    0.291967] libata version 3.00 loaded.
>>> [    0.292029] ACPI: bus type USB registered
>>> [    0.292109] usbcore: registered new interface driver usbfs
>>> [    0.292172] usbcore: registered new interface driver hub
>>> [    0.292260] usbcore: registered new device driver usb
>>> [    0.292654] PCI: Using ACPI for IRQ routing
>>> [    0.294397] PCI: pci_cache_line_size set to 64 bytes
>>> [    0.294508] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
>>> [    0.294511] e820: reserve RAM buffer [mem 0xd9c9f000-0xdbffffff]
>>> [    0.294513] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
>>> [    0.294515] e820: reserve RAM buffer [mem 0x11fe00000-0x11fffffff]
>>> [    0.294762] NetLabel: Initializing
>>> [    0.294798] NetLabel:  domain hash size = 128
>>> [    0.294834] NetLabel:  protocols = UNLABELED CIPSOv4
>>> [    0.294918] NetLabel:  unlabeled traffic allowed by default
>>> [    0.295047] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
>>> [    0.295236] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
>>> [    0.297297] Switched to clocksource hpet
>>> [    0.315015] AppArmor: AppArmor Filesystem Enabled
>>> [    0.315105] pnp: PnP ACPI init
>>> [    0.315155] ACPI: bus type PNP registered
>>> [    0.315574] pnp 00:00: [dma 4]
>>> [    0.315617] pnp 00:00: Plug and Play ACPI device, IDs PNP0200 (active)
>>> [    0.315663] pnp 00:01: Plug and Play ACPI device, IDs INT0800 (active)
>>> [    0.315831] pnp 00:02: Plug and Play ACPI device, IDs PNP0103 (active)
>>> [    0.315889] pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
>>> [    0.315967] system 00:04: [io  0x0680-0x069f] has been reserved
>>> [    0.316011] system 00:04: [io  0x1000-0x100f] has been reserved
>>> [    0.316052] system 00:04: [io  0x5000-0x5003] has been reserved
>>> [    0.316092] system 00:04: [io  0xffff] has been reserved
>>> [    0.316132] system 00:04: [io  0x0400-0x0453] could not be reserved
>>> [    0.316173] system 00:04: [io  0x0458-0x047f] has been reserved
>>> [    0.316214] system 00:04: [io  0x0500-0x057f] has been reserved
>>> [    0.316254] system 00:04: [io  0x0a00-0x0a0f] has been reserved
>>> [    0.316295] system 00:04: [io  0x164e-0x164f] has been reserved
>>> [    0.316336] system 00:04: [io  0x5000-0x500f] could not be reserved
>>> [    0.316378] system 00:04: Plug and Play ACPI device, IDs PNP0c02 (active)
>>> [    0.316428] pnp 00:05: Plug and Play ACPI device, IDs PNP0b00 (active)
>>> [    0.316520] system 00:06: [io  0x0454-0x0457] has been reserved
>>> [    0.316563] system 00:06: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
>>> [    0.316622] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
>>> [    0.316706] pnp 00:08: Plug and Play ACPI device, IDs ETD0b00 SYN0002 PNP0f13 (active)
>>> [    0.317018] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
>>> [    0.317060] system 00:09: [mem 0xfed10000-0xfed17fff] has been reserved
>>> [    0.317103] system 00:09: [mem 0xfed18000-0xfed18fff] has been reserved
>>> [    0.317144] system 00:09: [mem 0xfed19000-0xfed19fff] has been reserved
>>> [    0.317186] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
>>> [    0.317228] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
>>> [    0.317270] system 00:09: [mem 0xfed90000-0xfed93fff] has been reserved
>>> [    0.317323] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
>>> [    0.317366] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
>>> [    0.317409] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
>>> [    0.317452] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
>>> [    0.318148] system 00:0a: Plug and Play ACPI device, IDs PNP0c01 (active)
>>> [    0.318188] pnp: PnP ACPI: found 11 devices
>>> [    0.318225] ACPI: bus type PNP unregistered
>>> [    0.326319] pci 0000:00:1c.0: PCI bridge to [bus 01]
>>> [    0.326364] pci 0000:00:1c.0:   bridge window [mem 0xf0600000-0xf06fffff]
>>> [    0.326415] pci 0000:00:1c.3: PCI bridge to [bus 02]
>>> [    0.326455] pci 0000:00:1c.3:   bridge window [io  0x2000-0x2fff]
>>> [    0.326503] pci 0000:00:1c.3:   bridge window [mem 0xf0400000-0xf04fffff 64bit pref]
>>> [    0.326564] pci 0000:00:1c.4: PCI bridge to [bus 03]
>>> [    0.326606] pci 0000:00:1c.4:   bridge window [mem 0xf0500000-0xf05fffff]
>>> [    0.327078] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
>>> [    0.327081] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
>>> [    0.327083] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
>>> [    0.327085] pci_bus 0000:00: resource 7 [mem 0xdfa00000-0xfeafffff]
>>> [    0.327086] pci_bus 0000:00: resource 8 [mem 0xfed40000-0xfed44fff]
>>> [    0.327089] pci_bus 0000:01: resource 1 [mem 0xf0600000-0xf06fffff]
>>> [    0.327091] pci_bus 0000:02: resource 0 [io  0x2000-0x2fff]
>>> [    0.327093] pci_bus 0000:02: resource 2 [mem 0xf0400000-0xf04fffff 64bit pref]
>>> [    0.327096] pci_bus 0000:03: resource 1 [mem 0xf0500000-0xf05fffff]
>>> [    0.327231] NET: Registered protocol family 2
>>> [    0.327613] TCP established hash table entries: 32768 (order: 7, 524288 bytes)
>>> [    0.327849] TCP bind hash table entries: 32768 (order: 8, 1048576 bytes)
>>> [    0.328179] TCP: Hash tables configured (established 32768 bind 32768)
>>> [    0.328479] TCP: reno registered
>>> [    0.328531] UDP hash table entries: 2048 (order: 5, 196608 bytes)
>>> [    0.328635] UDP-Lite hash table entries: 2048 (order: 5, 196608 bytes)
>>> [    0.328931] NET: Registered protocol family 1
>>> [    0.328987] pci 0000:00:02.0: Boot video device
>>> [    0.329779] PCI: CLS 64 bytes, default 64
>>> [    0.329991] Trying to unpack rootfs image as initramfs...
>>> [    0.405840] Freeing initrd memory: 3356K (ffff880037962000 - ffff880037ca9000)
>>> [    0.405900] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
>>> [    0.405942] software IO TLB [mem 0xd5c9f000-0xd9c9f000] (64MB) mapped at [ffff8800d5c9f000-ffff8800d9c9efff]
>>> [    0.406372] microcode: CPU0 sig=0x206a7, pf=0x10, revision=0x28
>>> [    0.406420] microcode: CPU1 sig=0x206a7, pf=0x10, revision=0x28
>>> [    0.406471] microcode: CPU2 sig=0x206a7, pf=0x10, revision=0x28
>>> [    0.406522] microcode: CPU3 sig=0x206a7, pf=0x10, revision=0x28
>>> [    0.406649] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
>>> [    0.406707] Scanning for low memory corruption every 60 seconds
>>> [    0.407346] Initialise module verification
>>> [    0.407446] audit: initializing netlink socket (disabled)
>>> [    0.407507] type=2000 audit(1374746275.392:1): initialized
>>> [    0.437565] bounce pool size: 64 pages
>>> [    0.438126] HugeTLB registered 2 MB page size, pre-allocated 0 pages
>>> [    0.438842] VFS: Disk quotas dquot_6.5.2
>>> [    0.438919] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
>>> [    0.439788] fuse init (API version 7.22)
>>> [    0.439932] msgmni has been set to 7698
>>> [    0.440631] Key type asymmetric registered
>>> [    0.440671] Asymmetric key parser 'x509' registered
>>> [    0.440757] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
>>> [    0.440865] io scheduler noop registered
>>> [    0.440903] io scheduler deadline registered (default)
>>> [    0.440977] io scheduler cfq registered
>>> [    0.441451] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
>>> [    0.441532] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
>>> [    0.441719] intel_idle: MWAIT substates: 0x21120
>>> [    0.441720] intel_idle: v0.4 model 0x2A
>>> [    0.441722] intel_idle: lapic_timer_reliable_states 0xffffffff
>>> [    0.442453] ACPI: AC Adapter [ADP1] (on-line)
>>> [    0.442779] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
>>> [    0.443049] ACPI: Lid Switch [LID0]
>>> [    0.443158] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
>>> [    0.443224] ACPI: Power Button [PWRB]
>>> [    0.443330] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
>>> [    0.443386] ACPI: Power Button [PWRF]
>>> [    0.443521] ACPI: Fan [FAN0] (off)
>>> [    0.443609] ACPI: Fan [FAN1] (off)
>>> [    0.443693] ACPI: Fan [FAN2] (off)
>>> [    0.443778] ACPI: Fan [FAN3] (off)
>>> [    0.443868] ACPI: Fan [FAN4] (off)
>>> [    0.443984] ACPI: Requesting acpi_cpufreq
>>> [    0.447411] thermal LNXTHERM:00: registered as thermal_zone0
>>> [    0.447452] ACPI: Thermal Zone [TZ00] (63 C)
>>> [    0.447859] thermal LNXTHERM:01: registered as thermal_zone1
>>> [    0.447898] ACPI: Thermal Zone [TZ01] (30 C)
>>> [    0.447984] GHES: HEST is not enabled!
>>> [    0.448239] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
>>> [    0.452068] Linux agpgart interface v0.103
>>> [    0.454664] ACPI: Battery Slot [BAT1] (battery present)
>>> [    0.455065] brd: module loaded
>>> [    0.456511] loop: module loaded
>>> [    0.456771] mei_me 0000:00:16.0: setting latency timer to 64
>>> [    0.456815] mei_me 0000:00:16.0: irq 40 for MSI/MSI-X
>>> [    0.460853] ahci 0000:00:1f.2: version 3.0
>>> [    0.461031] ahci 0000:00:1f.2: irq 41 for MSI/MSI-X
>>> [    0.461266] ahci: SSS flag set, parallel bus scan disabled
>>> [    0.477329] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x1b impl SATA mode
>>> [    0.477398] ahci 0000:00:1f.2: flags: 64bit ncq sntf ilck stag pm led clo pio slum part ems sxs apst
>>> [    0.477458] ahci 0000:00:1f.2: setting latency timer to 64
>>> [    0.502183] scsi0 : ahci
>>> [    0.502509] scsi1 : ahci
>>> [    0.502758] scsi2 : ahci
>>> [    0.503007] scsi3 : ahci
>>> [    0.503272] scsi4 : ahci
>>> [    0.503528] scsi5 : ahci
>>> [    0.503666] ata1: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708100 irq 41
>>> [    0.503722] ata2: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708180 irq 41
>>> [    0.503775] ata3: DUMMY
>>> [    0.503809] ata4: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708280 irq 41
>>> [    0.503863] ata5: SATA max UDMA/133 abar m2048@0xf0708000 port 0xf0708300 irq 41
>>> [    0.503917] ata6: DUMMY
>>> [    0.504943] libphy: Fixed MDIO Bus: probed
>>> [    0.505271] tun: Universal TUN/TAP device driver, 1.6
>>> [    0.505309] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
>>> [    0.505459] PPP generic driver version 2.4.2
>>> [    0.505627] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
>>> [    0.505669] ehci_hcd: block sizes: qh 112 qtd 96 itd 192 sitd 96
>>> [    0.505676] ehci-pci: EHCI PCI platform driver
>>> [    0.505921] ehci-pci 0000:00:1a.0: setting latency timer to 64
>>> [    0.505931] ehci-pci 0000:00:1a.0: EHCI Host Controller
>>> [    0.505976] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
>>> [    0.506049] ehci-pci 0000:00:1a.0: debug port 2
>>> [    0.506090] ehci-pci 0000:00:1a.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
>>> [    0.506094] ehci-pci 0000:00:1a.0: reset hcc_params 36881 caching frame 1024 64 bit addr
>>> [    0.506132] ehci-pci 0000:00:1a.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
>>> [    0.510011] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
>>> [    0.510013] ehci-pci 0000:00:1a.0: supports USB remote wakeup
>>> [    0.510056] ehci-pci 0000:00:1a.0: irq 16, io mem 0xf070a000
>>> [    0.510097] ehci-pci 0000:00:1a.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
>>> [    0.521250] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
>>> [    0.521391] usb usb1: default language 0x0409
>>> [    0.521414] usb usb1: udev 1, busnum 1, minor = 0
>>> [    0.521416] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    0.521456] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.521508] usb usb1: Product: EHCI Host Controller
>>> [    0.521545] usb usb1: Manufacturer: Linux 3.11.0-rc2-next20130725-1-iniza-small ehci_hcd
>>> [    0.521598] usb usb1: SerialNumber: 0000:00:1a.0
>>> [    0.521808] usb usb1: usb_probe_device
>>> [    0.521811] usb usb1: configuration #1 chosen from 1 choice
>>> [    0.521822] usb usb1: adding 1-0:1.0 (config #1, interface 0)
>>> [    0.521855] hub 1-0:1.0: usb_probe_interface
>>> [    0.521857] hub 1-0:1.0: usb_probe_interface - got id
>>> [    0.521860] hub 1-0:1.0: USB hub found
>>> [    0.521902] hub 1-0:1.0: 2 ports detected
>>> [    0.521938] hub 1-0:1.0: standalone hub
>>> [    0.521939] hub 1-0:1.0: no power switching (usb 1.0)
>>> [    0.521941] hub 1-0:1.0: individual port over-current protection
>>> [    0.521942] hub 1-0:1.0: power on to power good time: 20ms
>>> [    0.521948] hub 1-0:1.0: local power source is good
>>> [    0.522003] hub 1-0:1.0: trying to enable port power on non-switchable hub
>>> [    0.522294] ehci-pci 0000:00:1d.0: setting latency timer to 64
>>> [    0.522301] ehci-pci 0000:00:1d.0: EHCI Host Controller
>>> [    0.522346] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
>>> [    0.522419] ehci-pci 0000:00:1d.0: debug port 2
>>> [    0.522458] ehci-pci 0000:00:1d.0: reset hcs_params 0x200002 dbg=2 cc=0 pcc=0 ordered !ppc ports=2
>>> [    0.522462] ehci-pci 0000:00:1d.0: reset hcc_params 36881 caching frame 1024 64 bit addr
>>> [    0.522497] ehci-pci 0000:00:1d.0: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
>>> [    0.526387] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
>>> [    0.526389] ehci-pci 0000:00:1d.0: supports USB remote wakeup
>>> [    0.526435] ehci-pci 0000:00:1d.0: irq 23, io mem 0xf0709000
>>> [    0.526476] ehci-pci 0000:00:1d.0: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
>>> [    0.537238] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
>>> [    0.537363] usb usb2: default language 0x0409
>>> [    0.537384] usb usb2: udev 1, busnum 2, minor = 128
>>> [    0.537386] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    0.537426] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.537479] usb usb2: Product: EHCI Host Controller
>>> [    0.537516] usb usb2: Manufacturer: Linux 3.11.0-rc2-next20130725-1-iniza-small ehci_hcd
>>> [    0.537569] usb usb2: SerialNumber: 0000:00:1d.0
>>> [    0.537770] usb usb2: usb_probe_device
>>> [    0.537773] usb usb2: configuration #1 chosen from 1 choice
>>> [    0.537784] usb usb2: adding 2-0:1.0 (config #1, interface 0)
>>> [    0.537816] hub 2-0:1.0: usb_probe_interface
>>> [    0.537818] hub 2-0:1.0: usb_probe_interface - got id
>>> [    0.537820] hub 2-0:1.0: USB hub found
>>> [    0.537862] hub 2-0:1.0: 2 ports detected
>>> [    0.537898] hub 2-0:1.0: standalone hub
>>> [    0.537900] hub 2-0:1.0: no power switching (usb 1.0)
>>> [    0.537901] hub 2-0:1.0: individual port over-current protection
>>> [    0.537903] hub 2-0:1.0: power on to power good time: 20ms
>>> [    0.537908] hub 2-0:1.0: local power source is good
>>> [    0.537961] hub 2-0:1.0: trying to enable port power on non-switchable hub
>>> [    0.538045] ehci-platform: EHCI generic platform driver
>>> [    0.538106] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
>>> [    0.538146] ohci_hcd: block sizes: ed 80 td 96
>>> [    0.538152] ohci-pci: OHCI PCI platform driver
>>> [    0.538208] ohci-platform: OHCI generic platform driver
>>> [    0.538259] uhci_hcd: USB Universal Host Controller Interface driver
>>> [    0.538551] xhci_hcd 0000:03:00.0: xHCI Host Controller
>>> [    0.538596] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 3
>>> [    0.548360] xhci_hcd 0000:03:00.0: supports USB remote wakeup
>>> [    0.548394] xhci_hcd 0000:03:00.0: irq 42 for MSI/MSI-X
>>> [    0.548401] xhci_hcd 0000:03:00.0: irq 43 for MSI/MSI-X
>>> [    0.548409] xhci_hcd 0000:03:00.0: irq 44 for MSI/MSI-X
>>> [    0.548415] xhci_hcd 0000:03:00.0: irq 45 for MSI/MSI-X
>>> [    0.548421] xhci_hcd 0000:03:00.0: irq 46 for MSI/MSI-X
>>> [    0.548670] usb usb3: default language 0x0409
>>> [    0.548681] usb usb3: udev 1, busnum 3, minor = 256
>>> [    0.548683] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002
>>> [    0.548723] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.548775] usb usb3: Product: xHCI Host Controller
>>> [    0.548812] usb usb3: Manufacturer: Linux 3.11.0-rc2-next20130725-1-iniza-small xhci_hcd
>>> [    0.548866] usb usb3: SerialNumber: 0000:03:00.0
>>> [    0.549011] usb usb3: usb_probe_device
>>> [    0.549014] usb usb3: configuration #1 chosen from 1 choice
>>> [    0.549019] xHCI xhci_add_endpoint called for root hub
>>> [    0.549020] xHCI xhci_check_bandwidth called for root hub
>>> [    0.549026] usb usb3: adding 3-0:1.0 (config #1, interface 0)
>>> [    0.549052] hub 3-0:1.0: usb_probe_interface
>>> [    0.549054] hub 3-0:1.0: usb_probe_interface - got id
>>> [    0.549056] hub 3-0:1.0: USB hub found
>>> [    0.549101] hub 3-0:1.0: 2 ports detected
>>> [    0.549154] hub 3-0:1.0: standalone hub
>>> [    0.549155] hub 3-0:1.0: no power switching (usb 1.0)
>>> [    0.549157] hub 3-0:1.0: individual port over-current protection
>>> [    0.549158] hub 3-0:1.0: Single TT
>>> [    0.549159] hub 3-0:1.0: TT requires at most 8 FS bit times (666 ns)
>>> [    0.549161] hub 3-0:1.0: power on to power good time: 20ms
>>> [    0.549166] hub 3-0:1.0: local power source is good
>>> [    0.549201] hub 3-0:1.0: trying to enable port power on non-switchable hub
>>> [    0.549263] xhci_hcd 0000:03:00.0: xHCI Host Controller
>>> [    0.549304] xhci_hcd 0000:03:00.0: new USB bus registered, assigned bus number 4
>>> [    0.549363] xhci_hcd 0000:03:00.0: supports USB remote wakeup
>>> [    0.549395] usb usb4: skipped 1 descriptor after endpoint
>>> [    0.549400] usb usb4: default language 0x0409
>>> [    0.549410] usb usb4: udev 1, busnum 4, minor = 384
>>> [    0.549412] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003
>>> [    0.549452] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>>> [    0.549503] usb usb4: Product: xHCI Host Controller
>>> [    0.549540] usb usb4: Manufacturer: Linux 3.11.0-rc2-next20130725-1-iniza-small xhci_hcd
>>> [    0.549594] usb usb4: SerialNumber: 0000:03:00.0
>>> [    0.549735] usb usb4: usb_probe_device
>>> [    0.549737] usb usb4: configuration #1 chosen from 1 choice
>>> [    0.549741] xHCI xhci_add_endpoint called for root hub
>>> [    0.549742] xHCI xhci_check_bandwidth called for root hub
>>> [    0.549747] usb usb4: adding 4-0:1.0 (config #1, interface 0)
>>> [    0.549774] hub 4-0:1.0: usb_probe_interface
>>> [    0.549776] hub 4-0:1.0: usb_probe_interface - got id
>>> [    0.549778] hub 4-0:1.0: USB hub found
>>> [    0.549822] hub 4-0:1.0: 2 ports detected
>>> [    0.549857] hub 4-0:1.0: standalone hub
>>> [    0.549859] hub 4-0:1.0: no power switching (usb 1.0)
>>> [    0.549860] hub 4-0:1.0: individual port over-current protection
>>> [    0.549861] hub 4-0:1.0: TT requires at most 8 FS bit times (666 ns)
>>> [    0.549863] hub 4-0:1.0: power on to power good time: 20ms
>>> [    0.549867] hub 4-0:1.0: local power source is good
>>> [    0.549900] hub 4-0:1.0: trying to enable port power on non-switchable hub
>>> [    0.561355] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:EPAD] at 0x60,0x64 irq 1,12
>>> [    0.567846] serio: i8042 KBD port at 0x60,0x64 irq 1
>>> [    0.567889] serio: i8042 AUX port at 0x60,0x64 irq 12
>>> [    0.568165] mousedev: PS/2 mouse device common for all mice
>>> [    0.568681] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
>>> [    0.568761] rtc_cmos 00:05: alarms up to one month, y3k, 242 bytes nvram, hpet irqs
>>> [    0.568972] device-mapper: uevent: version 1.0.3
>>> [    0.569176] device-mapper: ioctl: 4.25.0-ioctl (2013-06-26) initialised: dm-devel@redhat.com
>>> [    0.569246] Intel P-state driver initializing.
>>> [    0.569296] Intel pstate controlling: cpu 0
>>> [    0.569399] Intel pstate controlling: cpu 1
>>> [    0.569461] Intel pstate controlling: cpu 2
>>> [    0.569527] Intel pstate controlling: cpu 3
>>> [    0.569639] ledtrig-cpu: registered to indicate activity on CPUs
>>> [    0.570030] ashmem: initialized
>>> [    0.570285] TCP: cubic registered
>>> [    0.570571] NET: Registered protocol family 10
>>> [    0.571156] NET: Registered protocol family 17
>>> [    0.571215] Key type dns_resolver registered
>>> [    0.571822] PM: Hibernation image not present or could not be loaded.
>>> [    0.571834] Loading module verification certificates
>>> [    0.573261] MODSIGN: Loaded cert 'Magrathea: Glacier signing key: 16008e29484acf95da468dc31e20a211acb2ef48'
>>> [    0.573359] registered taskstats version 1
>>> [    0.576772] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
>>> [    0.578196] Key type trusted registered
>>> [    0.585701] Key type encrypted registered
>>> [    0.592543] rtc_cmos 00:05: setting system clock to 2013-07-25 09:57:55 UTC (1374746275)
>>> [    0.593213] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
>>> [    0.593265] EDD information not available.
>>> [    0.621210] ehci-pci 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
>>> [    0.621226] hub 1-0:1.0: port 1: status 0501 change 0001
>>> [    0.637202] ehci-pci 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
>>> [    0.637219] hub 2-0:1.0: port 1: status 0501 change 0001
>>> [    0.649269] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [    0.649289] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [    0.649304] hub 3-0:1.0: hub_suspend
>>> [    0.649313] usb usb3: bus auto-suspend, wakeup 1
>>> [    0.649362] hub 4-0:1.0: hub_suspend
>>> [    0.649367] usb usb4: bus auto-suspend, wakeup 1
>>> [    0.658062] usb usb4: usb wakeup-resume
>>> [    0.658074] usb usb4: usb auto-resume
>>> [    0.669168] hub 4-0:1.0: hub_resume
>>> [    0.669199] hub 4-0:1.0: port 1: status 0203 change 0001
>>> [    0.721189] hub 1-0:1.0: state 7 ports 2 chg 0002 evt 0000
>>> [    0.721217] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
>>> [    0.777315] ehci-pci 0000:00:1a.0: port 1 reset complete, port enabled
>>> [    0.777328] ehci-pci 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
>>> [    0.821061] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [    0.822363] ata1.00: ATA-8: Hitachi HTS545050A7E380, GG2OA6C0, max UDMA/133
>>> [    0.822443] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
>>> [    0.823879] ata1.00: configured for UDMA/133
>>> [    0.824406] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS54505 GG2O PQ: 0 ANSI: 5
>>> [    0.825095] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
>>> [    0.825128] sd 0:0:0:0: Attached scsi generic sg0 type 0
>>> [    0.825261] sd 0:0:0:0: [sda] 4096-byte physical blocks
>>> [    0.825713] sd 0:0:0:0: [sda] Write Protect is off
>>> [    0.825785] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>>> [    0.826024] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>> [    0.833004] usb 1-1: new high-speed USB device number 2 using ehci-pci
>>> [    0.835513]  sda: sda1 sda2 sda3
>>> [    0.836845] sd 0:0:0:0: [sda] Attached SCSI disk
>>> [    0.889237] ehci-pci 0000:00:1a.0: port 1 reset complete, port enabled
>>> [    0.889250] ehci-pci 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
>>> [    0.965675] usb 1-1: udev 2, busnum 1, minor = 1
>>> [    0.965686] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
>>> [    0.965761] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    0.966184] usb 1-1: usb_probe_device
>>> [    0.966195] usb 1-1: configuration #1 chosen from 1 choice
>>> [    0.966420] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
>>> [    0.966513] hub 1-1:1.0: usb_probe_interface
>>> [    0.966519] hub 1-1:1.0: usb_probe_interface - got id
>>> [    0.966527] hub 1-1:1.0: USB hub found
>>> [    0.966772] hub 1-1:1.0: 6 ports detected
>>> [    0.967398] hub 1-1:1.0: standalone hub
>>> [    0.967402] hub 1-1:1.0: individual port power switching
>>> [    0.967406] hub 1-1:1.0: individual port over-current protection
>>> [    0.967409] hub 1-1:1.0: Single TT
>>> [    0.967414] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
>>> [    0.967418] hub 1-1:1.0: power on to power good time: 100ms
>>> [    0.967918] hub 1-1:1.0: local power source is good
>>> [    0.968382] hub 1-1:1.0: enabling power on all ports
>>> [    0.969646] hub 2-0:1.0: state 7 ports 2 chg 0002 evt 0000
>>> [    0.969666] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
>>> [    1.025139] ehci-pci 0000:00:1d.0: port 1 reset complete, port enabled
>>> [    1.025155] ehci-pci 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
>>> [    1.069332] hub 1-1:1.0: port 2: status 0101 change 0001
>>> [    1.070078] hub 1-1:1.0: port 4: status 0101 change 0001
>>> [    1.080883] usb 2-1: new high-speed USB device number 2 using ehci-pci
>>> [    1.137059] ehci-pci 0000:00:1d.0: port 1 reset complete, port enabled
>>> [    1.137075] ehci-pci 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
>>> [    1.144831] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>> [    1.145508] ata2.00: ATA-8: SanDisk iSSD P4 16GB, SSD 9.14, max UDMA/133
>>> [    1.145587] ata2.00: 31277232 sectors, multi 1: LBA48
>>> [    1.146337] ata2.00: configured for UDMA/133
>>> [    1.146886] scsi 1:0:0:0: Direct-Access     ATA      SanDisk iSSD P4  SSD  PQ: 0 ANSI: 5
>>> [    1.147429] sd 1:0:0:0: [sdb] 31277232 512-byte logical blocks: (16.0 GB/14.9 GiB)
>>> [    1.147490] sd 1:0:0:0: Attached scsi generic sg1 type 0
>>> [    1.147836] sd 1:0:0:0: [sdb] Write Protect is off
>>> [    1.147906] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
>>> [    1.147964] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>> [    1.149378]  sdb: sdb1 sdb2
>>> [    1.150424] sd 1:0:0:0: [sdb] Attached SCSI disk
>>> [    1.168808] usb 1-1: link qh256-0001/ffff880118bda0c0 start 1 [1/0 us]
>>> [    1.213499] usb 2-1: udev 2, busnum 2, minor = 129
>>> [    1.213511] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
>>> [    1.213586] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    1.214009] usb 2-1: usb_probe_device
>>> [    1.214020] usb 2-1: configuration #1 chosen from 1 choice
>>> [    1.214253] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
>>> [    1.214339] hub 2-1:1.0: usb_probe_interface
>>> [    1.214345] hub 2-1:1.0: usb_probe_interface - got id
>>> [    1.214352] hub 2-1:1.0: USB hub found
>>> [    1.214588] hub 2-1:1.0: 6 ports detected
>>> [    1.214661] hub 2-1:1.0: standalone hub
>>> [    1.214666] hub 2-1:1.0: individual port power switching
>>> [    1.214670] hub 2-1:1.0: individual port over-current protection
>>> [    1.214673] hub 2-1:1.0: Single TT
>>> [    1.214678] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
>>> [    1.214681] hub 2-1:1.0: power on to power good time: 100ms
>>> [    1.214901] hub 2-1:1.0: local power source is good
>>> [    1.215438] hub 2-1:1.0: enabling power on all ports
>>> [    1.216469] hub 4-0:1.0: state 7 ports 2 chg 0002 evt 0000
>>> [    1.216492] hub 4-0:1.0: port 1, status 0203, change 0000, 5.0 Gb/s
>>> [    1.313920] hub 2-1:1.0: port 5: status 0101 change 0001
>>> [    1.332337] usb 4-1: new SuperSpeed USB device number 2 using xhci_hcd
>>> [    1.345259] usb 4-1: Parent hub missing LPM exit latency info.  Power management will be impacted.
>>> [    1.345721] usb 4-1: skipped 1 descriptor after endpoint
>>> [    1.345729] usb 4-1: skipped 1 descriptor after endpoint
>>> [    1.345886] usb 4-1: default language 0x0409
>>> [    1.346333] usb 4-1: udev 2, busnum 4, minor = 385
>>> [    1.346342] usb 4-1: New USB device found, idVendor=174c, idProduct=55aa
>>> [    1.346418] usb 4-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
>>> [    1.346492] usb 4-1: Product: MEDION HDDrive-n-GO
>>> [    1.346558] usb 4-1: Manufacturer: MEDION
>>> [    1.346623] usb 4-1: SerialNumber: 3180000000000000092C
>>> [    1.347018] usb 4-1: usb_probe_device
>>> [    1.347025] usb 4-1: configuration #1 chosen from 1 choice
>>> [    1.348103] usb 4-1: Successful Endpoint Configure command
>>> [    1.348195] usb 4-1: adding 4-1:1.0 (config #1, interface 0)
>>> [    1.348429] hub 1-1:1.0: state 7 ports 6 chg 0014 evt 0000
>>> [    1.348633] hub 1-1:1.0: port 2, status 0101, change 0000, 12 Mb/s
>>> [    1.404641] tsc: Refined TSC clocksource calibration: 1596.374 MHz
>>> [    1.412667] usb 2-1: link qh256-0001/ffff88011872acc0 start 1 [1/0 us]
>>> [    1.420854] usb 1-1.2: new low-speed USB device number 3 using ehci-pci
>>> [    1.464601] ata4: SATA link down (SStatus 0 SControl 300)
>>> [    1.515914] usb 1-1.2: skipped 1 descriptor after interface
>>> [    1.516463] usb 1-1.2: default language 0x0409
>>> [    1.518901] usb 1-1.2: udev 3, busnum 1, minor = 2
>>> [    1.518911] usb 1-1.2: New USB device found, idVendor=046d, idProduct=c00e
>>> [    1.518987] usb 1-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>> [    1.519076] usb 1-1.2: Product: USB-PS/2 Optical Mouse
>>> [    1.519142] usb 1-1.2: Manufacturer: Logitech
>>> [    1.519576] usb 1-1.2: usb_probe_device
>>> [    1.519587] usb 1-1.2: configuration #1 chosen from 1 choice
>>> [    1.520136] usb 1-1.2: adding 1-1.2:1.0 (config #1, interface 0)
>>> [    1.520460] hub 1-1:1.0: port 4, status 0101, change 0000, 12 Mb/s
>>> [    1.592724] usb 1-1.4: new high-speed USB device number 4 using ehci-pci
>>> [    1.784375] ata5: SATA link down (SStatus 0 SControl 300)
>>> [    1.787614] Freeing unused kernel memory: 1332K (ffffffff81d07000 - ffffffff81e54000)
>>> [    1.787710] Write protecting the kernel read-only data: 12288k
>>> [    1.793705] Freeing unused kernel memory: 1060K (ffff8800016f7000 - ffff880001800000)
>>> [    1.798786] Freeing unused kernel memory: 964K (ffff880001b0f000 - ffff880001c00000)
>>> [    1.834231] usb 1-1.4: skipped 1 descriptor after configuration
>>> [    1.834239] usb 1-1.4: skipped 5 descriptors after interface
>>> [    1.834244] usb 1-1.4: skipped 1 descriptor after endpoint
>>> [    1.834247] usb 1-1.4: skipped 23 descriptors after interface
>>> [    1.836335] usb 1-1.4: default language 0x0409
>>> [    1.838923] udevd[122]: starting version 175
>>> [    1.848329] usb 1-1.4: udev 4, busnum 1, minor = 3
>>> [    1.848338] usb 1-1.4: New USB device found, idVendor=2232, idProduct=1018
>>> [    1.848409] usb 1-1.4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>>> [    1.848473] usb 1-1.4: Product: WebCam SC-13HDL11431N
>>> [    1.848516] usb 1-1.4: Manufacturer: 123
>>> [    1.848776] usb 1-1.4: usb_probe_device
>>> [    1.848784] usb 1-1.4: configuration #1 chosen from 1 choice
>>> [    1.849987] usb 1-1.4: adding 1-1.4:1.0 (config #1, interface 0)
>>> [    1.981985] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
>>> [    1.982077] r8169 0000:02:00.0: can't disable ASPM; OS doesn't have ASPM control
>>> [    1.982465] r8169 0000:02:00.0: irq 47 for MSI/MSI-X
>>> [    1.982901] r8169 0000:02:00.0 eth0: RTL8168evl/8111evl at 0xffffc90000620000, e8:03:9a:36:17:a9, XID 0c900800 IRQ 47
>>> [    1.982968] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200 bytes, tx checksumming: ko]
>>> [    1.983886] usb-storage 4-1:1.0: usb_probe_interface
>>> [    1.983898] usb-storage 4-1:1.0: usb_probe_interface - got id
>>> [    1.983904] usb-storage 4-1:1.0: USB Mass Storage device detected
>>> [    1.984130] scsi6 : usb-storage 4-1:1.0
>>> [    1.985684] usbcore: registered new interface driver usb-storage
>>> [    2.020897] usb 1-1.4: adding 1-1.4:1.1 (config #1, interface 1)
>>> [    2.021303] hub 2-1:1.0: state 7 ports 6 chg 0020 evt 0000
>>> [    2.021433] hub 2-1:1.0: port 5, status 0101, change 0000, 12 Mb/s
>>> [    2.043531] hidraw: raw HID events driver (C) Jiri Kosina
>>> [    2.048320] usbhid 1-1.2:1.0: usb_probe_interface
>>> [    2.048325] usbhid 1-1.2:1.0: usb_probe_interface - got id
>>> [    2.051194] usbcore: registered new interface driver usbhid
>>> [    2.051236] usbhid: USB HID core driver
>>> [    2.055112] input: Logitech USB-PS/2 Optical Mouse as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input4
>>> [    2.055465] hid-generic 0003:046D:C00E.0001: input,hidraw0: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1a.0-1.2/input0
>>> [    2.092339] usb 2-1.5: new full-speed USB device number 3 using ehci-pci
>>> [    2.188853] usb 2-1.5: udev 3, busnum 2, minor = 130
>>> [    2.188863] usb 2-1.5: New USB device found, idVendor=8086, idProduct=0189
>>> [    2.188928] usb 2-1.5: New USB device strings: Mfr=0, Product=0, SerialNumber=0
>>> [    2.189271] usb 2-1.5: usb_probe_device
>>> [    2.189279] usb 2-1.5: configuration #1 chosen from 1 choice
>>> [    2.189838] usb 2-1.5: adding 2-1.5:1.0 (config #1, interface 0)
>>> [    2.190123] usb 2-1.5: adding 2-1.5:1.1 (config #1, interface 1)
>>> [    2.190572] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0010
>>> [    2.190699] hub 2-1:1.0: state 7 ports 6 chg 0000 evt 0020
>>> [    2.404228] Switched to clocksource tsc
>>> [    2.942151] EXT4-fs (loop0): mounted filesystem with ordered data mode. Opts: (null)
>>> [    2.984038] scsi 6:0:0:0: Direct-Access     ASMT     2105             0    PQ: 0 ANSI: 6
>>> [    2.984852] sd 6:0:0:0: Attached scsi generic sg2 type 0
>>> [    2.984979] sd 6:0:0:0: [sdc] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
>>> [    2.985526] sd 6:0:0:0: [sdc] Write Protect is off
>>> [    2.985593] sd 6:0:0:0: [sdc] Mode Sense: 43 00 00 00
>>> [    2.986055] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>>> [    2.989223]  sdc: sdc1 sdc2 sdc3
>>> [    2.991487] sd 6:0:0:0: [sdc] Attached SCSI disk
>>> [   14.821390] Adding 262140k swap on /host/ubuntu/disks/swap.disk.  Priority:-1 extents:1 across:262140k FS
>>> [   14.835400] EXT4-fs (loop0): re-mounted. Opts: errors=remount-ro
>>> [   14.893353] udevd[616]: starting version 175
>>> [   15.048184] ACPI Warning: 0x0000000000000428-0x000000000000042f SystemIO conflicts with Region \PMIO 1 (20130626/utaddress-251)
>>> [   15.048195] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   15.048201] ACPI Warning: 0x0000000000000540-0x000000000000054f SystemIO conflicts with Region \GPIO 1 (20130626/utaddress-251)
>>> [   15.048207] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   15.048209] ACPI Warning: 0x0000000000000530-0x000000000000053f SystemIO conflicts with Region \GPIO 1 (20130626/utaddress-251)
>>> [   15.048214] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   15.048217] ACPI Warning: 0x0000000000000500-0x000000000000052f SystemIO conflicts with Region \GPIO 1 (20130626/utaddress-251)
>>> [   15.048222] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>> [   15.048225] lpc_ich: Resource conflict(s) found affecting gpio_ich
>>> [   15.326256] lp: driver loaded but no devices found
>>> [   15.422530] cfg80211: Calling CRDA to update world regulatory domain
>>> [   15.430531] cfg80211: World regulatory domain updated:
>>> [   15.430535] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>>> [   15.430538] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> [   15.430540] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>> [   15.430541] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>>> [   15.430543] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> [   15.430544] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>>> [   15.488605] wmi: Mapper loaded
>>> [   15.501002] samsung_laptop: detected SABI interface: SwSmi@
>>> [   15.501008] samsung_laptop: Backlight controlled by ACPI video driver
>>> [   15.766590] ppdev: user-space parallel port driver
>>> [   15.887623] Bluetooth: Core ver 2.16
>>> [   15.887677] NET: Registered protocol family 31
>>> [   15.887680] Bluetooth: HCI device and connection manager initialized
>>> [   15.887697] Bluetooth: HCI socket layer initialized
>>> [   15.887710] Bluetooth: L2CAP socket layer initialized
>>> [   15.887738] Bluetooth: SCO socket layer initialized
>>> [   15.926642] type=1400 audit(1374739090.843:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=746 comm="apparmor_parser"
>>> [   15.927443] type=1400 audit(1374739090.843:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=746 comm="apparmor_parser"
>>> [   15.927973] type=1400 audit(1374739090.843:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=746 comm="apparmor_parser"
>>> [   15.928870] type=1400 audit(1374739090.843:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=860 comm="apparmor_parser"
>>> [   15.929478] type=1400 audit(1374739090.843:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=860 comm="apparmor_parser"
>>> [   15.929941] type=1400 audit(1374739090.843:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=860 comm="apparmor_parser"
>>> [   15.932941] Linux video capture interface: v2.00
>>> [   15.999279] init: failsafe main process (979) killed by TERM signal
>>> [   16.092980] type=1400 audit(1374739091.007:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=1096 comm="apparmor_parser"
>>> [   16.093582] type=1400 audit(1374739091.007:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1096 comm="apparmor_parser"
>>> [   16.093948] type=1400 audit(1374739091.007:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=1096 comm="apparmor_parser"
>>> [   16.172489] [drm] Initialized drm 1.1.0 20060810
>>> [   16.474523] btusb 2-1.5:1.0: usb_probe_interface
>>> [   16.474530] btusb 2-1.5:1.0: usb_probe_interface - got id
>>> [   16.475149] usbcore: registered new interface driver btusb
>>> [   16.475597] usb 2-1.5: link qh1-0e01/ffff8800bb6e0640 start 0 [1/2 us]
>>> [   16.490149] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
>>> [   16.490155] Bluetooth: BNEP filters: protocol multicast
>>> [   16.490176] Bluetooth: BNEP socket layer initialized
>>> [   16.491475] Bluetooth: RFCOMM TTY layer initialized
>>> [   16.491500] Bluetooth: RFCOMM socket layer initialized
>>> [   16.491502] Bluetooth: RFCOMM ver 1.11
>>> [   16.504603] Intel(R) Wireless WiFi driver for Linux, in-tree:d
>>> [   16.504608] Copyright(c) 2003-2013 Intel Corporation
>>> [   16.504677] iwlwifi 0000:01:00.0: can't disable ASPM; OS doesn't have ASPM control
>>> [   16.504998] iwlwifi 0000:01:00.0: irq 48 for MSI/MSI-X
>>> [   16.703971] type=1400 audit(1374739091.619:11): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm/lightdm-guest-session-wrapper" pid=1095 comm="apparmor_parser"
>>> [   16.748837] iwlwifi 0000:01:00.0: loaded firmware version 18.168.6.1 op_mode iwldvm
>>> [   17.012977] uvcvideo 1-1.4:1.0: usb_probe_interface
>>> [   17.012984] uvcvideo 1-1.4:1.0: usb_probe_interface - got id
>>> [   17.013021] uvcvideo: Found UVC 1.00 device WebCam SC-13HDL11431N (2232:1018)
>>> [   17.032351] input: WebCam SC-13HDL11431N as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input5
>>> [   17.032588] usbcore: registered new interface driver uvcvideo
>>> [   17.032592] USB Video Class driver (1.1.1)
>>> [   17.035212] usb 1-1.4: link qh16-0001/ffff8800bb6e08c0 start 2 [1/0 us]
>>> [   17.035279] usb 1-1.4: unlink qh16-0001/ffff8800bb6e08c0 start 2 [1/0 us]
>>> [   17.122627] [drm] Memory usable by graphics device = 2048M
>>> [   17.122639] i915 0000:00:02.0: setting latency timer to 64
>>> [   17.164740] BUG: spinlock bad magic on CPU#3, modprobe/635
>>> [   17.164797]  lock: 0xffff8800bc534040, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
>>> [   17.164856] CPU: 3 PID: 635 Comm: modprobe Not tainted 3.11.0-rc2-next20130725-1-iniza-small #1
>>> [   17.164914] Hardware name: SAMSUNG ELECTRONICS CO., LTD. 530U3BI/530U4BI/530U4BH/530U3BI/530U4BI/530U4BH, BIOS 13XK 03/28/2013
>>> [   17.164977]  0000000000000000 ffff8800c0fa1738 ffffffff816ddfc9 0000000000000007
>>> [   17.165101]  ffff8800bc534040 ffff8800c0fa1758 ffffffff816de065 ffff8800bc534040
>>> [   17.165222]  ffffffff81a5f497 ffff8800c0fa1778 ffffffff816de08b ffff8800bc534040
>>> [   17.165345] Call Trace:
>>> [   17.165386]  [<ffffffff816ddfc9>] dump_stack+0x46/0x58
>>> [   17.165428]  [<ffffffff816de065>] spin_dump+0x8a/0x8f
>>> [   17.165469]  [<ffffffff816de08b>] spin_bug+0x21/0x26
>>> [   17.165511]  [<ffffffff813787c4>] do_raw_spin_lock+0x84/0x120
>>> [   17.165554]  [<ffffffff816e6db4>] _raw_spin_lock_irqsave+0x24/0x30
>>> [   17.165620]  [<ffffffffa037a456>] i915_write32+0x36/0x150 [i915]
>>> [   17.165690]  [<ffffffffa03cf4c5>] intel_disable_gt_powersave+0xf5/0x360 [i915]
>>> [   17.165768]  [<ffffffffa03d1129>] intel_gt_sanitize+0x49/0xb0 [i915]
>>> [   17.165827]  [<ffffffffa037dd68>] i915_driver_load+0x638/0xed0 [i915]
>>> [   17.165886]  [<ffffffffa01b4b91>] drm_get_pci_dev+0x181/0x2a0 [drm]
>>> [   17.165929]  [<ffffffff813788fd>] ? do_raw_spin_unlock+0x5d/0xb0
>>> [   17.165987]  [<ffffffffa03796f6>] i915_pci_probe+0x36/0x70 [i915]
>>> [   17.166031]  [<ffffffff813973ab>] local_pci_probe+0x4b/0x80
>>> [   17.166073]  [<ffffffff81398c81>] pci_device_probe+0x101/0x120
>>> [   17.166115]  [<ffffffff8147599b>] driver_probe_device+0x7b/0x240
>>> [   17.166158]  [<ffffffff81475c0b>] __driver_attach+0xab/0xb0
>>> [   17.166200]  [<ffffffff81475b60>] ? driver_probe_device+0x240/0x240
>>> [   17.166244]  [<ffffffff81473c7e>] bus_for_each_dev+0x5e/0x90
>>> [   17.166286]  [<ffffffff8147549e>] driver_attach+0x1e/0x20
>>> [   17.166330]  [<ffffffff81474f94>] bus_add_driver+0x104/0x270
>>> [   17.166372]  [<ffffffff8147616d>] driver_register+0x7d/0x160
>>> [   17.166415]  [<ffffffff81397c04>] __pci_register_driver+0x64/0x70
>>> [   17.166460]  [<ffffffffa0446000>] ? 0xffffffffa0445fff
>>> [   17.166510]  [<ffffffffa01b4dca>] drm_pci_init+0x11a/0x130 [drm]
>>> [   17.166553]  [<ffffffffa0446000>] ? 0xffffffffa0445fff
>>> [   17.166610]  [<ffffffffa0446066>] i915_init+0x66/0x68 [i915]
>>> [   17.166652]  [<ffffffff8100207e>] do_one_initcall+0x4e/0x180
>>> [   17.166696]  [<ffffffff81058453>] ? set_memory_nx+0x43/0x50
>>> [   17.166742]  [<ffffffff810d111c>] load_module+0x209c/0x25b0
>>> [   17.166784]  [<ffffffff810cdd40>] ? show_initstate+0x50/0x50
>>> [   17.166827]  [<ffffffff810d16dc>] SyS_init_module+0xac/0xd0
>>> [   17.166871]  [<ffffffff816efdef>] tracesys+0xe1/0xe6
>>> [   17.167649] i915 0000:00:02.0: irq 49 for MSI/MSI-X
>>> [   17.167709] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
>>> [   17.167753] [drm] Driver supports precise vblank timestamp query.
>>> [   17.168036] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
>>> [   17.179048] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUG enabled
>>> [   17.179101] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
>>> [   17.179144] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_DEVICE_TRACING enabled
>>> [   17.179188] iwlwifi 0000:01:00.0: CONFIG_IWLWIFI_P2P disabled
>>> [   17.179231] iwlwifi 0000:01:00.0: Detected Intel(R) Centrino(R) Advanced-N 6230 AGN, REV=0xB0
>>> [   17.179403] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
>>> [   17.191305] [drm] Wrong MCH_SSKPD value: 0x16040307
>>> [   17.191548] [drm] This can cause pipe underruns and display issues.
>>> [   17.191806] [drm] Please upgrade your BIOS to fix this.
>>> [   17.200113] init: alsa-restore main process (1175) terminated with status 19
>>> [   17.204370] usb 1-1.2: link qh8-0e01/ffff8800bb6e09c0 start 3 [1/2 us]
>>> [   17.209295] fbcon: inteldrmfb (fb0) is primary device
>>> [   17.225544] usb 1-1.2: unlink qh8-0e01/ffff8800bb6e09c0 start 3 [1/2 us]
>>> [   17.231718] ieee80211 phy0: Selected rate control algorithm 'iwl-agn-rs'
>>> [   17.252830] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
>>> [   17.259547] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
>>> [   17.372778] psmouse serio1: elantech: assuming hardware version 3 (with firmware version 0x450f00)
>>> [   17.387876] psmouse serio1: elantech: Synaptics capabilities query result 0x08, 0x17, 0x0c.
>>> [   17.465514] input: ETPS/2 Elantech Touchpad as /devices/platform/i8042/serio1/input/input6
>>> [   17.534384] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
>>> [   17.541018] iwlwifi 0000:01:00.0: Radio type=0x1-0x2-0x0
>>> [   17.621870] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
>>> [   18.259707] Console: switching to colour frame buffer device 170x48
>>> [   18.266630] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
>>> [   18.266633] i915 0000:00:02.0: registered panic notifier
>>> [   18.283546] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
>>> [   18.284027] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/LNXVIDEO:00/input/input7
>>> [   18.284665] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>>> [   18.285158] snd_hda_intel 0000:00:1b.0: irq 50 for MSI/MSI-X
>>> [   18.315840] init: plymouth-splash main process (1307) terminated with status 1
>>> [   18.360521] input: HDA Intel PCH HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
>>> [   18.360902] input: HDA Intel PCH Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
>>> [   18.361148] input: HDA Intel PCH Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
>>> [   18.804651] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
>>> [   18.835847] init: plymouth-stop pre-start process (1460) terminated with status 1
>>> [   19.032359] usb 1-1.4: usb auto-suspend, wakeup 0
>>> [   19.454465] ehci-pci 0000:00:1a.0: reused qh ffff8800bb6e09c0 schedule
>>> [   19.454474] usb 1-1.2: link qh8-0e01/ffff8800bb6e09c0 start 3 [1/2 us]
>>> [   23.880493] wlan0: authenticate with 00:04:0e:e4:00:3d
>>> [   23.885372] wlan0: send auth to 00:04:0e:e4:00:3d (try 1/3)
>>> [   23.889197] wlan0: authenticated
>>> [   23.889481] iwlwifi 0000:01:00.0 wlan0: disabling HT as WMM/QoS is not supported by the AP
>>> [   23.889489] iwlwifi 0000:01:00.0 wlan0: disabling VHT as WMM/QoS is not supported by the AP
>>> [   23.892677] wlan0: associate with 00:04:0e:e4:00:3d (try 1/3)
>>> [   23.896209] wlan0: RX AssocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
>>> [   23.904647] wlan0: associated
>>> [   23.904785] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>>> [   26.811180] usb usb3: usb auto-resume
>>> [   26.811203] hub 3-0:1.0: hub_resume
>>> [   26.811255] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   26.811272] hub 3-0:1.0: hub_suspend
>>> [   26.811322] usb usb3: bus auto-suspend, wakeup 1
>>> [   26.811348] usb usb3: usb auto-resume
>>> [   26.822556] hub 3-0:1.0: hub_resume
>>> [   26.822599] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   26.822614] hub 3-0:1.0: hub_suspend
>>> [   26.822620] usb usb3: bus auto-suspend, wakeup 1
>>> [   26.823224] usb 1-1.4: usb auto-resume
>>> [   26.860474] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0010
>>> [   26.870688] usb 1-1.4: finish resume
>>> [   27.063824] usb usb3: usb auto-resume
>>> [   27.063857] hub 3-0:1.0: hub_resume
>>> [   27.063902] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.063916] hub 3-0:1.0: hub_suspend
>>> [   27.063926] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.064033] usb usb3: usb auto-resume
>>> [   27.074484] hub 3-0:1.0: hub_resume
>>> [   27.074567] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.074593] hub 3-0:1.0: hub_suspend
>>> [   27.074603] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.096339] usb usb3: usb auto-resume
>>> [   27.096362] hub 3-0:1.0: hub_resume
>>> [   27.096426] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.096478] hub 3-0:1.0: hub_suspend
>>> [   27.096486] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.127343] usb usb3: usb auto-resume
>>> [   27.127371] hub 3-0:1.0: hub_resume
>>> [   27.127409] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.127446] hub 3-0:1.0: hub_suspend
>>> [   27.127457] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.127550] usb usb3: usb auto-resume
>>> [   27.138409] hub 3-0:1.0: hub_resume
>>> [   27.138452] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.138469] hub 3-0:1.0: hub_suspend
>>> [   27.138475] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.201295] usb usb3: usb auto-resume
>>> [   27.201317] hub 3-0:1.0: hub_resume
>>> [   27.201343] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.201360] hub 3-0:1.0: hub_suspend
>>> [   27.201366] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.201412] usb usb3: usb auto-resume
>>> [   27.210287] hub 3-0:1.0: hub_resume
>>> [   27.210318] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.210332] hub 3-0:1.0: hub_suspend
>>> [   27.210341] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.228182] usb usb3: usb auto-resume
>>> [   27.228206] hub 3-0:1.0: hub_resume
>>> [   27.228258] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.228277] hub 3-0:1.0: hub_suspend
>>> [   27.228283] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.228315] usb usb3: usb auto-resume
>>> [   27.242307] hub 3-0:1.0: hub_resume
>>> [   27.242443] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.242454] hub 3-0:1.0: hub_suspend
>>> [   27.242462] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.273418] usb usb3: usb auto-resume
>>> [   27.273448] hub 3-0:1.0: hub_resume
>>> [   27.273491] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.273516] hub 3-0:1.0: hub_suspend
>>> [   27.273525] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.273651] usb usb3: usb auto-resume
>>> [   27.282292] hub 3-0:1.0: hub_resume
>>> [   27.282339] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.282358] hub 3-0:1.0: hub_suspend
>>> [   27.282365] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.400359] usb usb3: usb auto-resume
>>> [   27.400381] hub 3-0:1.0: hub_resume
>>> [   27.400413] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.400433] hub 3-0:1.0: hub_suspend
>>> [   27.400442] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.400466] usb usb3: usb auto-resume
>>> [   27.410186] hub 3-0:1.0: hub_resume
>>> [   27.410224] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.410244] hub 3-0:1.0: hub_suspend
>>> [   27.410250] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.419258] usb usb3: usb auto-resume
>>> [   27.430132] hub 3-0:1.0: hub_resume
>>> [   27.430192] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.430202] hub 3-0:1.0: hub_suspend
>>> [   27.430209] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.430257] usb usb3: usb auto-resume
>>> [   27.442204] hub 3-0:1.0: hub_resume
>>> [   27.442283] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.442323] hub 3-0:1.0: hub_suspend
>>> [   27.442333] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.796527] usb usb3: usb auto-resume
>>> [   27.796551] hub 3-0:1.0: hub_resume
>>> [   27.796589] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.796618] hub 3-0:1.0: hub_suspend
>>> [   27.796627] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.796690] usb usb3: usb auto-resume
>>> [   27.805868] hub 3-0:1.0: hub_resume
>>> [   27.805914] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.805936] hub 3-0:1.0: hub_suspend
>>> [   27.805952] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.967943] usb usb3: usb auto-resume
>>> [   27.967968] hub 3-0:1.0: hub_resume
>>> [   27.968002] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.968017] hub 3-0:1.0: hub_suspend
>>> [   27.968026] usb usb3: bus auto-suspend, wakeup 1
>>> [   27.968092] usb usb3: usb auto-resume
>>> [   27.977808] hub 3-0:1.0: hub_resume
>>> [   27.977829] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   27.977847] hub 3-0:1.0: hub_suspend
>>> [   27.977852] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.045543] usb usb3: usb auto-resume
>>> [   29.045567] hub 3-0:1.0: hub_resume
>>> [   29.046607] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.046625] hub 3-0:1.0: hub_suspend
>>> [   29.046649] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.061941] usb usb3: usb auto-resume
>>> [   29.061964] hub 3-0:1.0: hub_resume
>>> [   29.061990] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.061999] hub 3-0:1.0: hub_suspend
>>> [   29.062005] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.062051] usb usb3: usb auto-resume
>>> [   29.072964] hub 3-0:1.0: hub_resume
>>> [   29.072992] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.073015] hub 3-0:1.0: hub_suspend
>>> [   29.073023] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.075768] usb usb3: usb auto-resume
>>> [   29.084950] hub 3-0:1.0: hub_resume
>>> [   29.084978] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.084999] hub 3-0:1.0: hub_suspend
>>> [   29.085005] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.085063] usb usb3: usb auto-resume
>>> [   29.096946] hub 3-0:1.0: hub_resume
>>> [   29.097028] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.097046] hub 3-0:1.0: hub_suspend
>>> [   29.097055] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.157013] usb usb3: usb auto-resume
>>> [   29.157035] hub 3-0:1.0: hub_resume
>>> [   29.157064] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.157083] hub 3-0:1.0: hub_suspend
>>> [   29.157092] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.157122] usb usb3: usb auto-resume
>>> [   29.168928] hub 3-0:1.0: hub_resume
>>> [   29.168958] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.168983] hub 3-0:1.0: hub_suspend
>>> [   29.168991] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.169754] usb usb3: usb auto-resume
>>> [   29.180939] hub 3-0:1.0: hub_resume
>>> [   29.180970] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.180996] hub 3-0:1.0: hub_suspend
>>> [   29.181004] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.181064] usb usb3: usb auto-resume
>>> [   29.192882] hub 3-0:1.0: hub_resume
>>> [   29.192919] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.192936] hub 3-0:1.0: hub_suspend
>>> [   29.192942] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.194966] usb usb3: usb auto-resume
>>> [   29.204890] hub 3-0:1.0: hub_resume
>>> [   29.204920] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.204950] hub 3-0:1.0: hub_suspend
>>> [   29.204958] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.205018] usb usb3: usb auto-resume
>>> [   29.216918] hub 3-0:1.0: hub_resume
>>> [   29.216979] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.217006] hub 3-0:1.0: hub_suspend
>>> [   29.217012] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.219358] usb usb3: usb auto-resume
>>> [   29.228865] hub 3-0:1.0: hub_resume
>>> [   29.228903] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.228935] hub 3-0:1.0: hub_suspend
>>> [   29.228943] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.229022] usb usb3: usb auto-resume
>>> [   29.240964] hub 3-0:1.0: hub_resume
>>> [   29.240998] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.241016] hub 3-0:1.0: hub_suspend
>>> [   29.241023] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.253457] usb usb3: usb auto-resume
>>> [   29.253478] hub 3-0:1.0: hub_resume
>>> [   29.253507] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.253524] hub 3-0:1.0: hub_suspend
>>> [   29.253530] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.253559] usb usb3: usb auto-resume
>>> [   29.264861] hub 3-0:1.0: hub_resume
>>> [   29.264924] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.264942] hub 3-0:1.0: hub_suspend
>>> [   29.264949] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.282357] usb usb3: usb auto-resume
>>> [   29.282378] hub 3-0:1.0: hub_resume
>>> [   29.282434] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.282464] hub 3-0:1.0: hub_suspend
>>> [   29.282471] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.283178] usb usb3: usb auto-resume
>>> [   29.292838] hub 3-0:1.0: hub_resume
>>> [   29.292909] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.292925] hub 3-0:1.0: hub_suspend
>>> [   29.292932] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.292951] usb usb3: usb auto-resume
>>> [   29.304821] hub 3-0:1.0: hub_resume
>>> [   29.304854] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.304865] hub 3-0:1.0: hub_suspend
>>> [   29.304873] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.370015] usb usb3: usb auto-resume
>>> [   29.370040] hub 3-0:1.0: hub_resume
>>> [   29.370082] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.370105] hub 3-0:1.0: hub_suspend
>>> [   29.370112] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.370178] usb usb3: usb auto-resume
>>> [   29.384874] hub 3-0:1.0: hub_resume
>>> [   29.384919] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.384929] hub 3-0:1.0: hub_suspend
>>> [   29.384936] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.395757] usb usb3: usb auto-resume
>>> [   29.404879] hub 3-0:1.0: hub_resume
>>> [   29.404950] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.404972] hub 3-0:1.0: hub_suspend
>>> [   29.404980] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.405007] usb usb3: usb auto-resume
>>> [   29.416725] hub 3-0:1.0: hub_resume
>>> [   29.416791] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.416810] hub 3-0:1.0: hub_suspend
>>> [   29.416817] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.436482] usb usb3: usb auto-resume
>>> [   29.436504] hub 3-0:1.0: hub_resume
>>> [   29.436548] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.436567] hub 3-0:1.0: hub_suspend
>>> [   29.436574] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.436607] usb usb3: usb auto-resume
>>> [   29.444715] hub 3-0:1.0: hub_resume
>>> [   29.444756] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.444865] hub 3-0:1.0: hub_suspend
>>> [   29.444874] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.469110] usb usb3: usb auto-resume
>>> [   29.469133] hub 3-0:1.0: hub_resume
>>> [   29.469162] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.469188] hub 3-0:1.0: hub_suspend
>>> [   29.469197] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.469246] usb usb3: usb auto-resume
>>> [   29.480715] hub 3-0:1.0: hub_resume
>>> [   29.480756] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.480767] hub 3-0:1.0: hub_suspend
>>> [   29.480776] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.508566] usb usb3: usb auto-resume
>>> [   29.508587] hub 3-0:1.0: hub_resume
>>> [   29.508614] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.508657] hub 3-0:1.0: hub_suspend
>>> [   29.508665] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.508734] usb usb3: usb auto-resume
>>> [   29.520724] hub 3-0:1.0: hub_resume
>>> [   29.520777] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.520833] hub 3-0:1.0: hub_suspend
>>> [   29.520841] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.567465] usb usb3: usb auto-resume
>>> [   29.567488] hub 3-0:1.0: hub_resume
>>> [   29.567517] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.567538] hub 3-0:1.0: hub_suspend
>>> [   29.567547] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.567578] usb usb3: usb auto-resume
>>> [   29.576622] hub 3-0:1.0: hub_resume
>>> [   29.577036] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.577054] hub 3-0:1.0: hub_suspend
>>> [   29.577062] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.609135] usb usb3: usb auto-resume
>>> [   29.609157] hub 3-0:1.0: hub_resume
>>> [   29.609205] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.609223] hub 3-0:1.0: hub_suspend
>>> [   29.609229] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.609257] usb usb3: usb auto-resume
>>> [   29.620625] hub 3-0:1.0: hub_resume
>>> [   29.620665] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.620679] hub 3-0:1.0: hub_suspend
>>> [   29.620688] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.623757] usb usb3: usb auto-resume
>>> [   29.632606] hub 3-0:1.0: hub_resume
>>> [   29.632662] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.632684] hub 3-0:1.0: hub_suspend
>>> [   29.632692] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.632760] usb usb3: usb auto-resume
>>> [   29.644675] hub 3-0:1.0: hub_resume
>>> [   29.644752] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.644770] hub 3-0:1.0: hub_suspend
>>> [   29.644777] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.676740] usb usb3: usb auto-resume
>>> [   29.676763] hub 3-0:1.0: hub_resume
>>> [   29.676822] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.676855] hub 3-0:1.0: hub_suspend
>>> [   29.676862] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.680015] usb usb3: usb auto-resume
>>> [   29.688588] hub 3-0:1.0: hub_resume
>>> [   29.688647] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.688679] hub 3-0:1.0: hub_suspend
>>> [   29.688685] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.688753] usb usb3: usb auto-resume
>>> [   29.700526] hub 3-0:1.0: hub_resume
>>> [   29.700562] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.700576] hub 3-0:1.0: hub_suspend
>>> [   29.700586] usb usb3: bus auto-suspend, wakeup 1
>>> [   29.718301] usb usb3: usb auto-resume
>>> [   29.718325] hub 3-0:1.0: hub_resume
>>> [   29.718390] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   29.718447] hub 3-0:1.0: hub_suspend
>>> [   29.718453] usb usb3: bus auto-suspend, wakeup 1
>>> [   30.748649] usb usb3: usb auto-resume
>>> [   30.748672] hub 3-0:1.0: hub_resume
>>> [   30.748734] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   30.748763] hub 3-0:1.0: hub_suspend
>>> [   30.748770] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.055854] usb usb3: usb auto-resume
>>> [   31.055876] hub 3-0:1.0: hub_resume
>>> [   31.055937] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.055980] hub 3-0:1.0: hub_suspend
>>> [   31.055987] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.080654] usb usb3: usb auto-resume
>>> [   31.080678] hub 3-0:1.0: hub_resume
>>> [   31.080742] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.080771] hub 3-0:1.0: hub_suspend
>>> [   31.080777] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.083985] usb usb3: usb auto-resume
>>> [   31.095670] hub 3-0:1.0: hub_resume
>>> [   31.095732] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.095782] hub 3-0:1.0: hub_suspend
>>> [   31.095791] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.095891] usb usb3: usb auto-resume
>>> [   31.107609] hub 3-0:1.0: hub_resume
>>> [   31.107687] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.107711] hub 3-0:1.0: hub_suspend
>>> [   31.107720] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.111427] usb usb3: usb auto-resume
>>> [   31.119549] hub 3-0:1.0: hub_resume
>>> [   31.119618] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.119639] hub 3-0:1.0: hub_suspend
>>> [   31.119647] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.119677] usb usb3: usb auto-resume
>>> [   31.131619] hub 3-0:1.0: hub_resume
>>> [   31.131700] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.131728] hub 3-0:1.0: hub_suspend
>>> [   31.131737] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.175652] usb usb3: usb auto-resume
>>> [   31.175683] hub 3-0:1.0: hub_resume
>>> [   31.175775] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.175819] hub 3-0:1.0: hub_suspend
>>> [   31.175831] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.175872] usb usb3: usb auto-resume
>>> [   31.187562] hub 3-0:1.0: hub_resume
>>> [   31.187670] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.187705] hub 3-0:1.0: hub_suspend
>>> [   31.187718] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.194530] usb usb3: usb auto-resume
>>> [   31.203589] hub 3-0:1.0: hub_resume
>>> [   31.203663] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.203704] hub 3-0:1.0: hub_suspend
>>> [   31.203714] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.203808] usb usb3: usb auto-resume
>>> [   31.215553] hub 3-0:1.0: hub_resume
>>> [   31.215639] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.215668] hub 3-0:1.0: hub_suspend
>>> [   31.215678] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.343711] usb usb3: usb auto-resume
>>> [   31.343735] hub 3-0:1.0: hub_resume
>>> [   31.343770] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.343809] hub 3-0:1.0: hub_suspend
>>> [   31.343818] usb usb3: bus auto-suspend, wakeup 1
>>> [   31.343895] usb usb3: usb auto-resume
>>> [   31.355437] hub 3-0:1.0: hub_resume
>>> [   31.355482] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
>>> [   31.355507] hub 3-0:1.0: hub_suspend
>>> [   31.355521] usb usb3: bus auto-suspend, wakeup 1
>>> [   33.805755] usb 1-1.4: usb auto-suspend, wakeup 0
>>> [   40.596137] EXT4-fs (sdc3): mounted filesystem with ordered data mode. Opts: (null)
>>> [   40.619552] EXT4-fs (sdc1): mounted filesystem with ordered data mode. Opts: (null)
>>> [   55.836469] usb 2-1.5: unlink qh1-0e01/ffff8800bb6e0640 start 0 [1/2 us]
>>> [   56.040578] hub 2-1:1.0: state 7 ports 6 chg 0000 evt 0020
>>> [   56.040843] hub 2-1:1.0: port 5, status 0100, change 0001, 12 Mb/s
>>> [   56.040852] usb 2-1.5: USB disconnect, device number 3
>>> [   56.040856] usb 2-1.5: unregistering device
>>> [   56.040860] usb 2-1.5: unregistering interface 2-1.5:1.0
>>> [   56.041687] usb 2-1.5: unregistering interface 2-1.5:1.1
>>> [   56.041854] usb 2-1.5: usb_disable_device nuking all URBs
>>> [   56.167563] hub 2-1:1.0: debounce: port 5: total 100ms stable 100ms status 0x100
>>> [   56.167592] hub 2-1:1.0: hub_suspend
>>> [   56.167602] usb 2-1: unlink qh256-0001/ffff88011872acc0 start 1 [1/0 us]
>>> [   56.169859] usb 2-1: usb auto-suspend, wakeup 1
>>> [   56.183306] hub 2-0:1.0: hub_suspend
>>> [   56.183323] usb usb2: bus auto-suspend, wakeup 1
>>> [   56.183327] ehci-pci 0000:00:1d.0: suspend root hub
>>> _______________________________________________
>>> Intel-gfx mailing list
>>> Intel-gfx@lists.freedesktop.org
>>> http://lists.freedesktop.org/mailman/listinfo/intel-gfx
>>
>> --
>> Jani Nikula, Intel Open Source Technology Center
