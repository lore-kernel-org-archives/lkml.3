Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757888AbaEJVm3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 17:42:29 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:48463 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850AbaEJVm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 17:42:26 -0400
Date: Sat, 10 May 2014 14:42:12 -0700
From: Larry Bassel <larry.bassel@linaro.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Larry Bassel <larry.bassel@linaro.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH] arm64: Support arch_irq_work_raise() via self IPIs
Message-ID: <20140510214212.GA26308@ubuette>
References: <1399322907-21280-1-git-send-email-larry.bassel@linaro.org>
 <20140509155726.GK7950@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509155726.GK7950@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09 May 14 16:57, Catalin Marinas wrote:
> On Mon, May 05, 2014 at 09:48:27PM +0100, Larry Bassel wrote:
> > Support for arch_irq_work_raise() was missing from
> > arm64 (a prerequisite for FULL_NOHZ).
> > 
> > This patch is based on the arm32 patch ARM 7872/1
> > which ports cleanly.
> [...]
> > +#ifdef CONFIG_IRQ_WORK
> > +void arch_irq_work_raise(void)
> > +{
> > +	smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
> > +}
> > +#endif
> 
> There was a subsequent patch adding is_smp() check here (c682e51dbc98
> ARM: 7887/1: Don't smp_cross_call() on UP devices in
> arch_irq_work_raise()). Don't we need it?

I will look into this. Thanks.

> 
> -- 
> Catalin

Larry
