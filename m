Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879Ab3H3Kqz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:46:55 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:64810 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3H3Kqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:46:53 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUWYNGWYeVfGZy13wdrXgJaC_ZNS6ZkSMW5Ger3MkPkXSw@mail.gmail.com>
References: <CA+55aFx1oq7+jce8vLWRitASVMugCojYe3gmhXwhLx4K9Au3XQ@mail.gmail.com>
	<CA+55aFyq7dJnm6tfn12hLOw5qKLW2RXRFERHgZO-sOOnUmjd3g@mail.gmail.com>
	<52200DAE.2020303@hp.com>
	<CA+55aFyhTR15GBS4VNoRkcFyubEJU7a+Pzd-6VZeKoU8qB0q5Q@mail.gmail.com>
	<CA+icZUX3zQEWDoaXk0RMKmbQhDRo0Z7jGZ=9tJu1gZWvGodMkg@mail.gmail.com>
	<CA+icZUUDKExRW3iNXj6jTs8A4DwQNaWvPuUfV5_ExXNPzq=+rA@mail.gmail.com>
	<20130830094857.GA14502@gmail.com>
	<CA+icZUX5F8NtZkc1WsFZC8ggs0K7O=dk2iyhwCDi7FQz+7cHeQ@mail.gmail.com>
	<CA+icZUVKkVuOCf1h-g8-XZ=Kjt6aLF7Yh9Mt90hbNa7q0jsvQA@mail.gmail.com>
	<CA+icZUVnfVcYdc7XHyM9oA5GF-HG35JghWNabE4pgvBvTh1E0g@mail.gmail.com>
	<20130830103633.GG10002@twins.programming.kicks-ass.net>
	<CA+icZUWYNGWYeVfGZy13wdrXgJaC_ZNS6ZkSMW5Ger3MkPkXSw@mail.gmail.com>
Date: Fri, 30 Aug 2013 12:46:52 +0200
Message-ID: <CA+icZUVxhAX6jKHYBakp92Q7i+Ro=Kjahgs9531zADwUevcwKQ@mail.gmail.com>
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

On Fri, Aug 30, 2013 at 12:44 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Fri, Aug 30, 2013 at 12:36 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Fri, Aug 30, 2013 at 12:29:34PM +0200, Sedat Dilek wrote:
>>> [ Sorry for being off-topic ]
>>>
>>> Hey Ingo,
>>>
>>> can you help, please?
>>>
>>> I installed so far all missing -dev packages...
>>>
>>> $ sudo apt-get install libelf-dev libdw-dev libunwind7-dev libslang2-dev
>>
>> It seems to me the easier way is:
>>
>>  $ apt-get build-dep linux-tools
>>
>
> NO, se B-Ds for Ubuntu-kernel v3.2:
>
> Build-Depends: dpkg (>= 1.13.19), debhelper (>= 5), gawk
>
> http://archive.ubuntu.com/ubuntu/pool/main/l/linux-meta/linux-meta_3.2.0.52.62.dsc
>
>>> ...and then want a perf-only build...
>>>
>>> [ See tools/Makefile ]
>>>
>>> $ LANG=C LC_ALL=C make -C tools/ perf_install 2>&1 | tee ../perf_install-log.txt
>>
>> The way I always build that stuff is simply:
>>
>> $ cd tools/perf
>> $ make -j
>> $ cp perf `which perf`
>> $ cd -
>>
>
> Please, see advices in 'tools/Makefile':
>
>         @echo 'You can do:'
>         @echo ' $$ make -C tools/ <tool>_install'
>         @echo ''
>         @echo '  from the kernel command line to build and install one of'
>         @echo '  the tools above'
>         @echo ''
>         @echo '  $$ make tools/install'
>         @echo ''
>         @echo '  installs all tools.'
>
>
>> No idea about liblk though, never had that issue but maybe something
>> like:
>>
>> $ cd tools/lib/lk/
>> $ make clean
>> $ make
>>
>> will get you a more useful error. dunno, its a fairly trivial little
>> library, only a single .c file.
>
> If looked quickly over diverse Makefile one was saying liblk FORCE, so
> it should be built, but is NOT!
>
> Thanks anyway, Peter for all the hints!
>
> If you tell me where you discuss perf issues I can describe the problem.
>

Just as a sidenote for cleaning up (that seems to be the "official" way):

$ LANG=C LC_ALL=C make -C tools/ liblk_clean

$ LANG=C LC_ALL=C make -C tools/ perf_clean

- Sedat -
