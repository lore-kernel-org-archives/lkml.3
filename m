Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3H3Kg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 06:36:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33803 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755090Ab3H3Kgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 06:36:54 -0400
Date: Fri, 30 Aug 2013 12:36:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
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
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
Message-ID: <20130830103633.GG10002@twins.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVnfVcYdc7XHyM9oA5GF-HG35JghWNabE4pgvBvTh1E0g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 12:29:34PM +0200, Sedat Dilek wrote:
> [ Sorry for being off-topic ]
> 
> Hey Ingo,
> 
> can you help, please?
> 
> I installed so far all missing -dev packages...
> 
> $ sudo apt-get install libelf-dev libdw-dev libunwind7-dev libslang2-dev

It seems to me the easier way is:

 $ apt-get build-dep linux-tools

> ...and then want a perf-only build...
> 
> [ See tools/Makefile ]
> 
> $ LANG=C LC_ALL=C make -C tools/ perf_install 2>&1 | tee ../perf_install-log.txt

The way I always build that stuff is simply:

$ cd tools/perf
$ make -j
$ cp perf `which perf`
$ cd -

No idea about liblk though, never had that issue but maybe something
like:

$ cd tools/lib/lk/
$ make clean
$ make

will get you a more useful error. dunno, its a fairly trivial little
library, only a single .c file.
