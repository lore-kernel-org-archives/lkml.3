Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750948AbaLOABw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 19:01:52 -0500
Received: from ozlabs.org ([103.22.144.67]:50634 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaLOABr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 19:01:47 -0500
Message-ID: <1418601701.19970.4.camel@ellerman.id.au>
Subject: Re: [v4,4/4] powernv: powerpc: Add winkle support for offline cpus
From: Michael Ellerman <mpe@ellerman.id.au>
To: Shreyas B Prabhu <shreyas@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Paul Mackerras <paulus@samba.org>
Date: Mon, 15 Dec 2014 11:01:41 +1100
In-Reply-To: <548D7A0E.2060107@linux.vnet.ibm.com>
References: <20141214100600.3446B140119@ozlabs.org>
	 <548D7A0E.2060107@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 17:22 +0530, Shreyas B Prabhu wrote:
> On Sunday 14 December 2014 03:35 PM, Michael Ellerman wrote:
> >> diff --git a/arch/powerpc/platforms/powernv/subcore.h b/arch/powerpc/platforms/powernv/subcore.h
> >> index 148abc9..604eb40 100644
> >> --- a/arch/powerpc/platforms/powernv/subcore.h
> >> +++ b/arch/powerpc/platforms/powernv/subcore.h
> >> @@ -15,4 +15,5 @@
> >>  
> >>  #ifndef __ASSEMBLY__
> >>  void split_core_secondary_loop(u8 *state);
> >> +extern void update_subcore_sibling_mask(void);
> >>  #endif
> > 
> > subcore.c isn't built for CONFIG_SMP=n, resulting in:
> > 
> >   setup.c:(.init.text+0x34b0): undefined reference to `.update_subcore_sibling_mask'
> > 
> > I needed to add:
> > 
> > +#else
> > +static inline void update_subcore_sibling_mask(void) { };
> > +#endif /* CONFIG_SMP */

> Sorry I missed that.

No worries.

Can you please do a quick test with a SMP=n kernel.

It looks like it should work, but it would be good to test.

cheers


