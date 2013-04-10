Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934038Ab3DJF40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 01:56:26 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:60935 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab3DJF4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 01:56:25 -0400
Message-ID: <1365573371.10616.16.camel@ThinkPad-T5421>
Subject: Re: [RFC PATCH v2 6/6] powerpc: Use generic code for exception
 handling
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, paulus@samba.org,
        paulmck@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Date: Wed, 10 Apr 2013 13:56:11 +0800
In-Reply-To: <1365571931.10616.12.camel@ThinkPad-T5421>
References: <1364551221-23177-1-git-send-email-zhong@linux.vnet.ibm.com>
	 <1364551221-23177-7-git-send-email-zhong@linux.vnet.ibm.com>
	 <20130410045659.GB15929@concordia>
	 <1365571931.10616.12.camel@ThinkPad-T5421>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041005-1618-0000-0000-000003A81E1B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 13:32 +0800, Li Zhong wrote:
> On Wed, 2013-04-10 at 14:56 +1000, Michael Ellerman wrote:
> > On Fri, Mar 29, 2013 at 06:00:21PM +0800, Li Zhong wrote:
> > > After the exception handling moved to generic code, and some changes in
> > ...
> > > diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
> > > index 360fba8..eeab30f 100644
> > > --- a/arch/powerpc/mm/hash_utils_64.c
> > > +++ b/arch/powerpc/mm/hash_utils_64.c
> > > @@ -33,6 +33,7 @@
> > >  #include <linux/init.h>
> > >  #include <linux/signal.h>
> > >  #include <linux/memblock.h>
> > > +#include <linux/context_tracking.h>
> > >  
> > >  #include <asm/processor.h>
> > >  #include <asm/pgtable.h>
> > > @@ -56,7 +57,6 @@
> > >  #include <asm/fadump.h>
> > >  #include <asm/firmware.h>
> > >  #include <asm/tm.h>
> > > -#include <asm/context_tracking.h>
> > >  
> > >  #ifdef DEBUG
> > >  #define DBG(fmt...) udbg_printf(fmt)
> > > @@ -919,13 +919,17 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap)
> > >  	const struct cpumask *tmp;
> > >  	int rc, user_region = 0, local = 0;
> > >  	int psize, ssize;
> > > +	enum ctx_state prev_state;
> > > +
> > > +	prev_state = exception_enter();
> > >  
> > >  	DBG_LOW("hash_page(ea=%016lx, access=%lx, trap=%lx\n",
> > >  		ea, access, trap);
> > >  
> > >  	if ((ea & ~REGION_MASK) >= PGTABLE_RANGE) {
> > >  		DBG_LOW(" out of pgtable range !\n");
> > > - 		return 1;
> > > +		rc = 1;
> > > +		goto exit;
> > >  	}
> > >  
> > >  	/* Get region & vsid */
> > 
> > This no longer applies on mainline, please send an updated version.
> 
> Yes, for current mainline (powerpc tree), only previous five patches
> could be applied. The dependency of this patch is current in tip tree,
> and seems would be in for 3.10.
> 
> There are some more details in the cover letter (#0):
> 
> "I assume these patches would get in through powerpc tree, so I didn't
> combine the new patch (#6) with the original one (#2). So that if
> powerpc tree picks these, it could pick the first five patches, and
> apply patch #6 later when the dependency enters into powerpc tree (maybe
> on some 3.10-rcs)."

And I will send an updated version of this one when I see the dependency
commits in mainline. 

Thanks, Zhong

> Thanks, Zhong
> 
> > cheers
> > 
> 


