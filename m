Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650AbaKRGZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 01:25:39 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35711 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaKRGZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 01:25:38 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: kan.liang@intel.com
Cc: acme@kernel.org, jolsa@redhat.com, a.p.zijlstra@chello.nl,
        eranian@google.com, linux-kernel@vger.kernel.org, mingo@redhat.com,
        paulus@samba.org, ak@linux.intel.com
Subject: Re: [PATCH V3 3/3] perf tools: Construct LBR call chain
References: <1415972652-17310-1-git-send-email-kan.liang@intel.com>
	<1415972652-17310-4-git-send-email-kan.liang@intel.com>
Date: Tue, 18 Nov 2014 15:25:34 +0900
In-Reply-To: <1415972652-17310-4-git-send-email-kan.liang@intel.com> (kan
	liang's message of "Fri, 14 Nov 2014 08:44:12 -0500")
Message-ID: <87d28lqb35.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Nov 2014 08:44:12 -0500, kan liang wrote:
> +		/* LBR only affects the user callchain */
> +		if (i != chain_nr) {
> +			struct branch_stack *lbr_stack = sample->branch_stack;
> +			int lbr_nr = lbr_stack->nr;
> +			/*
> +			 * LBR callstack can only get user call chain.
> +			 * The mix_chain_nr is kernel call chain
> +			 * number plus LBR user call chain number.
> +			 * i is kernel call chain number,
> +			 * 1 is PERF_CONTEXT_USER,
> +			 * lbr_nr + 1 is the user call chain number.
> +			 * For details, please refer to the comments
> +			 * in callchain__printf
> +			 */
> +			int mix_chain_nr = i + 1 + lbr_nr + 1;
> +
> +			if (mix_chain_nr > PERF_MAX_STACK_DEPTH) {
> +				pr_warning("corrupted callchain. skipping...\n");
> +				return 0;
> +			}

I'm not sure whether this is really a corrupted callchain.  If a single
chain is greater than the max it should be corrupted, but we're now
summing up with other values..

What about checking callchain_nr and lbr_nr separately or mix_nr with
2*max?

Thanks,
Namhyung
