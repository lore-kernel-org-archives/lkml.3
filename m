Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbaAMQ2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:28:49 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:11724 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbaAMQ2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:28:46 -0500
Message-ID: <1389630165.1792.180.camel@misato.fc.hp.com>
Subject: Re: [PATCH 0/4] EFI memmap fix v2
From: Toshi Kani <toshi.kani@hp.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Dave Young <dyoung@redhat.com>
Date: Mon, 13 Jan 2014 09:22:45 -0700
In-Reply-To: <1389473370-1940-1-git-send-email-bp@alien8.de>
References: <1389473370-1940-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 21:49 +0100, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
> 
> Ok, here's v2 rebased and rediffed against tip (which has the relevant
> efi branches).
> 
> Toshi, I'm pushing it to:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git#efi-fixes
> 
> so that you can give it another run and so that the build robot can poke
> at it.

I tested the 4 patches on top of Matt's efi tree under kexec branch.
Unfortunately, it hit the same panic again...  I will send you the full
dmesg with EFI_PGT_DBG enabled in a separate email.  I will also test
your git tree as well. 

Thanks,
-Toshi

BUG: unable to handle kernel paging request at 00000207fec34020
IP: [<0000000072dcda76>] 0x72dcda76
PGD 0
Oops: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.13.0-rc1+ #82
Hardware name: HP CB920s x1, BIOS Bundle: 005.028.018 SFW: 012.124.000
10/28/2013
task: ffffffff81a10480 ti: ffffffff81a00000 task.ti: ffffffff81a00000
RIP: 0010:[<0000000072dcda76>]  [<0000000072dcda76>] 0x72dcda76
RSP: 0000:ffffffff81a01df8  EFLAGS: 00010206
RAX: 00000000725fee18 RBX: 00000000725feda0 RCX: 00000207fec34000
RDX: 0000000072dfe070 RSI: 0000000060000202 RDI: 0000000072dcdac8
RBP: 0000000072dd0560 R08: 0000000000000000 R09: 000000000000001d
R10: 0000000000000030 R11: 8000000000000000 R12: ffff8a07fec34000
R13: 0000000000000001 R14: 0000000000000570 R15: 000000000009c000
FS:  0000000000000000(0000) GS:ffff88087fa00000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000207fec34020 CR3: 000000000009c000 CR4: 00000000000406b0
Stack:
 0000000072dfb88f 0000000000000001 0000000000002643 0000000000000000
 ffffffff81ace2a8 0000000072dcdac8 0000000072dcdb93 0000000000000001
 ffffffff81a01f80 0000000000000570 ffff8a07fffbc000 0000000000000000
Call Trace:
 [<ffffffff81046a4c>] ? efi_call4+0x6c/0xf0
 [<ffffffff81b05a7a>] ? efi_enter_virtual_mode+0x35d/0x524
 [<ffffffff81aede1d>] ? start_kernel+0x397/0x431
 [<ffffffff81aed88f>] ? repair_env_string+0x5c/0x5c
 [<ffffffff81aed5a3>] ? x86_64_start_reservations+0x2a/0x2c
 [<ffffffff81aed696>] ? x86_64_start_kernel+0xf1/0xf4
Code:  Bad RIP value.
RIP  [<0000000072dcda76>] 0x72dcda76
 RSP <ffffffff81a01df8>
CR2: 00000207fec34020
---[ end trace b50fb077cda23ee8 ]---



