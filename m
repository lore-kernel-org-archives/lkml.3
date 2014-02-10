Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaBJWVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:21:55 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:33445 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbaBJWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:21:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140210212955.GC5002@laptop.programming.kicks-ass.net>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
	<20140210212955.GC5002@laptop.programming.kicks-ass.net>
Date: Mon, 10 Feb 2014 23:21:53 +0100
Message-ID: <CABPqkBRzvfcdKGG4yY9q1PmtVL5Z=9H1RzHg8QDMN42a7=AF6A@mail.gmail.com>
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Joe Mario <jmario@redhat.com>, Richard Fowles <fowles@inreach.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 10:29 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Feb 10, 2014 at 12:28:55PM -0500, Don Zickus wrote:
>> The data output is verbose and there are lots of data tables that interprit the latencies
>> and data addresses in different ways to help see where bottlenecks might be lying.
>
> Would be good to see what the output looks like.
>
> What I haven't seen; and what I would find most useful; is using the IP
> + dwarf info to map it back to a data structure member.
>
> Since you're already using the PEBS data-source fields, you can also
> have a precise IP. For many cases its possible to reconstruct the exact
> data member the instruction is modifying.
>
The tool already uses precise=2 to get the precise IP.

To get from IP to data member, you'd need some debug info which is not
yet emitted
by the compiler.

> At that point you can do pahole like output of data structures, showing
> which members are 'hot' on misses etc.
