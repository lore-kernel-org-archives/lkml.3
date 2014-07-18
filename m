Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762012AbaGRT5z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 15:57:55 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41519 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbaGRT5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 15:57:53 -0400
MIME-Version: 1.0
In-Reply-To: <53C97287.5020509@zytor.com>
References: <20140718150005.73db8eb9@canb.auug.org.au> <53C97287.5020509@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 18 Jul 2014 12:57:32 -0700
Message-ID: <CALCETrXs4fdKDA1C4ts3qzgbB6PrmCZZyK3R4cBLaO9RbBp0YA@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 12:16 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/17/2014 10:00 PM, Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the tip tree, today's linux-next build (x86_64
>> allmodconfig) produced these warnings:
>>
>> In file included from arch/x86/vdso/vdso2c.c:161:0:
>> arch/x86/vdso/vdso2c.c: In function 'main':
>> arch/x86/vdso/vdso2c.h:118:6: warning: assuming signed overflow
>> does not occur when assuming that (X + c) < X is always false
>> [-Wstrict-overflow] In file included from
>> arch/x86/vdso/vdso2c.c:165:0: arch/x86/vdso/vdso2c.h:118:6:
>> warning: assuming signed overflow does not occur when assuming that
>> (X + c) < X is always false [-Wstrict-overflow]
>>
>> Probably introduced by commit e6577a7ce99a ("x86, vdso: Move the
>> vvar area before the vdso text").
>>
>
> This seems toxic.
>
> I always wonder if we shouldn't use -fwrapv for the kernel...

This particular warning is IMO in a particularly dumb category: GCC
optimizes some code and then warns about a construct that wasn't there
in the original code.  In this case, I think it unrolled a loop and
discovered that one iteration contained a test that was always true.
Big deal.

(OTOH, the code in question was buggy, but not all for the reason that
GCC thought it was.)

--Andy

>
>         -hpa
>



-- 
Andy Lutomirski
AMA Capital Management, LLC
