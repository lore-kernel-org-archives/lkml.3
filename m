Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbaIEOI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:08:26 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:46785 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbaIEOIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:08:23 -0400
Date: Fri, 5 Sep 2014 23:08:15 +0900
From: Tejun Heo <tj@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140905140815.GA10455@mtj.dyndns.org>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 04, 2014 at 03:30:41PM -0700, Cong Wang wrote:
...
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Prolly should stable@vger.kernel.org?

> +static bool should_thaw_current(bool check_kthr_stop)
> +{
> +	if (!freezing(current))
> +		return true;
> +
> +	if (check_kthr_stop && kthread_should_stop())
> +		return true;
> +
> +	/* It might not be safe to check TIF_MEMDIE for pm freeze. */

This is just another representation of the following code which isn't
particularly useful.  Wouldn't it be better if the comment actually
explains why this might not be safe?

> +	if (cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
> +		return true;
> +
> +	return false;
> +}

Other than that,

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
