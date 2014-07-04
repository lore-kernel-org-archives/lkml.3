Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242AbaGDRS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 13:18:29 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:39366 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaGDRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 13:18:28 -0400
Date: Fri, 4 Jul 2014 13:18:24 -0400
From: Tejun Heo <tj@kernel.org>
To: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        Shirish Pargaonkar <spargaonkar@suse.com>, axboe@kernel.dk
Subject: Re: [PATCH] blkio: Release blkg infrastructure only after last
 policy is deactivated.
Message-ID: <20140704171824.GC11787@mtj.dyndns.org>
References: <1403549545-6535-1-git-send-email-spargaonkar@suse.com>
 <20140624210930.GD14909@htj.dyndns.org>
 <CADT32eJPAty_yGA5UGZV9h7XHN_8Sn70v1vhRRn7+URvU+URGA@mail.gmail.com>
 <20140624214340.GE14909@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140624214340.GE14909@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 05:43:40PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jun 24, 2014 at 04:37:58PM -0500, Shirish Pargaonkar wrote:
> > When we start from blk_cleanup_queue(), we put request queue in bypass mode,
> > drain it (and service queues), and then destroy blkcgs (explicitly)
> > 
> > When we start from blk_release_queue(), we do not drain first and then
> > destroy blkcgs.  So if we destroy blkcg and then call (implicitly) and
> > bail out of
> > blk_drain_queue, we would not have drained the service queues which
> > is not what we want.
> 
> I'm not really following you.  What do you mean "when we start from
> blk_release_queue()"?  blk_release_queue() is called after the last
> put which can only follow blk_cleanup_queue() if the queue is fully
> initialized.  The queue is already in bypass mode and fully drained by
> the time control reaches blk_release_queue().  Module [un]load
> re-invoking the path doesn't change anything.
> 
> > I do not see any harm in waiting till end to release blkcgs (as I understand).
> 
> Well, the harm there is not freeing those blkgs unless all the blkcg
> policies are unloaded which is usually never on most systems.

Ping.  We have a patch which makes this problem more visible.  Are you
still planning to re-spin the patch?

Thanks.

-- 
tejun
