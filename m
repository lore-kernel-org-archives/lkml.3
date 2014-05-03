Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaECTAt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 15:00:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60995 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbaECTAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 15:00:48 -0400
Message-ID: <53653CC8.1050900@zytor.com>
Date: Sat, 03 May 2014 12:00:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>	<CA+55aFwmhOGRv0Z7Sqgk08pTOYDJg4C9GB_XNHRAtiCLFrHG1g@mail.gmail.com>	<536488C2.8040106@zytor.com> <CA+55aFzSmm=UiK0WA7yPRojNBuOHhVYSYOFqeyXQUDd0ungNUQ@mail.gmail.com>
In-Reply-To: <CA+55aFzSmm=UiK0WA7yPRojNBuOHhVYSYOFqeyXQUDd0ungNUQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2014 06:54 AM, Linus Torvalds wrote:
> On Fri, May 2, 2014 at 11:12 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 05/02/2014 09:32 PM, Linus Torvalds wrote:
>>>
>>> At least as a proof-of-concept, having a code sequence in user mode
>>> trampoline that does
>>>
>>>    popq %rsi
>>>    popq %r11
>>>    retq $128
>>>
>>> and building up a stack in user space at '%rsp-128' that has the
>>> values or rsi/r11/rip should allow us to use 'sysret'. Hmm?
>>
>> That would be a security hole if another userspace thread could muck
>> with the stack.
> 
> No, all of the above is in user space, and the pre-restore register
> values for rsi/r11/rip/rsp are all user space values (just not the
> right ones for the "real" return point). So no security issue.
> 
> Now, replacing "iret" with "sysret + user-space trampoline" doesn't
> work in general (it gets RF wrong, for example, so it's useless for
> single-stepping and breakpoint handling), but I was more thinking that
> it would be an interesting way to see what the performance impact of a
> faster iret would be.
> 

Right, brain failure on my part.  I somehow got it in my head you'd run
the above off the user stack while in CPL 0, which would be obviously crazy.

I think this would be rather interesting experiment.

	-hpa


