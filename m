Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752741Ab3GHRAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 13:00:55 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:37616 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3GHRAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 13:00:53 -0400
Date: Mon, 8 Jul 2013 10:00:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Sha Zhengju <handai.szj@gmail.com>, devel@openvz.org,
        Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH RFC] fsio: filesystem io accounting cgroup
Message-ID: <20130708170047.GA18600@mtj.dyndns.org>
References: <20130708100046.14417.12932.stgit@zurg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708100046.14417.12932.stgit@zurg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Vivek and Jens)

Hello,

On Mon, Jul 08, 2013 at 02:01:39PM +0400, Konstantin Khlebnikov wrote:
> This is proof of concept, just basic functionality for IO controller.
> This cgroup will control filesystem usage on vfs layer, it's main goal is
> bandwidth control. It's supposed to be much more lightweight than memcg/blkio.

While blkcg is pretty heavy handed right now, there's no inherent
reason for it to be that way.  The right thing to do would be updating
blkcg to be light-weight rather than adding yet another controller.
Also, all controllers should support full hierarchy.

> Unlike to blkio this method works for all of filesystems, not just disk-backed.
> Also it's able to handle writeback, because each inode has context which can be
> used in writeback thread to account io operations.

Again, a problem to be fixed in the stack rather than patching up from
up above.  The right thing to do is to propagate pressure through bdi
properly and let whatever is backing the bdi generate appropriate
amount of pressure, be that disk or network.

> This is early prototype, I have some plans about extra functionality because
> this accounting itself is mostly useless, but it can be used as basis for more
> usefull features.

I'm afraid it'd have very low chance of making upstream.  If this area
of work is interesting / important, please look into improving blkcg
rather than working around it.

Thanks.

-- 
tejun
