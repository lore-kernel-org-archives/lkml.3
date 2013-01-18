Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3ARXMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:12:21 -0500
Received: from mga03.intel.com ([143.182.124.21]:47968 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869Ab3ARXMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:12:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,495,1355126400"; 
   d="scan'208";a="192805617"
Date: Fri, 18 Jan 2013 15:12:12 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, namhyung.kim@lge.com
Subject: Re: [PATCH v6 08/18] perf/x86: add memory profiling via PEBS Load
 Latency
Message-ID: <20130118231212.GK4051@tassilo.jf.intel.com>
References: <1358264386-24633-1-git-send-email-eranian@google.com>
 <1358264386-24633-9-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358264386-24633-9-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	sample_type = event->attr.sample_type;
> +
> +	/*
> +	 * if PEBS-LL or PreciseStore
> +	 */
> +	if (fll) {
> +		if (sample_type & PERF_SAMPLE_ADDR)
> +			data.addr = pebs->dla;
> +
> +		/*
> +		 * Use latency for weight (only avail with PEBS-LL)
> +		 */
> +		if (fll && (sample_type & PERF_SAMPLE_WEIGHT))

The extra fll tests here don't make sense because it's always true inside
the if. You could remove the variable and the tests and only check once
in the if.

The rest looks good to me. There will be some conflicts with the Haswell
patches, but either of us can rebase.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi
