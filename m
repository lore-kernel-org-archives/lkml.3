Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab3DLEux (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 00:50:53 -0400
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:11524 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab3DLEuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 00:50:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcVAF6SZ1F5LLHC/2dsb2JhbABQDoJ4gnu5eIUYBAGBCRd0gh8BAQU6HDMIAxgJJQ8FJQMhARIbh3i9QhWNZIEkgmBhA5cBkRCCTFEq
Date: Fri, 12 Apr 2013 14:50:42 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mgorman@suse.de>, linux-ext4@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: Excessive stall times on ext4 in 3.9-rc2
Message-ID: <20130412045042.GA30622@dastard>
References: <20130402142717.GH32241@suse.de>
 <20130402150651.GB31577@thunk.org>
 <20130410105608.GC1910@suse.de>
 <20130410131245.GC4862@thunk.org>
 <20130411170402.GB11656@suse.de>
 <20130411183512.GA12298@thunk.org>
 <20130411213335.GE9379@quack.suse.cz>
 <20130412025708.GB7445@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130412025708.GB7445@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 10:57:08PM -0400, Theodore Ts'o wrote:
> On Thu, Apr 11, 2013 at 11:33:35PM +0200, Jan Kara wrote:
> >   I think it might be more enlightening if Mel traced which process in
> > which funclion is holding the buffer lock. I suspect we'll find out that
> > the flusher thread has submitted the buffer for IO as an async write and
> > thus it takes a long time to complete in presence of reads which have
> > higher priority.
> 
> That's an interesting theory.  If the workload is one which is very
> heavy on reads and writes, that could explain the high latency.  That
> would explain why those of us who are using primarily SSD's are seeing
> the problems, because would be reads are nice and fast.
> 
> If that is the case, one possible solution that comes to mind would be
> to mark buffer_heads that contain metadata with a flag, so that the
> flusher thread can write them back at the same priority as reads.

Ext4 is already using REQ_META for this purpose.

I'm surprised that no-one has suggested "change the IO elevator"
yet.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
