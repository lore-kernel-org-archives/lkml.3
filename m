Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab3E3XX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 19:23:26 -0400
Received: from mail.candelatech.com ([208.74.158.172]:33723 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab3E3XXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 19:23:18 -0400
Message-ID: <51A7DF65.4020900@candelatech.com>
Date: Thu, 30 May 2013 16:23:17 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Question on mod_sysfs_init and kobject_put in error handling
 code.
References: <51A7AAE7.6020201@candelatech.com>
In-Reply-To: <51A7AAE7.6020201@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2013 12:39 PM, Ben Greear wrote:
> I'm seeing a crash (on hacked 3.9.3+ kernels).  It's rare, but in a kernel
> larded down with debugging, we are having some luck reproducing it.
>
> Please note, this kernel is running a fair amount of my patches, so it could
> be my bug.  We did not see this before 3.9.3, as far as we know..but I have not
> tried bisecting this yet.
>
> The crash happens on startup, and I see this splat or similar:

I was able to reproduce something similar on a stock 3.9.4 kernel,
so I'll start trying to bisect the problem...

Ben

>
>
> microcode: CPU3 sig=0x20652, pf=0x10, revision=0x9
> microcode: CPU3 updated to revision 0xd, date = 2011-09-01
> microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
> e1000e 0000:01:00.0 eth0: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
> kvm: disabled by bios
> ieee80211 phy0: Atheros AR9300 Rev:3 mem=0xffffc90023a40000, irq=18
> kvm_intel: module is already loaded
> BUG: unable to handle kernel paging request at ffffffffa08e8700
> IP: [<ffffffff813018e3>] kset_find_obj+0x23/0x7a
> PGD 1a0f067 PUD 1a10063 PMD 21e9ae067 PTE 0
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: acpi_cpufreq(+) kvm_intel(+) mperf intel_powerclamp kvm cdc_acm microcode serio_raw pcspkr snd_hda_codec_realtek ath9k(+) ath9k_common
> ath9k_hw ath e1000e ptp snd_hda_intel mac80211 snd_hda_codec snd_hwdep snd_seq i2c_i801 snd_seq_device lpc_ich pps_core cfg80211 snd_pcm snd_page_alloc
> snd_timer snd soundcore parport_pc parport uinput ipv6 i915 video i2c_algo_bit drm_kms_helper drm i2c_core
> CPU 0
> Pid: 498, comm: udevd Not tainted 3.9.4+ #3 To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M.
> RIP: 0010:[<ffffffff813018e3>]  [<ffffffff813018e3>] kset_find_obj+0x23/0x7a
> RSP: 0018:ffff88021f145d68  EFLAGS: 00010293
> RAX: ffffffffa08e8708 RBX: ffffffffa08e8700 RCX: 000000000000908f
> RDX: 0000000000008f61 RSI: ffffffffa0958029 RDI: ffff88021527a691
> RBP: ffff88021f145d88 R08: 0000000000000000 R09: ffff88021f145c78
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880221cd8410
> R13: ffff880221cd8420 R14: ffffffffa0958028 R15: ffffffffa0958028
> FS:  00007fa594c7f840(0000) GS:ffff88022bc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffa08e8700 CR3: 00000002150a0000 CR4: 00000000000007f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process udevd (pid: 498, threadinfo ffff88021f144000, task ffff880215550000)
> Stack:
>   ffffffffa0958010 ffff88021f145ef8 0000000000000000 ffffffffa0958028
>   ffff88021f145df8 ffffffff810f2e06 ffffffff81a51430 0000000000000246
>   0000000180007fff ffffffffa09575e8 ffff880200000001 ffffffffa09575e8
> Call Trace:
>   [<ffffffff810f2e06>] mod_sysfs_setup+0x52/0x522
>   [<ffffffff810f46be>] load_module+0x13e8/0x15cc
>   [<ffffffff8131dd69>] ? ddebug_dyndbg_boot_param_cb+0x45/0x45
>   [<ffffffff810f4a52>] sys_init_module+0xfd/0x103
>   [<ffffffff815f13d9>] system_call_fastpath+0x16/0x1b
> Code: ff 9d e8 ff 5e 5b c9 c3 55 48 89 e5 41 56 49 89 f6 41 55 4c 8d 6f 10 41 54 49 89 fc 4c 89 ef 53 e8 af 88 2e 00 49 8b 1c 24 eb 34 <48> 8b 3b 48 85 ff 74 28
> 4c 89 f6 e8 1f 55 00 00 85 c0 75 1c 8b
> RIP  [<ffffffff813018e3>] kset_find_obj+0x23/0x7a
>   RSP <ffff88021f145d68>
> CR2: ffffffffa08e8700
> ---[ end trace cc75890eca7ff0aa ]---
>
>
> While poking around the code, I wonder if the kobject put is correct below?
>
> In both cases I've reproduced I see the error about 'module is already loaded'
> printed in the logs right before the crash.  It was a different module name each time.
>
> The kset_find_obj plays some tricks where it only grabs a reference
> sometimes...maybe the kobject_put needs some similar conditions?
>
>
> static int mod_sysfs_init(struct module *mod)
> {
>      int err;
>      struct kobject *kobj;
>
>      if (!module_sysfs_initialized) {
>          printk(KERN_ERR "%s: module sysfs not initialized\n",
>                 mod->name);
>          err = -EINVAL;
>          goto out;
>      }
>
>      kobj = kset_find_obj(module_kset, mod->name);
>      if (kobj) {
>          printk(KERN_ERR "%s: module is already loaded\n", mod->name);
>          kobject_put(kobj);
>          err = -EINVAL;
>          goto out;
>      }
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

