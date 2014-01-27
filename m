Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaA0NJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 08:09:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37793 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaA0NJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 08:09:19 -0500
Date: Mon, 27 Jan 2014 13:09:15 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch for-3.14] mm, mempolicy: fix mempolicy printing in
 numa_maps
Message-ID: <20140127130914.GI4963@suse.de>
References: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com>
 <20140127105011.GB11314@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140127105011.GB11314@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 11:50:11AM +0100, Peter Zijlstra wrote:
> On Sat, Jan 25, 2014 at 07:12:35PM -0800, David Rientjes wrote:
> > As a result of commit 5606e3877ad8 ("mm: numa: Migrate on reference 
> > policy"), /proc/<pid>/numa_maps prints the mempolicy for any <pid> as 
> > "prefer:N" for the local node, N, of the process reading the file.
> > 
> > This should only be printed when the mempolicy of <pid> is MPOL_PREFERRED 
> > for node N.
> > 
> > If the process is actually only using the default mempolicy for local node 
> > allocation, make sure "default" is printed as expected.
> 
> Should we also consider printing the MOF and MORON states so we get a
> better view of what the actual policy is?
> 

MOF and MORON are separate issues because MOF is exposed to the userspace
API but not the policies that make up MORON. For MORON, I concluded that
we should not expose that via numa_maps unless it can be controlled from
userspace.

-- 
Mel Gorman
SUSE Labs
