Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab3HGWsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:48:18 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:37362 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933320Ab3HGWsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:48:17 -0400
Message-ID: <5202CEAA.9040204@linux.vnet.ibm.com>
Date: Wed, 07 Aug 2013 15:48:10 -0700
From: Cody P Schafer <cody@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2] mm: make lru_add_drain_all() selective
References: <201308071458.r77EwuJV013106@farm-0012.internal.tilera.com> <201308071551.r77FpWTf022475@farm-0012.internal.tilera.com>
In-Reply-To: <201308071551.r77FpWTf022475@farm-0012.internal.tilera.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080722-3620-0000-0000-000003DB1F59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 01:22 PM, Chris Metcalf wrote:
[...]

>
>   /**
> + * schedule_on_each_cpu - execute a function synchronously on each online CPU
> + * @func: the function to call
> + *
> + * schedule_on_each_cpu() executes @func on each online CPU using the
> + * system workqueue and blocks until all CPUs have completed.
> + * schedule_on_each_cpu() is very slow.
> + *
> + * RETURNS:
> + * 0 on success, -errno on failure.
> + */
> +int schedule_on_each_cpu(work_func_t func)
> +{
> +	get_online_cpus();
> +	schedule_on_cpu_mask(func, cpu_online_mask);

Looks like the return value gets lost here.

> +	put_online_cpus();
> +	return 0;
> +}
> +
> +/**
>    * flush_scheduled_work - ensure that any scheduled work has run to completion.
>    *
>    * Forces execution of the kernel-global workqueue and blocks until its

[...]

