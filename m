Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750800Ab3IXG2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:28:14 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:51294 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3IXG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:28:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAPoNrtuuMn=Bm9Mo=PsJfJp6DMQaM-Eaz5An+0+DXL2=uObndg@mail.gmail.com>
References: <CAPoNrtuuMn=Bm9Mo=PsJfJp6DMQaM-Eaz5An+0+DXL2=uObndg@mail.gmail.com>
Date: Tue, 24 Sep 2013 08:28:12 +0200
Message-ID: <CAFrcx1m=3_74SiVecGF14DF827UzAwprNZMVVGRa46aqqVGATw@mail.gmail.com>
Subject: Re: [Query] Stack Overflow in "arch/arm/kernel/unwind.c" while
 unwinding frame
From: Jean Pihet <jean.pihet@linaro.org>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>, linux@arm.linux.org.uk
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Adding Russell and l.a.k ML.

Another question: is this linked to the following build warning?
  CC      arch/arm/kernel/return_address.o
arch/arm/kernel/return_address.c:63:2: warning: #warning "TODO:
return_address should use unwind tables"

Regards,
Jean

On 24 September 2013 07:23, Anurag Aggarwal <anurag19aggarwal@gmail.com> wrote:
> Hi All,
>
> While executing unwind backtrace instructions in ARM, in the function
> unwind_exec_insn()
> there are chances that SP overflows from stack.
>
>
> For example while executing instruction with opcode 0xAE, vsp can go
> beyond stack to area that has not been allocated till now.
>
> unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> int reg;
>
> /* pop R4-R[4+bbb] */
> for (reg = 4; reg <= 4 + (insn & 7); reg++)
> ctrl->vrs[reg] = *vsp++;
>
> The above scenario can happen while executing any of the unwind instruction.
>
> One of the ways to fix the problem is to check for vsp with stack
> limits before we increment it, but doing it for all the instructions
> seems a little bad.
>
> I just want to know that if anyone has faced the problem before
>
> I am working on Linux kernel for Android phones and I saw one case
> when this happened.
>
> I am new to Linux Kernel so not sure if this is the right place to ask
> the question.
>
>
> --
> Anurag Aggarwal
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
