Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaGVIck (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:32:40 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59413 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753341AbaGVIci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:32:38 -0400
Date: Tue, 22 Jul 2014 10:32:24 +0200
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mtd: nand: add ONFI timing mode to nand_timings
 converter
Message-ID: <20140722103224.68841929@bbrezillon>
In-Reply-To: <20140722023947.GZ7537@ld-irv-0074>
References: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
	<1405064982-11456-3-git-send-email-boris.brezillon@free-electrons.com>
	<20140722023947.GZ7537@ld-irv-0074>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Brian,

On Mon, 21 Jul 2014 19:39:47 -0700
Brian Norris <computersforpeace@gmail.com> wrote:

> On Fri, Jul 11, 2014 at 09:49:42AM +0200, Boris BREZILLON wrote:
> > --- /dev/null
> > +++ b/drivers/mtd/nand/nand_timings.c
> > @@ -0,0 +1,250 @@
> > +/*
> > + *  Copyright (C) 2014 Free Electrons
> > + *
> > + *  Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + */
> > +#include <linux/mtd/nand.h>
> [...]
> > +/**
> > + * onfi_async_timing_mode_to_sdr_timings - [NAND Interface] Retrieve NAND
> > + * timings according to the given ONFI timing mode
> > + * @mode: ONFI timing mode
> > + */
> > +const struct nand_sdr_timings *onfi_async_timing_mode_to_sdr_timings(int mode)
> > +{
> > +	if (mode < 0 || mode >= ARRAY_SIZE(onfi_sdr_timings))
> 
> Might need <linux/kernel.h> for this.
> 
> > +		return ERR_PTR(-EINVAL);
> 
> And <linux/err.h> for this.
> 
> > +
> > +	return &onfi_sdr_timings[mode];
> > +}
> > +EXPORT_SYMBOL(onfi_async_timing_mode_to_sdr_timings);
> 
> <linux/export.h> for this.

Thanks for fixing these issues (I tend to rely on other inclusions when
the compiler does not yell at me :-))

Best Regards,

Boris



-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
