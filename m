Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaJVPIO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297AbaJVPIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:08:12 -0400
Date: Wed, 22 Oct 2014 17:07:12 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, kan.liang@intel.com, bp@alien8.de,
        maria.n.dimakopoulou@gmail.com
Subject: Re: [PATCH v2 05/12] perf/x86: add cross-HT counter exclusion
 infrastructure
Message-ID: <20141022150712.GD15126@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
 <1412872486-2930-6-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412872486-2930-6-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 06:34:39PM +0200, Stephane Eranian wrote:
> From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
> 

SNIP

> +struct intel_excl_cntrs *allocate_excl_cntrs(int cpu)
> +{
> +	struct intel_excl_cntrs *c;
> +	int i;
> +
> +	c = kzalloc_node(sizeof(struct intel_excl_cntrs),
> +			 GFP_KERNEL, cpu_to_node(cpu));
> +	if (c) {
> +		spin_lock_init(&c->lock);
> +		for (i = 0; i < X86_PMC_IDX_MAX; i++) {
> +			c->states[0].state[i] = INTEL_EXCL_UNUSED;
> +			c->states[0].init_state[i] = INTEL_EXCL_UNUSED;
> +
> +			c->states[1].state[i] = INTEL_EXCL_UNUSED;
> +			c->states[1].init_state[i] = INTEL_EXCL_UNUSED;

'c' is allocated with kzalloc_node, seems there's no need
to re-initialize states it to zero again with INTEL_EXCL_UNUSED

jirka
