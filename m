Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3JNPpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:45:05 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51060 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756193Ab3JNPpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:45:03 -0400
Date: Mon, 14 Oct 2013 16:44:02 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Will Deacon <Will.Deacon@arm.com>, Jiang Liu <jiang.liu@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFT PATCH v2 3/4] arm64: reduce duplicated code when
 saving/restoring FPSIMD for signal handling
Message-ID: <20131014154401.GG7682@arm.com>
References: <1381674029-430-1-git-send-email-liuj97@gmail.com>
 <1381674029-430-3-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381674029-430-3-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 03:20:19PM +0100, Jiang Liu wrote:
> +void fpsimd_prepare_sigctx(struct fpsimd_state *state)
> +{
> +	/* dump the hardware registers to the fpsimd_state structure */
> +	fpsimd_save_state(state);
> +	fpsimd_clear_fpsr();
> +}

What don't particularly like is that you save the FP context and then
corrupt it. Can we get preempted after this function and before we save
it on the signal stack?

-- 
Catalin
