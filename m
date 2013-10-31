Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3JaGN1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 02:13:27 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:59078 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab3JaGNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 02:13:07 -0400
Message-ID: <5271F4E9.8010709@huawei.com>
Date: Thu, 31 Oct 2013 14:12:57 +0800
From: Xie XiuQi <xiexiuqi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Younger Liu <younger.liucn@gmail.com>
CC: kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question: Takes about 2s in sched_clock_init() when kernel boots
References: <5271EAAC.7080304@gmail.com>
In-Reply-To: <5271EAAC.7080304@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.18]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/10/31 13:29, Younger Liu wrote:
> Hi,
>   When I analyse boot time on ArmV7, I found that it takes
> about 2s in sched_clock_init(), the log is as follow:
> [    0.000000] before:sched_clock_init.
> [    0.000000] start:sched_clock_init.
> [    2.100505] end  :sched_clock_init.
> [    2.103983] before:calibrate_delay.
> 
>   In my config, CONFIG_HAVE_UNSTABLE_SCHED_CLOCK does not config.
> 
>   Are there any suggestions?

see below:
u64 sched_clock_cpu(int cpu)
{
	struct sched_clock_data *scd;
	u64 clock;

	WARN_ON_ONCE(!irqs_disabled());

	if (sched_clock_stable)
		return sched_clock();

	if (unlikely(!sched_clock_running))
		return 0ull;

	scd = cpu_sdc(cpu);
[...]

Unless sched_clock_running is set, it'll return 0. So, the
printk() time stamp is 0 before sched_clock_init calling.

> 
> 	Younger
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


