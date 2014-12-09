Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932337AbaLIPtF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:49:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbaLIPtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:49:03 -0500
Date: Tue, 9 Dec 2014 10:48:59 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>,
        gregkh@linuxfoundation.org, agk@redhat.com,
        linux-kernel@vger.kernel.org, ejt@redhat.com
Subject: Re: staging: writeboost: Add dm-writeboost
Message-ID: <20141209154859.GC26238@redhat.com>
References: <5484498E.4000202@gmail.com>
 <20141207200834.GA2322@kroah.com>
 <5484C0E9.3060707@gmail.com>
 <20141209151253.GA17660@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209151253.GA17660@debian>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 09 2014 at 10:12am -0500,
Joe Thornber <thornber@redhat.com> wrote:

> On Mon, Dec 08, 2014 at 06:04:41AM +0900, Akira Hayakawa wrote:
> > Mike and Alasdair,
> > I need your ack
> 
> Hi Akira,
> 
> I just spent some time playing with your latest code.  On the positive
> side I am seeing some good performance with the fio tests.  Which is
> great, we know your design should outperform dm-cache with small
> random io.
> 
> However I'm still getting v. poor results with the git-extract test,
> which clones a linux kernel repo, and then checks out 5 revisions, all
> with drop_caches in between.

Thanks for re-evaluating dm-writeboost performance Joe.

> It's fine to have different benefits of the caching software depending
> on the load.  But I think the worst case should always be close to the
> performance of the raw spindle device.
> 
> If you get the following work items done I will ack to go upstream:
> 
> i) Get this test so it's performance is similar to raw spindle.
> 
> ii) Write good documentation in Documentation/device-mapper/.  eg. How
>     do I remove a cache?  When should I use dm-writeboost rather than
>     bcache or dm-cache?
> 
> iii) Provide an equivalent to the fsck tool to repair a damaged cache.

I agree with this TODO list.  But I'd also add:
 iv) perform full code review to catch various implementation issues,
     any style nits, etc.

 v) explore/implement read caching support (could the lack of read
    caching be contributing to why the git_extract test is so poor?)

Item iv) would be a task for myself and anyone else interested in
getting dm-writeboost ready for inclusion.  Akira, I can start working
on dm-writeboost code review once I complete review of the dm-dedup
target (my current priority) -- but realistically that likely won't be
until the new year.

BTW, I'm really not seeing much point putting dm-writeboost in staging.
I'd be happy to take dm-writeboost into drivers/md/ once the above list
is resolved.  BUT if you'd still like dm-writeboost to go into staging
_without_ any of these 5 work items being completed I'll ack it but to
be very clear: dm-writeboost will not migrate out of staging until these
items are resolved.

Thanks,
Mike
