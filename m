Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaJBDhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 23:37:54 -0400
Received: from ozlabs.org ([103.22.144.67]:42336 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbaJBDhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 23:37:53 -0400
Message-ID: <1412221071.19209.103.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 07/17] cxl: Add new header for call backs and structs
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Thu, 02 Oct 2014 13:37:51 +1000
In-Reply-To: <20141001120010.4813614016A@ozlabs.org>
References: <20141001120010.4813614016A@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 22:00 +1000, Michael Ellerman wrote:
> On Tue, 2014-30-09 at 10:34:56 UTC, Michael Neuling wrote:
> > From: Ian Munsie <imunsie@au1.ibm.com>
> > 
> > This new header add defines for callbacks and structs needed by the rest of the
>                   adds
> > kernel to hook into the cxl infrastructure.
> > 
> > Empty functions are provided when CONFIG CXL_BASE is not enabled.
> > 
> > Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> >  include/misc/cxl.h | 34 ++++++++++++++++++++++++++++++++++
> 
> include/misc is kind of weird. I guess it's a misc device.
> 
> Any reason not to have it in arch/powerpc/include ?

We can do either way.  We did consider it a driver so putting it in
arch/powerpc didn't seem quite right.

I might leave it here unless you really object.

> 
> > diff --git a/include/misc/cxl.h b/include/misc/cxl.h
> > new file mode 100644
> > index 0000000..bde46a3
> > --- /dev/null
> > +++ b/include/misc/cxl.h
> > @@ -0,0 +1,34 @@
> > +/*
> > + * Copyright 2014 IBM Corp.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License
> > + * as published by the Free Software Foundation; either version
> > + * 2 of the License, or (at your option) any later version.
> > + */
> > +
> > +#ifndef _MISC_ASM_CXL_H
> 
> No ASM.

Oops, yes.

> 
> > +#define _MISC_ASM_CXL_H
> > +
> > +#define CXL_IRQ_RANGES 4
> > +
> > +struct cxl_irq_ranges {
> > +	irq_hw_number_t offset[CXL_IRQ_RANGES];
> > +	irq_hw_number_t range[CXL_IRQ_RANGES];
> > +};
> > +
> > +#ifdef CONFIG_CXL_BASE
> > +
> > +void cxl_slbia(struct mm_struct *mm);
> > +void cxl_ctx_get(void);
> > +void cxl_ctx_put(void);
> > +bool cxl_ctx_in_use(void);
> > +
> > +#else /* CONFIG_CXL_BASE */
> > +
> > +#define cxl_slbia(...) do { } while (0)
> > +#define cxl_ctx_in_use(...) false
> 
> Any reason these shouldn't be static inlines?

No, I'll change.

Mikey
