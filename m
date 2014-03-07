Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaCGP1D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:27:03 -0500
Received: from mail-yk0-f171.google.com ([209.85.160.171]:34537 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaCGP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:26:59 -0500
Date: Fri, 7 Mar 2014 10:26:55 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCH 6/9] nvme: don't use PREPARE_WORK
Message-ID: <20140307152655.GG30778@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392929071-16555-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:44:28PM -0500, Tejun Heo wrote:
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
> 
> nvme_dev->reset_work is multiplexed with multiple work functions.
> Introduce nvme_reset_workfn() which invokes nvme_dev->reset_workfn and
> always use it as the work function and update the users to set the
> ->reset_workfn field instead of overriding the work function using
> PREPARE_WORK().
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.
> 
> Compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: linux-nvme@lists.infradead.org

Applied to wq/for-3.15.  Please holler if there's any objection.

Thanks.

-- 
tejun
