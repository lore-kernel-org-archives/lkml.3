Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab3GHRwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:52:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab3GHRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:52:15 -0400
Date: Mon, 8 Jul 2013 13:52:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Message-ID: <20130708175201.GB9094@redhat.com>
References: <20130708100046.14417.12932.stgit@zurg>
 <20130708170047.GA18600@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708170047.GA18600@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 10:00:47AM -0700, Tejun Heo wrote:
> (cc'ing Vivek and Jens)
> 
> Hello,
> 
> On Mon, Jul 08, 2013 at 02:01:39PM +0400, Konstantin Khlebnikov wrote:
> > This is proof of concept, just basic functionality for IO controller.
> > This cgroup will control filesystem usage on vfs layer, it's main goal is
> > bandwidth control. It's supposed to be much more lightweight than memcg/blkio.
> 
> While blkcg is pretty heavy handed right now, there's no inherent
> reason for it to be that way.  The right thing to do would be updating
> blkcg to be light-weight rather than adding yet another controller.
> Also, all controllers should support full hierarchy.

Agreed.

Looks like he is looking to implement only throttling IO with max upper
limits in fsio controller. And I thought that throttling IO part of blkcg was
pretty light weight. Konstantin, is that not the case. Or you find even
throttling functionality to be heavy weigth. If you have ideas to make
it light weight, we can always change it.

> 
> > Unlike to blkio this method works for all of filesystems, not just disk-backed.
> > Also it's able to handle writeback, because each inode has context which can be
> > used in writeback thread to account io operations.
> 
> Again, a problem to be fixed in the stack rather than patching up from
> up above.  The right thing to do is to propagate pressure through bdi
> properly and let whatever is backing the bdi generate appropriate
> amount of pressure, be that disk or network.

Ok, so use network controller for controlling IO rate on NFS? I had
tried it once and it did not work. I think it had problems related
to losing the context info as IO propagated through the stack. So
we will have to fix that too.

Thanks
Vivek
