Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaKDDVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:21:43 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63339 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaKDDVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:21:41 -0500
Message-ID: <5458462F.6000704@gmail.com>
Date: Tue, 04 Nov 2014 11:21:19 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, Morten.Rasmussen@arm.com,
        kamalesh@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: riel@redhat.com, efault@gmx.de, nicolas.pitre@linaro.org,
        linaro-kernel@lists.linaro.org
Subject: Re: [PATCH v8 08/10] sched: add SD_PREFER_SIBLING for SMT level
References: <1414745252-4895-1-git-send-email-vincent.guittot@linaro.org> <1414745252-4895-9-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1414745252-4895-9-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vincent,
On 14/10/31 下午4:47, Vincent Guittot wrote:
> Add the SD_PREFER_SIBLING flag for SMT level in order to ensure that
> the scheduler will put at least 1 task per core.

What's the behavior before this patch?

Regards,
Wanpeng Li

>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>
> ---
>   kernel/sched/core.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 37fb92c..731f2ad 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6165,6 +6165,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
>   	 */
>   
>   	if (sd->flags & SD_SHARE_CPUCAPACITY) {
> +		sd->flags |= SD_PREFER_SIBLING;
>   		sd->imbalance_pct = 110;
>   		sd->smt_gain = 1178; /* ~15% */
>   

