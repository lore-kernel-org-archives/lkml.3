Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbaLYH4P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 02:56:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:15909 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaLYH4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 02:56:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="433233131"
Message-ID: <549BC31A.3070103@intel.com>
Date: Thu, 25 Dec 2014 15:56:10 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        luto@amacapital.net, jamie@audible.transient.net
Subject: Re: regression bisected; KVM: entry failed, hardware error 0x80000021
References: <20141221124640.GA4059@cucamonga.audible.transient.net> <5497C882.4000108@intel.com> <20141222092358.GA3915@cucamonga.audible.transient.net> <5498CA50.8070906@intel.com> <5498CB62.3070901@intel.com> <20141223072659.GA4015@cucamonga.audible.transient.net> <549A796C.50801@intel.com> <20141224110239.GA3908@cucamonga.audible.transient.net> <549A9F4F.4020803@redhat.com>
In-Reply-To: <549A9F4F.4020803@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/24 19:11, Paolo Bonzini wrote:
>
>
> On 24/12/2014 12:02, Jamie Heilman wrote:
>> Running qemu-system-x86_64 -machine pc,accel=kvm -nodefaults works,
>> my real (headless) kvm guests work, but this new patch makes running
>> "qemu-system-x86_64 -machine pc,accel=kvm" fail again, this time with
>> errors in the host to the tune of:
>>
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 3901 at arch/x86/kvm/x86.c:6575 kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]()
>> Modules linked in: nfsv4 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 fan nfsd auth_rpcgss nfs lockd grace fscache sunrpc bridge stp llc vhost_net tun vhost macvtap macvlan fuse cbc dm_crypt usb_storage snd_hda_codec_analog snd_hda_codec_generic kvm_intel kvm tg3 ptp pps_core sr_mod snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd sg dcdbas cdrom psmouse soundcore floppy evdev xfs dm_mod raid1 md_mod
>> CPU: 1 PID: 3901 Comm: qemu-system-x86 Not tainted 3.19.0-rc1-00011-g53262d1-dirty #1
>> Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
>>   0000000000000000 000000007e052328 ffff8800c25ffcf8 ffffffff813defbe
>>   0000000000000000 0000000000000000 ffff8800c25ffd38 ffffffff8103b517
>>   ffff8800c25ffd28 ffffffffa019bdec ffff8800caf1d000 ffff8800c2774800
>> Call Trace:
>>   [<ffffffff813defbe>] dump_stack+0x4c/0x6e
>>   [<ffffffff8103b517>] warn_slowpath_common+0x97/0xb1
>>   [<ffffffffa019bdec>] ? kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>>   [<ffffffff8103b60b>] warn_slowpath_null+0x15/0x17
>>   [<ffffffffa019bdec>] kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>>   [<ffffffffa02308b9>] ? vmcs_load+0x20/0x62 [kvm_intel]
>>   [<ffffffffa0231e03>] ? vmx_vcpu_load+0x140/0x16a [kvm_intel]
>>   [<ffffffffa0196ba3>] ? kvm_arch_vcpu_load+0x15c/0x161 [kvm]
>>   [<ffffffffa018d8b1>] kvm_vcpu_ioctl+0x189/0x4bd [kvm]
>>   [<ffffffff8104647a>] ? do_sigtimedwait+0x12f/0x189
>>   [<ffffffff810ea316>] do_vfs_ioctl+0x370/0x436
>>   [<ffffffff810f24f2>] ? __fget+0x67/0x72
>>   [<ffffffff810ea41b>] SyS_ioctl+0x3f/0x5e
>>   [<ffffffff813e34d2>] system_call_fastpath+0x12/0x17
>> ---[ end trace 46abac932fb3b4a1 ]---
>> ------------[ cut here ]------------
>> WARNING: CPU: 1 PID: 3901 at arch/x86/kvm/x86.c:6575 kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]()
>> Modules linked in: nfsv4 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 fan nfsd auth_rpcgss nfs lockd grace fscache sunrpc bridge stp llc vhost_net tun vhost macvtap macvlan fuse cbc dm_crypt usb_storage snd_hda_codec_analog snd_hda_codec_generic kvm_intel kvm tg3 ptp pps_core sr_mod snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd sg dcdbas cdrom psmouse soundcore floppy evdev xfs dm_mod raid1 md_mod
>> CPU: 1 PID: 3901 Comm: qemu-system-x86 Tainted: G        W      3.19.0-rc1-00011-g53262d1-dirty #1
>> Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
>>   0000000000000000 000000007e052328 ffff8800c25ffcf8 ffffffff813defbe
>>   0000000000000000 0000000000000000 ffff8800c25ffd38 ffffffff8103b517
>>   ffff8800c25ffd28 ffffffffa019bdec ffff8800caf1d000 ffff8800c2774800
>> Call Trace:
>>   [<ffffffff813defbe>] dump_stack+0x4c/0x6e
>>   [<ffffffff8103b517>] warn_slowpath_common+0x97/0xb1
>>   [<ffffffffa019bdec>] ? kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>>   [<ffffffff8103b60b>] warn_slowpath_null+0x15/0x17
>>   [<ffffffffa019bdec>] kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>>   [<ffffffffa02308b9>] ? vmcs_load+0x20/0x62 [kvm_intel]
>>   [<ffffffffa0231e03>] ? vmx_vcpu_load+0x140/0x16a [kvm_intel]
>>   [<ffffffffa0196ba3>] ? kvm_arch_vcpu_load+0x15c/0x161 [kvm]
>>   [<ffffffffa018d8b1>] kvm_vcpu_ioctl+0x189/0x4bd [kvm]
>>   [<ffffffff8104647a>] ? do_sigtimedwait+0x12f/0x189
>>   [<ffffffff810ea316>] do_vfs_ioctl+0x370/0x436
>>   [<ffffffff810f24f2>] ? __fget+0x67/0x72
>>   [<ffffffff810ea41b>] SyS_ioctl+0x3f/0x5e
>>   [<ffffffff813e34d2>] system_call_fastpath+0x12/0x17
>> ---[ end trace 46abac932fb3b4a2 ]---
>>
>> over and over and over ad nauseum, or until I kill the qemu command,
>> it also eats a core's worth of cpu.

Such a message above seems to be out of our mem_slot issue, I'm not 100% 
sure but actually I can run this case,

qemu-system-x86_64 -machine pc,accel=kvm -m 2048 -smp 2 -hda ubuntu.img

Just one patch, "kvm: x86: vmx: reorder some msr writing", is needed 
here. So I guess you guy can try to pull your 3.19-rc1 + that patch, and 
also pull qemu.

>
> Yeah, I'm fairly sure that the second hunk of Tiejun's patch is not
> correct, but he's on the right track.  I hope to post a fix today, else

Yeah, looks that will broken !next case then I regenerate that again 
post into another email. Now at lease I myself can run Andy's next case 
and a normal case, "qemu-system-x86_64 -machine pc,accel=kvm", at the 
same time. But if I'm missing something please correct me directly :)

Tiejun
