Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbaBYDer (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:34:47 -0500
Received: from ozlabs.org ([203.10.76.45]:47925 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003AbaBYDd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:33:29 -0500
In-Reply-To: <1392415338-16288-9-git-send-email-cody@linux.vnet.ibm.com>
To: Cody P Schafer <cody@linux.vnet.ibm.com>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v2 08/11] powerpc/perf: add support for the hv gpci (get performance counter info) interface
Message-Id: <20140225033329.400E22C0331@ozlabs.org>
Date: Tue, 25 Feb 2014 14:33:29 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-14-02 at 22:02:12 UTC, Cody P Schafer wrote:
> This provides a basic link between perf and hv_gpci. Notably, it does
> not yet support transactions and does not list any events (they can
> still be manually composed).

Can you explain how the HV_CAPS stuff ends up looking.

I'm not against adding it, but I'd like to understand how we expect it to be
used a bit better.

cheers

> diff --git a/arch/powerpc/perf/hv-gpci.c b/arch/powerpc/perf/hv-gpci.c
> new file mode 100644
> index 0000000..1f5d96d
> --- /dev/null
> +++ b/arch/powerpc/perf/hv-gpci.c
> +
> +static struct pmu h_gpci_pmu = {
> +	.task_ctx_nr = perf_invalid_context,
> +
> +	.name = "hv_gpci",
> +	.attr_groups = attr_groups,
> +	.event_init  = h_gpci_event_init,
> +	.add         = h_gpci_event_add,
> +	.del         = h_gpci_event_del,
		     = h_gpci_event_stop,

> +	.start       = h_gpci_event_start,
> +	.stop        = h_gpci_event_stop,
> +	.read        = h_gpci_event_read,
		     = h_gpci_event_update

> +	.event_idx = perf_swevent_event_idx,
> +};


