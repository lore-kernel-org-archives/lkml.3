Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbaDXPdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:33:31 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:37679 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767AbaDXPdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:33:25 -0400
Date: Thu, 24 Apr 2014 11:33:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 4/4] workqueue: Handle ordered workqueues on
 cpumask_unbounds change
Message-ID: <20140424153320.GF14460@htj.dyndns.org>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-5-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398350256-7834-5-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 04:37:36PM +0200, Frederic Weisbecker wrote:
> Ordered unbound workqueues need some special care if we want to
> modify their CPU affinity. These can't be simply handled through
> apply_workqueue_attrs() since it works by hot plugging worker pools
> which has parallelism side effects and this would break ordering.
> 
> The way we solve this is to change the affinity of the (presumaly
> unique) worker backing the ordered workqueues.
> 
> NOTE: Now like Lai said, there may be bad side effects on this because
> ordered wq may share their worker pool with non-ordered workqueues.
> So changing the affinity of the worker itself is not a nice solution.
> This patch is very likely to be replaced by Lai's patch
> "workqueue: allow changing attributions of ordered workqueue"
> https://lkml.org/lkml/2014/4/15/181

Yeah, it bothers me that we're taking two completely different
approaches for ordered and !ordered workqueues.  The only difference
between them is concurrency and it probably would be a better idea to
address that directly.

Thanks.

-- 
tejun
