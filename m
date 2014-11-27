Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaK0S0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 13:26:03 -0500
Received: from one.firstfloor.org ([193.170.194.197]:49078 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaK0S0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 13:26:01 -0500
Date: Thu, 27 Nov 2014 19:25:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Brendan Gregg <brendan.d.gregg@gmail.com>
Subject: Re: perf report --branch-history segfaul hists browser: Print
 overhead percent value for first-level callchain
Message-ID: <20141127182558.GV12538@two.firstfloor.org>
References: <20141124145227.GE18625@kernel.org>
 <20141124152312.GA13167@kernel.org>
 <20141124152541.GB13167@kernel.org>
 <20141124153204.GC13167@kernel.org>
 <20141124154841.GD13167@kernel.org>
 <20141124212308.GE13167@kernel.org>
 <20141124225244.GS12538@two.firstfloor.org>
 <20141127154249.GI30226@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141127154249.GI30226@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for testing.

> Yeah, you are right:
> 
> [acme@zoo linux]$ addr2line -e /usr/lib/debug/usr/lib64/firefox/libxul.so.debug 22fefe8
> BFD: Dwarf Error: Offset (2585882475) greater than or equal to
> .debug_str size (44321517).
> BFD: Dwarf Error: Could not find abbrev number 11800.
> BFD: Dwarf Error: Offset (493511937) greater than or equal to .debug_str
> size (44321517).

But addr2line didn't crash? What happens when you run it under valgrind?

If yes, I can check what it does differently than get_srcline() to make
it recover better.

-Andi

