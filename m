Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3IYM7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:59:00 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:60465 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728Ab3IYM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:58:58 -0400
Message-ID: <5242DE0F.1080601@codeaurora.org>
Date: Wed, 25 Sep 2013 08:58:55 -0400
From: Christopher Covington <cov@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>, Jiang Liu <jiang.liu@huawei.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/7] arm64: introduce basic aarch64 instruction decoding
 helpers
References: <1380105868-31985-1-git-send-email-liuj97@gmail.com> <1380105868-31985-2-git-send-email-liuj97@gmail.com>
In-Reply-To: <1380105868-31985-2-git-send-email-liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiang,

On 09/25/2013 06:44 AM, Jiang Liu wrote:

[...]

> diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c

[...]

> +static int aarch64_insn_cls[] = {
> +	AARCH64_INSN_CLS_UNKNOWN,	/* 0 0 X X */
> +	AARCH64_INSN_CLS_UNKNOWN,	/* 0 0 X X */
> +	AARCH64_INSN_CLS_UNKNOWN,	/* 0 0 X X */
> +	AARCH64_INSN_CLS_UNKNOWN,	/* 0 0 X X */
> +	AARCH64_INSN_CLS_LDST,		/* X 1 X 0 */
> +	AARCH64_INSN_CLS_DP_REG,	/* X 1 0 1 */
> +	AARCH64_INSN_CLS_LDST,		/* X 1 X 0 */
> +	AARCH64_INSN_CLS_DP_FPSIMD,	/* 0 1 1 1 */
> +	AARCH64_INSN_CLS_DP_IMM,	/* 1 0 0 X */
> +	AARCH64_INSN_CLS_DP_IMM,	/* 1 0 0 X */
> +	AARCH64_INSN_CLS_BR_SYS,	/* 1 0 1 X */
> +	AARCH64_INSN_CLS_BR_SYS,	/* 1 0 1 X */
> +	AARCH64_INSN_CLS_LDST,		/* X 1 X 0 */
> +	AARCH64_INSN_CLS_DP_REG,	/* X 1 0 1 */
> +	AARCH64_INSN_CLS_LDST,		/* X 1 X 0 */
> +	AARCH64_INSN_CLS_DP_FPSIMD,	/* 1 1 1 1 */
> +};

As I read this, I was initially puzzled as to why there are duplicate entries
in the list. Since the data structure doesn't really support don't-cares,
perhaps it would be clearer to use 1's and 0's instead of X's.

[...]

Thanks,
Christopher

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by the Linux Foundation.
