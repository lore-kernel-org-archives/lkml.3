Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaLXLLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 06:11:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbaLXLLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 06:11:22 -0500
Message-ID: <549A9F4F.4020803@redhat.com>
Date: Wed, 24 Dec 2014 12:11:11 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        luto@amacapital.net
Subject: Re: regression bisected; KVM: entry failed, hardware error 0x80000021
References: <20141221124640.GA4059@cucamonga.audible.transient.net> <5497C882.4000108@intel.com> <20141222092358.GA3915@cucamonga.audible.transient.net> <5498CA50.8070906@intel.com> <5498CB62.3070901@intel.com> <20141223072659.GA4015@cucamonga.audible.transient.net> <549A796C.50801@intel.com> <20141224110239.GA3908@cucamonga.audible.transient.net>
In-Reply-To: <20141224110239.GA3908@cucamonga.audible.transient.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/12/2014 12:02, Jamie Heilman wrote:
> Running qemu-system-x86_64 -machine pc,accel=kvm -nodefaults works,
> my real (headless) kvm guests work, but this new patch makes running
> "qemu-system-x86_64 -machine pc,accel=kvm" fail again, this time with
> errors in the host to the tune of:
> 
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 3901 at arch/x86/kvm/x86.c:6575 kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]()
> Modules linked in: nfsv4 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 fan nfsd auth_rpcgss nfs lockd grace fscache sunrpc bridge stp llc vhost_net tun vhost macvtap macvlan fuse cbc dm_crypt usb_storage snd_hda_codec_analog snd_hda_codec_generic kvm_intel kvm tg3 ptp pps_core sr_mod snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd sg dcdbas cdrom psmouse soundcore floppy evdev xfs dm_mod raid1 md_mod
> CPU: 1 PID: 3901 Comm: qemu-system-x86 Not tainted 3.19.0-rc1-00011-g53262d1-dirty #1
> Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
>  0000000000000000 000000007e052328 ffff8800c25ffcf8 ffffffff813defbe
>  0000000000000000 0000000000000000 ffff8800c25ffd38 ffffffff8103b517
>  ffff8800c25ffd28 ffffffffa019bdec ffff8800caf1d000 ffff8800c2774800
> Call Trace:
>  [<ffffffff813defbe>] dump_stack+0x4c/0x6e
>  [<ffffffff8103b517>] warn_slowpath_common+0x97/0xb1
>  [<ffffffffa019bdec>] ? kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>  [<ffffffff8103b60b>] warn_slowpath_null+0x15/0x17
>  [<ffffffffa019bdec>] kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>  [<ffffffffa02308b9>] ? vmcs_load+0x20/0x62 [kvm_intel]
>  [<ffffffffa0231e03>] ? vmx_vcpu_load+0x140/0x16a [kvm_intel]
>  [<ffffffffa0196ba3>] ? kvm_arch_vcpu_load+0x15c/0x161 [kvm]
>  [<ffffffffa018d8b1>] kvm_vcpu_ioctl+0x189/0x4bd [kvm]
>  [<ffffffff8104647a>] ? do_sigtimedwait+0x12f/0x189
>  [<ffffffff810ea316>] do_vfs_ioctl+0x370/0x436
>  [<ffffffff810f24f2>] ? __fget+0x67/0x72
>  [<ffffffff810ea41b>] SyS_ioctl+0x3f/0x5e
>  [<ffffffff813e34d2>] system_call_fastpath+0x12/0x17
> ---[ end trace 46abac932fb3b4a1 ]---
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 3901 at arch/x86/kvm/x86.c:6575 kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]()
> Modules linked in: nfsv4 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 fan nfsd auth_rpcgss nfs lockd grace fscache sunrpc bridge stp llc vhost_net tun vhost macvtap macvlan fuse cbc dm_crypt usb_storage snd_hda_codec_analog snd_hda_codec_generic kvm_intel kvm tg3 ptp pps_core sr_mod snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd sg dcdbas cdrom psmouse soundcore floppy evdev xfs dm_mod raid1 md_mod
> CPU: 1 PID: 3901 Comm: qemu-system-x86 Tainted: G        W      3.19.0-rc1-00011-g53262d1-dirty #1
> Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
>  0000000000000000 000000007e052328 ffff8800c25ffcf8 ffffffff813defbe
>  0000000000000000 0000000000000000 ffff8800c25ffd38 ffffffff8103b517
>  ffff8800c25ffd28 ffffffffa019bdec ffff8800caf1d000 ffff8800c2774800
> Call Trace:
>  [<ffffffff813defbe>] dump_stack+0x4c/0x6e
>  [<ffffffff8103b517>] warn_slowpath_common+0x97/0xb1
>  [<ffffffffa019bdec>] ? kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>  [<ffffffff8103b60b>] warn_slowpath_null+0x15/0x17
>  [<ffffffffa019bdec>] kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
>  [<ffffffffa02308b9>] ? vmcs_load+0x20/0x62 [kvm_intel]
>  [<ffffffffa0231e03>] ? vmx_vcpu_load+0x140/0x16a [kvm_intel]
>  [<ffffffffa0196ba3>] ? kvm_arch_vcpu_load+0x15c/0x161 [kvm]
>  [<ffffffffa018d8b1>] kvm_vcpu_ioctl+0x189/0x4bd [kvm]
>  [<ffffffff8104647a>] ? do_sigtimedwait+0x12f/0x189
>  [<ffffffff810ea316>] do_vfs_ioctl+0x370/0x436
>  [<ffffffff810f24f2>] ? __fget+0x67/0x72
>  [<ffffffff810ea41b>] SyS_ioctl+0x3f/0x5e
>  [<ffffffff813e34d2>] system_call_fastpath+0x12/0x17
> ---[ end trace 46abac932fb3b4a2 ]---
> 
> over and over and over ad nauseum, or until I kill the qemu command,
> it also eats a core's worth of cpu.

Yeah, I'm fairly sure that the second hunk of Tiejun's patch is not
correct, but he's on the right track.  I hope to post a fix today, else
on the 27th or 29th.

Paolo
