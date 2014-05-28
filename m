Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150AbaE1PDU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:03:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaE1PDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:03:18 -0400
Date: Wed, 28 May 2014 11:03:14 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/md/block: Alloc space for member flush_rq
Message-ID: <20140528150314.GB25249@redhat.com>
References: <1401258172-17381-1-git-send-email-zhen-hual@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401258172-17381-1-git-send-email-zhen-hual@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28 2014 at  2:22am -0400,
Li, Zhen-Hua <zhen-hual@hp.com> wrote:

> This patch is trying to fix a kernel crash bug.
> 
> When kernel boots on a HP large system, it crashes.
> The reason is when blk_rq_init is called, the second parameter rq , which
> is a member as q->flush_rq, is NULL. Kernel does not allocate space for it.
> 
> This fix adds an alloc for flush_rq member when request_queue is created in
> struct mapped_device *alloc_dev(int minor);
> 
> Bug Details:
> Error message:
> 
> [   62.931942] BUG: unable to handle kernel NULL pointer dereference at (null)
> [   62.931949] IP: [<ffffffff812b3f30>] blk_rq_init+0x40/0x160^M
> [   62.931949] PGD 0 ^M
> [   62.931951] Oops: 0002 [#1] SMP

You didn't specify which kernel you're running.  But this was fixed for
v3.15-rc6 via linux.git commit 7982e90c3a5 ("block: fix q->flush_rq NULL
pointer crash on dm-mpath flush").  And then there was the follow-on fix
from linux.git commit 708f04d2ab ("block: free q->flush_rq in
blk_init_allocated_queue error paths")

So all this is to say: Nack to your patch, we've already fixed the issue
differently.
