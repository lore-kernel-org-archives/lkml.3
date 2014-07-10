Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaGJLSl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 07:18:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:35537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbaGJLSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 07:18:39 -0400
Date: Thu, 10 Jul 2014 13:18:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v3 08/12] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20140710111833.GY3935@laptop>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 06:05:39PM +0200, Vincent Guittot wrote:
> +		/*
> +		 * If the CPUs share their cache and the src_cpu's capacity is
> +		 * reduced because of other sched_class or IRQs, we trig an
> +		 * active balance to move the task
> +		 */
> +		if ((sd->flags & SD_SHARE_PKG_RESOURCES)
> +		 && ((capacity_orig_of(src_cpu) * 100) > (capacity_of(src_cpu) *
> +							sd->imbalance_pct)))
>  			return 1;

Why is this tied to shared caches?
