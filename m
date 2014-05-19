Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932822AbaESTzM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:55:12 -0400
Received: from smtp-69.nebula.fi ([83.145.220.69]:45029 "EHLO smtp.nebula.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbaESTzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:55:10 -0400
Date: Mon, 19 May 2014 22:54:34 +0300
From: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux@openrisc.net
Subject: Re: [PATCH] openrisc: irq: use irqchip framework
Message-ID: <20140519195433.GA18318@chokladfabriken.org>
References: <1400502328-23974-1-git-send-email-stefan.kristiansson@saunalahti.fi>
 <537A18E9.4010301@southpole.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537A18E9.4010301@southpole.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 04:44:57PM +0200, Jonas Bonn wrote:
> This looks good.  Let's complete the the cleanup of this driver while
> we're at it:
> 
> i) Move this file to drivers/irqchip/

Sure, that sounds like a good idea.

> ii) Put a Depends on CONFIG_ARCH_OPENRISC in the Kconfig

Hmm, do we really need that?
The irqchip driver will picked by 'select'ing it from arch/openrisc/Kconfig
So, it won't really be exposed to anyone not explicitly picking it like that.

> iii) Provide documentation for the binding at
> Documentation/devicetree/bindings/interrupt-controller/
> 
> Copy final result to Thomas Gleixner who maintains the irqchip bits.
>

Will do.
 
> > @@ -19,10 +19,13 @@
> >  #include <linux/of.h>
> >  #include <linux/ftrace.h>
> 
> Do we really need to pull in ftrace.h?
> 

The '__irq_entry' that is used below is defined in that

> >  
> >  void __irq_entry do_IRQ(struct pt_regs *regs)
> > 

Stefan
