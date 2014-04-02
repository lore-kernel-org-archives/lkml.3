Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932604AbaDBRSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:18:33 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58090 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320AbaDBRSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:18:32 -0400
Date: Wed, 2 Apr 2014 13:18:12 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
Message-ID: <20140402171812.GR14688@cmpxchg.org>
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org>
 <20140401212102.GM4407@cmpxchg.org>
 <533B8C2D.9010108@linaro.org>
 <20140402163013.GP14688@cmpxchg.org>
 <533C3BB4.8020904@zytor.com>
 <533C3CDD.9090400@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533C3CDD.9090400@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2014 at 09:37:49AM -0700, H. Peter Anvin wrote:
> On 04/02/2014 09:32 AM, H. Peter Anvin wrote:
> > On 04/02/2014 09:30 AM, Johannes Weiner wrote:
> >>
> >> So between zero-fill and SIGBUS, I'd prefer the one which results in
> >> the simpler user interface / fewer system calls.
> >>
> > 
> > The use cases are different; I believe this should be a user space option.
> > 
> 
> Case in point, for example: imagine a JIT.  You *really* don't want to
> zero-fill memory behind the back of your JIT, as all zero memory may not
> be a trapping instruction (it isn't on x86, for example, and if you are
> unlucky you may be modifying *part* of an instruction.)

Yes, and I think this would be comparable to the compressed-library
usecase that John mentioned.  What's special about these cases is that
the accesses are no longer under control of the application because
it's literally code that the CPU jumps into.  It is obvious to me that
such a usecase would require SIGBUS handling.  However, it seems that
in any usecase *besides* executable code caches, userspace would have
the ability to mark the pages non-volatile ahead of time, and thus not
require SIGBUS delivery.

Hence my follow-up question in the other mail about how large we
expect such code caches to become in practice in relationship to
overall system memory.  Are code caches interesting reclaim candidates
to begin with?  Are they big enough to make the machine thrash/swap
otherwise?

