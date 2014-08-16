Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbaHPMUe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 08:20:34 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:50464 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaHPMUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 08:20:33 -0400
Date: Sat, 16 Aug 2014 08:20:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v3 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140816122028.GC9305@htj.dyndns.org>
References: <1408050926-9525-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408050926-9525-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 02:15:25PM -0700, Cong Wang wrote:
> +static bool should_thaw_current(bool check_kthr_stop)
> +{
> +	if (!freezing(current) ||
> +	    (check_kthr_stop && kthread_should_stop()) ||
> +	    test_thread_flag(TIF_MEMDIE))
> +		return true;
> +	else
> +		return false;
> +}

I'm not sure this is safe w.r.t. hibernation.  Please cc Rafael on
freezer related changes.

Thanks.

-- 
tejun
