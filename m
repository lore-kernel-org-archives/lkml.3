Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaCGP10 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:27:26 -0500
Received: from mail-yk0-f175.google.com ([209.85.160.175]:59289 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbaCGP1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:27:22 -0500
Date: Fri, 7 Mar 2014 10:27:19 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH 7/9] afs: don't use PREPARE_WORK
Message-ID: <20140307152719.GH30778@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-8-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392929071-16555-8-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:44:29PM -0500, Tejun Heo wrote:
> PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
> and a nasty surprise in terms of reentrancy guarantee as workqueue
> considers work items to be different if they don't have the same work
> function.
> 
> afs_call->async_work is multiplexed with multiple work functions.
> Introduce afs_async_workfn() which invokes afs_call->async_workfn and
> always use it as the work function and update the users to set the
> ->async_workfn field instead of overriding the work function using
> PREPARE_WORK().
> 
> It would probably be best to route this with other related updates
> through the workqueue tree.
> 
> Compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-afs@lists.infradead.org

Applied to wq/for-3.15.  Please holler if there's any objection.

Thanks.

-- 
tejun
