Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab3LJR6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:58:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:54819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab3LJR6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:58:32 -0500
Message-ID: <1386698282.1979.44.camel@deneb.redhat.com>
Subject: Re: [PATCH 3/3] arm64: add EFI runtime services
From: Mark Salter <msalter@redhat.com>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, roy.franz@linaro.org
Date: Tue, 10 Dec 2013 12:58:02 -0500
In-Reply-To: <20131209135158.GH24997@rocoto.smurfnet.nu>
References: <1385762712-17043-1-git-send-email-msalter@redhat.com>
	 <1385762712-17043-4-git-send-email-msalter@redhat.com>
	 <20131209135158.GH24997@rocoto.smurfnet.nu>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 14:52 +0100, Leif Lindholm wrote:
> Apologies for late feedback.
> 
> On Fri, Nov 29, 2013 at 05:05:12PM -0500, Mark Salter wrote:
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > new file mode 100644
> > index 0000000..1bad8a7
> > --- /dev/null
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -0,0 +1,507 @@
> > +/*
> > + * Extensible Firmware Interface
> > + *
> > + * Based on Extensible Firmware Interface Specification version 2.3.1
> 
> Actually, for arm64, we're relying on UEFI 2.4 or later.

You're right.

> 
> > + *
> > + * Copyright (C) 2013 Linaro Ltd.
> 
> And I'd say you've easily done enough here to motivate adding Red Hat.
> 
> > + *
> > + * Adapted for arm64 from arch/arm/kernel/efi.c code
> > + */
> > +
> > +#include <linux/efi.h>
> > +#include <linux/export.h>
> > +#include <linux/memblock.h>
> > +#include <linux/of.h>
> > +#include <linux/of_fdt.h>
> > +#include <linux/sched.h>
> > +#include <linux/slab.h>
> > +#include <linux/bootmem.h>
> > +
> > +#include <asm/cacheflush.h>
> > +#include <asm/efi.h>
> > +#include <asm/tlbflush.h>
> > +#include <asm/mmu_context.h>
> > +
> > +#define efi_early_remap(a, b) \
> > +	((__force void *)early_ioremap((a), (b)))
> 
> Do we not want early_memremap() here, rather than early_ioremap()?
> 

Yes.


