Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3GDLIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:08:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756152Ab3GDLIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:08:17 -0400
Message-ID: <51D55798.5090404@redhat.com>
Date: Thu, 04 Jul 2013 13:08:08 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>
CC: Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
        Avi Kivity <avi.kivity@gmail.com>
Subject: Re: [PATCH] x86/kvm/emulate.c: simplify NOP (opcode 0x90) check
References: <1372928309-16488-1-git-send-email-dvlasenk@redhat.com> <20130704091345.GB5113@redhat.com> <51D55728.4060909@redhat.com>
In-Reply-To: <51D55728.4060909@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 04/07/2013 13:06, Denys Vlasenko ha scritto:
>>> >> -	case 0x90 ... 0x97: /* nop / xchg reg, rax */
>>> >> -		if (ctxt->dst.addr.reg == reg_rmw(ctxt, VCPU_REGS_RAX))
>>> >> -			break;
>>> >> +	case 0x90: /* nop */
>>> >> +		break;
>> > This does not work on 64bit and REX prefix.
> Can you elaborate?
> 
> 0x90 is special-cased in CPU to be a NOP regardless of bit width.
> IOW, xchg %eax,%eax ordinarily would clear upper 32 bits of %rax,
> but 0x90 doesn't do that.
> 
> Do you mean that with REX.R==1, 0x90 will refer to R8?

Yes.

$ echo 'xchg %rax,%r8' | as
$ objdump -d a.out

a.out:     file format elf64-x86-64

Disassembly of section .text:

0000000000000000 <.text>:
   0:	49 90                	xchg   %rax,%r8


Paolo
