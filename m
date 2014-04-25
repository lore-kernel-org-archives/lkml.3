Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaDYTyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:54:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29095 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166AbaDYTyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:54:00 -0400
Date: Fri, 25 Apr 2014 21:53:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uprobes/x86: Move default_xol_ops's data into
	arch_uprobe->def
Message-ID: <20140425195340.GA12875@redhat.com>
References: <20140422144753.GA8062@redhat.com> <1398382247.4536.12.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398382247.4536.12.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24, Jim Keniston wrote:
>
> I see a couple of nits in this patch (see below), but the others look
> good.
>
> Patches 1-5 of this set:
> Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

Thanks!

> >  		struct {
> >  			s32	offs;
> >  			u8	ilen;
> >  			u8	opc1;
> > -		}				branch;
> > +		}			branch;
> > +		struct {
> > +#ifdef CONFIG_X86_64
> > +			long	riprel_target;
> > +#endif
> > +			u16	fixups;
> > +		} 			def;
>
> "def" is kind of ambiguous.

Heh. I am shy to admit that my plan was to name it "default". I changed
its name only after gcc told me I should learn "C".

> How about "dfault" or some such?

Then probably "dflt", this looks more consintent and more IBMish ;)

On a serious note, I agree with any naming... but "dfault" looks like
"d" fault to me. Perhaps something else?

> > --- a/arch/x86/kernel/uprobes.c
> > +++ b/arch/x86/kernel/uprobes.c
> ...
> > @@ -636,12 +635,12 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
> >
> >  	/*
> >  	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
> > -	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
> > -	 * is either zero or it reflects rip-related fixups.
> > +	 * and annotate def->fixups accordingly. To start with, ->fixups is
> > +	 * either zero or it reflects rip-related fixups.
>
> That sentence stopped being true a couple of patch sets ago.
> handle_riprel_insn() is called later in this function now.

Yes, but the comment mentions arch_uprobe_post_xol? Anyway, I'll update
it to say "default_post_xol_op" instead.

Or I misunderstood you ?

Oleg.

