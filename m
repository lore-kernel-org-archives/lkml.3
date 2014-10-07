Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496AbaJGUDg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 16:03:36 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:42499 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaJGUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 16:03:35 -0400
Message-ID: <54344714.1000600@gmail.com>
Date: Tue, 07 Oct 2014 13:03:32 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Rich Felker <dalias@libc.org>,
        Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Matthew Fortune <Matthew.Fortune@imgtec.com>,
        David Daney <david.s.daney@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org> <543431DA.4090809@imgtec.com> <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com> <20141007190943.GM23797@brightrain.aerifal.cx> <54343C2B.2080801@imgtec.com> <20141007192107.GN23797@brightrain.aerifal.cx> <CALCETrU8qPL1qKGk7FqM=LCnoeSfuwDV_bG_a=5zcOKtWfkdGw@mail.gmail.com>
In-Reply-To: <CALCETrU8qPL1qKGk7FqM=LCnoeSfuwDV_bG_a=5zcOKtWfkdGw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 12:28 PM, Andy Lutomirski wrote:
> On Tue, Oct 7, 2014 at 12:21 PM, Rich Felker <dalias@libc.org> wrote:
>> On Tue, Oct 07, 2014 at 12:16:59PM -0700, Leonid Yegoshin wrote:
>>> On 10/07/2014 12:09 PM, Rich Felker wrote:
>>>> I agree completely here. We should not break things (or, as it
>>>> seems, leave them broken) for common usage cases that affect
>>>> everyone just to coddle proprietary vendor-specific instructions.
>>>> The latter just should not be used in delay slots unless the chip
>>>> vendor also promises to provide fpu branch in hardware. Rich
>>> And what do you propose - remove a current in-stack emulation and
>>> you still think it doesn't break a status-quo?
>>
>> The in-stack trampoline support could be left but used only for
>> emulating instructions the kernel doesn't know. This would make all
>> normal binaries immediately usable with non-executable stack, and
>> would avoid the only potential source of regressions. Ultimately I
>> think the "xol" stuff should be removed, but that could be a long term
>> goal.
>
> Does anything break if the xol stuff is disabled for PT_GNU_STACK tasks?
>

The instructions must be executed, if you turn on a non-executable 
stack, you cannot execute them on the stack, so they must be handled in 
another way, which is the subject of this thread.

Options:

1a) XOL kernel manages the memory
1b) XOL userspace manages the menory
2) Emulate the instructions.
3) I don't think there is a 3rd. option.

As the imgtec people have said, you have to do #2 for their new r6 ISA, 
as it uses PC relative instructions.

I really think we should bite the bullet and do #2 for everything, it 
will be the cleanest long term solutions.

David Daney
