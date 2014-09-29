Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaI2U3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 16:29:44 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:64512 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaI2U3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 16:29:43 -0400
MIME-Version: 1.0
In-Reply-To: <5429BAA7.8060406@zytor.com>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com>
 <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de>
 <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com>
 <alpine.DEB.2.02.1409292135090.22082@ionos.tec.linutronix.de>
 <5429B664.4060003@zytor.com> <alpine.DEB.2.02.1409292152270.22082@ionos.tec.linutronix.de>
 <5429BAA7.8060406@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Sep 2014 13:29:22 -0700
Message-ID: <CALCETrW-b_61Fqdo3ckxochLqcEs_hQK5Pu7t=y46M=_YBx=tQ@mail.gmail.com>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Sebastian Lackner <sebastian@fds-team.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 1:01 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 09/29/2014 12:57 PM, Thomas Gleixner wrote:
>>
>>> I think we should mask the bit anyway.
>>
>> I tend to disagree. If we clear it there we need to consequentely
>> audit ALL other possibilites and if there are any we need to clear the
>> bit there as well. Just to make buggy user space happy?
>>
>
> The entry options into the kernel are: interrupt/exception (already
> known to be OK),

> SYSENTER32,

I don't immediately see how to fix that without adding overhead.
Maybe do it in CLEAR_RREGS?  This won't do any good if EFI ever starts
using IRET, though.  We could suck it up and fix it on entry, adding
maybe ten cycles (wild guess).

> SYSCALL32

This should happen for free if we fix SYSCALL64, I think.

Also, I thought entry_64.S was a mess.  Eww, ia32entry.S.

I can try to write the patch later today.  But I don't want to touch
the actual 32-bit kernel code -- I'll stick to the 64-bit native and
compat stuff, thanks.

--Andy

 and SYSCALL64.  It is not too
> much to work through those issues, I don't think.
>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
