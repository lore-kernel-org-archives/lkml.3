Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3FFX4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:56:53 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:40348 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab3FFX4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:56:51 -0400
Date: Thu, 6 Jun 2013 16:56:47 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org
Subject: Re: [PATCH v7 08/11] sched: Push put_prev_task() into
 pick_next_task()
Message-ID: <20130606235647.GR5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-9-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-9-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:03:19PM +0400, Glauber Costa wrote:
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> In order to avoid having to do put/set on a whole cgroup hierarchy
> when we context switch, push the put into pick_next_task() so that
> both operations are in the same function. Further changes then allow
> us to possibly optimize away redundant work.

I suppose this is to optimize out css_put/get() if the previous and
next tasks are in the same group?  css refcnt will soon (this week) be
converted to percpu reference counter, so the optimization might not
be as meaningful unless there are other things which are being
optimized.

Thanks.

-- 
tejun
