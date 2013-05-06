Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3EFMfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:35:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:30520 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab3EFMfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:35:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,621,1363158000"; 
   d="scan'208";a="332497871"
Message-ID: <5187A397.9040102@intel.com>
Date: Mon, 06 May 2013 20:35:35 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Phil Carmody <pc+lkml@asdf.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch v7 05/21] sched: log the cpu utilization at rq
References: <20130506120318.GM21274@fatphil.org>
In-Reply-To: <20130506120318.GM21274@fatphil.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 08:03 PM, Phil Carmody wrote:
>> > +     period = rq->avg.runnable_avg_period ? rq->avg.runnable_avg_period : 1;
>> > +     rq->util = (u64)(rq->avg.runnable_avg_sum << SCHED_POWER_SHIFT)
>> > +                             / period;
> Greetings, Alex.
> 
> That cast achieves nothing where it is. If the shift has overflowed,
> then you've already lost information; and if it can't overflow, then
> it's not needed at all. 
> 
> It's itsy-bitsy, but note that there exists a div_u64(u64 dividend,
> u32 divisor) helper which may be implemented to be superior to just '/'.
> (And also note that the assignment to ``period'' is a good candidate for
> gcc's ``?:'' operator.)
> 
> If you pull the cast inside the brackets, then you may add my
> Reviewed-by: Phil Carmody <pc+lkml@asdf.org>

You are right, Phil!
Thanks for review! :)

-- 
Thanks
    Alex
