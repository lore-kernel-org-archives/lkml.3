Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaGKIVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:21:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3690 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbaGKIVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:21:12 -0400
Date: Fri, 11 Jul 2014 10:20:39 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, acme@redhat.com, namhyung@kernel.org
Subject: Re: [PATCH 3/4] perf tools: add core support for sampling intr
 machine state regs
Message-ID: <20140711082039.GB31646@krava.redhat.com>
References: <1404857759-25105-1-git-send-email-eranian@google.com>
 <1404857759-25105-4-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404857759-25105-4-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:15:58AM +0200, Stephane Eranian wrote:
> Add the infrastructure to setup, collect and report the interrupt
> machine state regs which can be captured by the kernel.
> 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---

SNIP

> +static const char *regs_abi[]= {
> + [PERF_SAMPLE_REGS_ABI_NONE] = "none",
> + [PERF_SAMPLE_REGS_ABI_32] = "32-bit",
> + [PERF_SAMPLE_REGS_ABI_64] = "64-bit",
> +};
> +
> +static inline const char *regs_dump_abi(struct regs_dump *d)
> +{
> +	if (d->abi > PERF_SAMPLE_REGS_ABI_64)
> +		return "???";
> +	return regs_abi[d->abi];
> +}
> +
> +static void regs_intr__printf(struct perf_sample *sample, u64 mask)
> +{
> +	struct regs_dump *intr_regs = &sample->intr_regs;
> +
> +	if (intr_regs->regs) {
> +		printf("... intr regs: mask 0x%" PRIx64 " ABI: %s\n", mask, regs_dump_abi(intr_regs));
> +		regs_dump__printf(mask, intr_regs->regs);
> +	}
> +}

could you please unify/share this with regs_user__printf,
so we could get same output for registers dump

jirka
