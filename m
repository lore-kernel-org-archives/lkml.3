Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266AbaJ2V6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:58:04 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42234 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756704AbaJ2V6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:58:02 -0400
Date: Wed, 29 Oct 2014 16:58:39 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alex Thorlton <athorlton@sgi.com>, linux-mm@kvack.org,
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
Message-ID: <20141029215839.GO2979@sgi.com>
References: <1414032567-109765-1-git-send-email-athorlton@sgi.com>
 <87lho0pf4l.fsf@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lho0pf4l.fsf@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 05:12:26AM -0700, Andi Kleen wrote:
> Alex Thorlton <athorlton@sgi.com> writes:
> 
> > Last week, while discussing possible fixes for some unexpected/unwanted behavior
> > from khugepaged (see: https://lkml.org/lkml/2014/10/8/515) several people
> > mentioned possibly changing changing khugepaged to work as a task_work function
> > instead of a kernel thread.  This will give us finer grained control over the
> > page collapse scans, eliminate some unnecessary scans since tasks that are
> > relatively inactive will not be scanned often, and eliminate the unwanted
> > behavior described in the email thread I mentioned.
> 
> With your change, what would happen in a single threaded case?
> 
> Previously one core would scan and another would run the workload.
> With your change both scanning and running would be on the same
> core.
> 
> Would seem like a step backwards to me.

I suppose from the single-threaded point of view, it could be.  Maybe we
could look at this a bit differently.  What if we allow processes to
choose their collapse mechanism on fork?  That way, the system could
default to using the standard khugepaged mechanism, but we could request
that processes handle collapses themselves if we want.  Overall, I don't
think that would add too much overhead to what I've already proposed
here, and it gives us more flexibility.

Thoughts?

- Alex
