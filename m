Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbaA0KuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:50:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51678 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbaA0KuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:50:19 -0500
Date: Mon, 27 Jan 2014 11:50:11 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch for-3.14] mm, mempolicy: fix mempolicy printing in
 numa_maps
Message-ID: <20140127105011.GB11314@laptop.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401251902180.3140@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 25, 2014 at 07:12:35PM -0800, David Rientjes wrote:
> As a result of commit 5606e3877ad8 ("mm: numa: Migrate on reference 
> policy"), /proc/<pid>/numa_maps prints the mempolicy for any <pid> as 
> "prefer:N" for the local node, N, of the process reading the file.
> 
> This should only be printed when the mempolicy of <pid> is MPOL_PREFERRED 
> for node N.
> 
> If the process is actually only using the default mempolicy for local node 
> allocation, make sure "default" is printed as expected.

Should we also consider printing the MOF and MORON states so we get a
better view of what the actual policy is?


