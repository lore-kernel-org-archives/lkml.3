Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3JBSMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 14:12:14 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53681 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753184Ab3JBSMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 14:12:13 -0400
Date: Wed, 2 Oct 2013 19:11:17 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Query] Stack Overflow in "arch/arm/kernel/unwind.c" while
 unwinding frame
Message-ID: <20131002181116.GH29794@arm.com>
References: <CAPoNrtuuMn=Bm9Mo=PsJfJp6DMQaM-Eaz5An+0+DXL2=uObndg@mail.gmail.com>
 <CAFrcx1m=3_74SiVecGF14DF827UzAwprNZMVVGRa46aqqVGATw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFrcx1m=3_74SiVecGF14DF827UzAwprNZMVVGRa46aqqVGATw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 September 2013 07:23, Anurag Aggarwal <anurag19aggarwal@gmail.com> wrote:
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

I haven't seen it but I think with some stack (or unwind bytecode)
corruption it could happen.

I think we could place some checks only when vsp is assigned and return
-URC_FAILURE, together with some warning.

-- 
Catalin
