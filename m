Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3BVRzk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 12:55:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:21843 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3BVRzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 12:55:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,717,1355126400"; 
   d="scan'208";a="260345529"
Date: Fri, 22 Feb 2013 09:55:30 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, fweisbec@gmail.com, john.stultz@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/2][RFC] time : set broadcast irq affinity
Message-ID: <20130222095530.377fd218@chromoly>
In-Reply-To: <1361484083-5906-2-git-send-email-daniel.lezcano@linaro.org>
References: <5123C299.3080005@linaro.org>
	<1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org>
	<1361484083-5906-2-git-send-email-daniel.lezcano@linaro.org>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013 23:01:23 +0100
Daniel Lezcano <daniel.lezcano@linaro.org> wrote:

> +/*
> + * Set broadcast interrupt affinity
> + */
> +static void tick_broadcast_set_affinity(struct clock_event_device
> *bc, int cpu) +{
> +	struct cpumask cpumask;
> +
> +	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
> +		return;
> +
> +	cpumask_clear(&cpumask);
> +	cpumask_set_cpu(cpu, &cpumask);
> +	irq_set_affinity(bc->irq, &cpumask);
would it be more efficient to keep track of the current bc->irq affinity
via cpumask then set it only if it is different?

-- 
Thanks,

Jacob
