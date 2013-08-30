Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab3H3K5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:57:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:40209 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755738Ab3H3K5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:57:40 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130830105215.GH10002@twins.programming.kicks-ass.net>
References: <52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<20130830094857.GA14502@gmail.com>
	<CA+icZUX5F8NtZkc1WsFZC8ggs0K7O=dk2iyhwCDi7FQz+7cHeQ@mail.gmail.com>
	<CA+icZUVKkVuOCf1h-g8-XZ=Kjt6aLF7Yh9Mt90hbNa7q0jsvQA@mail.gmail.com>
	<CA+icZUVnfVcYdc7XHyM9oA5GF-HG35JghWNabE4pgvBvTh1E0g@mail.gmail.com>
	<20130830103633.GG10002@twins.programming.kicks-ass.net>
	<CA+icZUWYNGWYeVfGZy13wdrXgJaC_ZNS6ZkSMW5Ger3MkPkXSw@mail.gmail.com>
	<20130830105215.GH10002@twins.programming.kicks-ass.net>
Date: Fri, 30 Aug 2013 12:57:38 +0200
Message-ID: <CA+icZUXmt1oKSguM4iXfHBPFR6MWWWL8w=KC+_c8y212+ckFnw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <waiman.long@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Aug 30, 2013 at 12:44:29PM +0200, Sedat Dilek wrote:
>> Please, see advices in 'tools/Makefile':
>>
>>         @echo 'You can do:'
>>         @echo ' $$ make -C tools/ <tool>_install'
>>         @echo ''
>>         @echo '  from the kernel command line to build and install one of'
>>         @echo '  the tools above'
>>         @echo ''
>>         @echo '  $$ make tools/install'
>>         @echo ''
>>         @echo '  installs all tools.'
>
> I never follow advice :-) Muwhaha, also I'm generally not interested in
> 'all' tools anywya.
>
>> If you tell me where you discuss perf issues I can describe the problem.
>
> On this list, start a new thread CC ingo, acme and me. There's also an
> IRC channel but I keep forgetting what the official channel is and I'm
> likely not on it. I do tend to abuse irc.oftc.net/#linux-rt for it since
> most people are on there anyway.

Hi rebel :-)!

I was away from IRC for quite a year.
I will write some words...

- Sedat -

P.S.: It worked...

$ ~/src/linux-kernel/linux/tools/perf/perf --version
perf version 3.11.rc7.ga7370

$ ~/src/linux-kernel/linux/tools/perf/perf stat --null --repeat 5
./t_lockref_from-linus
Total loops: 2652351
Total loops: 2604876
Total loops: 2649696
Total loops: 2651417
Total loops: 2644068

 Performance counter stats for './t_lockref_from-linus' (5 runs):

      10,002926693 seconds time elapsed
          ( +-  0,00% )

$ cat /proc/version
Linux version 3.11.0-rc7-1-lockref-small
(sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro
4.6.3-1ubuntu5) ) #1 SMP Fri Aug 30 10:23:19 CEST 2013
