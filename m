Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab3H3QtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:49:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50078 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab3H3QtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:49:13 -0400
Date: Fri, 30 Aug 2013 18:49:05 +0200
From: Robert Richter <rric@kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] tools: perf: Fix liblk not built when using perf_install
 target
Message-ID: <20130830164905.GA31061@rric.localhost>
References: <1377875916-5208-1-git-send-email-sedat.dilek@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377875916-5208-1-git-send-email-sedat.dilek@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.08.13 17:18:36, Sedat Dilek wrote:
> So, I tried to build perf the "official" way:
> 
>    $ make -C tools/ perf_install
> 
> Unfortunately, my build breaks like this:
> ...
> make[2]: Entering directory
> `~/src/linux-kernel/linux/tools/lib/traceevent'
> make[2]: Leaving directory
> `~/src/linux-kernel/linux/tools/lib/traceevent'
>     LINK perf
> gcc: error: ~/src/linux-kernel/linux/tools/lib/lk/liblk.a: No such file or directory
> make[1]: *** [perf] Error 1
> make[1]: Leaving directory `~/src/linux-kernel/linux/tools/perf'
> make: *** [perf_install] Error 2
> 
> After some discussion on IRC with peterz and acme and a closer look at
> the targets in "tools/Makefile", I have noticed that the perf_install
> target misses liblk to be built beforehand.

There are no build prerequisites on purpose for install targets.
Install targets are intended to be run with root permissions. We don't
want to create/overwrite files in the build directory as root while
running install rules. Thus, you always need to run:

 $ make -C tools/ perf

or similar first.

> On the contrary the perf_clean target invokes to clean liblk when perf
> is cleaned.
> 
> [ tools/Makefile ]
> ...
> perf_clean: liblk_clean
> 	$(call descend,$(@:_clean=),clean)
> ...
> 
> Fix this by adding liblk target to perf_install target.

So no, this is not the proper fix.

Before installing you *need* to build. You might want to fix the
documenation...

-Robert
