Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933564Ab3BLRfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:35:10 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:34998 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab3BLRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:35:08 -0500
Date: Tue, 12 Feb 2013 18:35:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Len Brown <lenb@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Len Brown <len.brown@intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree (acpi
	tree related)
Message-ID: <20130212173505.GA2155@merkur.ravnborg.org>
References: <20130211183409.7519b73ca320baeac5ec886f@canb.auug.org.au> <51197D8B.6010407@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51197D8B.6010407@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  arch/sparc/include/asm/processor.h | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/arch/sparc/include/asm/processor.h b/arch/sparc/include/asm/processor.h
> > index 34baa35..622cfa5 100644
> > --- a/arch/sparc/include/asm/processor.h
> > +++ b/arch/sparc/include/asm/processor.h
> > @@ -7,6 +7,8 @@
> >  #endif
> >  
> >  #define nop() 		__asm__ __volatile__ ("nop")
> > +#ifndef __ASSEMBLY__
> >  extern void (*sparc_idle)(void);
> > +#endif
> >  
> >  #endif
> > 
> 
> Thank you Stephen!
> 
> The last time I compiled a sparc kernel was in 1993:-)
> 
> I've added your fix and Dave's Ack to this patch,
> and updated it in my next branch.

Hi Len.

Can you please move the definition of sparc_idle to processor_32.h
It is sparc32 specific - and then we do not need the __ASSEMBLY__ guards
as the sparc32 variant are not used from assembler.

Do you btw. have any hints how I can convert to the cpu_idle thing you hinted?

	Sam
