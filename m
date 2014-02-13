Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaBMW0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:26:10 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:18676 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbaBMW0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:26:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AskJAEhF/VJ5LJYe/2dsb2JhbABZgwa7DIVQgRoXdIIlAQEEAScTHCMFCwgDDgYECSUPBSUDIROHfQfITBcWjiFCB4Q4BI4/iWySJINBKIEu
Date: Fri, 14 Feb 2014 09:26:02 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
Message-ID: <20140213222602.GK13997@dastard>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 11:53:05AM -0800, Christian Kujau wrote:
> Hi,
> 
> after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> the WARNING below was printed.
> 
> Shortly after, a lockdep warning appeared (possibly related to my 
> post to the XFS list yesterday[0]).

Unlikely.

> Even later in the log an out-of-memory error appeared, that may or may not 
> be relatd to that WARNING at all but which I'm trying to chase down ever 
> since 3.13, but which tends to appear more often lately.
> 
> Can anyone take a look if this is something to worry about?

Already fixed upstream:

commit 255d0884f5635122adb23866b242b4ca112f4bc8
Author: David Rientjes <rientjes@google.com>
Date:   Mon Feb 10 14:25:39 2014 -0800

    mm/slub.c: list_lock may not be held in some circumstances
    
    Commit c65c1877bd68 ("slub: use lockdep_assert_held") incorrectly
    required that add_full() and remove_full() hold n->list_lock.  The lock
    is only taken when kmem_cache_debug(s), since that's the only time it
    actually does anything.
    
    Require that the lock only be taken under such a condition.
    
    Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
    Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
    Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Acked-by: Christoph Lameter <cl@linux.com>
    Cc: Pekka Enberg <penberg@kernel.org>
    Signed-off-by: David Rientjes <rientjes@google.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
