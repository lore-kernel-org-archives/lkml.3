Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430AbaA3Tjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:39:54 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:40311 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaA3Tjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:39:52 -0500
Date: Thu, 30 Jan 2014 14:39:49 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
cc: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [RFC PATCH 1/3] cpuidle: split cpuidle_idle_call main function
 into functions
In-Reply-To: <1391090962-15032-2-git-send-email-daniel.lezcano@linaro.org>
Message-ID: <alpine.LFD.2.11.1401301433320.1652@knanqh.ubzr>
References: <1391090962-15032-1-git-send-email-daniel.lezcano@linaro.org> <1391090962-15032-2-git-send-email-daniel.lezcano@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jan 2014, Daniel Lezcano wrote:

>  /**
> + * cpuidle_select - ask the cpuidle framework to choose an idle state
> + *
> + * @drv: the cpuidle driver
> + * @dev: the cpuidle device
> + *
> + * Returns the index of the idle state. On error it returns:
> + * -NODEV : the cpuidle framework is available

s/available/not available/

> + * -EBUSY : the cpuidle framework is not initialized
> + */
> +int cpuidle_select(struct cpuidle_driver *drv, struct cpuidle_device *dev)
> +{
> +	if (off || !initialized)
> +		return -ENODEV;
> +
> +	if (!drv || !dev || !dev->enabled)
> +		return -EBUSY;
> +
> +	return cpuidle_curr_governor->select(drv, dev);
> +}
> +EXPORT_SYMBOL(cpuidle_select);

Peterz comment notwithstanding, is there actually a need to export those 
symbols? No modules should ever need to use this given this is going to 
be called by the scheduler code.

Ditto for the other symbols.


Nicolas
