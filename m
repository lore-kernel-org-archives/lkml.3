Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3ARXWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:22:08 -0500
Received: from mga03.intel.com ([143.182.124.21]:51384 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab3ARXWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:22:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="192808700"
Date: Fri, 18 Jan 2013 15:21:44 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 10/18] perf/x86: add support for PEBS Precise Store
Message-ID: <20130118232144.GL4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-11-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-11-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  	u64 sample_type;
> -	int fll;
> +	int fll, fst;
>  
>  	if (!intel_pmu_save_and_restart(event))
>  		return;
>  
>  	fll = event->hw.flags & PERF_X86_EVENT_PEBS_LDLAT;
> +	fst = event->hw.flags & PERF_X86_EVENT_PEBS_ST;
>  
>  	perf_sample_data_init(&data, 0, event->hw.last_period);
>  
> @@ -672,7 +715,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
>  	/*
>  	 * if PEBS-LL or PreciseStore
>  	 */
> -	if (fll) {
> +	if (fll || fst) {

Ok I understand now why the other patch looked so strange.
it makes sense and you can disregard those comments.

Looks good

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
