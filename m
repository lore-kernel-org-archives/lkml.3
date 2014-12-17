Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133AbaLQS6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:58:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbaLQS6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:58:40 -0500
Date: Wed, 17 Dec 2014 13:57:55 -0500
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
Message-ID: <20141217185755.GA22839@redhat.com>
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
References: <20141211145408.GB16800@redhat.com>
 <CA+55aFy1_w1NrkeopMXsxGftO5F03JzKgn-8uTQRnEAXuoiXgg@mail.gmail.com>
 <20141212185454.GB4716@redhat.com>
 <CA+55aFw7vJkuJ9RtVS3yhPsqDos+ii1kdJBZEeoxhb9c2=rStQ@mail.gmail.com>
 <20141213165915.GA12756@redhat.com>
 <20141213223616.GA22559@redhat.com>
 <CA+55aFwCa1+cBGxt-v487K-QBvxGyB9bL4u34zgMep9uFW+Mgw@mail.gmail.com>
 <20141214234654.GA396@redhat.com>
 <CA+55aFyUtZobUADgtss7e4w-yriMtz7hKVKs=Ed72KQoQ9n2nA@mail.gmail.com>
 <20141217182241.GA4821@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141217182241.GA4821@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 01:22:41PM -0500, Dave Jones wrote:
 
 > I'm going to try your two patches on top of .18, with the same kernel
 > config, and see where that takes us.
 > Hopefully to happier places.

Not so much.  Died very quickly.

[  270.822490] BUG: unable to handle kernel paging request at 000000000249db90
[  270.822573] IP: [<000000336ef04084>] 0x336ef04084
[  270.822602] PGD 20e5ee067 PUD 20e5ef067 PMD 23126d067 PTE 94ec80
[  270.822633] Oops: 0006 [#1] SMP 
[  270.822652] Modules linked in: hidp llc2 af_key fuse bnep can_raw scsi_transport_iscsi nfnetlink can_bcm rfcomm nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose sctp libcrc32c x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm coretemp hwmon x86_pkg_temp_thermal kvm_intel snd_timer kvm snd crct10dif_pclmul crc32c_intel ghash_clmulni_intel microcode pcspkr serio_raw usb_debug shpchp e1000e soundcore ptp pps_core nfsd auth_rpcgss oid_registry nfs_acl lockd grace sunrpc
[  270.822979] CPU: 3 PID: 9856 Comm: trinity-c93 Not tainted 3.18.0+ #105
[  270.823042] task: ffff8801a45416d0 ti: ffff88020e72c000 task.ti: ffff88020e72c000
[  270.823067] RIP: 0033:[<000000336ef04084>]  [<000000336ef04084>] 0x336ef04084
[  270.823096] RSP: 002b:00007fff9c3304c0  EFLAGS: 00010202
[  270.823117] RAX: 000000336f1b68c0 RBX: 000000000249db90 RCX: 0000000000000000
[  270.823142] RDX: fffffffffffffffe RSI: 00000000fbad8000 RDI: 00007fff9c3304c0
[  270.823168] RBP: 000000000249db90 R08: 0000000000000000 R09: 0000000000002680
[  270.823192] R10: 000000000000001f R11: 0000000000000246 R12: ffffffffffffffff
[  270.823217] R13: 000000000041edb9 R14: 00007fff9c3305f8 R15: 0000000000000001
[  270.823241] FS:  00007f5fd4acf740(0000) GS:ffff880245400000(0000) knlGS:0000000000000000
[  270.823268] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  270.823288] CR2: 00007f5fd2640113 CR3: 000000020e5ed000 CR4: 00000000001407e0
[  270.823312] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  270.823336] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  270.823360] 
[  270.823370] RIP  [<000000336ef04084>] 0x336ef04084
[  270.823392]  RSP <00007fff9c3304c0>
[  270.824407] CR2: 000000000249db90
[  270.825443] ---[ end trace d6eb8dccb8df6213 ]---
[  270.826448] Kernel panic - not syncing: Fatal exception

