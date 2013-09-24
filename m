Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3IXG3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:29:32 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:50347 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab3IXG3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:29:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAFrcx1m=3_74SiVecGF14DF827UzAwprNZMVVGRa46aqqVGATw@mail.gmail.com>
References: <CAPoNrtuuMn=Bm9Mo=PsJfJp6DMQaM-Eaz5An+0+DXL2=uObndg@mail.gmail.com>
	<CAFrcx1m=3_74SiVecGF14DF827UzAwprNZMVVGRa46aqqVGATw@mail.gmail.com>
Date: Tue, 24 Sep 2013 11:59:30 +0530
Message-ID: <CAPoNrtsrTVA+mcYUO_0bRa9vHBPsfrLh6aGHGzZANTX_gO3VTw@mail.gmail.com>
Subject: Re: [Query] Stack Overflow in "arch/arm/kernel/unwind.c" while
 unwinding frame
From: Anurag Aggarwal <anurag19aggarwal@gmail.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: linux@arm.linux.org.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

I don't think that it is related to the warning that you have suggested

On Tue, Sep 24, 2013 at 11:58 AM, Jean Pihet <jean.pihet@linaro.org> wrote:
> Hi,
>
> Adding Russell and l.a.k ML.
>
> Another question: is this linked to the following build warning?
>   CC      arch/arm/kernel/return_address.o
> arch/arm/kernel/return_address.c:63:2: warning: #warning "TODO:
> return_address should use unwind tables"
>
> Regards,
> Jean
>
> On 24 September 2013 07:23, Anurag Aggarwal <anurag19aggarwal@gmail.com> wrote:
>> Hi All,
>>
>> While executing unwind backtrace instructions in ARM, in the function
>> unwind_exec_insn()
>> there are chances that SP overflows from stack.
>>
>>
>> For example while executing instruction with opcode 0xAE, vsp can go
>> beyond stack to area that has not been allocated till now.
>>
>> unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
>> int reg;
>>
>> /* pop R4-R[4+bbb] */
>> for (reg = 4; reg <= 4 + (insn & 7); reg++)
>> ctrl->vrs[reg] = *vsp++;
>>
>> The above scenario can happen while executing any of the unwind instruction.
>>
>> One of the ways to fix the problem is to check for vsp with stack
>> limits before we increment it, but doing it for all the instructions
>> seems a little bad.
>>
>> I just want to know that if anyone has faced the problem before
>>
>> I am working on Linux kernel for Android phones and I saw one case
>> when this happened.
>>
>> I am new to Linux Kernel so not sure if this is the right place to ask
>> the question.
>>
>>
>> --
>> Anurag Aggarwal
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Anurag Aggarwal
