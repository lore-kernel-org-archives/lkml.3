Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbaLUW3J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 17:29:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaLUW3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 17:29:08 -0500
Date: Sun, 21 Dec 2014 20:28:51 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, oleg@redhat.com, rientjes@google.com,
        linux-mm@kvack.org
Subject: Re: [PATCH] proc: task_mmu: show page size in /proc/<pid>/numa_maps
Message-ID: <20141221222850.GA2038@x61.redhat.com>
References: <c97f30472ec5fe79cb8fa8be66cc3d8509777990.1419079617.git.aquini@redhat.com>
 <20141220183613.GA19229@phnom.home.cmpxchg.org>
 <20141220194457.GA3166@x61.redhat.com>
 <54970B49.3070104@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54970B49.3070104@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 21, 2014 at 10:02:49AM -0800, Dave Hansen wrote:
> On 12/20/2014 11:44 AM, Rafael Aquini wrote:
> >> > 
> >> > It would be simpler to include this unconditionally.  Otherwise you
> >> > are forcing everybody parsing the file and trying to run calculations
> >> > of it to check for its presence, and then have them fall back and get
> >> > the value from somewhere else if not.
> > I'm fine either way, it makes the change even simpler. Also, if we
> > decide to get rid of page_size != PAGE_SIZE condition I believe we can 
> > also get rid of that "huge" hint being conditionally printed out too.
> 
> That would break existing users of the "huge" flag.  That makes it out
> of the question, right?
>
Yeah, but it sort of follows the same complaint Johannes did for the 
conditional page size printouts. If we start to print out page size
deliberately for each map regardless their backing pages being PAGE_SIZE 
long or bigger, I don't see much point on keep conditionally printing out 
the 'huge' hint out. As I said before, I'm fine either way though I think 
we can keep the current behaviour, and just disambiguate page sizes !=
PAGE_SIZE as in the current proposal.

Looking forward more of your thoughts!

Cheers,
-- Rafael
