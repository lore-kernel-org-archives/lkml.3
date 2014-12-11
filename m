Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbaLKRwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:52:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:48416 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758230AbaLKRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:52:40 -0500
Date: Thu, 11 Dec 2014 17:52:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "yingjoe.chen@mediatek.com" <yingjoe.chen@mediatek.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: arm64 hitting BUG in arch_timer.h
Message-ID: <20141211175224.GL31456@e104818-lin.cambridge.arm.com>
References: <1418245000.23374.26.camel@t520.localdomain>
 <CAPz6YkXcerUiLc3dQG0URSuioiLsAwcTLkDTivD4JU9YQsdR+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPz6YkXcerUiLc3dQG0URSuioiLsAwcTLkDTivD4JU9YQsdR+Q@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 10:43:54PM +0000, Sonny Rao wrote:
> On Wed, Dec 10, 2014 at 12:56 PM, Mark Salter <msalter@redhat.com> wrote:
> > Using Linus' tree from this morning, I am hitting:
> >
> >    [    0.000000] BUG: failure at ./arch/arm64/include/asm/arch_timer.h:112/arch_counter_get_cntpct!
> >
> > This is triggered by commit 0b46b8a718 ("clocksource: arch_timer: Fix
> > code to use physical timers when requested") which addresses an armv7
> > problem. Arm64 wants to always use a virtual timer. I used this to avoid
> > the BUG and get a booting kernel:
> >
> > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch
> > index 71846f9..4d8a01e 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -468,7 +468,7 @@ static void __init arch_counter_register(unsigned type)
> >
> >         /* Register the CP15 based counter if we have one */
> >         if (type & ARCH_CP15_TIMER) {
> > -               if (arch_timer_use_virtual)
> > +               if (IS_ENABLED(CONFIG_ARM64) || arch_timer_use_virtual)
> >                         arch_timer_read_counter = arch_counter_get_cntvct;
> >                 else
> >                         arch_timer_read_counter = arch_counter_get_cntpct;
> >
> >
> 
> Yes Catalin has prepared a similar patch:
> https://patchwork.kernel.org/patch/5468031/

Indeed. Daniel will be pushing it upstream.

-- 
Catalin
