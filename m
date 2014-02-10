Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBJVaH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:30:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36609 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbaBJVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:30:04 -0500
Date: Mon, 10 Feb 2014 22:29:55 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140210212955.GC5002@laptop.programming.kicks-ass.net>
References: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392053356-23024-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 12:28:55PM -0500, Don Zickus wrote:
> The data output is verbose and there are lots of data tables that interprit the latencies
> and data addresses in different ways to help see where bottlenecks might be lying.

Would be good to see what the output looks like.

What I haven't seen; and what I would find most useful; is using the IP
+ dwarf info to map it back to a data structure member.

Since you're already using the PEBS data-source fields, you can also
have a precise IP. For many cases its possible to reconstruct the exact
data member the instruction is modifying.

At that point you can do pahole like output of data structures, showing
which members are 'hot' on misses etc.
