Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3DVVh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:37:26 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:54004
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753115Ab3DVVhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:37:25 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zz98dI1432I4015I179dNzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLOEQ4-02-1N7-02
X-M-MSG: 
Date: Mon, 22 Apr 2013 16:37:15 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] perf: Add hardware breakpoint address mask
Message-ID: <20130422213715.GA24256@jshin-Toonie>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
 <20130420165334.GA14814@redhat.com>
 <20130420224757.GB6155@jshin-Toonie>
 <20130421170202.GA5358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130421170202.GA5358@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 07:02:02PM +0200, Oleg Nesterov wrote:
> On 04/20, Jacob Shin wrote:
> >
> > On Sat, Apr 20, 2013 at 06:53:34PM +0200, Oleg Nesterov wrote:
> > >
> > > And does attr.bp_len "contribute" to the mask?
> > >
> > > I mean, if bp_len == X86_BREAKPOINT_LEN_8, does this mean that
> > > bp_bp_addr_mask and (bp_bp_addr_mask | 7) have the same effect?
> >
> > Yes it has the same effect.
> 
> OK, thanks...
> 
> So this is the "natural" extension. Given that currently bp_addr
> should be aligned, bp_len could be already bp_mask but I guess it
> is too late to change this, so we need another field.
> 
> Hmm. Perhaps arch_has_hw_breakpoint_addr_mask(void) should be turned
> into arch_validate_hw_breakpoint_addr_mask(bp) which should also
> check that (bp_addr & bp_addr_mask) == 0. But I won't insist.

Yes I can do that .. in that case should the Kconfig
CONFIG_HAVE_HW_BREAKPOINT_ADDR_MASK go away, and in every non-x86
hw_breakpoint.c do:

bool arch_validate_hw_breakpoint_addr_mask(struct perf_event *bp)
{
	return false;
}

?

Or keep CONFIG_HAVE_HW_BREAKPOINT_ADDR_MASK and in
include/linux/hw_breakpoint.h do:

#ifndef CONFIG_HAVE_HW_BREAKPOINT_ADDR_MASK
static inline bool arch_validate_hw_breakpoint_addr_mask(struct perf_event *bp)
{
	return falase;
}
#endif

?

Thanks,

