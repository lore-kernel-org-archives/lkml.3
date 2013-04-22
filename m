Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab3DVCpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:45:50 -0400
Received: from ozlabs.org ([203.10.76.45]:44854 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab3DVCpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:45:49 -0400
Date: Mon, 22 Apr 2013 12:45:46 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Michael Neuling <mikey@neuling.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 1/5] powerpc, perf: Add new BHRB related instructions
 for POWER8
Message-ID: <20130422024546.GA24739@concordia>
References: <1366287976-3900-1-git-send-email-khandual@linux.vnet.ibm.com>
 <1366287976-3900-2-git-send-email-khandual@linux.vnet.ibm.com>
 <20130421234109.GC22246@concordia>
 <14010.1366593223@ale.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14010.1366593223@ale.ozlabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 11:13:43AM +1000, Michael Neuling wrote:
> Michael Ellerman <michael@ellerman.id.au> wrote:
> 
> > On Thu, Apr 18, 2013 at 05:56:12PM +0530, Anshuman Khandual wrote:
> > > This patch adds new POWER8 instruction encoding for reading
> > > the BHRB buffer entries and also clearing it. Encoding for
> > > "clrbhrb" instruction is straight forward.
> > 
> > Which is "clear branch history rolling buffer" ?
> > 
> > > But "mfbhrbe"
> > > encoding involves reading a certain index of BHRB buffer
> > > into a particular GPR register.
> > 
> > And "Move from branch history rolling buffer entry" ?
> > 
> > > diff --git a/arch/powerpc/include/asm/ppc-opcode.h b/arch/powerpc/include/asm/ppc-opcode.h
> > > index 8752bc8..93ae5a1 100644
> > > --- a/arch/powerpc/include/asm/ppc-opcode.h
> > > +++ b/arch/powerpc/include/asm/ppc-opcode.h
> > > @@ -82,6 +82,7 @@
> > >  #define	__REGA0_R31	31
> > >  
> > >  /* sorted alphabetically */
> > > +#define PPC_INST_BHRBE			0x7c00025c
> > 
> > I don't think you really need this, just use the literal value below.
> 
> The rest of the defines in this file do this, so Anshuman's right. 

I don't see the point, but sure let's be consistent. Though in that case
he should do the same for PPC_CLRBHRB below.

> > > @@ -297,6 +298,12 @@
> > >  #define PPC_NAP			stringify_in_c(.long PPC_INST_NAP)
> > >  #define PPC_SLEEP		stringify_in_c(.long PPC_INST_SLEEP)
> > >  
> > > +/* BHRB instructions */
> > > +#define PPC_CLRBHRB		stringify_in_c(.long 0x7c00035c)
> > > +#define PPC_MFBHRBE(r, n)	stringify_in_c(.long PPC_INST_BHRBE | \
> > > +						__PPC_RS(r) | \
> > > +							(((n) & 0x1f) << 11))
> > 
> > Why are you not using ___PPC_RB(n) here ?
> 
> Actually, this is wrong.  The number field should be 10 bits (0x3ff),
> not 5 (0x1f)  Anshuman please fix.

ACK.

cheers
