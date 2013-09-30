Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108Ab3I3TPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:15:50 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:48764 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201Ab3I3TPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:15:48 -0400
Date: Mon, 30 Sep 2013 21:15:44 +0200
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
Message-ID: <20130930191544.GD3427@gmail.com>
References: <20130912204313.GA3259@gmail.com>
 <20130915091029.GA21465@gmail.com>
 <20130930164210.GA22342@gmail.com>
 <20130930171220.GC10293@ghostprotocols.net>
 <20130930172741.GD10293@ghostprotocols.net>
 <20130930173052.GE10293@ghostprotocols.net>
 <20130930173627.GF10293@ghostprotocols.net>
 <20130930173914.GG10293@ghostprotocols.net>
 <20130930174639.GH10293@ghostprotocols.net>
 <20130930180247.GJ10293@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930180247.GJ10293@ghostprotocols.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:

> In fact this is why I thought those messages had been missing in your 
> patchset, they don't appear when I remove perl-devel, i.e. 'perl' 
> supporty is correctly detected as not possible to build due to missing 
> deps, but no message is emitted for this case.
> 
> And the bug is that the feature test for perl support passes, but since 
> it doesn't try to use EXTERN.h, like something that is enabled when the 
> feature test passes (util/scripting-engines/trace-event-perl.c), the 
> build fails.

Hm, I probably messed up the lib-perl testcase - it was one of the more 
complex ones. I assumed that this:

...                       libperl: [ OFF ]

meant that I didn't have the dependencies installed - but it's the 
testcase that is wrong most likely.

Thanks,

	Ingo
