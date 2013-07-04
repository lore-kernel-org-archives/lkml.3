Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3GDLrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:47:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:51104 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab3GDLrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:47:39 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18awuxc255u3nLrXC09yume
Date: Thu, 4 Jul 2013 04:47:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Jon Hunter <jgchunter@gmail.com>
Cc: Afzal Mohammed <afzal@ti.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] ARM: OMAP2+: timer: initialize before using oh_name
Message-ID: <20130704114736.GC5523@atomide.com>
References: <1369722288-15592-1-git-send-email-afzal@ti.com>
 <51A51FAC.5090606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A51FAC.5090606@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jon Hunter <jgchunter@gmail.com> [130528 14:26]:
> 
> On 28/05/13 07:24, Afzal Mohammed wrote:
> > of_property_read_string_index(...,&oh_name) in omap_dm_timer_init_one
> > does not alter the value of 'oh_name' even if the relevant function
> > fails and as 'oh_name' in stack may have a non-zero value, it would
> > be misunderstood by timer code that DT has specified "ti,hwmod"
> > property for timer. 'oh_name' in this scenario would be a junk value,
> > this would result in module not being enabled by hwmod API's for
> > timer, and in turn crash.
> > 
> > Signed-off-by: Afzal Mohammed <afzal@ti.com>
> > ---
> >  arch/arm/mach-omap2/timer.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
> > index f8b23b8..8e0c390 100644
> > --- a/arch/arm/mach-omap2/timer.c
> > +++ b/arch/arm/mach-omap2/timer.c
> > @@ -220,7 +220,7 @@ static int __init omap_dm_timer_init_one(struct omap_dm_timer *timer,
> >  					 int posted)
> >  {
> >  	char name[10]; /* 10 = sizeof("gptXX_Xck0") */
> > -	const char *oh_name;
> > +	const char *oh_name = NULL;
> >  	struct device_node *np;
> >  	struct omap_hwmod *oh;
> >  	struct resource irq, mem;
> 
> Thanks!
> 
> Acked-by: Jon Hunter <jgchunter@gmail.com>

Thanks, applying into omap-for-v3.11/fixes.

Tony 

