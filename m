Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab3CADGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 22:06:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3CADGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 22:06:05 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=tLUlnkoJZcZI9ocdGARlSQ==:17 a=c11ml42nfjYA:10 a=wom5GMh1gUkA:10 a=Rj1_iGo3bfgA:10 a=kj9zAlcOel0A:10 a=hBqU3vQJAAAA:8 a=6mb0EbNfTAsA:10 a=PtDNVHqPAAAA:8 a=20KFwNOVAAAA:8 a=DfNHnWVPAAAA:8 a=X2rHeFa1ENLdKyoa67oA:9 a=CjuIK1q_8ugA:10 a=wYE_KDyynt4A:10 a=jEp0ucaQiEUA:10 a=lBRciGGoxdUA:10 a=tLUlnkoJZcZI9ocdGARlSQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 70.114.148.7
Date: Thu, 28 Feb 2013 21:06:44 -0600
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        dhowells@redhat.com, "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: commit_creds oops
Message-ID: <20130301030644.GB13057@austin.hallyn.com>
References: <20130228234351.GA22046@redhat.com>
 <87hakw7ypn.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hakw7ypn.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Dave Jones <davej@redhat.com> writes:
> 
> > Just hit this on Linus' current tree.
> >
> > [   89.621770] BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
> > [   89.623111] IP: [<ffffffff810784b0>] commit_creds+0x250/0x2f0
> > [   89.624062] PGD 122bfd067 PUD 122bfe067 PMD 0 
> > [   89.624901] Oops: 0000 [#1] PREEMPT SMP 
> > [   89.625678] Modules linked in: caif_socket caif netrom bridge hidp 8021q garp stp mrp rose llc2 af_rxrpc phonet af_key binfmt_misc bnep l2tp_ppp can_bcm l2tp_core pppoe pppox can_raw scsi_transport_iscsi ppp_generic slhc nfnetlink can ipt_ULOG ax25 decnet irda nfc rds x25 crc_ccitt appletalk atm ipx p8023 psnap p8022 llc lockd sunrpc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_conntrack nf_conntrack ip6table_filter ip6_tables btusb bluetooth snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm vhost_net snd_page_alloc snd_timer tun macvtap usb_debug snd rfkill microcode macvlan edac_core pcspkr serio_raw kvm_amd soundcore kvm r8169 mii
> > [   89.637846] CPU 2 
> > [   89.638175] Pid: 782, comm: trinity-main Not tainted 3.8.0+ #63 Gigabyte Technology Co., Ltd. GA-MA78GM-S2H/GA-MA78GM-S2H
> > [   89.639850] RIP: 0010:[<ffffffff810784b0>]  [<ffffffff810784b0>] commit_creds+0x250/0x2f0
> > [   89.641161] RSP: 0018:ffff880115657eb8  EFLAGS: 00010207
> > [   89.641984] RAX: 00000000000003e8 RBX: ffff88012688b000 RCX: 0000000000000000
> > [   89.643069] RDX: 0000000000000000 RSI: ffffffff81c32960 RDI: ffff880105839600
> > [   89.644167] RBP: ffff880115657ed8 R08: 0000000000000000 R09: 0000000000000000
> > [   89.645254] R10: 0000000000000001 R11: 0000000000000246 R12: ffff880105839600
> > [   89.646340] R13: ffff88011beea490 R14: ffff88011beea490 R15: 0000000000000000
> > [   89.647431] FS:  00007f3ac063b740(0000) GS:ffff88012b200000(0000) knlGS:0000000000000000
> > [   89.648660] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [   89.649548] CR2: 00000000000000c8 CR3: 0000000122bfc000 CR4: 00000000000007e0
> > [   89.650635] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   89.651723] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [   89.652812] Process trinity-main (pid: 782, threadinfo ffff880115656000, task ffff88011beea490)
> > [   89.654128] Stack:
> > [   89.654433]  0000000000000000 ffff8801058396a0 ffff880105839600 ffff88011beeaa78
> > [   89.655769]  ffff880115657ef8 ffffffff812c7d9b ffffffff82079be0 0000000000000000
> > [   89.657073]  ffff880115657f28 ffffffff8106c665 0000000000000002 ffff880115657f58
> > [   89.658399] Call Trace:
> > [   89.658822]  [<ffffffff812c7d9b>] key_change_session_keyring+0xfb/0x140
> > [   89.659845]  [<ffffffff8106c665>] task_work_run+0xa5/0xd0
> > [   89.660698]  [<ffffffff81002911>] do_notify_resume+0x71/0xb0
> > [   89.661581]  [<ffffffff816c9a4a>] int_signal+0x12/0x17
> > [   89.662385] Code: 24 90 00 00 00 48 8b b3 90 00 00 00 49 8b 4c 24 40 48 39 f2 75 08 e9 83 00 00 00 48 89 ca 48 81 fa 60 29 c3 81 0f 84 41 fe ff ff <48> 8b 8a c8 00 00 00 48 39 ce 75 e4 3b 82 d0 00 00 00 0f 84 4b 
> > [   89.667778] RIP  [<ffffffff810784b0>] commit_creds+0x250/0x2f0
> > [   89.668733]  RSP <ffff880115657eb8>
> > [   89.669301] CR2: 00000000000000c8
> >
> > My fastest trinity induced oops yet!
> >
> >
> > Appears to be..
> >
> >                 if ((set_ns == subset_ns->parent)  &&
> >      850:       48 8b 8a c8 00 00 00    mov    0xc8(%rdx),%rcx
> >
> > from the inlined cred_cap_issubset
> 
> Interesting.  That line is protected with the check subset_ns !=
> &init_user_ns so subset_ns->parent must be valid or subset_ns is not
> a proper user namespace.
> 
> Ugh.  I think I see what is going on and it is just silly. 
> 
> It looks like by historical accident we have been reading trying to set
> new->user_ns from new->user_ns.  Which is totally silly as new->user_ns
> is NULL (as is every other field in new except session_keyring at that
> point).
> 
> It looks like it is safe to sleep in key_change_session_keyring so why
> we just don't use prepare_creds there like everywhere else is beyond
> me.
> 
> The intent is clearly to copy all of the fields from old to new so what
> we should be doing is is copying old->user_ns into new->user_ns.
> 
> Dave can you verify that this patch fixes the oops?
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Jinkeys - that should have stood out like a sore thumb.

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
> diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
> index 58dfe08..a571fad 100644
> --- a/security/keys/process_keys.c
> +++ b/security/keys/process_keys.c
> @@ -839,7 +839,7 @@ void key_change_session_keyring(struct callback_head *twork)
>         new-> sgid      = old-> sgid;
>         new->fsgid      = old->fsgid;
>         new->user       = get_uid(old->user);
> -       new->user_ns    = get_user_ns(new->user_ns);
> +       new->user_ns    = get_user_ns(old->user_ns);
>         new->group_info = get_group_info(old->group_info);
>  
>         new->securebits = old->securebits;
