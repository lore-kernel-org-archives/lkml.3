Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbaHKTSN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:18:13 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaHKTSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:18:12 -0400
Message-ID: <53E916F0.80308@nod.at>
Date: Mon, 11 Aug 2014 21:18:08 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        sahne@0x90.at
Subject: Re: "resource: provide new functions to walk through resources" breaks
 UML
References: <53E7A42E.4090702@nod.at> <20140811122229.GA26869@redhat.com> <53E8B654.2000807@nod.at> <20140811184401.GE1863@redhat.com>
In-Reply-To: <20140811184401.GE1863@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 11.08.2014 20:44, schrieb Vivek Goyal:
> On Mon, Aug 11, 2014 at 02:25:56PM +0200, Richard Weinberger wrote:
>> Hi Vivek,
>>
>> Am 11.08.2014 14:22, schrieb Vivek Goyal:
>>> On Sun, Aug 10, 2014 at 06:56:14PM +0200, Richard Weinberger wrote:
>>>> Hi Vivek,
>>>>
>>>> Daniel Walter reported that UML is currently broken.
>>>> The offending commit is:
>>>>
>>>
>>> Hi Richard,
>>>
>>> Thanks for pointing it out. I will look into it.
>>>
>>> Would you have link to the report Daniel sent. I am interested in 
>>> looking at backtrace.
>>
>> he reported it on IRC to me.
>>
>> Here is a backtrace:
>> RIP: 0033:[<0000000060039b9f>]
>> RSP: 0000000081459da0  EFLAGS: 00010202
>> RAX: 0000000000000000 RBX: 00000000219b3fff RCX: 000000006010d1d9
>> RDX: 0000000000000001 RSI: 00000000602dfb94 RDI: 0000000081459df8
>> RBP: 0000000081459de0 R08: 00000000601b59f4 R09: ffffffff0000ff00
>> R10: ffffffff0000ff00 R11: 0000000081459e88 R12: 0000000081459df8
>> R13: 00000000219b3fff R14: 00000000602dfb94 R15: 0000000000000000
>> Kernel panic - not syncing: Segfault with no mm
>> CPU: 0 PID: 1 Comm: swapper Not tainted 3.16.0-10454-g58d08e3 #13
>> Stack:
>>  00000000 000080d0 81459df0 219b3fff
>>  81459e70 6010d1d9 ffffffff 6033e010
>>  81459e50 6003a269 81459e30 00000000
>> Call Trace:
>>  [<6010d1d9>] ? kclist_add_private+0x0/0xe7
>>  [<6003a269>] walk_system_ram_range+0x61/0xb7
>>  [<6000e859>] ? proc_kcore_init+0x0/0xf1
>>  [<6010d574>] kcore_update_ram+0x4c/0x168
>>  [<6010d72e>] ? kclist_add+0x0/0x2e
>>  [<6000e943>] proc_kcore_init+0xea/0xf1
>>  [<6000e859>] ? proc_kcore_init+0x0/0xf1
>>  [<6000e859>] ? proc_kcore_init+0x0/0xf1
>>  [<600189f0>] do_one_initcall+0x13c/0x204
>>  [<6004ca46>] ? parse_args+0x1df/0x2e0
>>  [<6004c82d>] ? parameq+0x0/0x3a
>>  [<601b5990>] ? strcpy+0x0/0x18
>>  [<60001e1a>] kernel_init_freeable+0x240/0x31e
>>  [<6026f1c0>] kernel_init+0x12/0x148
>>  [<60019fad>] new_thread_handler+0x81/0xa3
>>
>> RIP is at kernel/resource.c:66.
> 
> Hi Richard,
> 
> Can you please give the attached patch a try and see if it fixes the UML
> issue.
> 
> I noticed that previous code had a for() loop which will not execute
> if p was null. I have resorted back to same code now. 

Looks good!

Reported-by: Daniel Walter <sahne@0x90.at>
Tested-by: Richard Weinberger <richard@nod.at>

Thanks,
//richard
