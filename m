Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757138Ab3FSSNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:13:24 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:51778 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756708Ab3FSSNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:13:22 -0400
Date: Wed, 19 Jun 2013 11:13:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130619181302.GE5146@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130619164540.GB22483@redhat.com>
 <20130619175356.GA23673@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130619175356.GA23673@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061918-3620-0000-0000-00000333B199
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 01:53:56PM -0400, Dave Jones wrote:
> On Wed, Jun 19, 2013 at 12:45:40PM -0400, Dave Jones wrote:
>  > I've been hitting this a lot the last few days.
>  > This is the same machine that I was also seeing lockups during sync()
> 
> On a whim, I reverted 971394f389992f8462c4e5ae0e3b49a10a9534a3
> (As I started seeing these just after that rcu merge).
> 
> It's only been 30 minutes, but it seems stable again. Normally I would
> hit these within 5 minutes.
> 
> I think this may be the same root cause for http://www.spinics.net/lists/kernel/msg1551503.html too.
> 
> Paul ?

???

In both cases, I am guessing that you built with CONFIG_PROVE_RCU_DELAY=y.
Even then, this is very strange.  I am at a loss as to why udelay(200)
would result in a hang.  Or does your system turn udelay() into something
other than a pure spin?

							Thanx, Paul

> 	Dave
> 
> 
> 
>  > BUG: soft lockup - CPU#1 stuck for 22s! [trinity-child9:6902]
>  > Modules linked in: bridge snd_seq_dummy dlci bnep fuse 8021q garp stp hidp tun rfcomm can_raw ipt_ULOG nfnetlink rose scsi_transport_iscsi ipx p8023 p8022 phonet llc2 irda rds pppoe pppox caif_socket caif ppp_generic af_key slhc crc_ccitt bluetooth netrom can_bcm x25 appletalk psnap can llc af_rxrpc atm ax25 af_802154 nfc rfkill coretemp hwmon kvm_intel kvm snd_hda_codec_realtek snd_hda_codec_hdmi crc32c_intel ghash_clmulni_intel snd_hda_intel microcode snd_hda_codec pcspkr snd_hwdep snd_seq snd_seq_device usb_debug snd_pcm e1000e ptp pps_core snd_page_alloc snd_timer snd soundcore xfs libcrc32c
>  > irq event stamp: 2057909
>  > hardirqs last  enabled at (2057908): [<ffffffff816ed220>] restore_args+0x0/0x30
>  > hardirqs last disabled at (2057909): [<ffffffff816f5d2a>] apic_timer_interrupt+0x6a/0x80
>  > softirqs last  enabled at (1444600): [<ffffffff810542d4>] __do_softirq+0x194/0x440
>  > softirqs last disabled at (1444851): [<ffffffff8105473d>] irq_exit+0xcd/0xe0
>  > CPU: 1 PID: 6902 Comm: trinity-child9 Not tainted 3.10.0-rc6+ #16
>  > task: ffff880243212520 ti: ffff88015c1fa000 task.ti: ffff88015c1fa000
>  > RIP: 0010:[<ffffffff810541f1>]  [<ffffffff810541f1>] __do_softirq+0xb1/0x440
>  > RSP: 0000:ffff880244a03f08  EFLAGS: 00000202
>  > RAX: ffff880243212520 RBX: ffffffff816ed220 RCX: 0000000000000000
>  > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880243212520
>  > RBP: ffff880244a03f70 R08: 0000000010000003 R09: 0000000000000000
>  > R10: 0000000000000001 R11: 0000000000000000 R12: ffff880244a03e78
>  > R13: ffffffff816f5d2f R14: ffff880244a03f70 R15: 0000000000000000
>  > FS:  00007f2e89fa1740(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
>  > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  > CR2: 000000000351a000 CR3: 00000001f6b7d000 CR4: 00000000001407e0
>  > DR0: 00007f2e898d2000 DR1: 0000000001c59000 DR2: 0000000001c5c000
>  > DR3: 0000000000008000 DR6: 00000000fffe0ff0 DR7: 00000000000b0602
>  > Stack:
>  >  0000000a00406040 00000001008fead4 ffff88015c1fbfd8 ffff88015c1fbfd8
>  >  ffff88015c1fbfd8 0000000010010002 ffff88015c1fbfd8 ffffffff00000001
>  >  ffff880243212520 0000000000000000 ffff88023bbf0c80 0000000000000001
>  > Call Trace:
>  >  <IRQ> 
>  > 
>  >  [<ffffffff8105473d>] irq_exit+0xcd/0xe0
>  >  [<ffffffff816f6bcb>] smp_apic_timer_interrupt+0x6b/0x9b
>  >  [<ffffffff816f5d2f>] apic_timer_interrupt+0x6f/0x80
>  >  <EOI> 
>  > 
>  >  [<ffffffff816ed220>] ? retint_restore_args+0xe/0xe
>  >  [<ffffffff816ec642>] ? _raw_spin_unlock_irq+0x32/0x60
>  >  [<ffffffff816ec63c>] ? _raw_spin_unlock_irq+0x2c/0x60
>  >  [<ffffffff81086c95>] finish_task_switch+0x85/0x130
>  >  [<ffffffff81086c57>] ? finish_task_switch+0x47/0x130
>  >  [<ffffffff816ea734>] __schedule+0x444/0x9c0
>  >  [<ffffffff816eb313>] preempt_schedule_irq+0x53/0x90
>  >  [<ffffffff816ed336>] retint_kernel+0x26/0x30
>  >  [<ffffffff81145297>] ? user_enter+0x87/0xd0
>  >  [<ffffffff8100f6f8>] syscall_trace_leave+0x78/0x140
>  >  [<ffffffff816f53af>] int_check_syscall_exit_work+0x34/0x3d
>  > Code: 48 89 45 b8 48 89 45 b0 48 89 45 a8 66 0f 1f 44 00 00 65 c7 04 25 80 0f 1d 00 00 00 00 00 e8 b7 31 06 00 fb 49 c7 c6 00 41 c0 81 <eb> 0e 0f 1f 44 00 00 49 83 c6 08 41 d1 ef 74 6c 41 f6 c7 01 74 
>  > 
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  > Please read the FAQ at  http://www.tux.org/lkml/
> ---end quoted text---
> 

