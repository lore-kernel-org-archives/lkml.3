Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaBZRSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 12:18:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:53622 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaBZRST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 12:18:19 -0500
Date: Wed, 26 Feb 2014 18:18:05 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [RFC] perf tools: Fix strict alias issue for find_first_bit
Message-ID: <20140226171805.GC22802@laptop.programming.kicks-ass.net>
References: <1393434867-20271-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393434867-20271-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 06:14:26PM +0100, Jiri Olsa wrote:
> hi,
> got issue below when compiling perf tool on i686 with gcc 4.4,
> but not sure the patch is correct workaround here.
> 
> thanks for comments,
> jirka
> 
> 
> ---
> When compiling perf tool code with gcc 4.4.7 I'm getting
> following error:
> 
>   CC       util/session.o
> cc1: warnings being treated as errors
> util/session.c: In function ‘perf_session_deliver_event’:
> /root/linux/tools/perf/util/include/linux/bitops.h:109: error: dereferencing pointer ‘p’ does break strict-aliasing rules
> /root/linux/tools/perf/util/include/linux/bitops.h:101: error: dereferencing pointer ‘p’ does break strict-aliasing rules
> util/session.c:697: note: initialized from here
> /root/linux/tools/perf/util/include/linux/bitops.h:101: note: initialized from here
> make[1]: *** [util/session.o] Error 1
> make: *** [util/session.o] Error 2
> 
> The aliased types here are u64 and unsigned long pointers,
> which is safe for the find_first_bit processing.
> 
> This error shows up for me only for gcc 4.4 on 32bit x86,
> even for -Wstrict-aliasing=3, while newer gcc are quiet
> and scream here for -Wstrict-aliasing={2,1}. Looks like
> newer gcc changed the rules for strict alias warnings.
> 
> The gcc documentation offers workaround for valid
> aliasing by using __may_alias__ attribute:
>   http://gcc.gnu.org/onlinedocs/gcc-4.4.0/gcc/Type-Attributes.html
> 

The kernel builds with -fno-strict-aliasing because the C aliasing rules
are a bunch of monkey poo. Perf tool should probably do the same.
