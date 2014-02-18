Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbaBRWd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:33:27 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:63689 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaBRWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:31:55 -0500
Date: Tue, 18 Feb 2014 17:31:50 -0500
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] workqueue: kick worker to die directly in idle
 timeout handler
Message-ID: <20140218223150.GE31892@mtj.dyndns.org>
References: <1392472948-2486-1-git-send-email-laijs@cn.fujitsu.com>
 <1392654243-2829-1-git-send-email-laijs@cn.fujitsu.com>
 <1392654243-2829-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392654243-2829-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 12:24:03AM +0800, Lai Jiangshan wrote:
> since original destroy_worker() does not do the full-destruction,
> its main work just deprives the worker-duty from worker-thread and kick
> it to die, so we rename it to kick_worker_to_die().
> 
> And since kick_worker_to_die() don't need manager_mutex and sleeping,
> so we move maybe_destroy_worker() out from manager and kick worker to die
> directly in idle timeout handler. And we remove %POOL_MANAGE_WORKERS which
> help us remove a branch in worker_thread().
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Heh, this is awesome. :)

Thanks.

-- 
tejun
