Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131Ab3EBR5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:57:10 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:36453 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760373Ab3EBR5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:57:08 -0400
Date: Thu, 2 May 2013 10:57:01 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502175701.GL19814@mtj.dyndns.org>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502173428.GA4771@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Thu, May 02, 2013 at 01:34:28PM -0400, Vivek Goyal wrote:
> On Wed, May 01, 2013 at 05:39:18PM -0700, Tejun Heo wrote:
> 
> [..]
> > While this patchset contains many patches, the implementation is
> > pretty straight-forward.  throtl_grp's form a tree anchored at
> > throtl_data and bios climb the tree as they get dispatched at each
> > level.  The bios which reach the top of the tree - throl_data - are
> > issued. 
> 
> Have a question here. Looks like when bio climbs from child group
> to parent group, then parent group slice starts fresh if parent
> was empty. So if we have a parent with 1MB/s limit and a child with
> 1MB/s limit and a bio gets queued in child, then looks like effective
> IO rate would be .5MB/s and not 1MB/s?

Hmmm.... not that drastic but when the same limit is configured in
both parent and its single active child, the child gets penalized by
about 15%, which is not nice.

> IOW, when child gets queued, we should start time accounting for
> all parents in the hiearchy too.

I don't particularly like doing that as a separate step, maybe we can
just push the child's start time to the parent while dispatching?
Does that sound doable to you?

Thanks.

-- 
tejun
