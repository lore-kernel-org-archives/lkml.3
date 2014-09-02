Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaIBSuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:50:11 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40505 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaIBSuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:50:08 -0400
Date: Tue, 2 Sep 2014 14:50:05 -0400
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org, cl@linux-foundation.org
Cc: laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCHSET REPOST percpu/for-3.18] percpu: implement atomic
 allocation support
Message-ID: <20140902185005.GA28687@mtj.dyndns.org>
References: <1408726399-4436-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408726399-4436-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 12:53:04PM -0400, Tejun Heo wrote:
> (the initial posting was missing cc's, reposting)
> 
> Due to the use of vmalloc area allocations and page table populations,
> preparing percpu areas require GFP_KERNEL and all the allocator users
> are expected to be able to perform GFP_KERNEL allocations.  This is
> mostly okay but there are cases where atomic percpu allocations are
> necessary usually in the IO path.
> 
> Currently, blk-throttle is implementing its own ad-hoc async
> allocation and there are some more planned similar usages.  I posted
> [1] percpu_pool which generalizes the percpu atomic allocation a bit
> but this was a bit too cumbersome especially to use with other library
> data structures which make use of percpu memory as a part of it.
> 
> This patchset implements proper atomic allocation support in the
> percpu allocator.  It's largely composed of two parts.  The first is
> updates to the area allocator so that it can skip non-populated areas.
> The second is async filling mechanisms which try to maintain a certain
> level of empty populated areas.  The allocator currently tries to keep
> the number of empty populated pages between 2 and 4.  Even with fairly
> aggressive back-to-back allocations, this seems enough to satisfy most
> allocations as long as the allocation size is under a page.

1-2 applied to percpu/for-3.17-fixes.  The rest applied to
percpu/for-3.18.

Thanks.

-- 
tejun
