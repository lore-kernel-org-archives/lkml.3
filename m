Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaIXM2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:28:09 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60027 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbaIXM2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:28:04 -0400
Message-ID: <5422B8C7.6090905@linux.vnet.ibm.com>
Date: Wed, 24 Sep 2014 17:57:51 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: riel@redhat.com, Morten.Rasmussen@arm.com, efault@gmx.de,
        nicolas.pitre@linaro.org, linaro-kernel@lists.linaro.org,
        daniel.lezcano@linaro.org, dietmar.eggemann@arm.com, pjt@google.com,
        bsegall@google.com
Subject: Re: [PATCH v6 6/6] sched: add SD_PREFER_SIBLING for SMT level
References: <1411488485-10025-1-git-send-email-vincent.guittot@linaro.org> <1411488485-10025-7-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1411488485-10025-7-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092412-1542-0000-0000-0000050F6747
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 09:38 PM, Vincent Guittot wrote:
> add the SD_PREFER_SIBLING flag for SMT level in order to ensure that
> the scheduler will put at least 1 task per core.
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c7c8ac4..f72663e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6134,6 +6134,7 @@ sd_init(struct sched_domain_topology_level *tl, int cpu)
>  	 */
> 
>  	if (sd->flags & SD_SHARE_CPUCAPACITY) {
> +		sd->flags |= SD_PREFER_SIBLING;
>  		sd->imbalance_pct = 110;
>  		sd->smt_gain = 1178; /* ~15% */
> 
Reviewed-by: Preeti U. Murthy <preeti@linux.vnet.ibm.com>

