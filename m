Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbbAUMgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 07:36:12 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:62363 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbAUMf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 07:35:59 -0500
Date: Wed, 21 Jan 2015 12:35:51 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Kumar Gala <galak@codeaurora.org>, Daniel Mack <daniel@zonque.org>
Subject: Re: [PATCH v3 2/3] mfd: lubbock_io: add lubbock_io board
Message-ID: <20150121123551.GD9258@x1>
References: <1421406010-14851-1-git-send-email-robert.jarzmik@free.fr>
 <1421406010-14851-2-git-send-email-robert.jarzmik@free.fr>
 <20150119091705.GG21886@x1>
 <87ppaah9k5.fsf@free.fr>
 <20150120102919.GP5767@x1>
 <20150120115658.GJ26493@n2100.arm.linux.org.uk>
 <873874fuei.fsf@free.fr>
 <20150121081645.GC9258@x1>
 <87y4owedx1.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y4owedx1.fsf@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Robert Jarzmik wrote:

> Lee Jones <lee.jones@linaro.org> writes:
> 
> > On Wed, 21 Jan 2015, Robert Jarzmik wrote:
> >> > > > platform_get_irq()?
> >> > > No. I need the flags.
> >> > Where are they used?
> >> A couple of lines below, using local "irqflags" variable :
> >>        ret = devm_request_irq(&pdev->dev, cot->irq, lubbock_irq_handler,
> >>                               irqflags, dev_name(&pdev->dev), cot);
> >
> > No, I mean where are they _used_?
> I don't get your point.
> 
> For you, isn't it "using" irqflags by passing them as an argument to devm_request_irq()

No, this is where the argument is being _passed_.

> ??? And if you think ahead, then there are used all around in
> kernel/irq/manage.c, as you probably know.

Perhaps some context would help.

Looking at one of the other patches in the series it appears the flag
you're trying to capture is IORESOURCE_IRQ_LOWEDGE.  When I grep for
where this is being _used_ (think 'consumed, rather than passed.  I
only see a single entry in drivers/pnp/interface.c.

That's what got me thinking... are you sure you're a) making use of
this flag and b) assuming the answer to 'a' is "no" and if everyting's
working correctly in the code's current state, are you sure you need
them at all? 

I think to set an edge trigger on an IRQ, you should instead do so via
irq_set_irq_type(), or have a missed a line or two?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
