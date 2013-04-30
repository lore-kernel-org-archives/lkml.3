Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760488Ab3D3L6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:58:45 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41639 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759863Ab3D3L6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:58:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,580,1363132800"; 
   d="scan'208";a="22346449"
Date: Tue, 30 Apr 2013 12:58:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jon Medhurst <tixy@linaro.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: linux-next build error (at91) - use of bool in mach/arch.h
In-Reply-To: <CAMuHMdXYaDHYq7CG8ftP+yyF18pMx8qZrvM3AUTAXk+tUruNcA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1304301257200.5398@kaball.uk.xensource.com>
References: <517F8FF4.3050901@atmel.com> <CAMuHMdXYaDHYq7CG8ftP+yyF18pMx8qZrvM3AUTAXk+tUruNcA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Apr 2013, Geert Uytterhoeven wrote:
> On Tue, Apr 30, 2013 at 11:33 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> > So, I am wondering if the best correction is to add the types.h header file
> > in the asm/mach/arch.h file, like this:
> >
> > --- a/arch/arm/include/asm/mach/arch.h
> > +++ b/arch/arm/include/asm/mach/arch.h
> > @@ -8,6 +8,8 @@
> >   * published by the Free Software Foundation.
> >   */
> >
> > +#include <linux/types.h>
> > +
> >  #ifndef __ASSEMBLY__
> >
> >  struct tag;
> >
> > or if a better option would be to re-arrange the include directives in
> > various at91xxx_devices.c files?
> 
> Include files should be self-contained, so asm/mach/arch.h is the right place.

Nicolas,
are you happy to come up with a proper patch to fix the issue?
