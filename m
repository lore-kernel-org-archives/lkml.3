Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaCFUzU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:55:20 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:49931 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaCFUzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:55:18 -0500
Date: Thu, 6 Mar 2014 17:46:53 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] perf tools: Fix strict alias issue for find_first_bit
Message-ID: <20140306204653.GA2361@infradead.org>
References: <1393622751-21513-1-git-send-email-acme@infradead.org>
 <1393622751-21513-3-git-send-email-acme@infradead.org>
 <20140228212923.GI14089@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140228212923.GI14089@laptop.programming.kicks-ass.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Feb 28, 2014 at 10:29:23PM +0100, Peter Zijlstra escreveu:
> On Fri, Feb 28, 2014 at 06:25:51PM -0300, Arnaldo Carvalho de Melo wrote:
> > From: Jiri Olsa <jolsa@redhat.com>

> > The gcc documentation offers workaround for valid aliasing by using
> > __may_alias__ attribute:

> >   http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Type-Attributes.html

> > Using this workaround for the find_first_bit function.

> Hurm; didn't I suggest using -fno-strict-aliasing just like the kernel
> does? Because the C aliasing rules are bonghits heavy?

Either way would solve the problem at hand, I just used the smaller
hammer offered.

I thought that Ingo had something against this, but only reference I
could find now about it was this:

--------------------------------------------

commit 65014ab36196f6d86edc9ee23759d6930b9d89a8
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Sep 2 14:55:55 2009 +0200

    perf tools: Work around strict aliasing related warnings
    
    Older versions of GCC are rather stupid about strict aliasing:

<SNIP>

    Make it clear to GCC that we intend with those pointers, by passing
    them through via an explicit (void *) cast.
    
    We might want to add -fno-strict-aliasing as well, like the kernel
    itself does.
    
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Cc: Mike Galbraith <efault@gmx.de>
    Cc: Paul Mackerras <paulus@samba.org>
    Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    LKML-Reference: <new-submission>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
--------------------------------------------

Jiri's bandaid is for _newer_ compilers, so...

- Arnaldo
