Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaE0OAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:00:52 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:32947 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaE0OAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:00:51 -0400
Message-ID: <53849AF5.8040904@gmail.com>
Date: Tue, 27 May 2014 16:02:29 +0200
From: Francis Moreau <francis.moro@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: kernel 3.14.2 oops: seems related to EFI
References: <53777F7B.8060407@gmail.com> <20140518134206.GA8040@pd.tnic> <5379AE46.3000407@gmail.com> <20140520115421.GH4798@console-pimps.org>
In-Reply-To: <20140520115421.GH4798@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 01:54 PM, Matt Fleming wrote:
> On Mon, 19 May, at 09:09:58AM, Francis Moreau wrote:
>>
>> I don't know, I can't really afford to configure/compile/test this new
>> kernel, sorry.
> 
> It would be useful to know whether this issue still occurs when booting
> with the efi=old_map kernel parameter.
> 

the bug triggered:

[  +0.002872] BUG: unable to handle kernel paging request at
fffffffefd4a1e60
[  +0.000066] IP: [<ffffffff810648f8>] virt_efi_get_variable+0x48/0x80
[  +0.000054] PGD 280f067 PUD 0
[  +0.000031] Oops: 0000 [#1] PREEMPT SMP
[  +0.000039] Modules linked in: tun ses enclosure usb_storage loop fuse
joydev coretemp hwmon arc4 nls_iso8859_1 nls_c
[  +0.000691]  ac ext4 crc16 mbcache jbd2 hid_generic usbhid hid bcache
sd_mod sr_mod crc_t10dif cdrom crct10dif_common
[  +0.000289] CPU: 7 PID: 23293 Comm: systemd-udevd Tainted: G        W
   3.14.4-1-ARCH #1
[  +0.000057] Hardware name: CLEVO CO.                        W55xEU
                      /W55xEU
[  +0.000087] task: ffff88039557bae0 ti: ffff8802de764000 task.ti:
ffff8802de764000
[  +0.000050] RIP: 0010:[<ffffffff810648f8>]  [<ffffffff810648f8>]
virt_efi_get_variable+0x48/0x80
[  +0.000064] RSP: 0018:ffff8802de765e58  EFLAGS: 00010082
[  +0.000037] RAX: fffffffefd4a1e18 RBX: ffff8800da88f000 RCX:
0000000000000000
[  +0.000048] RDX: ffff8800da88f400 RSI: ffff8800da88f000 RDI:
00000000ffffffff
[  +0.000048] RBP: ffff8802de765e80 R08: ffff8802de765ec0 R09:
0000000000000000
[  +0.000047] R10: 0000000000000000 R11: 0000000000000246 R12:
ffff8800da88f400
[  +0.000048] R13: 0000000000000000 R14: ffff8802de765ec0 R15:
0000000000000000
[  +0.000048] FS:  00007f10751057c0(0000) GS:ffff88041e3c0000(0000)
knlGS:0000000000000000
[  +0.000054] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0.000040] CR2: fffffffefd4a1e60 CR3: 00000003c4afa000 CR4:
00000000001407e0
[  +0.000048] Stack:
[  +0.000016]  ffff8800da88f000 ffff8802de765ec0 ffffffff81b27c20
ffff8802de765f48
[  +0.000060]  3bc93ec9a0004bba ffff8802de765ea8 ffffffff813dbc91
ffff8800da88f000
[  +0.000060]  00007fffdc30c104 0000000000000004 ffff8802de765ef8
ffffffff81245779
[  +0.000060] Call Trace:
[  +0.000025]  [<ffffffff813dbc91>] efivar_entry_size+0x41/0x80
[  +0.000044]  [<ffffffff81245779>] efivarfs_file_read+0x49/0x100
[  +0.000044]  [<ffffffff811ba7d7>] vfs_read+0x97/0x160
[  +0.000037]  [<ffffffff811bb329>] SyS_read+0x59/0xd0
[  +0.000039]  [<ffffffff81517769>] system_call_fastpath+0x16/0x1b
[  +0.000041] Code: ce 4d 89 c7 e8 9a 06 00 00 65 ff 04 25 a0 c7 00 00
48 8b 05 1b d4 86 00 4d 89 f9 4d 89 f0 4c 89 e9
[  +0.000335] RIP  [<ffffffff810648f8>] virt_efi_get_variable+0x48/0x80
[  +0.000049]  RSP <ffff8802de765e58>
[  +0.000026] CR2: fffffffefd4a1e60
[  +0.016781] ---[ end trace 5a7017feeac75345 ]---

the sad thing is tht my system can't shutdown properly when it happens.

