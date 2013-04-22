Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab3DVWOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 18:14:12 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:8209 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753528Ab3DVWOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 18:14:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI1432I168aJzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLOGFE-01-2ZY-02
X-M-MSG: 
Date: Mon, 22 Apr 2013 17:14:01 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] perf, x86: AMD implementation for hardware
 breakpoint address mask
Message-ID: <20130422221401.GA28525@jshin-Toonie>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
 <1365528113-5458-3-git-send-email-jacob.shin@amd.com>
 <20130421171921.GA6645@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130421171921.GA6645@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 07:19:21PM +0200, Oleg Nesterov wrote:
> Not a comment, but the question...
> 
> On 04/09, Jacob Shin wrote:
> >
> > --- a/arch/x86/include/asm/hw_breakpoint.h
> > +++ b/arch/x86/include/asm/hw_breakpoint.h
> > @@ -14,6 +14,7 @@ struct arch_hw_breakpoint {
> >  	unsigned long	address;
> >  	u8		len;
> >  	u8		type;
> > +	u32		mask;
> >  };
> ...
> > @@ -254,6 +258,7 @@ static int arch_build_bp_info(struct perf_event *bp)
> >  	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
> >
> >  	info->address = bp->attr.bp_addr;
> > +	info->mask = bp->attr.bp_addr_mask;
> 
> OK, this matches the usage of info->address so I think this change
> is right.
> 
> But otoh, why do we need info->address (or mask added by this patch)?
> we could use bp->attr.bp_addr instead. arch_hw_breakpoint could have
> a single filed = "type | len" for encode_dr7().

I understood this as maybe remapping arch independant uapi struct into
x86 specific struct. I guess to future proof in cause uapi interfaces
change.

> 
> Yes, off-topic, sorry for noise.
> 
> Oleg.
> 
> 

