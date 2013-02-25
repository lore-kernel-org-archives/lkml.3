Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab3BYWub (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 17:50:31 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:59636 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab3BYWuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 17:50:24 -0500
Message-ID: <512BEAAF.1070500@linaro.org>
Date: Mon, 25 Feb 2013 23:50:23 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, santosh.shilimkar@ti.com,
        linux-pm@vger.kernel.org, fweisbec@gmail.com, john.stultz@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/2][RFC] time : set broadcast irq affinity
References: <5123C299.3080005@linaro.org> <1361484083-5906-1-git-send-email-daniel.lezcano@linaro.org> <1361484083-5906-2-git-send-email-daniel.lezcano@linaro.org> <20130222095530.377fd218@chromoly>
In-Reply-To: <20130222095530.377fd218@chromoly>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2013 06:55 PM, Jacob Pan wrote:
> On Thu, 21 Feb 2013 23:01:23 +0100
> Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> 
>> +/*
>> + * Set broadcast interrupt affinity
>> + */
>> +static void tick_broadcast_set_affinity(struct clock_event_device
>> *bc, int cpu) +{
>> +	struct cpumask cpumask;
>> +
>> +	if (!(bc->features & CLOCK_EVT_FEAT_DYNIRQ))
>> +		return;
>> +
>> +	cpumask_clear(&cpumask);
>> +	cpumask_set_cpu(cpu, &cpumask);
>> +	irq_set_affinity(bc->irq, &cpumask);
> would it be more efficient to keep track of the current bc->irq affinity
> via cpumask then set it only if it is different?

Do you mean a cpumask static variable ? and something like:

if (!cpumask_test_cpu(cpu, &affinitymask)) {
	cpumask_set_cpu(cpu, &affinitymask);
	irq_set_affinity(bc->irq, &affinitymask)
}




-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

