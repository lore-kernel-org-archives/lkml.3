Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaHQXmU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 19:42:20 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:28003 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751556AbaHQXmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 19:42:19 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhMRAGs98VN5LDJ8PGdsb2JhbABYgw2BKoIshQenfwEBAQMGnnyFewGBEBcFAQEBATg2hAQBBTocIxAIAxgJJQ8FJQMHGhOIQcECFxiFZIlQB4MvgR0BBIUEA5c6mHMrL4JPAQEB
Date: Mon, 18 Aug 2014 09:41:52 +1000
From: Dave Chinner <david@fromorbit.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <davidlohr@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH 2/7] locking/rwsem: more aggressive use of optimistic
 spinning
Message-ID: <20140817234152.GC26465@dastard>
References: <1407119782-41119-1-git-send-email-Waiman.Long@hp.com>
 <1407119782-41119-3-git-send-email-Waiman.Long@hp.com>
 <1407125450.4710.38.camel@j-VirtualBox>
 <53DFAA53.4010003@hp.com>
 <20140813055153.GD20518@dastard>
 <53EB9522.2070804@hp.com>
 <20140815033447.GJ20518@dastard>
 <53EE4A31.5080407@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EE4A31.5080407@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 01:58:09PM -0400, Waiman Long wrote:
> On 08/14/2014 11:34 PM, Dave Chinner wrote:
> >
> ><create sparse vm image file of 500TB on ssd with XFS on it>
> >xfs_io -f -c "truncate 500t" -c "extsize 1m" /path/to/vm/image/file
....
> 
> Thank for the testing recipe. I am afraid that I can't find a 500TB
> SSD for testing purpose.

Which bit of "sparse vm image file" didn't you understand?  I'm
using a 400GB of SSD for this testing....

$ df -h /mnt/fast-ssd
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdf        400G  275G  125G  69% /mnt/fast-ssd
$ ls -lh /mnt/fast-ssd/vm-500t.img
-rw------- 1 root root 500T Aug 15 13:21 /mnt/fast-ssd/vm-500t.img
$ du -sh /mnt/fast-ssd/vm-500t.img
275G    /mnt/fast-ssd/vm-500t.img

That is on a Samsung 840 EVO SSD, which just about everyone should
be able to obtain. Do you *really* think I have 500TB of SSDs lying
around?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
