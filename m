Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbaFSBqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:46:07 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:44895 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbaFSBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:46:04 -0400
Date: Wed, 18 Jun 2014 21:46:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 00/12] New version of the BFQ I/O
 Scheduler
Message-ID: <20140619014600.GA20100@mtj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <20140530160712.GG24871@htj.dyndns.org>
 <538926F6.7080409@kernel.dk>
 <20140531051635.GA19925@mtj.dyndns.org>
 <538C8A47.1050502@kernel.dk>
 <0A5218F8-0215-4B4F-959B-EE5AAEFC164A@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0A5218F8-0215-4B4F-959B-EE5AAEFC164A@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 17, 2014 at 05:55:57PM +0200, Paolo Valente wrote:
> In general, with both a smooth but messy and a sharp but clean
> transformation, there seems to be the following common problems:
>
> 1) The main benefits highlighted by Jens, i.e., being able to move
> back and forth and easily understand what works and what does not,
> seem to be lost, because, with both solutions, intermediate versions
> would likely have a worse performance than the current version of
> cfq.

So, the perfectly smooth and performant transformation is possible,
it'd be great, but I don't really think that'd be the case.  My
opinion is that if the infrastructure pieces can be mostly maintained
while making logical gradual steps it should be fine.  ie. pick
whatever strategy which seems executable, chop down the pieces which
get in the way (ie. tear down all the cfq heuristics if you have to),
transform the base and then build things on top again.  Ensuring that
each step is logical and keeps working should give us enough safety
net, IMO.

Jens, what do you think?

> 2) bfq, on one side, does not export some of the sysfs parameters of
> cfq, such as slice_sync, and, on the other side, uses other common
> parameters in a different way. For example, bfq turns I/O priorities
> into throughput shares in a different way than cfq does. As a
> consequence, existing configurations may break or behave in
> unexpected ways.

This is why I hate exposing internal knobs without layering proper
semantic interpretation on top.  It ends up creating unnecessary
lock-in effect too often just to serve some esoteric cases which
aren't all that useful.  For knobs which don't make any sense for the
new scheduler, the appropriate thing to do would be just making them
noop and generate a warning message when it's written to.

As for behavior change for existing users, any change to scheduler
does that.  I don't think it's practical to avoid any changes for that
reason.  I think there already is a pretty solid platform to base
things on and the way forward is making the changes and iterating as
testing goes on and issues get reported.

Thanks.

-- 
tejun
