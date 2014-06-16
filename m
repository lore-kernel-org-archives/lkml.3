Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbaFPO5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:57:05 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:19167 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFPO5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:57:01 -0400
Message-ID: <539F05BA.7070004@imgtec.com>
Date: Mon, 16 Jun 2014 15:56:58 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Vince Weaver <vincent.weaver@maine.edu>, <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 3/6] metag,perf: Use common PMU interrupt disabled code
References: <alpine.DEB.2.10.1406150202050.16738@vincent-weaver-1.umelst.maine.edu>
In-Reply-To: <alpine.DEB.2.10.1406150202050.16738@vincent-weaver-1.umelst.maine.edu>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.101]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vince,

On 15/06/14 07:03, Vince Weaver wrote:
> 
> Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
> failing a sampling event when no PMU interrupt is available.
> 
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>


> @@ -866,6 +856,15 @@ static int __init init_hw_perf_events(void)
>  	pr_info("enabled with %s PMU driver, %d counters available\n",
>  			metag_pmu->name, metag_pmu->max_events);
>  
> +	/*
> +	 * Early cores have "limited" counters - they have no overflow
> +	 * interrupts - and so are unable to do sampling without extra work
> +	 * and timer assistance.
> +	 */
> +	if (metag_pmu->max_period == 0) {
> +		metag_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
> +	}

The braces could be dropped.

Otherwise looks good to me,

Acked-by: James Hogan <james.hogan@imgtec.com>

Cheers
James
