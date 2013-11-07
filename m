Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3KGPQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:16:07 -0500
Received: from mail-ee0-f41.google.com ([74.125.83.41]:58329 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab3KGPQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:16:05 -0500
Date: Thu, 7 Nov 2013 16:16:01 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: preparations for arm port
Message-ID: <20131107151601.GA5163@gmail.com>
References: <20131106191913.GA18661@redhat.com>
 <20131107075151.GB31560@gmail.com>
 <20131107143432.GA6240@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107143432.GA6240@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 11/07, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > --- a/arch/powerpc/include/asm/uprobes.h
> > > +++ b/arch/powerpc/include/asm/uprobes.h
> > > @@ -37,6 +37,7 @@ typedef ppc_opcode_t uprobe_opcode_t;
> > >  struct arch_uprobe {
> > >  	union {
> > >  		u8	insn[MAX_UINSN_BYTES];
> > > +		u8	ixol[MAX_UINSN_BYTES];
> > >  		u32	ainsn;
> > >  	};
> > >  };
> >
> > > --- a/arch/x86/include/asm/uprobes.h
> > > +++ b/arch/x86/include/asm/uprobes.h
> > > @@ -35,7 +35,10 @@ typedef u8 uprobe_opcode_t;
> > >
> > >  struct arch_uprobe {
> > >  	u16				fixups;
> > > -	u8				insn[MAX_UINSN_BYTES];
> > > +	union {
> > > +		u8			insn[MAX_UINSN_BYTES];
> > > +		u8			ixol[MAX_UINSN_BYTES];
> > > +	};
> > >  #ifdef CONFIG_X86_64
> > >  	unsigned long			rip_rela_target_address;
> > >  #endif
> >
> > Btw., at least on the surface, the powerpc and x86 definitions seem rather
> > similar, barring senseless variations. Would it make sense to generalize
> > the data structure a bit more?
> 
> Heh. You know, I have another patch, see below. It was not tested yet, 
> it should be splitted into 3 changes, and we need to cleanup copy_insn() 
> first. I didn't sent it now because I wanted to merge the minimal 
> changes which allow us to avoid the new arm arch_upobe_* hooks. And of 
> course it needs the review.
> 
> But in short, I do not think we should try to unify/generalize 
> insn/ixol.

That's OK.

> For the moment, please ignore the patch which adds the new ->ixol 
> member.

I didn't actually disagree with it so I pulled it - I was just wondering 
about those cleanliness details.

Thanks,

	Ingo
