Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaF3PNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:13:11 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53203 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaF3PNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:13:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140628170700.GA23634@xo-6d-61-c0.localdomain>
References: <55466fbd36df1d011876135cf7ca5d40c05029c7.1403809591.git.luto@amacapital.net>
 <20140626195629.GC5714@two.firstfloor.org> <CALCETrVBKno2skh3zR=1GYuojwPhYPLD=1HFcLMXjStS+0SPJQ@mail.gmail.com>
 <CALCETrWJD4kvoCxxb9y19uMakChmxamveKDceDOhyjYzFkJoUA@mail.gmail.com>
 <7919ae8b-958b-4b12-a5f4-8be2c3df3824@email.android.com> <CALCETrVkeTd4UJNm2ir3AMo1eLEr6CKK0Cf9_-NCO+DP+iTRxg@mail.gmail.com>
 <20140628170700.GA23634@xo-6d-61-c0.localdomain>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 30 Jun 2014 08:12:47 -0700
Message-ID: <CALCETrVGTPL9tuODBRW08-q_RrvR1q2kfnjRs3g8+r6vGsLrzw@mail.gmail.com>
Subject: Re: [PATCH] x86_64,entry: Fix RCX for traced syscalls
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        X86 ML <x86@kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 10:07 AM, Pavel Machek <pavel@ucw.cz> wrote:
> On Thu 2014-06-26 13:47:32, Andy Lutomirski wrote:
>> On Thu, Jun 26, 2014 at 1:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > The real question is if we care that sysret and iter don't match.  On 32 bits the situation is even more complex.
>>
>> At least for 64 bits, iret vs sysret is purely a kernel implementation
>> detail (except where a tracer modifies things that are inaccessible to
>> sysret), so ISTM it's worth one instruction to make them match.
>>
>> I noticed this thing while fiddling with moving some of the syscall
>> tracing logic to C.  This isn't a real problem, but it at least made
>> me scratch my head.
>
> If possible, we'd like to trace programs without programs being noticed they are
> being traced. See subterfugue utility, for example.
>
> It is certainly worth one extra instruction.

I tend to agree.

FWIW, I haven't looked at the ia32 stuff, but it should be possible to
do something similar if it's not there already.  The iret path can set
any user state it wants.

--Andy
