Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbaCLHqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:46:19 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:11614
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756413AbaCLHqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:46:17 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(z579ehz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h16a6h1758h1806h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1de2h1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
Date: Wed, 12 Mar 2014 15:46:10 +0800
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: Re: [PATCH 5/9] powerpc/85xx: disable irq by hardware when suspend
 for 64-bit
Message-ID: <20140312074610.GD4706@localhost.localdomain>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
 <1394168285-32275-5-git-send-email-chenhui.zhao@freescale.com>
 <1394581880.13761.69.camel@snotra.buserror.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1394581880.13761.69.camel@snotra.buserror.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 06:51:20PM -0500, Scott Wood wrote:
> On Fri, 2014-03-07 at 12:58 +0800, Chenhui Zhao wrote:
> > In 64-bit mode, kernel just clears the irq soft-enable flag
> > in struct paca_struct to disable external irqs. But, in
> > the case of suspend, irqs should be disabled by hardware.
> > Therefore, hook a function to ppc_md.suspend_disable_irqs
> > to really disable irqs.
> > 
> > Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
> > ---
> >  arch/powerpc/platforms/85xx/corenet_generic.c |   12 ++++++++++++
> >  1 files changed, 12 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
> > index 3fdf9f3..983d81f 100644
> > --- a/arch/powerpc/platforms/85xx/corenet_generic.c
> > +++ b/arch/powerpc/platforms/85xx/corenet_generic.c
> > @@ -32,6 +32,13 @@
> >  #include <sysdev/fsl_pci.h>
> >  #include "smp.h"
> >  
> > +#if defined(CONFIG_PPC64) && defined(CONFIG_SUSPEND)
> > +static void fsl_suspend_disable_irqs(void)
> > +{
> > +	__hard_irq_disable();
> > +}
> > +#endif
> 
> Why the underscore version?  Don't you want PACA_IRQ_HARD_DIS to be set?
> 
> If hard disabling is appropriate here, shouldn't we do it in
> generic_suspend_disable_irqs()?
> 
> Are there any existing platforms that supply a
> ppc_md.suspend_disable_irqs()?  I don't see any when grepping.
> 
> -Scott

Will use hard_irq_disable().

I think this is a general problem for powerpc.
Should clear MSR_EE before suspend. I agree to put it
in generic_suspend_disable_irqs().

-Chenhui

