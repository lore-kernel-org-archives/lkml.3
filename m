Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752416AbaBLPak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:30:40 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:51042 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbaBLPai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:30:38 -0500
Date: Wed, 12 Feb 2014 10:30:33 -0500
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] cgroup: update cgroup_transfer_tasks() to either
 succeed or fail
Message-ID: <20140212153033.GA26809@htj.dyndns.org>
References: <1392063694-26465-1-git-send-email-tj@kernel.org>
 <1392063694-26465-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392063694-26465-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 03:21:34PM -0500, Tejun Heo wrote:
> cgroup_transfer_tasks() can currently fail in the middle due to memory
> allocation failure.  When that happens, the function just aborts and
> returns error code and there's no way to tell how many actually got
> migrated at the point of failure and or to revert the partial
> migration.
> 
> Update it to use cgroup_migrate{_add_src|prepare_dst|migrate|finish}()
> so that the function either succeeds or fails as a whole as long as
> ->can_attach() doesn't fail.

While this solves one aspect of the problem, it may still race with
fork and may leave newly forked tasks behind.  I'll think more about
it.

Thanks.

-- 
tejun
