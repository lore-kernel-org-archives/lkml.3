Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab3FVV73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 17:59:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab3FVV71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 17:59:27 -0400
Date: Sat, 22 Jun 2013 17:59:05 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130622215905.GA28238@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130619164540.GB22483@redhat.com>
 <20130619175356.GA23673@redhat.com>
 <20130619181302.GE5146@linux.vnet.ibm.com>
 <20130620001212.GB12151@redhat.com>
 <20130620161652.GA4462@linux.vnet.ibm.com>
 <20130621151119.GA1596@redhat.com>
 <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130622173129.GA29375@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 22, 2013 at 07:31:29PM +0200, Oleg Nesterov wrote:
 
 > > [ 7485.261299] WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
 > > [ 7485.262021] Modules linked in: 8021q garp stp tun fuse rfcomm bnep hidp snd_seq_dummy nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can_raw rds af_802154 nfc can rose caif_socket caif llc2 af_rxrpc phonet ipx p8023 p8022 pppoe pppox ppp_generic netrom slhc ax25 x25 af_key appletalk atm psnap llc irda crc_ccitt bluetooth rfkill coretemp hwmon kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device pcspkr snd_pcm snd_page_alloc e1000e snd_timer ptp snd pps_core soundcore xfs libcrc32c
 > > [ 7485.265434] CPU: 2 PID: 5623 Comm: trinity-child3 Not tainted 3.10.0-rc6+ #28 
 > > [ 7485.267158]  ffffffff81a1529c ffff8801c8eafd30 ffffffff816e432d ffff8801c8eafd68
 > > [ 7485.268045]  ffffffff8104a0c1 0000000000000000 ffff880225e9bd18 ffff8801bc6e4de0
 > > [ 7485.268932]  0000000000000000 00000000000000dd ffff8801c8eafd78 ffffffff8104a19a
 > > [ 7485.270463] Call Trace:
 > > [ 7485.271338]  [<ffffffff816e432d>] dump_stack+0x19/0x1b
 > > [ 7485.272207]  [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
 > > [ 7485.273092]  [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
 > > [ 7485.273942]  [<ffffffff81229f58>] get_proc_task_net+0x1c8/0x1d0
 > > [ 7485.274793]  [<ffffffff81229d95>] ? get_proc_task_net+0x5/0x1d0
 > > [ 7485.275659]  [<ffffffff8122a0bd>] proc_tgid_net_lookup+0x1d/0x80
 > > [ 7485.276531]  [<ffffffff811b778d>] lookup_real+0x1d/0x50
 > > [ 7485.277646]  [<ffffffff811b7d83>] __lookup_hash+0x33/0x40
 > > [ 7485.278477]  [<ffffffff811bb143>] kern_path_create+0xb3/0x190
 > > [ 7485.279345]  [<ffffffff811b93d5>] ? getname_flags+0xb5/0x190
 > > [ 7485.280292]  [<ffffffff811bb261>] user_path_create+0x41/0x60
 > > [ 7485.281233]  [<ffffffff811be6bb>] SyS_symlinkat+0x4b/0xd0
 > > [ 7485.282072]  [<ffffffff816f5a54>] tracesys+0xdd/0xe2
 > > [ 7485.282973] ---[ end trace 2204b7c65d6c5519 ]---
 > 
 > Hmm. The test case tries to create the symlink in /proc/*/net/ ?

hit it with symlink, but also some other syscalls. eg:

WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
 Modules linked in: 8021q garp stp tun fuse rfcomm bnep hidp snd_seq_dummy nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can_raw rds af_802154 nfc can rose caif_socket caif llc2 af_rxrpc phonet ipx p8023 p8022 pppoe pppox ppp_generic netrom slhc ax25 x25 af_key appletalk atm psnap llc irda crc_ccitt bluetooth rfkill coretemp hwmon kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device pcspkr snd_pcm snd_page_alloc e1000e snd_timer ptp snd pps_core soundcore xfs libcrc32c
 CPU: 2 PID: 12821 Comm: trinity-child2 Tainted: G        W    3.10.0-rc6+ #28
  ffffffff81a1529c ffff8801bcbdbc70 ffffffff816e432d ffff8801bcbdbca8
  ffffffff8104a0c1 0000000000000000 ffff880226704828 ffff8801b95a7090
  00000000ffffff9c 0000000000000008 ffff8801bcbdbcb8 ffffffff8104a19a
 Call Trace:
  [<ffffffff816e432d>] dump_stack+0x19/0x1b
  [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
  [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
  [<ffffffff81229f58>] get_proc_task_net+0x1c8/0x1d0
  [<ffffffff81229d95>] ? get_proc_task_net+0x5/0x1d0
  [<ffffffff8122a0bd>] proc_tgid_net_lookup+0x1d/0x80
  [<ffffffff811b778d>] lookup_real+0x1d/0x50
  [<ffffffff811b7d83>] __lookup_hash+0x33/0x40
  [<ffffffff816e3635>] lookup_slow+0x44/0xa9
  [<ffffffff811bae88>] path_lookupat+0x7b8/0x810
  [<ffffffff8119d3d2>] ? kmem_cache_alloc+0x142/0x320
  [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
  [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
  [<ffffffff811baf0b>] filename_lookup+0x2b/0xc0
  [<ffffffff811be144>] user_path_at_empty+0x54/0x90
  [<ffffffff81145965>] ? user_exit+0x45/0x90
  [<ffffffff810b773d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
  [<ffffffff811be191>] user_path_at+0x11/0x20
  [<ffffffff811d5338>] SyS_lgetxattr+0x38/0x90
  [<ffffffff816f5a54>] tracesys+0xdd/0xe2
 ---[ end trace 2204b7c65d6c551a ]---
 
WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
Modules linked in: 8021q garp stp tun fuse rfcomm bnep hidp snd_seq_dummy nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can_raw rds af_802154 nfc can rose caif_socket caif llc2 af_rxrpc phonet ipx p8023 p8022 pppoe pppox ppp_generic netrom slhc ax25 x25 af_key appletalk atm psnap llc irda crc_ccitt bluetooth rfkill coretemp hwmon kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device pcspkr snd_pcm snd_page_alloc e1000e snd_timer ptp snd pps_core soundcore xfs libcrc32c
CPU: 2 PID: 13142 Comm: trinity-child1 Tainted: G        W    3.10.0-rc6+ #28
 ffffffff81a1529c ffff880228f3dc30 ffffffff816e432d ffff880228f3dc68
 ffffffff8104a0c1 0000000000000000 ffff8802239f3790 ffff880224021030
 00000000ffffff9c 0000000000000001 ffff880228f3dc78 ffffffff8104a19a
Call Trace:
 [<ffffffff816e432d>] dump_stack+0x19/0x1b
 [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
 [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81229f58>] get_proc_task_net+0x1c8/0x1d0
 [<ffffffff81229d95>] ? get_proc_task_net+0x5/0x1d0
 [<ffffffff8122a0bd>] proc_tgid_net_lookup+0x1d/0x80
 [<ffffffff811b778d>] lookup_real+0x1d/0x50
 [<ffffffff811b7d83>] __lookup_hash+0x33/0x40
 [<ffffffff816e3635>] lookup_slow+0x44/0xa9
 [<ffffffff811bae88>] path_lookupat+0x7b8/0x810
 [<ffffffff8119d3d2>] ? kmem_cache_alloc+0x142/0x320
 [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
 [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
 [<ffffffff811baf0b>] filename_lookup+0x2b/0xc0
 [<ffffffff811be144>] user_path_at_empty+0x54/0x90
 [<ffffffff810ba1f8>] ? lock_release_non_nested+0x308/0x350
 [<ffffffff810b4dae>] ? lock_release_holdtime.part.30+0xee/0x170
 [<ffffffff811be191>] user_path_at+0x11/0x20
 [<ffffffff811e1069>] do_utimes+0xa9/0x160
 [<ffffffff811e118f>] SyS_utime+0x6f/0xa0
 [<ffffffff816f5a54>] tracesys+0xdd/0xe2
---[ end trace 2204b7c65d6c551e ]---

WARNING: at include/linux/nsproxy.h:63 get_proc_task_net+0x1c8/0x1d0()
Modules linked in: 8021q garp stp tun fuse rfcomm bnep hidp snd_seq_dummy nfnetlink scsi_transport_iscsi can_bcm ipt_ULOG can_raw rds af_802154 nfc can rose caif_socket caif llc2 af_rxrpc phonet ipx p8023 p8022 pppoe pppox ppp_generic netrom slhc ax25 x25 af_key appletalk atm psnap llc irda crc_ccitt bluetooth rfkill coretemp hwmon kvm_intel snd_hda_codec_realtek kvm snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel microcode snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device pcspkr snd_pcm snd_page_alloc e1000e snd_timer ptp snd pps_core soundcore xfs libcrc32c
CPU: 0 PID: 13692 Comm: trinity-child0 Tainted: G        W    3.10.0-rc6+ #28
 ffffffff81a1529c ffff88021dea7c90 ffffffff816e432d ffff88021dea7cc8
 ffffffff8104a0c1 0000000000000000 ffff880226704828 ffff88022404ae40
 00000000ffffff9c 0000000000000000 ffff88021dea7cd8 ffffffff8104a19a
Call Trace:
 [<ffffffff816e432d>] dump_stack+0x19/0x1b
 [<ffffffff8104a0c1>] warn_slowpath_common+0x61/0x80
 [<ffffffff8104a19a>] warn_slowpath_null+0x1a/0x20
 [<ffffffff81229f58>] get_proc_task_net+0x1c8/0x1d0
 [<ffffffff81229d95>] ? get_proc_task_net+0x5/0x1d0
 [<ffffffff8122a0bd>] proc_tgid_net_lookup+0x1d/0x80
 [<ffffffff811b778d>] lookup_real+0x1d/0x50
 [<ffffffff811b7d83>] __lookup_hash+0x33/0x40
 [<ffffffff816e3635>] lookup_slow+0x44/0xa9
 [<ffffffff811bae88>] path_lookupat+0x7b8/0x810
 [<ffffffff8119d3d2>] ? kmem_cache_alloc+0x142/0x320
 [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
 [<ffffffff811b936f>] ? getname_flags+0x4f/0x190
 [<ffffffff811baf0b>] filename_lookup+0x2b/0xc0
 [<ffffffff811be144>] user_path_at_empty+0x54/0x90
 [<ffffffff810b773d>] ? trace_hardirqs_on_caller+0xfd/0x1c0
 [<ffffffff810b780d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff811be191>] user_path_at+0x11/0x20
 [<ffffffff811abe7f>] SyS_chdir+0x2f/0xc0
 [<ffffffff816f59f5>] ? tracesys+0x7e/0xe2
 [<ffffffff816f5a54>] tracesys+0xdd/0xe2
---[ end trace 2204b7c65d6c5521 ]---

and a bunch of other similar VFS related calls.

 > >  > +		pr_info("YESTHISHAPPENS new=%p\n", new);
 > >
 > > This didn't trigger. (yet?)
 > 
 > This should only trigger if the test-case plays with the namespaces...
 > But once again, the warnings are fine. I hoped that they can provide
 > more info when/if you reproduce the lockup.
 > 
 > But it seems you can't ?
 >
 > Dave, I am sorry but all I can do is to ask you to do more testing.
 > Could you please reproduce the lockup again on the clean Linus's
 > current ? (and _without_ reverting 8aac6270, of course).
 
I'll give it a shot.  Just rebuilt clean tree, and restarted the tests.

 > If watchdog will blame __do_softirq() again I can try to make a
 > better debugging patch.
 > 
 > Perhaps it makes sense to decrease /proc/sys/kernel/watchdog_thresh
 > to detect the possible lockups earlier. 2 * 10 is probably too much.

I can try that too if it doesn't show up.

 > And who knows, perhaps you pulled some fix (say 34376a50fb1 looks
 > promising) after you finished bisecting and then pulled Linus
 > current.

maybe, though I'm doubtful. I'm sure I already saw it yesterday
on this tree without the revert, but I'll confirm for sure of course..

	Dave

