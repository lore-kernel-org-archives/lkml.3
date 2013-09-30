Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209Ab3I3TJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:09:45 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:38281 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756118Ab3I3TJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:09:43 -0400
Date: Mon, 30 Sep 2013 21:09:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them
 in parallel
Message-ID: <20130930190939.GC3427@gmail.com>
References: <20130912184341.GA11400@ghostprotocols.net>
 <52321CE4.1080804@gmail.com>
 <20130912200236.GC11400@ghostprotocols.net>
 <20130912203116.GD32644@gmail.com>
 <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <20130930172741.GD10293@ghostprotocols.net>
 <20130930173052.GE10293@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930173052.GE10293@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> Em Mon, Sep 30, 2013 at 02:27:41PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Mon, Sep 30, 2013 at 02:12:20PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Mon, Sep 30, 2013 at 06:42:10PM +0200, Ingo Molnar escreveu:
> > > > This series (with combo patch attached) implements (much) faster 
> > > > perf-tools feature-auto-detection.
> 
> > > Cool stuff!
> 
> > > Testing:
> 
> 
> Removed python-devel and it correctly turned those off:
> 
> ...                     libpython: [ OFF ]
> ...             libpython-version: [ OFF ]
> 
> One possible way to speed this up a bit more would be to somehow state 
> that if the test A fails, then don't even bother testing test B, like in 
> the case above.

Yeah, that's possible in a way, I did it in another case, see how the 
'bionic' test for Android libc gets executed separately (but still 
unconditionally - we should probably only execute it if the libc test 
fails).

The 'FEATURE_TESTS' variable holds the 'flat' list of features that we 
want to definitely test.

Also, if glibc test passes then perhaps the strlcpy() test does not have 
to be executed at all.

In the initial version I wanted to maintain the existing feature 
dependency.

Thanks,

	Ingo
