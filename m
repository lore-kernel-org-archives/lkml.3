Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbbAMVVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:21:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46743 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbbAMVVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:21:44 -0500
Date: Tue, 13 Jan 2015 22:21:40 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, mingo@redhat.com,
        peterz@infradead.org, jgross@suse.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, luto@amacapital.net,
        david.vrabel@citrix.com, JBeulich@suse.com, hpa@zytor.com,
        masami.hiramatsu.pt@hitachi.com, xen-devel@lists.xenproject.org,
        tglx@linutronix.de, Borislav Petkov <bp@suse.de>, bpoirier@suse.de
Subject: Re: [Xen-devel] [PATCH v2 2/2] x86/xen: allow privcmd hypercalls
	to be preempted
Message-ID: <20150113212140.GD27566@wotan.suse.de>
References: <1418254487-9988-1-git-send-email-mcgrof@do-not-panic.com> <1418254487-9988-3-git-send-email-mcgrof@do-not-panic.com> <20141218192313.GA19507@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218192313.GA19507@laptop.dumpdata.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 02:23:14PM -0500, Konrad Rzeszutek Wilk wrote:
> > index 0000000..b5a3e98
> > --- /dev/null
> > +++ b/drivers/xen/preempt.c
> > @@ -0,0 +1,17 @@
> > +/*
> > + * Preemptible hypercalls
> > + *
> > + * Copyright (C) 2014 Citrix Systems R&D ltd.
> > + *
> > + * This source code is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation; either version 2 of the
> > + * License, or (at your option) any later version.
> > + */
> > +
> > +#include <xen/xen-ops.h>
> > +
> > +#ifndef CONFIG_PREEMPT
> > +DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
> > +EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
> > +#endif
> 
> Please also add this in the patch:
> 
> 
> diff --git a/drivers/xen/preempt.c b/drivers/xen/preempt.c
> index b5a3e98..5d773dc 100644
> --- a/drivers/xen/preempt.c
> +++ b/drivers/xen/preempt.c
> @@ -13,5 +13,5 @@
>  
>  #ifndef CONFIG_PREEMPT
>  DEFINE_PER_CPU(bool, xen_in_preemptible_hcall);
> -EXPORT_SYMBOL_GPL(xen_in_preemptible_hcall);
> +EXPORT_PER_CPU_SYMBOL_GPL(xen_in_preemptible_hcall);
>  #endif

Ammended, although I think we want another approach now based
on the recommendations by Andy Lutomirski.

  Luis
