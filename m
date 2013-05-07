Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3EGORG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:17:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083Ab3EGORC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:17:02 -0400
Date: Tue, 7 May 2013 10:16:57 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET v2] blk-throttle: implement proper hierarchy support
Message-ID: <20130507141657.GC7082@redhat.com>
References: <1367880372-28312-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367880372-28312-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 03:45:39PM -0700, Tejun Heo wrote:
> Changes since the last take[L] are
> 
> * Unnecessary throtl_schedule_delayed_work() call dropped from 0007.
> 
> * throtl_log() implement in 0021 forgot to print space after blkg
>   path.  Fixed.
> 
> * 0030-blk-throttle-add-throtl_qnode-for-dispatch-fairness.patch added
>   to address dispatch fairness.
> 
> * 0031-blk-throttle-Account-for-child-group-s-start-time-in.patch
>   added to address unwarranted penalty of nested limit enforcement due
>   to staggered delays of slice start times at multiple levels.
> 
> The original patchset description follows.

Hi Tejun,

Can you please also update blkio-controller.txt file to reflect the
fact that now throttling also supports hierarchy. One of the places
which needs updation is following.

Hierarchical Cgroups
====================
- Currently only CFQ supports hierarchical groups. For throttling,
  cgroup interface does allow creation of hierarchical cgroups and
  internally it treats them as flat hierarchy.

Thanks
Vivek
