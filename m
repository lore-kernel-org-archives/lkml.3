Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196Ab3IGJLe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 05:11:34 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:55664 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3IGJLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 05:11:32 -0400
Message-ID: <522AEDBF.2050203@colorfullife.com>
Date: Sat, 07 Sep 2013 11:11:27 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>
Subject: Re: soft lockup in sysvipc code.
References: <20130904215022.GA30606@redhat.com>
In-Reply-To: <20130904215022.GA30606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 09/04/2013 11:50 PM, Dave Jones wrote:
> Haven't seen this before.
> Tree based on v3.11-3104-gf357a82
>
> BUG: soft lockup - CPU#0 stuck for 22s! [trinity-child0:25479]
> Modules linked in: sctp snd_seq_dummy fuse dlci rfcomm tun bnep hidp ipt_ULOG nfnetlink can_raw can_bcm scsi_transport_iscsi nfc caif_socket caif af_802154 phonet af_rxrpc bluetooth rfkill can llc2 pppoe pppox ppp_generic slhc irda crc_ccitt rds af_key rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 xfs snd_hda_codec_realtek libcrc32c snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_page_alloc snd_timer snd soundcore pcspkr usb_debug e1000e ptp pps_core
> irq event stamp: 1143030
> hardirqs last  enabled at (1143029): [<ffffffff81715d5c>] restore_args+0x0/0x30
> hardirqs last disabled at (1143030): [<ffffffff8171f9aa>] apic_timer_interrupt+0x6a/0x80
> softirqs last  enabled at (1143028): [<ffffffff8105a938>] __do_softirq+0x198/0x460
> softirqs last disabled at (1143023): [<ffffffff8105ae55>] irq_exit+0x135/0x150
> CPU: 0 PID: 25479 Comm: trinity-child0 Not tainted 3.11.0+ #44
> task: ffff88022c013f90 ti: ffff88022bd8c000 task.ti: ffff88022bd8c000
> RIP: 0010:[<ffffffff8131014b>]  [<ffffffff8131014b>] idr_find_slowpath+0x9b/0x150
> RSP: 0018:ffff88022bd8dc88  EFLAGS: 00000206
> RAX: 0000000000000006 RBX: ffff000a6c0a0000 RCX: 0000000000000008
> RDX: 0000000000000008 RSI: ffffffff81c41040 RDI: ffff88022c014668
> RBP: ffff88022bd8dca0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000001 R11: 0000000000000001 R12: ffff88023831a290
> R13: 0000000000000001 R14: ffff88022bd8dbe8 R15: ffff8802449dffff
> FS:  00007fcfcad2c740(0000) GS:ffff880244800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fcfc84cb968 CR3: 00000001de93f000 CR4: 00000000001407f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Stack:
>   0000000000000260 0000000000002dba ffffffff81c7e258 ffff88022bd8dcf8
>   ffffffff812b1131 ffff88022c013f90 ffff8801d37174c0 ffff88022bd8dd38
>   ffffffff81c7e2f0 ffff88022bd8dd38 ffff8801e065cec8 ffff880241d86ca8
> Call Trace:
>   [<ffffffff812b1131>] sysvipc_find_ipc+0x61/0x300
>   [<ffffffff812b1416>] sysvipc_proc_next+0x46/0xd0
>   [<ffffffff811e13b9>] traverse.isra.7+0xc9/0x260
>   [<ffffffff810c4078>] ? lock_release_non_nested+0x308/0x350
>   [<ffffffff811e1b61>] seq_read+0x3e1/0x450
>   [<ffffffff81228f10>] ? proc_reg_write+0x80/0x80
>   [<ffffffff81228f4d>] proc_reg_read+0x3d/0x80
Do you have any details about load?

I haven't seen it either - but I don't have a stress test that does
#while true;cat /proc/sysvipc/*>/dev/null;done
in parallel with create/remove/whatever operations.

Davidlohr: Have you done any stress tests for the /proc interface?

--
     Manfred
