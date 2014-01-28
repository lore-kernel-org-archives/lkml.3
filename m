Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaA1ANQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 19:13:16 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:46823 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaA1ANO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 19:13:14 -0500
Date: Mon, 27 Jan 2014 16:13:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch for-3.14] mm, mempolicy: fix mempolicy printing in
 numa_maps
In-Reply-To: <20140127130914.GI4963@suse.de>
Message-ID: <alpine.DEB.2.02.1401271610230.17114@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com> <20140127105011.GB11314@laptop.programming.kicks-ass.net> <20140127130914.GI4963@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jan 2014, Mel Gorman wrote:

> > Should we also consider printing the MOF and MORON states so we get a
> > better view of what the actual policy is?
> > 
> 
> MOF and MORON are separate issues because MOF is exposed to the userspace
> API but not the policies that make up MORON. For MORON, I concluded that
> we should not expose that via numa_maps unless it can be controlled from
> userspace.
> 

We print the possible flags for set_mempolicy() which is pretty simple 
since there's only one possible flag at any given time, but we don't print 
any possible flags for mbind().  If we are to start printing lazy 
migrate-on-fault then we should probably print the other flags as well, I 
just don't know how long we want lines in numa_maps to be.
