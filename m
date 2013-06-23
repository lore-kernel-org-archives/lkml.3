Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157Ab3FWFCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 01:02:48 -0400
Received: from relay.parallels.com ([195.214.232.42]:43450 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3FWFCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 01:02:47 -0400
Date: Sun, 23 Jun 2013 09:00:24 +0400
From: Andrew Vagin <avagin@parallels.com>
To: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130623050023.GA678@paralelels.com>
References: <20130619164540.GB22483@redhat.com>
 <20130619175356.GA23673@redhat.com>
 <20130619181302.GE5146@linux.vnet.ibm.com>
 <20130620001212.GB12151@redhat.com>
 <20130620161652.GA4462@linux.vnet.ibm.com>
 <20130621151119.GA1596@redhat.com>
 <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <20130622215905.GA28238@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [10.24.21.206]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 05:59:05PM -0400, Dave Jones wrote:
> On Sat, Jun 22, 2013 at 07:31:29PM +0200, Oleg Nesterov wrote:
>  
>  > > [ 7485.261299] WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
>  > > [ 7485.262021] Modules linked in: 8021q garp stp tun fuse rfcomm bnep hidp snd_seq_dummy nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can_raw rds af_802154 nfc can rose caif_socket caif llc2 af_rxrpc phonet ipx p8023 p8022 pppoe pppox ppp_generic netrom slhc ax25 x25 af_key appletalk atm psnap llc irda crc_ccitt bluetooth rfkill coretemp hwmon kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device pcspkr snd_pcm snd_page_alloc e1000e snd_timer ptp snd pps_core soundcore xfs libcrc32c
>  > > [ 7485.265434] CPU: 2 PID: 5623 Comm: trinity-child3 Not tainted 3.10.0-rc6+ #28 
>  > > [ 7485.267158]  ffffffff81a1529c ffff8801c8eafd30 ffffffff816e432d ffff8801c8eafd68
>  > > [ 7485.268045]  ffffffff8104a0c1 0000000000000000 ffff880225e9bd18 ffff8801bc6e4de0
>  > > [ 7485.268932]  0000000000000000 00000000000000dd ffff8801c8eafd78 ffffffff8104a19a
>  > > [ 7485.270463] Call Trace:
>  > > [ 7485.271338]  [<ffffffff816e432d>] dump_stack+0x19/0x1b
>  > > [ 7485.272207]  [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
>  > > [ 7485.273092]  [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
>  > > [ 7485.273942]  [<ffffffff81229f58>] get_proc_task_net+0x1c8/0x1d0
>  > > [ 7485.274793]  [<ffffffff81229d95>] ? get_proc_task_net+0x5/0x1d0
>  > > [ 7485.275659]  [<ffffffff8122a0bd>] proc_tgid_net_lookup+0x1d/0x80
>  > > [ 7485.276531]  [<ffffffff811b778d>] lookup_real+0x1d/0x50
>  > > [ 7485.277646]  [<ffffffff811b7d83>] __lookup_hash+0x33/0x40
>  > > [ 7485.278477]  [<ffffffff811bb143>] kern_path_create+0xb3/0x190
>  > > [ 7485.279345]  [<ffffffff811b93d5>] ? getname_flags+0xb5/0x190
>  > > [ 7485.280292]  [<ffffffff811bb261>] user_path_create+0x41/0x60
>  > > [ 7485.281233]  [<ffffffff811be6bb>] SyS_symlinkat+0x4b/0xd0
>  > > [ 7485.282072]  [<ffffffff816f5a54>] tracesys+0xdd/0xe2
>  > > [ 7485.282973] ---[ end trace 2204b7c65d6c5519 ]---
>  > 
>  > Hmm. The test case tries to create the symlink in /proc/*/net/ ?
> 
> hit it with symlink, but also some other syscalls. eg:
> 
> WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
>  Modules linked in: 8021q garp stp tun fuse rfcomm bnep hidp snd_seq_dummy nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can_raw rds af_802154 nfc can rose caif_socket caif llc2 af_rxrpc phonet ipx p8023 p8022 pppoe pppox ppp_generic netrom slhc ax25 x25 af_key appletalk atm psnap llc irda crc_ccitt bluetooth rfkill coretemp hwmon kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device pcspkr snd_pcm snd_page_alloc e1000e snd_timer ptp snd pps_core soundcore xfs libcrc32c
>  CPU: 2 PID: 12821 Comm: trinity-child2 Tainted: G        W    3.10.0-rc6+ #28
>   ffffffff81a1529c ffff8801bcbdbc70 ffffffff816e432d ffff8801bcbdbca8
>   ffffffff8104a0c1 0000000000000000 ffff880226704828 ffff8801b95a7090
>   00000000ffffff9c 0000000000000008 ffff8801bcbdbcb8 ffffffff8104a19a
>  Call Trace:
>   [<ffffffff816e432d>] dump_stack+0x19/0x1b
>   [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
>   [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff81229f58>] get_proc_task_net+0x1c8/0x1d0
>   [<ffffffff81229d95>] ? get_proc_task_net+0x5/0x1d0
>   [<ffffffff8122a0bd>] proc_tgid_net_lookup+0x1d/0x80
>   [<ffffffff811b778d>] lookup_real+0x1d/0x50
>   [<ffffffff811b7d83>] __lookup_hash+0x33/0x40
>   [<ffffffff816e3635>] lookup_slow+0x44/0xa9
>   [<ffffffff811bae88>] path_lookupat+0x7b8/0x810
>   [<ffffffff8119d3d2>] ? kmem_cache_alloc+0x142/0x320
>   [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
>   [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
>   [<ffffffff811baf0b>] filename_lookup+0x2b/0xc0
>   [<ffffffff811be144>] user_path_at_empty+0x54/0x90
>   [<ffffffff81145965>] ? user_exit+0x45/0x90
>   [<ffffffff810b773d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
>   [<ffffffff811be191>] user_path_at+0x11/0x20
>   [<ffffffff811d5338>] SyS_lgetxattr+0x38/0x90
>   [<ffffffff816f5a54>] tracesys+0xdd/0xe2
>  ---[ end trace 2204b7c65d6c551a ]---
>  
> 
> and a bunch of other similar VFS related calls.

All these VFS related calls try to work with /proc/PID/ns/SMTH. If a
process is zombie, it's detached from namespaces (except pidns), so if
we try to read /proc/PID/ns/SMTH, we get this warning.

> 
