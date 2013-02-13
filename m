Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017Ab3BMIQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 03:16:44 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:64896 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3BMIQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 03:16:42 -0500
Date: Wed, 13 Feb 2013 09:16:36 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] perf, x86: Basic Haswell PMU support v4
Message-ID: <20130213081636.GA4542@gmail.com>
References: <1360706658-13468-1-git-send-email-andi@firstfloor.org>
 <1360706658-13468-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360706658-13468-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> +static int hsw_hw_config(struct perf_event *event)
> +{
> +	int ret = intel_pmu_hw_config(event);
> +
> +	if (ret)
> +		return ret;
> +	if (!boot_cpu_has(X86_FEATURE_RTM) && !boot_cpu_has(X86_FEATURE_HLE))
> +		return 0;
> +	event->hw.config |= event->attr.config & (HSW_INTX|HSW_INTX_CHECKPOINTED);
> +
> +	/*
> +	 * INTX/INTX-CP do not play well with PEBS or ANY thread mode.
> +	 */
> +	if ((event->hw.config & (HSW_INTX|HSW_INTX_CHECKPOINTED)) &&
> +	     ((event->hw.config & ARCH_PERFMON_EVENTSEL_ANY) ||
> +	      event->attr.precise_ip > 0))
> +		return -EOPNOTSUPP;

Please explain it more verbosely in the comment what 'do not 
play well' means and why it necessiates a -EOPNOTSUPP reply.

Thanks,

	Ingo
