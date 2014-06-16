Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaFPNQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:16:23 -0400
Received: from smtprelay4.synopsys.com ([198.182.44.111]:43978 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaFPNQW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:16:22 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Vince Weaver <vincent.weaver@maine.edu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/6] arc,perf: Use common PMU interrupt disabled code
Thread-Topic: [PATCH 1/6] arc,perf: Use common PMU interrupt disabled code
Thread-Index: AQHPiF51r05p/Ov7REqcqqblhDg26Q==
Date: Mon, 16 Jun 2014 13:16:12 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230751A6B7E8A@IN01WEMBXA.internal.synopsys.com>
References: <alpine.DEB.2.10.1406150159280.16738@vincent-weaver-1.umelst.maine.edu>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 June 2014 11:25 AM, Vince Weaver wrote:
> Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
> failing a sampling event when no PMU interrupt is available.
>
> Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Thx,
-Vineet

>
> diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
> index 63177e4..b9a5685 100644
> --- a/arch/arc/kernel/perf_event.c
> +++ b/arch/arc/kernel/perf_event.c
> @@ -99,10 +99,6 @@ static int arc_pmu_event_init(struct perf_event *event)
>  	struct hw_perf_event *hwc = &event->hw;
>  	int ret;
>  
> -	/* ARC 700 PMU does not support sampling events */
> -	if (is_sampling_event(event))
> -		return -ENOENT;
> -
>  	switch (event->attr.type) {
>  	case PERF_TYPE_HARDWARE:
>  		if (event->attr.config >= PERF_COUNT_HW_MAX)
> @@ -298,6 +294,9 @@ static int arc_pmu_device_probe(struct platform_device *pdev)
>  		.read		= arc_pmu_read,
>  	};
>  
> +	/* ARC 700 PMU does not support sampling events */
> +	arc_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
> +
>  	ret = perf_pmu_register(&arc_pmu->pmu, pdev->name, PERF_TYPE_RAW);
>  
>  	return ret;
>

