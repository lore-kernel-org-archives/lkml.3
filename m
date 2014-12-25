Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaLYKwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 05:52:20 -0500
Received: from audible.transient.net ([24.143.126.66]:46535 "HELO
	audible.transient.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751968AbaLYKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 05:52:16 -0500
Date: Thu, 25 Dec 2014 10:52:14 +0000
From: Jamie Heilman <jamie@audible.transient.net>
To: "Chen, Tiejun" <tiejun.chen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        luto@amacapital.net
Subject: Re: regression bisected; KVM: entry failed, hardware error 0x80000021
Message-ID: <20141225105214.GA4440@cucamonga.audible.transient.net>
Mail-Followup-To: "Chen, Tiejun" <tiejun.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>, kvm list <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	luto@amacapital.net
References: <20141221124640.GA4059@cucamonga.audible.transient.net>
 <5497C882.4000108@intel.com>
 <20141222092358.GA3915@cucamonga.audible.transient.net>
 <5498CA50.8070906@intel.com>
 <5498CB62.3070901@intel.com>
 <20141223072659.GA4015@cucamonga.audible.transient.net>
 <549A796C.50801@intel.com>
 <20141224110239.GA3908@cucamonga.audible.transient.net>
 <549BC0D9.6040801@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <549BC0D9.6040801@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen, Tiejun wrote:
> On 2014/12/24 19:02, Jamie Heilman wrote:
> >Chen, Tiejun wrote:
> >>On 2014/12/23 15:26, Jamie Heilman wrote:
> >>>Chen, Tiejun wrote:
> >>>>On 2014/12/23 9:50, Chen, Tiejun wrote:
> >>>>>On 2014/12/22 17:23, Jamie Heilman wrote:
> >>>>>>KVM internal error. Suberror: 1
> >>>>>>emulation failure
> >>>>>>EAX=000de494 EBX=00000000 ECX=00000000 EDX=00000cfd
> >>>>>>ESI=00000059 EDI=00000000 EBP=00000000 ESP=00006fb4
> >>>>>>EIP=000f15c1 EFL=00010016 [----AP-] CPL=0 II=0 A20=1 SMM=0 HLT=0
> >>>>>>ES =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> >>>>>>CS =0008 00000000 ffffffff 00c09b00 DPL=0 CS32 [-RA]
> >>>>>>SS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> >>>>>>DS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> >>>>>>FS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> >>>>>>GS =0010 00000000 ffffffff 00c09300 DPL=0 DS   [-WA]
> >>>>>>LDT=0000 00000000 0000ffff 00008200 DPL=0 LDT
> >>>>>>TR =0000 00000000 0000ffff 00008b00 DPL=0 TSS32-busy
> >>>>>>GDT=     000f6be8 00000037
> >>>>>>IDT=     000f6c26 00000000
> >>>>>>CR0=60000011 CR2=00000000 CR3=00000000 CR4=00000000
> >>>>>>DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
> >>>>>>DR3=0000000000000000
> >>>>>>DR6=00000000ffff0ff0 DR7=0000000000000400
> >>>>>>EFER=0000000000000000
> >>>>>>Code=e8 ae fc ff ff 89 f2 a8 10 89 d8 75 0a b9 41 15 ff ff ff d1 <5b>
> >>>>>>5e c3 5b 5e e9 76 ff ff ff b0 11 e6 20 e6 a0 b0 08 e6 21 b0 70 e6 a1
> >>>>>>b0 04 e6 21 b0 02
> >>>>>>
> >>>>>>FWIW, I get the same thing with 34a1cd60d17 reverted.  Maybe there are
> >>>>>>two bugs, maybe there's more to this first one.  I can repro this
> >>>>>
> >>>>>So if my understanding is correct, this is probably another bug. And
> >>>>>especially, I already saw the same log in another thread, "Cleaning up
> >>>>>the KVM clock". Maybe you can continue to `git bisect` to locate that
> >>>>>bad commit.
> >>>>>
> >>>>
> >>>>Looks just now Andy found that commit,
> >>>>0e60b0799fedc495a5c57dbd669de3c10d72edd2 "kvm: change memslot sorting rule
> >>>>from size to GFN", maybe you can try to revert this to try yours again.
> >>>
> >>>That doesn't revert cleanly for me, and I don't have much time to
> >>>fiddle with it until the 24th---so checked out the commit before it
> >>>(d4ae84a0), applied your patch, built, and yes, everything works fine
> >>>at that point.  I'll probably have time for another full bisection
> >>>later, assuming things aren't ironed out already by then.
> >
> >3.18.0-rc3-00120-gd4ae84a0 + vmx reorder msr writes patch = OK
> >3.18.0-rc3-00121-g0e60b07 + vmx reorder msr writes patch = emulation failure
> >
> >So that certainly points to 0e60b0799fedc495a5c57dbd669de3c10d72edd2
> >as well.
> >
> >>Could you try this to fix your last error?
> >
> >Running qemu-system-x86_64 -machine pc,accel=kvm -nodefaults works,
> >my real (headless) kvm guests work, but this new patch makes running
> >"qemu-system-x86_64 -machine pc,accel=kvm" fail again, this time with
> 
> Are you sure? From my test based on 3.19-rc1 that it owns top commit,
> 
> aa39477b5692611b91ac9455ae588738852b3f60
> 
> just plus my previous patch, "kvm: x86: vmx: reorder some msr writing"
> 
> I already can execute such a command successfully,
> 
> qemu-system-x86_64 -machine pc,accel=kvm -m 2048 -smp 2 -hda ubuntu.img
> 
> And your log below seems not to relate mem_slot issue we're discussing, I
> guess you need to update qemu as well.

Yes, I'm sure.

> But I also found my new patch just work out Andy's next case, its really
> bringing a new issue in !next case. So I tried to refine that patch again as
> follows,

This latest patch (again, after fixing all the whitespace so it actually
applies), does the trick.  Both
"qemu-system-x86_64 -machine pc,accel=kvm" and
"qemu-system-x86_64 -machine pc,accel=kvm -nodefaults" work for me
now without any of the aforementioned warnings from the host.


> Signed-off-by: Tiejun Chen <tiejun.chen@intel.com>
> ---
>  virt/kvm/kvm_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f528343..910bc48 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -672,6 +672,7 @@ static void update_memslots(struct kvm_memslots *slots,
>         WARN_ON(mslots[i].id != id);
>         if (!new->npages) {
>                 new->base_gfn = 0;
> +               new->flags = 0;
>                 if (mslots[i].npages)
>                         slots->used_slots--;
>         } else {
> @@ -688,7 +689,9 @@ static void update_memslots(struct kvm_memslots *slots,
>                 i++;
>         }
>         while (i > 0 &&
> -              new->base_gfn > mslots[i - 1].base_gfn) {
> +              ((new->base_gfn > mslots[i - 1].base_gfn) ||
> +            (!new->base_gfn &&
> +             !mslots[i - 1].base_gfn && !mslots[i - 1].npages))) {
>                 mslots[i] = mslots[i - 1];
>                 slots->id_to_index[mslots[i].id] = i;
>                 i--;
> 
> 
> 
> Tiejun
> 
> >errors in the host to the tune of:
> >
> >------------[ cut here ]------------
> >WARNING: CPU: 1 PID: 3901 at arch/x86/kvm/x86.c:6575 kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]()
> >Modules linked in: nfsv4 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 fan nfsd auth_rpcgss nfs lockd grace fscache sunrpc bridge stp llc vhost_net tun vhost macvtap macvlan fuse cbc dm_crypt usb_storage snd_hda_codec_analog snd_hda_codec_generic kvm_intel kvm tg3 ptp pps_core sr_mod snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd sg dcdbas cdrom psmouse soundcore floppy evdev xfs dm_mod raid1 md_mod
> >CPU: 1 PID: 3901 Comm: qemu-system-x86 Not tainted 3.19.0-rc1-00011-g53262d1-dirty #1
> >Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
> >  0000000000000000 000000007e052328 ffff8800c25ffcf8 ffffffff813defbe
> >  0000000000000000 0000000000000000 ffff8800c25ffd38 ffffffff8103b517
> >  ffff8800c25ffd28 ffffffffa019bdec ffff8800caf1d000 ffff8800c2774800
> >Call Trace:
> >  [<ffffffff813defbe>] dump_stack+0x4c/0x6e
> >  [<ffffffff8103b517>] warn_slowpath_common+0x97/0xb1
> >  [<ffffffffa019bdec>] ? kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
> >  [<ffffffff8103b60b>] warn_slowpath_null+0x15/0x17
> >  [<ffffffffa019bdec>] kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
> >  [<ffffffffa02308b9>] ? vmcs_load+0x20/0x62 [kvm_intel]
> >  [<ffffffffa0231e03>] ? vmx_vcpu_load+0x140/0x16a [kvm_intel]
> >  [<ffffffffa0196ba3>] ? kvm_arch_vcpu_load+0x15c/0x161 [kvm]
> >  [<ffffffffa018d8b1>] kvm_vcpu_ioctl+0x189/0x4bd [kvm]
> >  [<ffffffff8104647a>] ? do_sigtimedwait+0x12f/0x189
> >  [<ffffffff810ea316>] do_vfs_ioctl+0x370/0x436
> >  [<ffffffff810f24f2>] ? __fget+0x67/0x72
> >  [<ffffffff810ea41b>] SyS_ioctl+0x3f/0x5e
> >  [<ffffffff813e34d2>] system_call_fastpath+0x12/0x17
> >---[ end trace 46abac932fb3b4a1 ]---
> >------------[ cut here ]------------
> >WARNING: CPU: 1 PID: 3901 at arch/x86/kvm/x86.c:6575 kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]()
> >Modules linked in: nfsv4 cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand cpufreq_conservative autofs4 fan nfsd auth_rpcgss nfs lockd grace fscache sunrpc bridge stp llc vhost_net tun vhost macvtap macvlan fuse cbc dm_crypt usb_storage snd_hda_codec_analog snd_hda_codec_generic kvm_intel kvm tg3 ptp pps_core sr_mod snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_timer snd sg dcdbas cdrom psmouse soundcore floppy evdev xfs dm_mod raid1 md_mod
> >CPU: 1 PID: 3901 Comm: qemu-system-x86 Tainted: G        W      3.19.0-rc1-00011-g53262d1-dirty #1
> >Hardware name: Dell Inc. Precision WorkStation T3400  /0TP412, BIOS A14 04/30/2012
> >  0000000000000000 000000007e052328 ffff8800c25ffcf8 ffffffff813defbe
> >  0000000000000000 0000000000000000 ffff8800c25ffd38 ffffffff8103b517
> >  ffff8800c25ffd28 ffffffffa019bdec ffff8800caf1d000 ffff8800c2774800
> >Call Trace:
> >  [<ffffffff813defbe>] dump_stack+0x4c/0x6e
> >  [<ffffffff8103b517>] warn_slowpath_common+0x97/0xb1
> >  [<ffffffffa019bdec>] ? kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
> >  [<ffffffff8103b60b>] warn_slowpath_null+0x15/0x17
> >  [<ffffffffa019bdec>] kvm_arch_vcpu_ioctl_run+0xd63/0xe5b [kvm]
> >  [<ffffffffa02308b9>] ? vmcs_load+0x20/0x62 [kvm_intel]
> >  [<ffffffffa0231e03>] ? vmx_vcpu_load+0x140/0x16a [kvm_intel]
> >  [<ffffffffa0196ba3>] ? kvm_arch_vcpu_load+0x15c/0x161 [kvm]
> >  [<ffffffffa018d8b1>] kvm_vcpu_ioctl+0x189/0x4bd [kvm]
> >  [<ffffffff8104647a>] ? do_sigtimedwait+0x12f/0x189
> >  [<ffffffff810ea316>] do_vfs_ioctl+0x370/0x436
> >  [<ffffffff810f24f2>] ? __fget+0x67/0x72
> >  [<ffffffff810ea41b>] SyS_ioctl+0x3f/0x5e
> >  [<ffffffff813e34d2>] system_call_fastpath+0x12/0x17
> >---[ end trace 46abac932fb3b4a2 ]---
> >
> >over and over and over ad nauseum, or until I kill the qemu command,
> >it also eats a core's worth of cpu.

-- 
Jamie Heilman                     http://audible.transient.net/~jamie/
