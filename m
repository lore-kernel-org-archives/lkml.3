Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaBJVSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 16:18:33 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36406 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaBJVSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 16:18:31 -0500
Date: Mon, 10 Feb 2014 22:18:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jolsa@redhat.com, jmario@redhat.com, fowles@inreach.com,
        eranian@google.com
Subject: Re: [PATCH 00/21] perf, c2c: Add new tool to analyze cacheline
 contention on NUMA systems
Message-ID: <20140210211825.GB5002@laptop.programming.kicks-ass.net>
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
> With the introduction of NUMA systems, came the possibility of remote memory accesses.
> Combine those remote memory accesses with contention on the remote node (ie a modified
> cacheline) and you have a possibility for very long latencies.  These latencies can
> bottleneck a program.
> 
> The program added by these patches, helps detect the situation where two nodes are
> 'tugging' on the same _data_ cacheline.  The term used through out this program and
> the various changelogs is called a HITM.  This means nodeX went to read a cacheline
> and it was discovered to be loaded in nodeY's LLC cache (hence the cacheHIT). The 
> remote cacheline was also in a 'M'odified state thus creating a 'HIT M' for hit in
> a modified state.  HITMs can happen locally and remotely.  This program's interest
> is mainly in remote HITMs as they cause the longest latencies.

All of that is true of the traditional SMP system too. Just use lower
level caches.
