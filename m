Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaKRLfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:35:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33564 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753276AbaKRLfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:35:12 -0500
Date: Tue, 18 Nov 2014 12:35:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Rogelio Serrano <rogelio.serrano@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mysterious udev segfault
Message-ID: <20141118113509.GA5346@pd.tnic>
References: <CANszf4jKHq-WY=+W=D3mFEnhL9=aZJ+-Mx7yp9kw=hYTi+gGFA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANszf4jKHq-WY=+W=D3mFEnhL9=aZJ+-Mx7yp9kw=hYTi+gGFA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 11:05:32AM +0000, Rogelio Serrano wrote:
> on boot i get this half of the time:
> 
> [    6.349867] general protection fault: 0000 [#1] SMP
> [    6.352177] Modules linked in: zram lz4_decompress lz4_compress unix
> [    6.354483] CPU: 1 PID: 112 Comm: udevd Not tainted 3.16.3-grsec-26 #2
								^^^^^

> [    6.356583] Hardware name: Matsushita Electric Industrial Co.,Ltd. CF-W7DWM0$
> [    6.356583] task: ffff8800ba589e00 ti: ffff8800ba58a5d8 task.ti: ffff8800ba5$
> [    6.356583] RIP: 0010:[<ffffffff812f9a2c>]  [<ffffffff812f9a2c>] ffffffff812$
> [    6.356583] RSP: 0018:ffffc9001555b9c8  EFLAGS: 00010246
> [    6.356583] RAX: 0000000000000000 RBX: fefefefefefefefe RCX: ffff8800bb6d0a68
> [    6.356583] RDX: ffffc9001555ba18 RSI: 0000000000000036 RDI: fefefefefefefefe
> [    6.356583] RBP: ffffc9001555b9f8 R08: 0000000000015660 R09: ffff8800bb71d890
> [    6.356583] R10: ffff8800b9087000 R11: 000000000000000a R12: 0000000000000036
> [    6.356583] R13: ffffc9001555ba18 R14: ffff8800bb145b58 R15: ffff8800bab10000
> [    6.356583] FS:  000002c2ecf717c0(0000) GS:ffff8800bf500000(0000) knlGS:0000$
> [    6.356583] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [    6.356583] CR2: 000006c2ecf7b000 CR3: 000000000194d000 CR4: 00000000000007f0
> [    6.356583] Stack:
> [    6.356583]  ffffc9001555b9f8 f4b9ed2e7f08ef51 000000000003602f ffff8800bb71$
> [    6.356583]  ffff8800bb6d0c70 0000000000000036 ffffc9001555ba58 ffffffff812f$
> [    6.356583]  ffff8800bb6d0a68 ffff8800bb71d680 ffffc9001555ba58 f4b9ed2e7f08$
> [    6.356583] Call Trace:
> [    6.356583]  [<ffffffff812fa70e>] diRead+0x7e/0x250
> [    6.356583]  [<ffffffff812f06c0>] jfs_iget+0x70/0x190
> [    6.356583]  [<ffffffff812f1034>] jfs_lookup+0xd4/0xe0
> [    6.356583]  [<ffffffff8119e8dc>] ? kmem_cache_alloc+0x3c/0x160
> [    6.356583]  [<ffffffff811cf315>] ? __d_alloc+0x35/0x1d0
> [    6.356583]  [<ffffffff813b643a>] ? __list_add+0x3a/0x80
> [    6.356583]  [<ffffffff811cf7ec>] ? d_alloc+0x6c/0xa0
> [    6.356583]  [<ffffffff811bbe28>] lookup_real+0x58/0xb0
> [    6.356583]  [<ffffffff811c2f33>] do_last.isra.58+0x7a3/0xf70
> [    6.356583]  [<ffffffff811c37d1>] path_openat+0xd1/0x690
> [    6.356583]  [<ffffffff811c4188>] do_filp_open+0x58/0xd0
> [    6.356583]  [<ffffffff811aca43>] do_sys_open+0x143/0x2d0
> [    6.356583]  [<ffffffff811acc13>] SyS_open+0x43/0x70
> [    6.356583]  [<ffffffff8193e3b8>] system_call_fastpath+0x16/0x1b
> [    6.356583] Code: 48 89 e5 48 83 ec 30 65 48 8b 04 25 28 00 00 00 48 89 45 d$
> [    6.356583] RIP  [<ffffffff812f9a2c>] ffffffff812f9a2c
> [    6.356583]  RSP <ffffc9001555b9c8>
> [    6.380024] general protection fault: 0000 [#2]
> [    6.443540] ---[ end trace 32a35fdec5a04e9e ]---
> 
> what are we seeing here? a jfs bug?

Can you trigger with the upstream kernel too? i.e. remove the grsec
stuff and retry.

Btw, your mail is somehow cutoff on the right-hand side with those '$'
chars...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
