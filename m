Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab3KVO4h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:56:37 -0500
Received: from www.linutronix.de ([62.245.132.108]:45090 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab3KVO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:56:35 -0500
Date: Fri, 22 Nov 2013 15:56:34 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Pavel Vasilyev <pavel@pavlinux.ru>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.2.52-rt73
Message-ID: <20131122145634.GD8698@linutronix.de>
References: <20131116194633.GD11518@linutronix.de>
 <528E70B5.5010603@pavlinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <528E70B5.5010603@pavlinux.ru>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Vasilyev | 2013-11-22 00:44:37 [+0400]:

>
>Fine, killed 3.12 now decided to finish 3.2.x. Good job guys!
>
>Not configuration, not hardware, not software has not been updated or changed.

No I am a bit confused. On 16th you write:
|3.2.52-rt72 - work

and now you say that we killed v3.2. There was no v3.2.52-rt72 but
v3.2.51-rt72. So did -rt72 work and -rt73 does no more?

I saw your earlier screenshots and there is nothing I can say. I can't
tell based on the screenshot what is wrong. Sorry.

This time you managed to include a backtrace. Better! However would you
mind to enable frame pointers? The backtrace 

>BUG: scheduling while atomic: irq/74-sata_nv/57/0x00000002
>Modules linked in: cls_u32 sch_sfq sch_htb
>Pid: 57, comm: irq/74-sata_nv Tainted: G           O 3.2.52-rt73 #10
>Call Trace:
> [<ffffffff814bdef4>] ? __schedule+0x314/0x344
> [<ffffffff81081b77>] ? task_blocks_on_rt_mutex+0x1e7/0x280
> [<ffffffff814be741>] ? schedule+0x21/0xa0
> [<ffffffff814c0d88>] ? rt_spin_lock_slowlock+0x128/0x280
> [<ffffffff81204d01>] ? blk_update_request+0x11/0x450
> [<ffffffff812a6976>] ? add_timer_randomness+0x86/0x1e0
> [<ffffffff81206eac>] ? blk_end_request+0x9c/0xc0
> [<ffffffff812c629a>] ? scsi_io_completion+0x9a/0x770
> [<ffffffff8120d4ab>] ? blk_done_softirq+0x6b/0x80
> [<ffffffff8104a805>] ? __do_softirq_common+0xa5/0x1d0
> [<ffffffff81094ec0>] ? irq_thread_fn+0x50/0x50
> [<ffffffff8104ad77>] ? local_bh_enable+0x127/0x150
> [<ffffffff81094f08>] ? irq_forced_thread_fn+0x48/0x70
> [<ffffffff81094d80>] ? irq_thread+0x150/0x240
> [<ffffffff81094c30>] ? disable_irq_nosync+0x60/0x60
> [<ffffffff81067150>] ? kthread+0x80/0x90
> [<ffffffff814c3174>] ? kernel_thread_helper+0x4/0x10
> [<ffffffff810670d0>] ? kthread_bind+0x80/0x80
> [<ffffffff814c3170>] ? gs_change+0xb/0xb

shows now random functions which were on stack before the accident. What
happens is that something on the system tries to take a sleeping long
while beeing most likely in a preempt disable region. With lockdep on it
might even throw some additional information here.

Sebastian
