Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaELPi7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:38:59 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64313 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297AbaELPi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:38:57 -0400
Date: Mon, 12 May 2014 08:38:48 -0700
From: Larry Bassel <larry.bassel@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Larry Bassel <larry.bassel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v2] arm64: Support arch_irq_work_raise() via self IPIs
Message-ID: <20140512153848.GA13068@linaro6>
References: <1399760621-10954-1-git-send-email-larry.bassel@linaro.org>
 <20140512092956.GB914@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512092956.GB914@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 May 14 10:29, Will Deacon wrote:
> On Sat, May 10, 2014 at 11:23:41PM +0100, Larry Bassel wrote:
> > Support for arch_irq_work_raise() was missing from
> > arm64 (a prerequisite for FULL_NOHZ).
> 
> [...]
> 
> > @@ -455,6 +457,14 @@ void arch_send_call_function_single_ipi(int cpu)
> >  	smp_cross_call(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
> >  }
> >  
> > +#ifdef CONFIG_IRQ_WORK
> > +void arch_irq_work_raise(void)
> > +{
> > +	if (is_smp())
> > +		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
> > +}
> > +#endif
> 
> Does this even compile? We're probably better off just checking whether or
> not smp_cross_call is NULL.

No it doesn't (I incorrectly assumed that is_smp() was generic, not
arm32 specific and so I didn't compile this before submitting).

I've verified that your suggestion compiles and runs properly
and will resubmit.

Thanks for catching this.

> 
> Will

Larry
