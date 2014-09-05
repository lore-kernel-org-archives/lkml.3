Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312AbaIEMbK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:31:10 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:49835 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756934AbaIEMbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:31:08 -0400
Message-ID: <5409AD9A.4030206@gmail.com>
Date: Fri, 05 Sep 2014 14:33:30 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-efi@vger.kernel.org
Subject: Re: oops on kernel 3.14.17 seems related to EFI
References: <54095D73.7010907@gmail.com> <20140905120904.GN3001@console-pimps.org>
In-Reply-To: <20140905120904.GN3001@console-pimps.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 02:09 PM, Matt Fleming wrote:
> (Adding linux-efi)
> 
> On Fri, 05 Sep, at 08:51:31AM, Francis Moreau wrote:
>> [  +0.000045] RIP: 0010:[<0000000000000000>]  [<          (null)>]      (null)
>> [  +0.000046] RSP: 0018:ffff8800b4001da8  EFLAGS: 00010002
>> [  +0.000032] RAX: 0000000080050033 RBX: ffff880406288000 RCX: ffff880406288000
>> [  +0.000041] RDX: ffff880406288400 RSI: ffff880406288000 RDI: 0000000000000000
>> [  +0.000042] RBP: ffff8800b4001e80 R08: 0000000000000000 R09: ffff8800b4001ec0
>> [  +0.000042] R10: 0000000000000000 R11: 0000000000000246 R12: ffff880406288400
>> [  +0.000042] R13: 0000000000000000 R14: ffff8800b4001ec0 R15: 000000000009b000
>> [  +0.000042] FS:  00007f7720a567c0(0000) GS:ffff88041e2c0000(0000) knlGS:0000000000000000
>> [  +0.000048] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  +0.000034] CR2: 0000000000000000 CR3: 000000000009b000 CR4: 00000000001427e0
>> [  +0.000042] Stack:
>> [  +0.000014]  ffffffff81063281 ffffffff811bd95c 0000000000000246 ffff8800da9e6628
>> [  +0.000052]  8000000300000000 0000000000000000 0000000000000000 ffff8800b4001e50
>> [  +0.000051]  0000000080050033 00007f7722abbc50 00007f7722abbb50 00ffffffffffffff
>> [  +0.000052] Call Trace:
>> [  +0.000022]  [<ffffffff81063281>] ? efi_call5+0x71/0xf0
>> [  +0.000035]  [<ffffffff811bd95c>] ? getname_flags+0x2c/0x130
>> [  +0.000037]  [<ffffffff81062649>] ? virt_efi_get_variable+0x49/0x60
>> [  +0.000051]  [<ffffffff813d0181>] efivar_entry_size+0x41/0x80
>> [  +0.000030]  [<ffffffff8123aec9>] efivarfs_file_read+0x49/0x100
>> [  +0.000046]  [<ffffffff811b2077>] vfs_read+0x97/0x160
>> [  +0.000041]  [<ffffffff811b2bc9>] SyS_read+0x59/0xd0
>> [  +0.000041]  [<ffffffff81509e29>] system_call_fastpath+0x16/0x1b
> 
> This looks like efi.systab->runtime->get_variable is NULL.
> 
> Could you send a copy of the dmesg buffer? It might contain some info to
> explain this issue.

Unfortunately, I haven't kept a copy of it.

> 
> Also, is this a regression? If so it would be excellent if you could
> pinpoint the commit that causes the problem, using git bisect.
> 

it's been a while now I'm stuck to 3.14 (later kernels oops for other
reasons) so I don't really remember. I would say no but I'm really not sure.

Thanks
