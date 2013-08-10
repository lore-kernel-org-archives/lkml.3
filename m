Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417Ab3HJAO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 20:14:27 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:63270 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab3HJAO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 20:14:26 -0400
Message-ID: <520585DF.6010002@mit.edu>
Date: Fri, 09 Aug 2013 17:14:23 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jason Baron <jbaron@akamai.com>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 3/2] x86/jump labels: Count and display the short
 jumps used
References: <20130807173606.872055511@goodmis.org> <1375898048.6848.18.camel@gandalf.local.home> <CA+55aFwo4iFk4_6cSoK=NjCWjVgdPgKy0YfKpZd2zSGn_RXHYg@mail.gmail.com> <5202ABEF.10107@akamai.com> <CA+55aFyu+3fRrsGUZkH6y5yND3oV9K+jCzrJyCWqwHQreFELOw@mail.gmail.com> <5202BE17.9010408@akamai.com> <CA+55aFykSZb-XmGU0WjZDuiSUXQ6RbRhV3ZH5BUFCRifaoLUGA@mail.gmail.com>
In-Reply-To: <CA+55aFykSZb-XmGU0WjZDuiSUXQ6RbRhV3ZH5BUFCRifaoLUGA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 02:56 PM, Linus Torvalds wrote:
> 
> Both of the biased cases *might* also want things like "save register
> state in the unlikely path so that the *likely* path doesn't have to".
> Think things like "it's a leaf function, and the likely path doesn't
> need any temporaries, but the unlikely path ends up doing function
> calls and needs a stack frame". If the compiler can make likely path
> avoid the stack frame generation and be straight-line, that would be
> really nice.

This inspired me to see what happens when you call an
__attribute__((noreturn)) function.  The results are sad:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=10837

I think the explanations for why that bug is WONTFIX are bogus.  And
unless gcc fixes that, trying to get efficient code that intentionally
jumps and never returns seems hard (at least without sticking the
call/jump into inline assembly).

--Andy
