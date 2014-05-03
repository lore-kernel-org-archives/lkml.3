Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaECNyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 09:54:20 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:46997 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaECNyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 09:54:19 -0400
MIME-Version: 1.0
In-Reply-To: <536488C2.8040106@zytor.com>
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
	<CA+55aFwmhOGRv0Z7Sqgk08pTOYDJg4C9GB_XNHRAtiCLFrHG1g@mail.gmail.com>
	<536488C2.8040106@zytor.com>
Date: Sat, 3 May 2014 06:54:18 -0700
X-Google-Sender-Auth: Seyzb2SbxT8IzMhxqdB-Dq6pZew
Message-ID: <CA+55aFzSmm=UiK0WA7yPRojNBuOHhVYSYOFqeyXQUDd0ungNUQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 11:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/02/2014 09:32 PM, Linus Torvalds wrote:
>>
>> At least as a proof-of-concept, having a code sequence in user mode
>> trampoline that does
>>
>>    popq %rsi
>>    popq %r11
>>    retq $128
>>
>> and building up a stack in user space at '%rsp-128' that has the
>> values or rsi/r11/rip should allow us to use 'sysret'. Hmm?
>
> That would be a security hole if another userspace thread could muck
> with the stack.

No, all of the above is in user space, and the pre-restore register
values for rsi/r11/rip/rsp are all user space values (just not the
right ones for the "real" return point). So no security issue.

Now, replacing "iret" with "sysret + user-space trampoline" doesn't
work in general (it gets RF wrong, for example, so it's useless for
single-stepping and breakpoint handling), but I was more thinking that
it would be an interesting way to see what the performance impact of a
faster iret would be.

              Linus
