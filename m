Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbaJ3Ift (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:35:49 -0400
Received: from one.firstfloor.org ([193.170.194.197]:54847 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbaJ3Ifq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:35:46 -0400
Date: Thu, 30 Oct 2014 09:35:44 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Bob Liu <lliubbo@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Davydov <vdavydov@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Convert khugepaged to a task_work function
Message-ID: <20141030083544.GX12538@two.firstfloor.org>
References: <1414032567-109765-1-git-send-email-athorlton@sgi.com>
 <87lho0pf4l.fsf@tassilo.jf.intel.com>
 <20141029215839.GO2979@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029215839.GO2979@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I suppose from the single-threaded point of view, it could be.  Maybe we

It's not only for single threaded. Consider the "has to wait a long time
for a lock" problem Rik pointed out. With that multiple threads are
always better.

> could look at this a bit differently.  What if we allow processes to
> choose their collapse mechanism on fork?  That way, the system could
> default to using the standard khugepaged mechanism, but we could request
> that processes handle collapses themselves if we want.  Overall, I don't
> think that would add too much overhead to what I've already proposed
> here, and it gives us more flexibility.

We already have too many VM tunables. Better would be to switch
automatically somehow.

I guess you could use some kind of work stealing scheduler, but these
are fairly complicated. Maybe some simpler heuristics can be found.

BTW my thinking has been usually to actually use more khugepageds to 
scan large address spaces faster.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
