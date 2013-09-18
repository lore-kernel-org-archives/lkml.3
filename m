Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3IRQyN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:54:13 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:60217 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab3IRQyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:54:12 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19bAHDUaNjBMspyq7xj4Wea7USj0LGU/6U=
Date: Wed, 18 Sep 2013 12:54:01 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Jean Pihet <jean.pihet@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        patches@linaro.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] arm: mvebu: use the main timer as clock source from DT
Message-ID: <20130918165401.GO19937@titan.lakedaemon.net>
References: <1379519624-4267-1-git-send-email-jean.pihet@linaro.org>
 <20130918184509.0ad0a5be@skate>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130918184509.0ad0a5be@skate>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 06:45:09PM +0200, Thomas Petazzoni wrote:
> Dear Jean Pihet,
> 
> On Wed, 18 Sep 2013 17:53:44 +0200, Jean Pihet wrote:
> > This commit:
> >   573145f08c2b92c45498468afbbba909f6ce6135
> >   clocksource: armada-370-xp: Use CLOCKSOURCE_OF_DECLARE
> > 
> > replaced a call to the driver's timer initialization by a call to
> > clocksource_of_init(). However, it failed to select CONFIG_CLKSRC_OF.
> > 
> > Fix this by selecting CONFIG_CLKSRC_OF for Armada370/XP machines.
> > Without this change the kernel is stuck at: 'Calibrating delay
> > loop...'.
> > 
> > Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> > Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> > ---
> >  arch/arm/mach-mvebu/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
> > index 9eb63d7..25e6c00 100644
> > --- a/arch/arm/mach-mvebu/Kconfig
> > +++ b/arch/arm/mach-mvebu/Kconfig
> > @@ -26,6 +26,7 @@ config MACH_ARMADA_370_XP
> >  	select HAVE_SMP
> >  	select CACHE_L2X0
> >  	select CPU_PJ4B
> > +	select CLKSRC_OF
> 
> I disagree. This should go to drivers/clocksource/Kconfig, because it's
> the clocksource driver that uses CLOCKSOURCE_OF_DECLARE. See what is
> already done in drivers/clocksource/Kconfig for other drivers.

Ack.  I missed the 'select ARMADA_370_XP_TIMER' for this block since it
was outside the context.

Jean, please fix this up and resubmit to Daniel Lezcano.

I'll drop this version from my tree.

thx,

Jason.
