Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273AbaJ0PSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:18:12 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:63276 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbaJ0PSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:18:09 -0400
Date: Mon, 27 Oct 2014 11:18:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Zefan Li <lizefan@huawei.com>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH RESEND 2/4] cpuset: simplify cpuset_node_allowed API
Message-ID: <20141027151806.GR4436@htj.dyndns.org>
References: <cover.1413804554.git.vdavydov@parallels.com>
 <c52e3c30a61d29da40b69b602c41c2d91868c3ae.1413804554.git.vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c52e3c30a61d29da40b69b602c41c2d91868c3ae.1413804554.git.vdavydov@parallels.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 03:50:30PM +0400, Vladimir Davydov wrote:
> Current cpuset API for checking if a zone/node is allowed to allocate
> from looks rather awkward. We have hardwall and softwall versions of
> cpuset_node_allowed with the softwall version doing literally the same
> as the hardwall version if __GFP_HARDWALL is passed to it in gfp flags.
> If it isn't, the softwall version may check the given node against the
> enclosing hardwall cpuset, which it needs to take the callback lock to
> do.
> 
> Such a distinction was introduced by commit 02a0e53d8227 ("cpuset:
> rework cpuset_zone_allowed api"). Before, we had the only version with
> the __GFP_HARDWALL flag determining its behavior. The purpose of the
> commit was to avoid sleep-in-atomic bugs when someone would mistakenly
> call the function without the __GFP_HARDWALL flag for an atomic
> allocation. The suffixes introduced were intended to make the callers
> think before using the function.
> 
> However, since the callback lock was converted from mutex to spinlock by
> the previous patch, the softwall check function cannot sleep, and these
> precautions are no longer necessary.
> 
> So let's simplify the API back to the single check.
> 
> Suggested-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Acked-by: Zefan Li <lizefan@huawei.com>

Applied 1-2 to cgroup/for-3.19-cpuset-api-simplification which
contains only these two patches on top of v3.18-rc2 and will stay
stable.  sl[au]b trees can pull it in or I can take the other two
patches too.  Please let me know how the other two should be routed.

Thanks.

-- 
tejun
