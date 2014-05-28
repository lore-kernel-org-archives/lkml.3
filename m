Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaE1J1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:27:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47543 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbaE1J1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:27:21 -0400
Date: Wed, 28 May 2014 11:27:17 +0200
From: Borislav Petkov <bp@alien8.de>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Hugh Dickins <hughd@google.com>, rusty@rustcorp.com.au, mst@redhat.com,
        Dave Hansen <dave.hansen@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC 2/2] x86_64: expand kernel stack to 16K
Message-ID: <20140528092717.GA17220@pd.tnic>
References: <1401260039-18189-1-git-send-email-minchan@kernel.org>
 <1401260039-18189-2-git-send-email-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1401260039-18189-2-git-send-email-minchan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 03:53:59PM +0900, Minchan Kim wrote:
> While I play inhouse patches with much memory pressure on qemu-kvm,
> 3.14 kernel was randomly crashed. The reason was kernel stack overflow.
> 
> When I investigated the problem, the callstack was a little bit deeper
> by involve with reclaim functions but not direct reclaim path.
> 
> I tried to diet stack size of some functions related with alloc/reclaim
> so did a hundred of byte but overflow was't disappeard so that I encounter
> overflow by another deeper callstack on reclaim/allocator path.
> 
> Of course, we might sweep every sites we have found for reducing
> stack usage but I'm not sure how long it saves the world(surely,
> lots of developer start to add nice features which will use stack
> agains) and if we consider another more complex feature in I/O layer
> and/or reclaim path, it might be better to increase stack size(
> meanwhile, stack usage on 64bit machine was doubled compared to 32bit
> while it have sticked to 8K. Hmm, it's not a fair to me and arm64
> already expaned to 16K. )

Hmm, stupid question: what happens when 16K is not enough too, do we
increase again? When do we stop increasing? 1M, 2M... ?

Sounds like we want to make it a config option with a couple of sizes
for everyone to be happy. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
