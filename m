Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787Ab3D3PPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 11:15:33 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:47023 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab3D3PP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 11:15:29 -0400
Date: Tue, 30 Apr 2013 11:15:25 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jon Medhurst <tixy@linaro.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: linux-next build error (at91) - use of bool in mach/arch.h
In-Reply-To: <alpine.DEB.2.02.1304301257200.5398@kaball.uk.xensource.com>
Message-ID: <alpine.LFD.2.03.1304301114140.17372@syhkavp.arg>
References: <517F8FF4.3050901@atmel.com> <CAMuHMdXYaDHYq7CG8ftP+yyF18pMx8qZrvM3AUTAXk+tUruNcA@mail.gmail.com> <alpine.DEB.2.02.1304301257200.5398@kaball.uk.xensource.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Stefano Stabellini wrote:

> On Tue, 30 Apr 2013, Geert Uytterhoeven wrote:
> > On Tue, Apr 30, 2013 at 11:33 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > > So, I am wondering if the best correction is to add the types.h header file
> > > in the asm/mach/arch.h file, like this:
> > >
> > > --- a/arch/arm/include/asm/mach/arch.h
> > > +++ b/arch/arm/include/asm/mach/arch.h
> > > @@ -8,6 +8,8 @@
> > >   * published by the Free Software Foundation.
> > >   */
> > >
> > > +#include <linux/types.h>
> > > +
> > >  #ifndef __ASSEMBLY__
> > >
> > >  struct tag;
> > >
> > > or if a better option would be to re-arrange the include directives in
> > > various at91xxx_devices.c files?
> > 
> > Include files should be self-contained, so asm/mach/arch.h is the right place.
> 
> Nicolas,
> are you happy to come up with a proper patch to fix the issue?

I'd prefer if you just folded the above include into the original patch, 
unless this has been pulled already.


Nicolas
