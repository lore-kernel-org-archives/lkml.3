Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaBEVpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 16:45:35 -0500
Received: from relay1.sgi.com ([192.48.179.29]:50336 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750AbaBEVpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 16:45:32 -0500
Date: Wed, 5 Feb 2014 15:45:36 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140205214536.GT3034@sgi.com>
References: <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <52EAD0F2.7090101@zytor.com>
 <20140131100722.GA21873@pd.tnic>
 <20140131140220.GC22498@sgi.com>
 <20140131142318.GC21873@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131142318.GC21873@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 03:23:18PM +0100, Borislav Petkov wrote:
> And now my question:
> 
> How can I reliably find out which region contains that
> uv_systab.function call?
> 
> I need it so that I can map it in the EFI page table and you can
> continue to call that function and you can get back to your reliable way
> to boot.

While working on an answer to this question, I ran across another issue
on some newer hardware, that looks like it's definitely related to this
problem, and might be the root cause.

When booting on a UV2 we die in efi_enter_virtual_mode:

BUG: unable to handle kernel paging request at 0000008f7e848020
IP: [<000000007dadb6a9>] 0x7dadb6a8
PGD 0
Oops: 0000 [#1] SMP
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-medusa-00038-gd2f7cbe #821
Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
task: ffffffff817ae400 ti: ffffffff8179e000 task.ti: ffffffff8179e000
RIP: 0010:[<000000007dadb6a9>]  [<000000007dadb6a9>] 0x7dadb6a8
RSP: 0000:ffffffff8179fd90  EFLAGS: 00010202
RAX: 000000007d9b8e01 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 000000007db074f8 RSI: 000000007d9b8e18 RDI: 0000008f7e848000
RBP: 000000007db074f8 R08: 0000000000000001 R09: 0000008f7e848000
R10: 0000000000000030 R11: ffff880ffffda000 R12: 8000000000000000
R13: 000077ff80000000 R14: ffff888f7e848000 R15: 000000000009b000
FS:  0000000000000000(0000) GS:ffff880fffc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000008f7e848020 CR3: 000000000009b000 CR4: 00000000000406b0
Stack:
 fffffffef6000000 0000000000000000 0000000000000000 80000000000001e3
 0000000000000030 000000007dadd540 0000000000001f20 0000000060000202
 000000007d9b8da0 000000007daf8c6b ffffffff810fd2bc 00000000000000d0
Call Trace:
 [<ffffffff810fd2bc>] ? cache_grow+0x1e5/0x236
 [<ffffffff8103adac>] ? efi_call4+0x6c/0xf0
 [<ffffffff8186452f>] ? efi_enter_virtual_mode+0x1ac/0x328
 [<ffffffff8184de98>] ? start_kernel+0x35b/0x3ed
 [<ffffffff8184d950>] ? repair_env_string+0x60/0x60
 [<ffffffff8184d479>] ? x86_64_start_reservations+0x2e/0x30
 [<ffffffff8184d5a3>] ? x86_64_start_kernel+0x128/0x12f
Code:  Bad RIP value.
RIP  [<000000007dadb6a9>] 0x7dadb6a8
 RSP <ffffffff8179fd90>
CR2: 0000008f7e848020

Let me know what other information you need and I'll get it to you ASAP.

Thanks!

- Alex
