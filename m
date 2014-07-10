Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaGJLHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:07:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbaGJLHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:07:03 -0400
Date: Thu, 10 Jul 2014 13:06:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 07/12] sched: test the cpu's capacity in wake affine
Message-ID: <20140710110644.GX3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-8-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404144343-18720-8-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 06:05:38PM +0200, Vincent Guittot wrote:
> Currently the task always wakes affine on this_cpu if the latter is idle.
> Before waking up the task on this_cpu, we check that this_cpu capacity is not
> significantly reduced because of RT tasks or irq activity.
> 
> Use case where the number of irq and/or the time spent under irq is important
> will take benefit of this because the task that is woken up by irq or softirq
> will not use the same CPU than irq (and softirq) but a idle one which share
> its cache.

The above, doesn't seem to explain:

> +	} else if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
> +		this_eff_load = 0;
> +	}
> +
> +	balanced = this_eff_load <= prev_eff_load;

this. Why would you unconditionally allow wake_affine across cache
domains?
