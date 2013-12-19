Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab3LSEX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 23:23:27 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:18888 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751008Ab3LSEX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 23:23:26 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmIHAOdzslJ5LHyk/2dsb2JhbABZgwu0TYVdgRQXdIIlAQEBBDocIxAIAw4KCSUPBSUDIROIA8pAFxaOfAeENgSYFYpMh0mDPyg
Date: Thu, 19 Dec 2013 15:23:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Lameter <cl@linux.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [fs] inode_lru_isolate(): Move counter increment into spinlock
 section
Message-ID: <20131219042322.GX31386@dastard>
References: <00000143072add16-956bfa6c-d7d5-4df9-aabc-05a904a0edc4-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000143072add16-956bfa6c-d7d5-4df9-aabc-05a904a0edc4-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 07:24:46PM +0000, Christoph Lameter wrote:
> The counter increment in inode_lru_isolate is happening after
> spinlocks have been dropped with preemption on using __count_vm_events
> making counter increment races possible.

That's a nasty, undocumented problem that __count_vm_events() has.
Nobody who is modifying the fs/inode.c code is likely to know about
this, so just moving the code under an unrelated lock is not
sufficient to prevent this from happening again. Hence I'd prefer
that you just change it to use count_vm_events() rather than try to
be tricksy by replacing the landmine in the code that we've already
stepped on once.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
