Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759612Ab3HOSF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 14:05:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59818 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab3HOSFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 14:05:46 -0400
Date: Thu, 15 Aug 2013 20:05:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Joonsoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v3 3/3] sched: clean-up struct sd_lb_stat
Message-ID: <20130815180521.GV24092@twins.programming.kicks-ass.net>
References: <1375778203-31343-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 05:36:43PM +0900, Joonsoo Kim wrote:
> -	if (sds->group_imb) {
> -		sds->busiest_load_per_task =
> -			min(sds->busiest_load_per_task, sds->avg_load);

> +	if (busiest->group_imb) {
> +		busiest->load_per_task =
> +			min(busiest->load_per_task, sds->sd_avg_load);
>  	}

> -	if (sds->max_load < sds->avg_load) {
> +	if (busiest->avg_load < this->avg_load) {

Tsk, inconsistency there.

> -	max_pull = min(sds->max_load - sds->avg_load, load_above_capacity);
> +	max_pull = min(busiest->avg_load - sds->sd_avg_load,
> +			load_above_capacity);

you just made it possible for the above subtraction to become negative.

Also not entirely sure why you renamed sds->avg_load; renaming it back.
