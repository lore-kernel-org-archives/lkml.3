Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505Ab3EBReg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758632Ab3EBRee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:34:34 -0400
Date: Thu, 2 May 2013 13:34:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502173428.GA4771@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367455189-6957-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 05:39:18PM -0700, Tejun Heo wrote:

[..]
> While this patchset contains many patches, the implementation is
> pretty straight-forward.  throtl_grp's form a tree anchored at
> throtl_data and bios climb the tree as they get dispatched at each
> level.  The bios which reach the top of the tree - throl_data - are
> issued. 

Have a question here. Looks like when bio climbs from child group
to parent group, then parent group slice starts fresh if parent
was empty. So if we have a parent with 1MB/s limit and a child with
1MB/s limit and a bio gets queued in child, then looks like effective
IO rate would be .5MB/s and not 1MB/s?

IOW, when child gets queued, we should start time accounting for
all parents in the hiearchy too.

Thanks
Vivek
