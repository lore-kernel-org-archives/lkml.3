Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529AbaEGP1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:27:32 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:39906 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359AbaEGP1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140507111422.GA8410@gmail.com>
References: <e94ab903e725eaf9d98e56f3043878bde7fc1b58.1399408110.git.luto@amacapital.net>
 <CA+55aFy6NzQOfyne4xLqQQCvuhpi-KSXnJNLjXTRc7+4ChPAnQ@mail.gmail.com>
 <CA+55aFw_Dj7Lx_bE0B3mDxMUNz_K1yc=saziC9dmA_dKSkFWiw@mail.gmail.com>
 <CA+55aFwix8dSDQ1N1Qu2-9rzGxWeeGAv4fSPVQWGo1YNzJoCoA@mail.gmail.com>
 <CALCETrVHj1rd=ma-dW8C9RNyQNj3smRAyevWJSQXmvgshbQb6w@mail.gmail.com> <20140507111422.GA8410@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 7 May 2014 08:27:09 -0700
Message-ID: <CALCETrXS=U159bRLKGwrz0ab_VYH8gXGu1mCPDHJ_oM=iAaiow@mail.gmail.com>
Subject: Re: [ABOMINATION] x86: Fast interrupt return to userspace
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2014 at 4:14 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Andy Lutomirski <luto@amacapital.net> wrote:
>
>> > Whatever. I got enough profile data to say that it seems to have
>> > cut 'iret' overhead by at least two thirds. So it may not *work*,
>> > but from a "hey look, some random numbers" standpoint it is worth
>> > playing with.
>>
>> :)
>>
>> Is there actual interest in turning something like this into a real
>> patch?  It would almost certainly have to default off and no one
>> sane would ever use it except for special-purpose machines.
>
> The macro speedup looks rather impressive, and we've done ugly things
> for far smaller speedups.
>
> But I don't think it should be a 'special mode'. It either is made to
> work unconditionally and can be a prime speedup to be proud of in a
> politely disgusted fashion, or we don't want the complexity (and
> future bitrot) of some special switch.

The problem is that we'll break anything that expects to be able to
use more than the specified 128-byte redzone.  Doing that is currently
safe as long as no signals are delivered.

I could imagine something like Go blowing up badly.

We might be able to get away with automatically disabling this thing
if sigaltstack is enabled.

--Andy
