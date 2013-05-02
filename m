Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426Ab3EBTAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:00:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761292Ab3EBS77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:59:59 -0400
Date: Thu, 2 May 2013 14:59:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, lizefan@huawei.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
Message-ID: <20130502185952.GJ30020@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
 <20130502173428.GA4771@redhat.com>
 <20130502180815.GG30020@redhat.com>
 <20130502184426.GO19814@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502184426.GO19814@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 02, 2013 at 11:44:26AM -0700, Tejun Heo wrote:

[..]
> Also, if you're actually thinking about reimplementing blk-throttle,
> please do consider the followings.
> 
> * Currently, blk-throttle doesn't throttle the number of bios being
>   queued.  Note that this breaks the basic back-pressure mechanism
>   where IO pressure is propagated back to the issuer by throttling the
>   issuing task.  blk-throttle breaks that link and converts it to a
>   memory pressure.

Agreed. Implementing something along the lines of per group nr_requests
is needed.

> 
> * It's almost inherently unscalable with highops devices.  Given that
>   IO limiting doesn't require very fine granularity, I think doing
>   this per-cpu shouldn't be too hard.  e.g. build a per-cpu token
>   distributing hierarchy with rebalancing across CPUs happening
>   periodically.

Interesting. I thought for highops devices we will these multi queue
patches from jens and there we can probably implement per queue tokens
and rebalance tokens across queues periodically.

> 
> In short, right now, the goal is getting the hierarchy support
> acceptably working ASAP and yeap we wanna get the nested limits and at
> least certain level of fairness, but let's please implement something
> simple for now and strive for sophistification later because it's
> holding back everyone else.

I am fine with this. Having some hierarchical algorithm and not blocking
full hierarchical support for cgroup is better than not having any
hierachical support and wait for better implementation.

Thanks
Vivek
