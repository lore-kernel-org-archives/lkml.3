Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaLOQin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 11:38:43 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36719 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaLOQii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 11:38:38 -0500
Message-ID: <548F0E88.5010504@kernel.dk>
Date: Mon, 15 Dec 2014 09:38:32 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Christoph Hellwig <hch@infradead.org>, ming.lei@canonical.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: blk-mq oops with today's Linus' kernel
References: <20141215151907.GA22895@quack.suse.cz> <548EFC4B.4010307@kernel.dk> <548EFE7D.4020400@kernel.dk> <20141215153515.GB22895@quack.suse.cz> <20141215163731.GA24859@quack.suse.cz>
In-Reply-To: <20141215163731.GA24859@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2014 09:37 AM, Jan Kara wrote:
> On Mon 15-12-14 16:35:15, Jan Kara wrote:
>> On Mon 15-12-14 08:30:05, Jens Axboe wrote:
>>> On 12/15/2014 08:20 AM, Jens Axboe wrote:
>>>> On 12/15/2014 08:19 AM, Jan Kara wrote:
>>>>>    Hello,
>>>>>
>>>>>    when running xfstests with today's Linus' kernel I've got the
>>>>> following
>>>>> oops:
>>>>> BUG: unable to handle kernel paging request at 0000001000000a28
>>>>> IP: [<ffffffff810ad9f3>] autoremove_wake_function+0x23/0x40
>>>>> PGD 7f566067 PUD 0
>>>>> Oops: 0002 [#1] SMP
>>>>> Modules linked in: ext4 jbd2 crc16 netconsole loop raid6_pq
>>>>> zlib_deflate lzo_compress xor
>>>>> CPU: 4 PID: 0 Comm: swapper/4 Not tainted 3.18.0-xen+ #19
>>>>> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>>>>> task: ffff88007e8fa310 ti: ffff88007e900000 task.ti: ffff88007e900000
>>>>> RIP: 0010:[<ffffffff810ad9f3>]  [<ffffffff810ad9f3>]
>>>>> autoremove_wake_function+0x23/0x40
>>>>> RSP: 0018:ffff88007f103d78  EFLAGS: 00010002
>>>>> RAX: 0000000000000000 RBX: ffff88005140f948 RCX: ffff88005140f960
>>>>> RDX: 0000001000000a20 RSI: 0000000000000001 RDI: ffffffff813c2e1f
>>>>> RBP: ffff88007f103d88 R08: 0000000000000001 R09: 0000000000000000
>>>>> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
>>>>> R13: 0000000000000001 R14: ffff88007a3bd640 R15: 0000000000000000
>>>>> FS:  00007ff3b5dc8700(0000) GS:ffff88007f100000(0000)
>>>>> knlGS:0000000000000000
>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>>>>> CR2: 0000001000000a28 CR3: 000000007a580000 CR4: 00000000000006e0
>>>>> Stack:
>>>>>   ffff880000000000 ffff88007a3bd628 ffff88007f103dc8 ffffffff810ad8d2
>>>>>   0000000300000000 ffff88007a3bd608 0000000000000000 0000000000000001
>>>>>   0000000000000082 0000000000000003 ffff88007f103e08 ffffffff810adf73
>>>>> Call Trace:
>>>>>   <IRQ>
>>>>>   [<ffffffff810ad8d2>] __wake_up_common+0x52/0x80
>>>>>   [<ffffffff810adf73>] __wake_up+0x43/0x70
>>>>>   [<ffffffff8121d94e>] bt_clear_tag+0xae/0xc0
>>>>>   [<ffffffff8121d98b>] blk_mq_put_tag+0x2b/0x50
>>>>>   [<ffffffff8121ab10>] __blk_mq_free_request+0x40/0xc0
>>>>>   [<ffffffff8121abc1>] blk_mq_free_hctx_request+0x31/0x40
>>>>>   [<ffffffff8121abff>] blk_mq_free_request+0x2f/0x40
>>>>>   [<ffffffff8121b047>] blk_mq_end_request+0x57/0x60
>>>>>   [<ffffffff81214f73>] blk_flush_complete_seq+0x293/0x2d0
>>>>>   [<ffffffff81215373>] flush_end_io+0x113/0x210
>>>>>   [<ffffffff8121b029>] blk_mq_end_request+0x39/0x60
>>>>>   [<ffffffff812d3f46>] virtblk_request_done+0x36/0x80
>>>>>   [<ffffffff81219d1e>] __blk_mq_complete_request_remote+0xe/0x10
>>>>>   [<ffffffff810e1d82>]
>>>>> generic_smp_call_function_single_interrupt+0x72/0x120
>>>>>   [<ffffffff810657d2>] smp_call_function_single_interrupt+0x22/0x30
>>>>>   [<ffffffff813c4462>] call_function_single_interrupt+0x72/0x80
>>>>>   <EOI>
>>>>>   [<ffffffff8106e606>] ? native_safe_halt+0x6/0x10
>>>>>   [<ffffffff810b65bd>] ? trace_hardirqs_on+0xd/0x10
>>>>>   [<ffffffff8104520e>] default_idle+0xe/0x20
>>>>>   [<ffffffff8104509a>] arch_cpu_idle+0xa/0x10
>>>>>   [<ffffffff810ae64f>] cpu_startup_entry+0x2af/0x310
>>>>>   [<ffffffff81066c8d>] start_secondary+0x15d/0x180
>>>>> Code: 64 4a ff ff c9 c3 66 90 55 48 89 e5 53 48 89 fb 48 83
>>>>> ec 08 e8 4f 4a ff ff 85 c0 89 c6 74 1b 48 8b 53 18 48 8b 43 20 48 8d
>>>>> 4b 18
>>>>> <48> 89 42 08 48 89 10 48 89 4b 18 48 89 4b 20 48 83 c4 08 89 f0
>>>>> RIP  [<ffffffff810ad9f3>] autoremove_wake_function+0x23/0x40
>>>>>   RSP <ffff88007f103d78>
>>>>> CR2: 0000001000000a28
>>>>> ---[ end trace d4dc64619e0b4713 ]---
>>>>
>>>> Is this easily reproducible? If so, could you try and revert
>>>> 52f7eb945f2ba62b324bb9ae16d945326a961dcf and see if that helps?
>>>
>>> Re-checking that patch, it is broken. Reverting that should fix it
>>> up for you, I'll send that in in a bit...
>>    I'm running a test with that patch reverted. I'll see whether it fixes
>> the problem in about 20 minutes.
>    The revert seems to fix the issue for me.

Thanks for confirming, I was pretty sure this was the problem. I'll get 
the revert sent in today.

-- 
Jens Axboe

