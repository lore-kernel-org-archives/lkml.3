Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3J0T4p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 15:56:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46086 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab3J0T4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 15:56:44 -0400
Message-ID: <526D6FF9.9020003@canonical.com>
Date: Sun, 27 Oct 2013 20:56:41 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking fix
References: <20131026121902.GA24890@gmail.com>	<CA+55aFwLwZ2SoqLdD9itnXrFJyS9szC+g4J01pLxHFgKYCvrog@mail.gmail.com>	<526D62D8.8050001@canonical.com>	<CA+55aFz3MLHcAFqF=WBwmHGQ+8+uU+Hd7avXt=P9L-ohv08bnw@mail.gmail.com>	<526D6B6D.2000605@canonical.com> <CA+55aFz4Fd-dibRL0+VKxz3PhppasvqCU7E6ToW2AWfnsenP_w@mail.gmail.com>
In-Reply-To: <CA+55aFz4Fd-dibRL0+VKxz3PhppasvqCU7E6ToW2AWfnsenP_w@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 27-10-13 20:51, Linus Torvalds schreef:
> On Sun, Oct 27, 2013 at 12:37 PM, Maarten Lankhorst
> <maarten.lankhorst@canonical.com> wrote:
>> I would love for a compiler to become that smart though, but I do not think it's likely.
> Dammit, even if that is true, then write the conditional *correctly*.
>
> As mentioned, the conditional
>
>     __builtin_constant_p(ww_ctx) && ww_ctx == NULL
>
> is actually sensible, in a way the original one was *not*. It actually
> tests what you apparently intended to test, and is more readable to
> humans to boot.
Yeah that mail arrived after I sent mine, I agree that this would have been more sensible.
> And no, it still isn't actually guaranteed to do what you want it to
> do. Historically, in gcc, __builtin_constant_p() really only ever
> worked in macros, because by the time you use it in inline functions,
> a constant NULL in the caller will have been turned into a argument
> variable in the inline function, and __builtin_constant_p() would be
> done before that was optimized away. Over the years, gcc has pushed
> some of the builtin evaluation deeper down, and these days it actually
> works within inline functions, but my point that
> __builtin_constant_p() is about a certain level of compiler
> optimization is very much true: you're actually testing for a compiler
> optimization detail.
>
> I know the LLVM people had similar issues with this comparison, so
> these days it's not even just about gcc versions. We may never have
> cared very much about icc, but llvm is actually an interesting target
> compiler.
>
And this is why ww_ctx == NULL is now passed as an inline argument. :)

~Maarten
