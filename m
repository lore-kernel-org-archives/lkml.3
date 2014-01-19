Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaASVFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 16:05:30 -0500
Received: from smtp2.Stanford.EDU ([171.67.219.82]:35879 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752037AbaASVF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 16:05:26 -0500
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Jan 2014 16:05:26 EST
Message-ID: <52DC3B94.2000408@localhost>
Date: Sun, 19 Jan 2014 12:54:44 -0800
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Nicholas Mc Guire <der.herr@hofr.at>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: nando@ccrma.Stanford.EDU, linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt@goodmis.org,
        John Kacur <jkacur@redhat.com>
Subject: Re: [ANNOUNCE] 3.12.6-rt9
References: <20131223225017.GA8623@linutronix.de> <20131227200024.GA19505@opentech.at>
In-Reply-To: <20131227200024.GA19505@opentech.at>
Content-Type: multipart/mixed;
 boundary="------------010202030707090204040907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010202030707090204040907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 12/27/2013 12:00 PM, Nicholas Mc Guire wrote:
> On Mon, 23 Dec 2013, Sebastian Andrzej Siewior wrote:
>
>> Dear RT folks!
>>
>> I'm pleased to announce the v3.12.6-rt9 patch set.
>>
>> Changes since v3.12.6-rt8
> <snip>
>> - A patch from Thomas Gleixner not to raise the timer softirq
>>    unconditionally (only if a timer is pending)
>>
>
> This one seems to deadlock early in the boot sequence on x86
> (i3/i7/Phenom-4x here and Carsten Emde also had boot failures)
>
> after droping this patch with:
> patch -p1 -R < ../paches/timers-do-not-raise-softirq-unconditionally.patch
> 3.12.6-rt9 boots up fine. cyclictest seems to be back to what it was before
> (only ran for a few minutes idle and 1h with load on an i3).

I can confirm that dropping this patch makes the kernel bootable in my 
tests (it would hang very early before, no clues left behind).

On a boot this morning I got a couple of oops (I'm attaching the 
configuration for this kernel), see below.
-- Fernando

--------
Jan 19 12:42:11 localhost kernel: [    2.721316] BUG: unable to handle 
kernel paging request at 0000000000841f0f
Jan 19 12:42:11 localhost kernel: [    2.721320] IP: 
[<ffffffff81331f3b>] __list_add+0x1b/0xc0
Jan 19 12:42:11 localhost kernel: [    2.721321] PGD 0
Jan 19 12:42:11 localhost kernel: [    2.721322] Oops: 0000 [#1] PREEMPT 
SMP
Jan 19 12:42:11 localhost kernel: [    2.721330] Modules linked in: 
snd_hda_codec_realtek lpc_ich(+) e1000e(+) mfd_core mei_me ptp mei 
pps_core snd_hda_intel(+) snd_hda_codec snd_hdsp(+) snd_rawmidi 
snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd 
soundcore shpchp firewire_ohci firewire_core nouveau crc_itu_t 
i2c_algo_bit drm_kms_helper ttm drm i2c_core mxm_wmi wmi video
Jan 19 12:42:11 localhost kernel: [    2.721332] CPU: 6 PID: 427 Comm: 
systemd-udevd Not tainted 3.12.6-300.rt9.1.fc20.ccrma.x86_64+rt #1
Jan 19 12:42:11 localhost kernel: [    2.721333] Hardware name: 
          /DZ77GA-70K, BIOS GAZ7711H.86A.0061.2012.1228.1110 12/28/2012
Jan 19 12:42:11 localhost kernel: [    2.721333] task: ffff8800372fdc80 
ti: ffff8807d57ea000 task.ti: ffff8807d57ea000
Jan 19 12:42:11 localhost kernel: [    2.721334] RIP: 
0010:[<ffffffff81331f3b>]  [<ffffffff81331f3b>] __list_add+0x1b/0xc0
Jan 19 12:42:11 localhost kernel: [    2.721335] RSP: 
0018:ffff8807d57ebd28  EFLAGS: 00010046
Jan 19 12:42:11 localhost kernel: [    2.721336] RAX: 0000000000000000 
RBX: ffff8807d57ebe30 RCX: ffffffff81353ba8
Jan 19 12:42:11 localhost kernel: [    2.721336] RDX: ffffffff81353bb0 
RSI: 0000000000841f0f RDI: ffff8807d57ebe30
Jan 19 12:42:11 localhost kernel: [    2.721337] RBP: ffff8807d57ebd40 
R08: 0000000000841f0f R09: 0000000000000000
Jan 19 12:42:11 localhost kernel: [    2.721337] R10: ffffffff81ca67c9 
R11: 0000000000000246 R12: ffffffff81353bb0
Jan 19 12:42:11 localhost kernel: [    2.721338] R13: 0000000000841f0f 
R14: ffff8807d57ebe40 R15: ffff8807d57ebe30
Jan 19 12:42:11 localhost kernel: [    2.721338] FS: 
00007fb3e891c880(0000) GS:ffff8807fe500000(0000) knlGS:0000000000000000
Jan 19 12:42:11 localhost kernel: [    2.721339] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Jan 19 12:42:11 localhost kernel: [    2.721339] CR2: 0000000000841f0f 
CR3: 00000007d50a1000 CR4: 00000000001407e0
Jan 19 12:42:11 localhost kernel: [    2.721340] Stack:
Jan 19 12:42:11 localhost kernel: [    2.721342]  ffff8807d57ebe28 
ffffffff81ca6e68 ffffffff81353bc0 ffff8807d57ebd78
Jan 19 12:42:11 localhost kernel: [    2.721343]  ffffffff8131e122 
ffffffff81ca67c8 ffff8807d57ebe18 ffff8807d57ebe00
Jan 19 12:42:11 localhost kernel: [    2.721343]  ffffffff81ca67b0 
ffff8800372fdc80 ffff8807d57ebdd8 ffffffff810db933
Jan 19 12:42:11 localhost kernel: [    2.721344] Call Trace:
Jan 19 12:42:11 localhost kernel: [    2.721347]  [<ffffffff81353bc0>] ? 
pci_dev_attrs_are_visible+0x40/0x40
Jan 19 12:42:11 localhost kernel: [    2.721349]  [<ffffffff8131e122>] 
plist_add+0x82/0xd0
Jan 19 12:42:11 localhost kernel: [    2.721352]  [<ffffffff810db933>] 
task_blocks_on_rt_mutex+0x1e3/0x260
Jan 19 12:42:11 localhost kernel: [    2.721354]  [<ffffffff8168a951>] 
rt_mutex_slowlock+0x111/0x260
Jan 19 12:42:11 localhost kernel: [    2.721356]  [<ffffffff8168ab51>] 
rt_mutex_lock+0x31/0x40
Jan 19 12:42:11 localhost kernel: [    2.721358]  [<ffffffff8168b4be>] 
_mutex_lock+0xe/0x10
Jan 19 12:42:11 localhost kernel: [    2.721360]  [<ffffffff81232f96>] 
sysfs_read_file+0x36/0x1a0
Jan 19 12:42:11 localhost kernel: [    2.721363]  [<ffffffff811bae6e>] 
vfs_read+0x9e/0x170
Jan 19 12:42:11 localhost kernel: [    2.721364]  [<ffffffff811bb999>] 
SyS_read+0x49/0xa0
Jan 19 12:42:11 localhost kernel: [    2.721366]  [<ffffffff81693529>] 
system_call_fastpath+0x16/0x1b
Jan 19 12:42:11 localhost kernel: [    2.721374] Code: 5e 41 5f 5d c3 66 
2e 0f 1f 84 00 00 00 00 00 90 55 48 89 e5 41 55 49 89 f5 41 54 49 89 d4 
53 4c 8b 42 08 48 89 fb 49 39 f0 75 2a <4d> 8b 45 00 4d 39 c4 75 68 4c 
39 e3 74 3e 4c 39 eb 74 39 49 89
Jan 19 12:42:11 localhost kernel: [    2.721375] RIP 
[<ffffffff81331f3b>] __list_add+0x1b/0xc0
Jan 19 12:42:11 localhost kernel: [    2.721375]  RSP <ffff8807d57ebd28>
Jan 19 12:42:11 localhost kernel: [    2.721375] CR2: 0000000000841f0f
Jan 19 12:42:11 localhost kernel: [    2.726383] ---[ end trace 
0000000000000002 ]---
Jan 19 12:42:11 localhost kernel: [    2.726385] note: 
systemd-udevd[427] exited with preempt_count 2
Jan 19 12:42:11 localhost kernel: [    2.726534] ------------[ cut here 
]------------
Jan 19 12:42:11 localhost kernel: [    2.726536] WARNING: CPU: 6 PID: 
427 at lib/list_debug.c:62 __list_del_entry+0x82/0xd0()
Jan 19 12:42:11 localhost kernel: [    2.726536] list_del corruption. 
next->prev should be ffffffff81ca67e0, but was ffffffff81ca67d8
Jan 19 12:42:11 localhost kernel: [    2.726541] Modules linked in: 
ac97_bus(+) snd_hda_codec_realtek lpc_ich(+) e1000e(+) mfd_core mei_me 
ptp mei pps_core snd_hda_intel(+) snd_hda_codec snd_hdsp(+) snd_rawmidi 
snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd 
soundcore shpchp firewire_ohci firewire_core nouveau crc_itu_t 
i2c_algo_bit drm_kms_helper ttm drm i2c_core mxm_wmi wmi video
Jan 19 12:42:11 localhost kernel: [    2.726542] CPU: 6 PID: 427 Comm: 
systemd-udevd Tainted: G      D 
3.12.6-300.rt9.1.fc20.ccrma.x86_64+rt #1
Jan 19 12:42:11 localhost kernel: [    2.726543] Hardware name: 
          /DZ77GA-70K, BIOS GAZ7711H.86A.0061.2012.1228.1110 12/28/2012
Jan 19 12:42:11 localhost kernel: [    2.726544]  0000000000000009 
ffff8807d57eb8a0 ffffffff8168536e ffff8807d57eb8e8
Jan 19 12:42:11 localhost kernel: [    2.726545]  ffff8807d57eb8d8 
ffffffff8106d21d ffffffff81ca67e0 ffffffff81ca6790
Jan 19 12:42:11 localhost kernel: [    2.726546]  ffff8807d866e770 
ffff8807d83aa690 ffff8807d59d2920 ffff8807d57eb938
Jan 19 12:42:11 localhost kernel: [    2.726546] Call Trace:
Jan 19 12:42:11 localhost kernel: [    2.726547]  [<ffffffff8168536e>] 
dump_stack+0x54/0x9a
Jan 19 12:42:11 localhost kernel: [    2.726549]  [<ffffffff8106d21d>] 
warn_slowpath_common+0x7d/0xc0
Jan 19 12:42:11 localhost kernel: [    2.726550]  [<ffffffff8106d2ac>] 
warn_slowpath_fmt+0x4c/0x50
Jan 19 12:42:11 localhost kernel: [    2.726551]  [<ffffffff81332062>] 
__list_del_entry+0x82/0xd0
Jan 19 12:42:11 localhost kernel: [    2.726552]  [<ffffffff813320bd>] 
list_del+0xd/0x30
Jan 19 12:42:11 localhost kernel: [    2.726553]  [<ffffffff81232bdf>] 
sysfs_release+0x3f/0xa0
Jan 19 12:42:11 localhost kernel: [    2.726554]  [<ffffffff811bc970>] 
__fput+0xd0/0x220
Jan 19 12:42:11 localhost kernel: [    2.726555]  [<ffffffff811bcb0e>] 
____fput+0xe/0x10
Jan 19 12:42:11 localhost kernel: [    2.726556]  [<ffffffff8108e514>] 
task_work_run+0xc4/0xe0
Jan 19 12:42:11 localhost kernel: [    2.726558]  [<ffffffff810700e8>] 
do_exit+0x2c8/0xae0
Jan 19 12:42:11 localhost kernel: [    2.726560]  [<ffffffff81681516>] ? 
printk+0x67/0x69
Jan 19 12:42:11 localhost kernel: [    2.726562]  [<ffffffff810c30e1>] ? 
kmsg_dump+0xc1/0xd0
Jan 19 12:42:11 localhost kernel: [    2.726563]  [<ffffffff8168ccd2>] 
oops_end+0xa2/0xe0
Jan 19 12:42:11 localhost kernel: [    2.726564]  [<ffffffff81680985>] 
no_context+0x263/0x270
Jan 19 12:42:11 localhost kernel: [    2.726565]  [<ffffffff81680a05>] 
__bad_area_nosemaphore+0x73/0x1ca
Jan 19 12:42:11 localhost kernel: [    2.726567]  [<ffffffff810ada22>] ? 
enqueue_task_fair+0x412/0x660
Jan 19 12:42:11 localhost kernel: [    2.726567]  [<ffffffff81680b6f>] 
bad_area_nosemaphore+0x13/0x15
Jan 19 12:42:11 localhost kernel: [    2.726568]  [<ffffffff8168f104>] 
__do_page_fault+0xf4/0x600
Jan 19 12:42:11 localhost kernel: [    2.726569]  [<ffffffff810aade0>] ? 
update_curr+0x70/0x1f0
Jan 19 12:42:11 localhost kernel: [    2.726570]  [<ffffffff810ab386>] ? 
dequeue_entity+0x106/0x560
Jan 19 12:42:11 localhost kernel: [    2.726571]  [<ffffffff810abbfe>] ? 
dequeue_task_fair+0x41e/0x620
Jan 19 12:42:11 localhost kernel: [    2.726572]  [<ffffffff81353bb0>] ? 
pci_dev_attrs_are_visible+0x30/0x40
Jan 19 12:42:11 localhost kernel: [    2.726573]  [<ffffffff8168f61e>] 
do_page_fault+0xe/0x10
Jan 19 12:42:11 localhost kernel: [    2.726574]  [<ffffffff8168c118>] 
page_fault+0x28/0x30
Jan 19 12:42:11 localhost kernel: [    2.726575]  [<ffffffff81353bb0>] ? 
pci_dev_attrs_are_visible+0x30/0x40
Jan 19 12:42:11 localhost kernel: [    2.726576]  [<ffffffff81353ba8>] ? 
pci_dev_attrs_are_visible+0x28/0x40
Jan 19 12:42:11 localhost kernel: [    2.726576]  [<ffffffff81353bb0>] ? 
pci_dev_attrs_are_visible+0x30/0x40
Jan 19 12:42:11 localhost kernel: [    2.726577]  [<ffffffff81331f3b>] ? 
__list_add+0x1b/0xc0
Jan 19 12:42:11 localhost kernel: [    2.726578]  [<ffffffff81353bc0>] ? 
pci_dev_attrs_are_visible+0x40/0x40
Jan 19 12:42:11 localhost kernel: [    2.726580]  [<ffffffff8131e122>] 
plist_add+0x82/0xd0
Jan 19 12:42:11 localhost kernel: [    2.726581]  [<ffffffff810db933>] 
task_blocks_on_rt_mutex+0x1e3/0x260
Jan 19 12:42:11 localhost kernel: [    2.726583]  [<ffffffff8168a951>] 
rt_mutex_slowlock+0x111/0x260
Jan 19 12:42:11 localhost kernel: [    2.726584]  [<ffffffff8168ab51>] 
rt_mutex_lock+0x31/0x40
Jan 19 12:42:11 localhost kernel: [    2.726586]  [<ffffffff8168b4be>] 
_mutex_lock+0xe/0x10
Jan 19 12:42:11 localhost kernel: [    2.726586]  [<ffffffff81232f96>] 
sysfs_read_file+0x36/0x1a0
Jan 19 12:42:11 localhost kernel: [    2.726588]  [<ffffffff811bae6e>] 
vfs_read+0x9e/0x170
Jan 19 12:42:11 localhost kernel: [    2.726589]  [<ffffffff811bb999>] 
SyS_read+0x49/0xa0
Jan 19 12:42:11 localhost kernel: [    2.726590]  [<ffffffff81693529>] 
system_call_fastpath+0x16/0x1b
Jan 19 12:42:11 localhost kernel: [    2.726591] ---[ end trace 
0000000000000003 ]---
Jan 19 12:42:11 localhost kernel: [    2.726594] ------------[ cut here 
]------------
Jan 19 12:42:11 localhost kernel: [    2.726594] kernel BUG at 
mm/slub.c:3398!
Jan 19 12:42:11 localhost kernel: [    2.726595] invalid opcode: 0000 
[#2] PREEMPT SMP
Jan 19 12:42:11 localhost kernel: [    2.726599] Modules linked in: 
ac97_bus(+) snd_hda_codec_realtek lpc_ich(+) e1000e(+) mfd_core mei_me 
ptp mei pps_core snd_hda_intel(+) snd_hda_codec snd_hdsp(+) snd_rawmidi 
snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd 
soundcore shpchp firewire_ohci firewire_core nouveau crc_itu_t 
i2c_algo_bit drm_kms_helper ttm drm i2c_core mxm_wmi wmi video
Jan 19 12:42:11 localhost kernel: [    2.726600] CPU: 6 PID: 427 Comm: 
systemd-udevd Tainted: G      D W 
3.12.6-300.rt9.1.fc20.ccrma.x86_64+rt #1
Jan 19 12:42:11 localhost kernel: [    2.726600] Hardware name: 
          /DZ77GA-70K, BIOS GAZ7711H.86A.0061.2012.1228.1110 12/28/2012
Jan 19 12:42:11 localhost kernel: [    2.726600] task: ffff8800372fdc80 
ti: ffff8807d57ea000 task.ti: ffff8807d57ea000
Jan 19 12:42:11 localhost kernel: [    2.726602] RIP: 
0010:[<ffffffff811a4237>]  [<ffffffff811a4237>] kfree+0x1f7/0x200
Jan 19 12:42:11 localhost kernel: [    2.726603] RSP: 
0018:ffff8807d57eb928  EFLAGS: 00010046
Jan 19 12:42:11 localhost kernel: [    2.726603] RAX: 003ff00000000400 
RBX: ffffffff81ca6790 RCX: 0000000000000000
Jan 19 12:42:11 localhost kernel: [    2.726604] RDX: 0000000000000000 
RSI: 0000000000000000 RDI: ffffffff81ca6790
Jan 19 12:42:11 localhost kernel: [    2.726604] RBP: ffff8807d57eb960 
R08: ffffffff81f3dd9c R09: ffffffff81f558b0
Jan 19 12:42:11 localhost kernel: [    2.726605] R10: 0000000000028520 
R11: 0000000000040000 R12: ffffffff81ca6790
Jan 19 12:42:11 localhost kernel: [    2.726606] R13: ffffea0000072980 
R14: ffff8807d83aa690 R15: ffff8807d59d2920
Jan 19 12:42:11 localhost kernel: [    2.726606] FS: 
0000000000000000(0000) GS:ffff8807fe500000(0000) knlGS:0000000000000000
Jan 19 12:42:11 localhost kernel: [    2.726607] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Jan 19 12:42:11 localhost kernel: [    2.726607] CR2: 0000000000841f0f 
CR3: 0000000001c0f000 CR4: 00000000001407e0
Jan 19 12:42:11 localhost kernel: [    2.726607] Stack:
Jan 19 12:42:11 localhost kernel: [    2.726608]  ffffffff81ca67d8 
0000000000000000 ffffffff81ca6790 ffffffff81ca6790
Jan 19 12:42:11 localhost kernel: [    2.726609]  ffff8807d866e770 
ffff8807d83aa690 ffff8807d59d2920 ffff8807d57eb988
Jan 19 12:42:11 localhost kernel: [    2.726610]  ffffffff81232c0a 
ffff8807d61d5180 0000000000000010 ffff8807d83ad600
Jan 19 12:42:11 localhost kernel: [    2.726610] Call Trace:
Jan 19 12:42:11 localhost kernel: [    2.726611]  [<ffffffff81232c0a>] 
sysfs_release+0x6a/0xa0
Jan 19 12:42:11 localhost kernel: [    2.726611]  [<ffffffff811bc970>] 
__fput+0xd0/0x220
Jan 19 12:42:11 localhost kernel: [    2.726612]  [<ffffffff811bcb0e>] 
____fput+0xe/0x10
Jan 19 12:42:11 localhost kernel: [    2.726613]  [<ffffffff8108e514>] 
task_work_run+0xc4/0xe0
Jan 19 12:42:11 localhost kernel: [    2.726614]  [<ffffffff810700e8>] 
do_exit+0x2c8/0xae0
Jan 19 12:42:11 localhost kernel: [    2.726615]  [<ffffffff81681516>] ? 
printk+0x67/0x69
Jan 19 12:42:11 localhost kernel: [    2.726616]  [<ffffffff810c30e1>] ? 
kmsg_dump+0xc1/0xd0
Jan 19 12:42:11 localhost kernel: [    2.726617]  [<ffffffff8168ccd2>] 
oops_end+0xa2/0xe0
Jan 19 12:42:11 localhost kernel: [    2.726617]  [<ffffffff81680985>] 
no_context+0x263/0x270
Jan 19 12:42:11 localhost kernel: [    2.726618]  [<ffffffff81680a05>] 
__bad_area_nosemaphore+0x73/0x1ca
Jan 19 12:42:11 localhost kernel: [    2.726619]  [<ffffffff810ada22>] ? 
enqueue_task_fair+0x412/0x660
Jan 19 12:42:11 localhost kernel: [    2.726620]  [<ffffffff81680b6f>] 
bad_area_nosemaphore+0x13/0x15
Jan 19 12:42:11 localhost kernel: [    2.726621]  [<ffffffff8168f104>] 
__do_page_fault+0xf4/0x600
Jan 19 12:42:11 localhost kernel: [    2.726621]  [<ffffffff810aade0>] ? 
update_curr+0x70/0x1f0
Jan 19 12:42:11 localhost kernel: [    2.726622]  [<ffffffff810ab386>] ? 
dequeue_entity+0x106/0x560
Jan 19 12:42:11 localhost kernel: [    2.726623]  [<ffffffff810abbfe>] ? 
dequeue_task_fair+0x41e/0x620
Jan 19 12:42:11 localhost kernel: [    2.726625]  [<ffffffff81353bb0>] ? 
pci_dev_attrs_are_visible+0x30/0x40
Jan 19 12:42:11 localhost kernel: [    2.726626]  [<ffffffff8168f61e>] 
do_page_fault+0xe/0x10
Jan 19 12:42:11 localhost kernel: [    2.726627]  [<ffffffff8168c118>] 
page_fault+0x28/0x30
Jan 19 12:42:11 localhost kernel: [    2.726628]  [<ffffffff81353bb0>] ? 
pci_dev_attrs_are_visible+0x30/0x40
Jan 19 12:42:11 localhost kernel: [    2.726629]  [<ffffffff81353ba8>] ? 
pci_dev_attrs_are_visible+0x28/0x40
Jan 19 12:42:11 localhost kernel: [    2.726630]  [<ffffffff81353bb0>] ? 
pci_dev_attrs_are_visible+0x30/0x40
Jan 19 12:42:11 localhost kernel: [    2.726631]  [<ffffffff81331f3b>] ? 
__list_add+0x1b/0xc0
Jan 19 12:42:11 localhost kernel: [    2.726632]  [<ffffffff81353bc0>] ? 
pci_dev_attrs_are_visible+0x40/0x40
Jan 19 12:42:11 localhost kernel: [    2.726633]  [<ffffffff8131e122>] 
plist_add+0x82/0xd0
Jan 19 12:42:11 localhost kernel: [    2.726634]  [<ffffffff810db933>] 
task_blocks_on_rt_mutex+0x1e3/0x260
Jan 19 12:42:11 localhost kernel: [    2.726635]  [<ffffffff8168a951>] 
rt_mutex_slowlock+0x111/0x260
Jan 19 12:42:11 localhost kernel: [    2.726637]  [<ffffffff8168ab51>] 
rt_mutex_lock+0x31/0x40
Jan 19 12:42:11 localhost kernel: [    2.726638]  [<ffffffff8168b4be>] 
_mutex_lock+0xe/0x10
Jan 19 12:42:11 localhost kernel: [    2.726638]  [<ffffffff81232f96>] 
sysfs_read_file+0x36/0x1a0
Jan 19 12:42:11 localhost kernel: [    2.726640]  [<ffffffff811bae6e>] 
vfs_read+0x9e/0x170
Jan 19 12:42:11 localhost kernel: [    2.726641]  [<ffffffff811bb999>] 
SyS_read+0x49/0xa0
Jan 19 12:42:11 localhost kernel: [    2.726642]  [<ffffffff81693529>] 
system_call_fastpath+0x16/0x1b
Jan 19 12:42:11 localhost kernel: [    2.726648] Code: 00 c0 00 00 74 25 
49 8b 45 00 31 f6 f6 c4 40 74 04 41 8b 75 68 4c 89 ef e8 37 4c fb ff e9 
14 ff ff ff 4d 8b 6d 30 e9 74 fe ff ff <0f> 0b 0f 1f 80 00 00 00 00 0f 
1f 44 00 00 55 48 89 e5 41 57 41
Jan 19 12:42:11 localhost kernel: [    2.726649] RIP 
[<ffffffff811a4237>] kfree+0x1f7/0x200
Jan 19 12:42:11 localhost kernel: [    2.726650]  RSP <ffff8807d57eb928>
Jan 19 12:42:11 localhost kernel: [    2.736576] usb 3-1.2: new 
low-speed USB device number 4 using xhci_hcd
Jan 19 12:42:11 localhost kernel: [    2.752839] usb 3-1.2: New USB 
device found, idVendor=046d, idProduct=c00e
Jan 19 12:42:11 localhost kernel: [    2.752841] usb 3-1.2: New USB 
device strings: Mfr=1, Product=2, SerialNumber=0
Jan 19 12:42:11 localhost kernel: [    2.752842] usb 3-1.2: Product: 
USB-PS/2 Optical Mouse
Jan 19 12:42:11 localhost kernel: [    2.752843] usb 3-1.2: 
Manufacturer: Logitech
Jan 19 12:42:11 localhost kernel: [    2.785648] ---[ end trace 
0000000000000004 ]---
Jan 19 12:42:11 localhost kernel: [    2.785649] Fixing recursive fault 
but reboot is needed!
Jan 19 12:42:11 localhost kernel: [    2.785650] BUG: unable to handle 
kernel paging request at 0000000100000010
Jan 19 12:42:11 localhost kernel: [    2.785653] IP: 
[<ffffffff8134734c>] pinctrl_get+0x4c/0x470
Jan 19 12:42:11 localhost kernel: [    2.785654] PGD 0
Jan 19 12:42:11 localhost kernel: [    2.785654] Oops: 0000 [#3] PREEMPT 
SMP
Jan 19 12:42:11 localhost kernel: [    2.785663] Modules linked in: 
ac97_bus(+) snd_hda_codec_realtek lpc_ich(+) e1000e(+) mfd_core mei_me 
ptp mei pps_core snd_hda_intel(+) snd_hda_codec snd_hdsp(+) snd_rawmidi 
snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd 
soundcore shpchp firewire_ohci firewire_core nouveau crc_itu_t 
i2c_algo_bit drm_kms_helper ttm drm i2c_core mxm_wmi wmi video
Jan 19 12:42:11 localhost kernel: [    2.785664] CPU: 4 PID: 75 Comm: 
khubd Tainted: G      D W    3.12.6-300.rt9.1.fc20.ccrma.x86_64+rt #1
Jan 19 12:42:11 localhost kernel: [    2.785664] Hardware name: 
          /DZ77GA-70K, BIOS GAZ7711H.86A.0061.2012.1228.1110 12/28/2012
Jan 19 12:42:11 localhost kernel: [    2.785665] task: ffff8807d84b5340 
ti: ffff8807d86ce000 task.ti: ffff8807d86ce000
Jan 19 12:42:11 localhost kernel: [    2.785666] RIP: 
0010:[<ffffffff8134734c>]  [<ffffffff8134734c>] pinctrl_get+0x4c/0x470
Jan 19 12:42:11 localhost kernel: [    2.785667] RSP: 
0018:ffff8807d86cfb98  EFLAGS: 00010203
Jan 19 12:42:11 localhost kernel: [    2.785667] RAX: 0000000000000000 
RBX: 0000000100000000 RCX: 0000000000000000
Jan 19 12:42:11 localhost kernel: [    2.785668] RDX: ffff8807d84b5340 
RSI: 0000000000000000 RDI: ffffffff81ca6840
Jan 19 12:42:11 localhost kernel: [    2.785668] RBP: ffff8807d86cfbe0 
R08: 00000000000664e0 R09: ffff8807cd8ca1c0
Jan 19 12:42:11 localhost kernel: [    2.785669] R10: ffff8807fdc03b00 
R11: 0000000000000000 R12: ffff8807d5260088
Jan 19 12:42:11 localhost kernel: [    2.785669] R13: ffff8807d5260088 
R14: ffff8807d5260088 R15: ffff8807d5a3a800
Jan 19 12:42:11 localhost kernel: [    2.785670] FS: 
0000000000000000(0000) GS:ffff8807fe400000(0000) knlGS:0000000000000000
Jan 19 12:42:11 localhost kernel: [    2.785670] CS:  0010 DS: 0000 ES: 
0000 CR0: 0000000080050033
Jan 19 12:42:11 localhost kernel: [    2.785671] CR2: 0000000100000010 
CR3: 00000000df05b000 CR4: 00000000001407e0
Jan 19 12:42:11 localhost kernel: [    2.785671] Stack:
Jan 19 12:42:11 localhost kernel: [    2.785673]  ffffffff81a6afa4 
ffffffff813471c0 ffff8807d86cfbe0 ffffffff8141bc13
Jan 19 12:42:11 localhost kernel: [    2.785674]  ffff8807cd8ca1e8 
ffff8807d46d2e08 ffff8807d5260088 ffff8807d5260088
Jan 19 12:42:11 localhost kernel: [    2.785674]  ffff8807d5a3a800 
ffff8807d86cfc08 ffffffff813477b5 ffff8807d5260088
Jan 19 12:42:11 localhost kernel: [    2.785675] Call Trace:
Jan 19 12:42:11 localhost kernel: [    2.785676]  [<ffffffff813471c0>] ? 
pinctrl_put+0x30/0x30
Jan 19 12:42:11 localhost kernel: [    2.785678]  [<ffffffff8141bc13>] ? 
__devres_alloc+0x43/0x70
Jan 19 12:42:11 localhost kernel: [    2.785679]  [<ffffffff813477b5>] 
devm_pinctrl_get+0x45/0x80
Jan 19 12:42:11 localhost kernel: [    2.785681]  [<ffffffff8143205b>] 
pinctrl_bind_pins+0x3b/0x220
Jan 19 12:42:11 localhost kernel: [    2.785682]  [<ffffffff814189ba>] 
driver_probe_device+0x6a/0x3a0
Jan 19 12:42:11 localhost kernel: [    2.785684]  [<ffffffff81418cf0>] ? 
driver_probe_device+0x3a0/0x3a0
Jan 19 12:42:11 localhost kernel: [    2.785685]  [<ffffffff81418d2b>] 
__device_attach+0x3b/0x40
Jan 19 12:42:11 localhost kernel: [    2.785686]  [<ffffffff81416893>] 
bus_for_each_drv+0x63/0xa0
Jan 19 12:42:11 localhost kernel: [    2.785687]  [<ffffffff814188d8>] 
device_attach+0x88/0xa0
Jan 19 12:42:11 localhost kernel: [    2.785688]  [<ffffffff81417bd8>] 
bus_probe_device+0xa8/0xd0
Jan 19 12:42:11 localhost kernel: [    2.785689]  [<ffffffff81415794>] 
device_add+0x4c4/0x7a0
Jan 19 12:42:11 localhost kernel: [    2.785691]  [<ffffffff8148b000>] 
usb_new_device+0x220/0x3b0
Jan 19 12:42:11 localhost kernel: [    2.785692]  [<ffffffff8148dd08>] 
hub_thread+0x8b8/0x1710
Jan 19 12:42:11 localhost kernel: [    2.785695]  [<ffffffff81092b30>] ? 
wake_up_atomic_t+0x30/0x30
Jan 19 12:42:11 localhost kernel: [    2.785696]  [<ffffffff8148d450>] ? 
usb_reset_device+0x1d0/0x1d0
Jan 19 12:42:11 localhost kernel: [    2.785697]  [<ffffffff81091f52>] 
kthread+0xb2/0xc0
Jan 19 12:42:11 localhost kernel: [    2.785698]  [<ffffffff81091ea0>] ? 
kthread_worker_fn+0x180/0x180
Jan 19 12:42:11 localhost kernel: [    2.785700]  [<ffffffff8169347c>] 
ret_from_fork+0x7c/0xb0
Jan 19 12:42:11 localhost kernel: [    2.785701]  [<ffffffff81091ea0>] ? 
kthread_worker_fn+0x180/0x180
Jan 19 12:42:11 localhost kernel: [    2.785708] Code: 00 48 c7 c7 40 68 
ca 81 e8 82 41 34 00 48 8b 1d 5b f4 95 00 48 81 fb 90 67 ca 81 75 0e eb 
60 48 8b 1b 48 81 fb 90 67 ca 81 74 54 <4c> 3b 63 10 75 ee 48 c7 c7 40 
68 ca 81 e8 b2 41 34 00 48 85 db
Jan 19 12:42:11 localhost kernel: [    2.785709] RIP 
[<ffffffff8134734c>] pinctrl_get+0x4c/0x470
Jan 19 12:42:11 localhost kernel: [    2.785709]  RSP <ffff8807d86cfb98>
Jan 19 12:42:11 localhost kernel: [    2.785709] CR2: 0000000100000010
Jan 19 12:42:11 localhost kernel: [    2.820180] ---[ end trace 
0000000000000005 ]---


--------------010202030707090204040907
Content-Type: application/x-bzip;
 name="config-3.12.6-300.rt9.1.fc20.ccrma.x86_64+rt.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="config-3.12.6-300.rt9.1.fc20.ccrma.x86_64+rt.bz2"

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
+LuSKcKEhFZw4gA=
--------------010202030707090204040907--
