Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaLQTZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 14:25:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129AbaLQTZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 14:25:05 -0500
Date: Wed, 17 Dec 2014 14:24:24 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141217192424.GB22839@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <20141217182241.GA4821@redhat.com>
 <20141217185755.GA22839@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217185755.GA22839@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 01:57:55PM -0500, Dave Jones wrote:
 > On Wed, Dec 17, 2014 at 01:22:41PM -0500, Dave Jones wrote:
 >  
 >  > I'm going to try your two patches on top of .18, with the same kernel
 >  > config, and see where that takes us.
 >  > Hopefully to happier places.
 > 
 > Not so much.  Died very quickly.
 > 
 > [  270.822490] BUG: unable to handle kernel paging request at 000000000249db90
 > [  270.822573] IP: [<000000336ef04084>] 0x336ef04084
 > [  270.822602] PGD 20e5ee067 PUD 20e5ef067 PMD 23126d067 PTE 94ec80
 > [  270.822633] Oops: 0006 [#1] SMP 
 > [  270.822652] Modules linked in: hidp llc2 af_key fuse bnep can_raw scsi_transport_iscsi nfnetlink can_bcm rfcomm nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose sctp libcrc32c x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm coretemp hwmon x86_pkg_temp_thermal kvm_intel snd_timer kvm snd crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw usb_debug shpchp e1000e soundcore ptp pps_core nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
 > [  270.822979] CPU: 3 PID: 9856 Comm: trinity-c93 Not tainted 3.18.0+ #105
 > [  270.823042] task: ffff8801a45416d0 ti: ffff88020e72c000 task.ti: ffff88020e72c000
 > [  270.823067] RIP: 0033:[<000000336ef04084>]  [<000000336ef04084>] 0x336ef04084
 > [  270.823096] RSP: 002b:00007fff9c3304c0  EFLAGS: 00010202
 > [  270.823117] RAX: 000000336f1b68c0 RBX: 000000000249db90 RCX: 0000000000000000
 > [  270.823142] RDX: fffffffffffffffe RSI: 00000000fbad8000 RDI: 00007fff9c3304c0
 > [  270.823168] RBP: 000000000249db90 R08: 0000000000000000 R09: 0000000000002680
 > [  270.823192] R10: 000000000000001f R11: 0000000000000246 R12: ffffffffffffffff
 > [  270.823217] R13: 000000000041edb9 R14: 00007fff9c3305f8 R15: 0000000000000001
 > [  270.823241] FS:  00007f5fd4acf740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
 > [  270.823268] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 > [  270.823288] CR2: 00007f5fd2640113 CR3: 000000020e5ed000 CR4: 00000000001407e0
 > [  270.823312] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 > [  270.823336] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 > [  270.823360] 
 > [  270.823370] RIP  [<000000336ef04084>] 0x336ef04084
 > [  270.823392]  RSP <00007fff9c3304c0>
 > [  270.824407] CR2: 000000000249db90
 > [  270.825443] ---[ end trace d6eb8dccb8df6213 ]---
 > [  270.826448] Kernel panic - not syncing: Fatal exception

different flavour of the same thing

[  298.759018] BUG: unable to handle kernel paging request at 00000000016edc30
[  298.759108] IP: [<0000000000412c20>] 0x412c20
[  298.759130] PGD 2315d1067 PUD 2315d2067 PMD 2315d7067 PTE 3c2a880
[  298.759159] Oops: 0004 [#1] SMP 
[  298.759177] Modules linked in: rfcomm hidp bnep llc2 af_key scsi_transport_iscsi nfnetlink can_raw can_bcm nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose sctp libcrc32c x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm crct10dif_pclmul crc32c_intel ghash_clmulni_intel snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic microcode serio_raw pcspkr snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e ptp snd_timer shpchp snd pps_core soundcore nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[  298.759487] CPU: 3 PID: 4568 Comm: trinity-c193 Not tainted 3.18.0+ #105
[  298.759550] task: ffff88018c534470 ti: ffff8801deafc000 task.ti: ffff8801deafc000
[  298.759575] RIP: 0033:[<0000000000412c20>]  [<0000000000412c20>] 0x412c20
[  298.759601] RSP: 002b:00007fff8b5d80c0  EFLAGS: 00010202
[  298.759621] RAX: 00000000016edc20 RBX: 00000000017769f0 RCX: 00000000016edc20
[  298.759645] RDX: 0000000000000003 RSI: 0000000000000003 RDI: 000000336f1b76e0
[  298.759668] RBP: 00000000016edc20 R08: 000000336f1b70fc R09: 000000336f1b7140
[  298.759692] R10: 000000000000001f R11: 0000000000000246 R12: 0000000001776ef0
[  298.759716] R13: 00000000017769f0 R14: 0000000000000000 R15: 0000000000000000
[  298.759740] FS:  00007fbc02017740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[  298.759766] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  298.760773] CR2: 0000000000000004 CR3: 00000002315d0000 CR4: 00000000001407e0
[  298.761788] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  298.762802] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  298.763812] 
[  298.764808] RIP  [<0000000000412c20>] 0x412c20
[  298.765806]  RSP <00007fff8b5d80c0>
[  298.766772] CR2: 00000000016edc30
[  298.767725] ---[ end trace eaa888b859a91308 ]---
[  298.768672] Kernel panic - not syncing: Fatal exception

This seems to be easily reproducable at least..

	Dave
