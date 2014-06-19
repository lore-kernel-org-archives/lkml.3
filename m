Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbaFSQaE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 12:30:04 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:49757 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757405AbaFSQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 12:30:02 -0400
Date: Thu, 19 Jun 2014 12:29:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workqueue: clear leftover flags when detached
Message-ID: <20140619162958.GM26904@htj.dyndns.org>
References: <1401780772-12263-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401780772-12263-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 03:32:52PM +0800, Lai Jiangshan wrote:
> When a worker is detached, the worker->flags may still have WORKER_UNBOUND
> or WORKER_REBOUND, it is OK for all cases:
>   1) if it is a normal worker, the worker will be dead, it is OK.
>   2) if it is a rescuer, it may re-attach to a pool with this leftover flag[s],
>      it is still correct except it may cause unneeded wakeup.
> 
> It is correct but not good, so we just remove the leftover flags.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied to wq/for-3.17.

Thanks.

-- 
tejun
