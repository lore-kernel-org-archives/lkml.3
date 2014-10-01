Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbaJAKvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 06:51:45 -0400
Received: from ozlabs.org ([103.22.144.67]:40148 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaJAKvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 06:51:44 -0400
Message-ID: <1412160702.19209.59.camel@ale.ozlabs.ibm.com>
Subject: Re: [PATCH v2 03/17] powerpc/cell: Make spu_flush_all_slbs() generic
From: Michael Neuling <mikey@neuling.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: greg@kroah.com, arnd@arndb.de, benh@kernel.crashing.org, anton@samba.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, jk@ozlabs.org,
        imunsie@au.ibm.com, cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Date: Wed, 01 Oct 2014 20:51:42 +1000
In-Reply-To: <20141001071330.E4262140174@ozlabs.org>
References: <20141001071330.E4262140174@ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-01 at 17:13 +1000, Michael Ellerman wrote:
> On Tue, 2014-30-09 at 10:34:52 UTC, Michael Neuling wrote:
> > diff --git a/arch/powerpc/include/asm/copro.h b/arch/powerpc/include/asm/copro.h
> > index 2858108..f3d338f 100644
> > --- a/arch/powerpc/include/asm/copro.h
> > +++ b/arch/powerpc/include/asm/copro.h
> > @@ -15,4 +15,10 @@ int copro_handle_mm_fault(struct mm_struct *mm, unsigned long ea,
> >  
> >  int copro_data_segment(struct mm_struct *mm, u64 ea, u64 *esid, u64 *vsid);
> >  
> > +
> > +#ifdef CONFIG_PPC_COPRO_BASE
> > +void copro_flush_all_slbs(struct mm_struct *mm);
> > +#else
> > +#define copro_flush_all_slbs(mm) do {} while(0)
> 
> This can be a static inline, so it should be. That way you get type checking on
> the argument for CONFIG_PPC_COPRO_BASE=n.

OK, I'll update.

Mikey
