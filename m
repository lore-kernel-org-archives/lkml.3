Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbaEIP6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:58:22 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:44973 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753527AbaEIP6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:58:20 -0400
Date: Fri, 9 May 2014 16:57:26 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH] arm64: Support arch_irq_work_raise() via self IPIs
Message-ID: <20140509155726.GK7950@arm.com>
References: <1399322907-21280-1-git-send-email-larry.bassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399322907-21280-1-git-send-email-larry.bassel@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 09:48:27PM +0100, Larry Bassel wrote:
> Support for arch_irq_work_raise() was missing from
> arm64 (a prerequisite for FULL_NOHZ).
> 
> This patch is based on the arm32 patch ARM 7872/1
> which ports cleanly.
[...]
> +#ifdef CONFIG_IRQ_WORK
> +void arch_irq_work_raise(void)
> +{
> +	smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
> +}
> +#endif

There was a subsequent patch adding is_smp() check here (c682e51dbc98
ARM: 7887/1: Don't smp_cross_call() on UP devices in
arch_irq_work_raise()). Don't we need it?

-- 
Catalin
