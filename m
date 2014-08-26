Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934100AbaHZIXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:23:25 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44578 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933895AbaHZIXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:23:23 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        acme@redhat.com, jolsa@redhat.com, dsahern@gmail.com
Subject: Re: [PATCH v3 1/6] perf: add ability to sample machine state on interrupt
References: <1408317500-28146-1-git-send-email-eranian@google.com>
	<1408317500-28146-2-git-send-email-eranian@google.com>
Date: Tue, 26 Aug 2014 17:23:21 +0900
In-Reply-To: <1408317500-28146-2-git-send-email-eranian@google.com> (Stephane
	Eranian's message of "Mon, 18 Aug 2014 01:18:15 +0200")
Message-ID: <87bnr7bqx2.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephane,

On Mon, 18 Aug 2014 01:18:15 +0200, Stephane Eranian wrote:
> Enable capture of interrupted machine state for each
> sample.
>
> Registers to sample are passed per event in the
> sample_regs_intr bitmask.
>
> To sample interrupt machine state, the
> PERF_SAMPLE_INTR_REGS must be passed in
> sample_type.
>
> The list of available registers is arch
> dependent and provided by asm/perf_regs.h
>
> Registers are laid out as u64 in the order
> of the bit order of sample_intr_regs.


[SNIP]
> @@ -334,6 +335,15 @@ struct perf_event_attr {
>  
>  	/* Align to u64. */
>  	__u32	__reserved_2;
> +	/*
> +	 * Defines set of regs to dump for each sample
> +	 * state captured on:
> +	 *  - precise = 0: PMU interrupt
> +	 *  - precise > 0: sampled instruction
> +	 *
> +	 * See asm/perf_regs.h for details.
> +	 */
> +	__u64	sample_regs_intr;
>  };

Hmm.. this increases the size of perf_event_attr.  It seems you need to
also define PERF_ATTR_SIZE_VER4 and update attr_file_abi_sizes.

Thanks,
Namhyung
