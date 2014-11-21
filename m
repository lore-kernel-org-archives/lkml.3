Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592AbaKUOXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:23:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54695 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758147AbaKUOXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:23:07 -0500
Date: Fri, 21 Nov 2014 15:23:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the ftrace tree
In-Reply-To: <20141121092036.09edee57@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1411211522020.23174@pobox.suse.cz>
References: <20141121183215.01ba539c@canb.auug.org.au> <alpine.LNX.2.00.1411211149490.23174@pobox.suse.cz> <20141121092036.09edee57@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014, Steven Rostedt wrote:

> > From: Jiri Kosina <jkosina@suse.cz>
> > Subject: [PATCH] printk: make sure printk_func_t is known in percpu.h
> > 
> > Commit afdc34a3d3b8 ("printk: Add per_cpu printk func to allow printk to 
> > be diverted") caused percpu variable printk_func to be declared in 
> > percpu.h. Make sure that the corresponding type is known at the time of 
> > declaration.
> > 
> > Fixes build failure on certain arch/config combinations.
> > 
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> >  include/linux/percpu.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> > index a3aa63e..c94c766 100644
> > --- a/include/linux/percpu.h
> > +++ b/include/linux/percpu.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/cpumask.h>
> >  #include <linux/pfn.h>
> >  #include <linux/init.h>
> > +#include <linux/printk.h>
> >  
> >  #include <asm/percpu.h>
> 
> Unfortunately, this wasn't the fix. This was an allnoconfig, which
> means printk wasn't defined.

Ah, thanks, that indeed needs to be done as well.

I still think that the patch I sent should be applied, as there might be 
configurations where printk.h doesn't implicitly transitively make it into 
percpu.h.

-- 
Jiri Kosina
SUSE Labs
