Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921AbaE3VXJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 17:23:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:42876 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525AbaE3VXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 17:23:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,943,1392192000"; 
   d="scan'208";a="549130494"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
	<1401260039-18189-2-git-send-email-minchan@kernel.org>
	<CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
Date: Fri, 30 May 2014 14:23:04 -0700
In-Reply-To: <CA+55aFxXdc22dirnE49UbQP_2s2vLQpjQFL+NptuyK7Xry6c=g@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 28 May 2014 09:09:23 -0700")
Message-ID: <8738frt0zr.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> From a quick glance at the frame usage, some of it seems to be gcc
> being rather bad at stack allocation, but lots of it is just nasty
> spilling around the disgusting call-sites with tons or arguments. A
> _lot_ of the stack slots are marked as "%sfp" (which is gcc'ese for
> "spill frame pointer", afaik).

> Avoiding some inlining, and using a single flag value rather than the
> collection of "bool"s would probably help. But nothing really
> trivially obvious stands out.

One thing that may be worth playing around with gcc's
--param large-stack-frame and --param large-stack-frame-growth

This tells the inliner when to stop inlining when too much
stack would be used.

We use conserve stack I believe. So perhaps smaller values than 100
and 400 would make sense to try.

       -fconserve-stack
           Attempt to minimize stack usage.  The compiler attempts to
           use less stack space, even if that makes the program slower.
           This option
           implies setting the large-stack-frame parameter to 100 and
           the large-stack-frame-growth parameter to 400.


-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
