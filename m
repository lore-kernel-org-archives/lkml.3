Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaBNBUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 20:20:12 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:26215 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbaBNBUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 20:20:10 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgJAIpu/VJ5LJYe/2dsb2JhbABZgwa7EYVQgRgXdIIlAQEFJxMcIxAIAw4KCSUPBSUDIROIBMhsFxaOIUIHhDgBA5RDg2iSJINBKIEu
Date: Fri, 14 Feb 2014 12:14:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: 3.14.0-rc2: WARNING: at mm/slub.c:1007
Message-ID: <20140214011453.GP13997@dastard>
References: <alpine.DEB.2.19.4.1402131144390.6233@trent.utfs.org>
 <20140213222602.GK13997@dastard>
 <alpine.DEB.2.19.4.1402131531290.6233@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.19.4.1402131531290.6233@trent.utfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 03:34:19PM -0800, Christian Kujau wrote:
> On Fri, 14 Feb 2014 at 09:26, Dave Chinner wrote:
> > > after upgrading from 3.13-rc8 to 3.14.0-rc2 on this PowerPC G4 machine, 
> > > the WARNING below was printed.
> > > 
> > > Shortly after, a lockdep warning appeared (possibly related to my 
> > > post to the XFS list yesterday[0]).
> > 
> > Unlikely.
> 
> OK, so the "possible irq lock inversion dependency detected" is a lockdep 
> regression, as you explained in the xfs-list thread. What about the 
> "RECLAIM_FS-safe -> RECLAIM_FS-unsafe lock order detected" warning - I 
> haven't seen it again though, only once with 3.14.0-rc2.

That was also an i_lock/mmapsem issue, so it's likely to be the same
root cause. I'm testing a fix for it at the moment.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
