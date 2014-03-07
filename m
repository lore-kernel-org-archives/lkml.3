Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaCGP1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:27:48 -0500
Received: from mail-yk0-f177.google.com ([209.85.160.177]:62883 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaCGP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:27:47 -0500
Date: Fri, 7 Mar 2014 10:27:44 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 9/9] workqueue: remove PREPARE_[DELAYED_]WORK()
Message-ID: <20140307152744.GI30778@htj.dyndns.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
 <1392929071-16555-10-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392929071-16555-10-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 03:44:31PM -0500, Tejun Heo wrote:
> Peter Hurley noticed that since a2c1c57be8d9 ("workqueue: consider
> work function when searching for busy work items"), a work item which
> gets assigned a different work function would break out of the
> non-reentrancy guarantee as workqueue would consider it a different
> work item.
> 
> This is fragile and extremely subtle.  PREPARE_[DELAYED_]WORK() have
> never been used widely and its semantics has always been somewhat
> iffy.  If the work item is known not to be on queue when
> PREPARE_WORK() is called, there's no difference from using
> INIT_WORK().  If the work item may be queued at the time of
> PREPARE_WORK(), we can't really tell whether the old or new function
> will be executed the next time.
> 
> We really don't want this level of subtlety in workqueue interface for
> such marginal use cases.  The previous patches converted all existing
> users away from PREPARE_[DELAYED_]WORK().  Let's remove them.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Peter Hurley <peter@hurleysoftware.com>
> Link: http://lkml.kernel.org/g/1392493119-9277-1-git-send-email-peter@hurleysoftware.com

Applied to wq/for-3.15.

Thanks.

-- 
tejun
