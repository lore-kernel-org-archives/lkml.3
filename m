Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3HGLJv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:09:51 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:23152 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757294Ab3HGLJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:09:50 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/gcpgEwgNmxli96b+FBzyR
Date: Wed, 7 Aug 2013 04:09:45 -0700
From: Tony Lindgren <tony@atomide.com>
To: Chen Baozi <baozich@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: fix wrong address when loading
 PRM_FRAC_INCREMENTOR_DENUMERATOR_RELOAD
Message-ID: <20130807110945.GL7656@atomide.com>
References: <1375356474-24203-1-git-send-email-baozich@gmail.com>
 <C635EF21-CD18-4633-AA39-16209F8EE231@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C635EF21-CD18-4633-AA39-16209F8EE231@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Chen Baozi <baozich@gmail.com> [130805 08:33]:
> ping?
> 
> On Aug 1, 2013, at 7:27 PM, Chen Baozi <baozich@gmail.com> wrote:
> 
> > The denominator should be load from INCREMENTOR_DENUMERATOR_RELOAD_OFFSET
> > rather than INCREMENTER_NUMERATOR_OFFSET.

Maybe describe what exactly happens without this fix?

Also we should get few acks for this for the -rc series.

Regards,

Tony

> > Signed-off-by: Chen Baozi <baozich@gmail.com>
> > ---
> > arch/arm/mach-omap2/timer.c | 2 +-
> > 1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> > index b37e1fc..9265e03 100644
> > --- a/arch/arm/mach-omap2/timer.c
> > +++ b/arch/arm/mach-omap2/timer.c
> > @@ -537,7 +537,7 @@ static void __init realtime_counter_init(void)
> > 	reg |= num;
> > 	__raw_writel(reg, base + INCREMENTER_NUMERATOR_OFFSET);
> > 
> > -	reg = __raw_readl(base + INCREMENTER_NUMERATOR_OFFSET) &
> > +	reg = __raw_readl(base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET) &
> > 			NUMERATOR_DENUMERATOR_MASK;
> > 	reg |= den;
> > 	__raw_writel(reg, base + INCREMENTER_DENUMERATOR_RELOAD_OFFSET);
> > -- 
> > 1.8.1.4
> > 
> 
