Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbaJASpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 14:45:13 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:52680 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbaJASpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 14:45:06 -0400
MIME-Version: 1.0
In-Reply-To: <542C496F.80003@zytor.com>
References: <cover.1412187233.git.luto@amacapital.net> <bf6fb790787eb95b922157838f52712c25dda157.1412187233.git.luto@amacapital.net>
 <542C496F.80003@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 Oct 2014 11:44:44 -0700
Message-ID: <CALCETrUgdUXEiwpa3W75o3ivamPXkZ=qjKuxPW2sSzxG_zhjFg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] x86_64: Don't save flags on context switch
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Sebastian Lackner <sebastian@fds-team.de>,
        Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 1, 2014 at 11:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 10/01/2014 11:28 AM, Andy Lutomirski wrote:
>>
>>  #define __EXTRA_CLOBBER  \
>>       , "rcx", "rbx", "rdx", "r8", "r9", "r10", "r11", \
>> -       "r12", "r13", "r14", "r15"
>> +       "r12", "r13", "r14", "r15", "flags"
>>
>
> I was under the impression that gcc *always* assumes the flags were
> clobbered for an asm statement.  Otherwise I think we'd have a lot of
> problems.
>

I have no idea, but I doubt that adding the explicit "flags" clobber
hurts, and it will make other people who are unsure about this less
worried.

--Andy

>         -hpa
>
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
